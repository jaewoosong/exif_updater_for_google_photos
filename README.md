# EXIF Updater for Google Photos
This is a tool for updating EXIF so image and video files appear on the correct dates in Google Photos.
Sometimes Google Photos use incorrect date and time information of image or video files.
This tool fixes such problems.

## Usage
```bash
./exif_updater_for_google_photos path/to/image/and/video/directory
```

## Dependencies
This tool uses [ExifTool](https://exiftool.org/). You can install it by following the instruction on its homepage. Also there are easier ways for Ubuntu and macOS.

### Ubuntu (and other Debian-based systems)
```bash
sudo apt-get install exiftool
```

### macOS
```bash
brew install exiftool
```
