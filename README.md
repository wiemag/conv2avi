conv2avi
========

Convert mp4's or mkv's to avi's.

conv2avi is a simple converter--do not expect any special features, but...
it uses gnu make (Makefile) to do a chosen number of conversions simultaneously.


CONVERSION
- mp4 --> avi (default)
- mkv --> avi
- Original video bit rate is kept.
- Audio bit rate is kept (or rounded to a multiple of 16kb/s)
- Video is converted with libxvid
- Audio is converted with libmp3lame

No other conversion parameters are used.


INSTALLATION
conv2avi.sh  is a bash script and does not need any installation.
- Dependencies: 			ffmpeg, findutils
- Optional dependencies: 	wipe
- Conflicts:  				none


USAGE
Put the enclosed conv2avi_makefile into the directory with the mp4's and mkv's that you want to convert.

The command

	conv2avi.sh -h

will show you a usage help.
