#!/bin/bash

echo "+---------------------------------------------------------+"
echo "| Image and Video EXIF Updater for Google Photos (v1.0.0) |"
echo "+---------------------------------------------------------+"
echo "This tool updates EXIF tags so that image and video files will appear on the correct dates in Google Photos."
echo "Don't worry if you see some messages saying 'N files failed condition'."
echo "They simply mean that the image files already have correct tags. :)"

# Check if the user provided a photo path
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/photos/"
    exit 1
fi

# Set the path to your photos from the user argument
PHOTO_PATH="$1"

# Check if exiftool is installed
EXIFTOOL='exiftool'
if ! command -v $EXIFTOOL &> /dev/null; then
    echo "$EXIFTOOL could not be found. Please install it."
    exit 1
fi

# Define string variables for repeated strings
OVERWRITE_OPTION='-overwrite_original_in_place'
DATE_TIME_ORIGINAL='DateTimeOriginal'
FILE_MODIFY_DATE='FileModifyDate'
MEDIA_CREATE_DATE='MediaCreateDate'
FILENAME='Filename'
EXIF_DATE_TIME_ORIGINAL="EXIF:${DATE_TIME_ORIGINAL}"

echo -e "\nStep 1 (General): If ${DATE_TIME_ORIGINAL} is missing, create it using ${FILE_MODIFY_DATE}"
"${EXIFTOOL}" -if "not \$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${DATE_TIME_ORIGINAL}<${FILE_MODIFY_DATE}" -r "${PHOTO_PATH}"

echo -e "\nStep 2 (K3G): If ${DATE_TIME_ORIGINAL} is missing, create it using ${FILE_MODIFY_DATE}"
"${EXIFTOOL}" -if "not \$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${DATE_TIME_ORIGINAL}<${FILE_MODIFY_DATE}" -r -ext k3g "${PHOTO_PATH}"

echo -e "\nStep 3 (PNG): If ${DATE_TIME_ORIGINAL} exists, update ${FILE_MODIFY_DATE} based on EXIF:${DATE_TIME_ORIGINAL}. Google Photos recognizes EXIF:${FILE_MODIFY_DATE} for PNG files. ('EXIF:' is important for PNG files.)"
"${EXIFTOOL}" -if "\$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<EXIF:${DATE_TIME_ORIGINAL}" -r -ext png "${PHOTO_PATH}"

echo -e "\nStep 4 (GIF): If ${DATE_TIME_ORIGINAL} exists, update ${FILE_MODIFY_DATE} based on it."
"${EXIFTOOL}" -if "\$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${DATE_TIME_ORIGINAL}" -r -ext gif "${PHOTO_PATH}"

echo -e "\nStep 5 (MP4): If ${DATE_TIME_ORIGINAL} exists, update ${FILE_MODIFY_DATE} based on it."
"${EXIFTOOL}" -if "\$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${DATE_TIME_ORIGINAL}" -r -ext mp4 "${PHOTO_PATH}"

echo -e "\nStep 6 (MOV): If ${DATE_TIME_ORIGINAL} exists, update ${FILE_MODIFY_DATE} based on it."
"${EXIFTOOL}" -if "\$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${DATE_TIME_ORIGINAL}" -r -ext mov "${PHOTO_PATH}"

echo -e "\nStep 7 (3GP): If ${MEDIA_CREATE_DATE} exists, update ${DATE_TIME_ORIGINAL} and ${FILE_MODIFY_DATE} based on it. 3GP is used by LG Optimus series smartphones."
"${EXIFTOOL}" -if "\$${MEDIA_CREATE_DATE}" ${OVERWRITE_OPTION} "-${DATE_TIME_ORIGINAL}<${MEDIA_CREATE_DATE}" -r -ext 3gp "${PHOTO_PATH}"
"${EXIFTOOL}" -if "\$${MEDIA_CREATE_DATE}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${MEDIA_CREATE_DATE}" -r -ext 3gp "${PHOTO_PATH}"

echo -e "\nSpecific commands for LG Cyon and VK phones are disabled. If you need them, enable the if block in the shell script."
# Future use block (currently disabled)
if false; then
    echo -e "\nStep 8 (MP4 by CYON): If ${MEDIA_CREATE_DATE} exists, update ${DATE_TIME_ORIGINAL} and ${FILE_MODIFY_DATE} based on it. MP4 from LG Cyon phones may have wrong ${DATE_TIME_ORIGINAL} information or may not have it at all."
    "${EXIFTOOL}" -if "\$${MEDIA_CREATE_DATE}" ${OVERWRITE_OPTION} "-${DATE_TIME_ORIGINAL}<${MEDIA_CREATE_DATE}" -r -ext mp4 "${PHOTO_PATH}"
    "${EXIFTOOL}" -if "\$${MEDIA_CREATE_DATE}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${MEDIA_CREATE_DATE}" -r -ext mp4 "${PHOTO_PATH}"

    # 6. Only for VK (VK has wrong ${FILE_MODIFY_DATE} tag. So the date and time needs to be extracted from the filename.)
    echo -e "\nStep 9 (VK phones): Files from VK phones have wrong ${FILE_MODIFY_DATE} tag values. So the date and time need to be extracted from the filename."
    rename s/P-/20/g ./*.*
    "${EXIFTOOL}" -if "not \$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${DATE_TIME_ORIGINAL}<${FILENAME}" -r "${PHOTO_PATH}"
    "${EXIFTOOL}" -if "\$${DATE_TIME_ORIGINAL}" ${OVERWRITE_OPTION} "-${FILE_MODIFY_DATE}<${DATE_TIME_ORIGINAL}" -r "${PHOTO_PATH}"
fi

echo -e "\nAll tasks are complete. Enjoy your photo backup!"

