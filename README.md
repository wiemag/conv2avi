conv2avi
========

Convert mp4's or mkv's to avi's.
conv2avi is a simple converter--do not expect any special features, but...
it uses gnu make (Makefile) to do a chosen number of conversions simultaneously.

It keeps the original video and audio bit rates.
Conversion:
- video is converted with libxvid
- audio is converted with libmp3lame


INSTALLATION

conv2avi.sh  is a bash script and does not need any installation.
Dependencies:           ffmpeg, findutils
Optional dependencies:  wipe
Conflicts:              none


USAGE

Put the enclosed conv2avi_makefile into the directory with the mp4's and mkv's that you want to convert.
The command

	conv2avi.sh -h

will show you a usage help.
