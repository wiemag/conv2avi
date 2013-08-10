#!/bin/bash
# conv2avi.sh by Wiesław Magusiak (wiemag/wm/dif)
# 	<w.magusiak@gmail.com>
# A simple converter of mp4 and mkv files into avis.
# It keeps the original video and audio bit rates.
# Conversion:
# - video is converted with libxvid
# - audio is converted with libmp3lame

VERSION=1.0
path0=$(pwd)				# Original path
EXT="mp4"					# File extension to filter
mFILE='conv2avi_makefile'	# Makefile name for conv2avi.sh
mJOBS=""					# No of jobs for make to run simultaneously; zero='No limit'
mTARGETS=""					# Makefile targets
mEXEC="--dry-run"			# If $mEXEC == "--dry-run", make runs dry, just printing its jobs.

function usage () {
	echo -e "\n\e[1;32m${0##*/} (ver.${VERSION})\e[0m converts mp4's or mv's into avi's."
	echo -e "\nUsage:\n\t\e[1m${0##*/} [ -h | [-e EXT] [-p PATH] [-j JOBS] [-r]\e[0m"
	echo -e "Where:\n\tEXT is either mp4 (default) or mkv;"
	echo -e "\tPATH is the path to the directory with mp4's/mkv's;"
	echo -e "\tJOBS is the number of conversion jobs run simultaneously;"
	echo -e "\t     (Zero jobs denotes no limits.)"
	echo -en "\t\e[1m'-r'\e[0m must be used to do conversion;"
	echo -e " Otherwise it is a dry-run.\n"
}

while getopts  ":re:p:j:vh?" flag
do
    case "$flag" in
    	r) mEXEC="";;					# Empty = Execute make.
		h|v) usage && exit;;
		e) EXT="$OPTARG";
			[[ $EXT != "mp4" && $EXT != "mkv" ]] && \
				{ usage; echo "Only mp4's and mkv's can be converted."; exit;};;
		p) path1="$OPTARG";
			#echo path1=[${path1}];
			[[ -z $path1 ]] && path1=$path0;
			[[ -d "$path1" ]] || \
				{ usage; echo -e "\n\E[1mThe path does not exist.\E[0m"; exit 1; };
			path1=${path1%/};
			cd $path1 ;;
		j) mJOBS="$OPTARG"; [[ "$mJOBS" == "0" ]] && mJOBS="";;
	esac
done

#=== Targets for Makefile ================
[[ $(ls *$EXT 2>/dev/null) == "" ]] && { echo "No $EXT files found."; exit 2; }
for f in *$EXT; do
	if [[ $(expr index "$f" " ") -gt 0 ]]; then
		ln -s "$f" "${f// /_}"
		f="${f// /_}"
	fi
	f=${f%.$EXT}.avi
	mTARGETS=${mTARGETS}${f}" "
done

#===  Path to the Makefile ===============
if [[ ! -f $mFILE ]]; then
	if [[ -f ${path0}/${mFILE} ]]; then
		mFILE=${path0}/${mFILE}
	else
		echo -e "\nNo makefile found."
		echo -e "Note that only \E[1m${mFILE}\E[0m is accepted as a makefile."
		exit 3
	fi
fi

#=== THE HEART OF THE SCRIPT =============
[[ -z $mEXEC && $# -gt 0 ]] || {
	echo -en "\n\e[1;32mDRY RUN. \e[0m"
	echo -e "Use '-r' for conversion or '-h' for help.\n"
}
make $mEXEC -j"$mJOBS" -f "$mFILE" $mTARGETS
#=== CLEANING ============================
# dependency: findutils (find)
# optional dependency: wipe
# shred can't be used - t follows symlinks!
[[ -z $(which wipe) ]] && find . -type l -name \*.$EXT -delete \
	|| find . -type l -name \*.$EXT -exec wipe -zn {} +
#=========================================
