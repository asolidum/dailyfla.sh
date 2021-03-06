#!/bin/bash

# Adjustable parameters
## Duration of each daily video (in seconds)
duration="00:00:01"
## Duration of the title screen (in seconds)
title_duration="3"
## Resolution of the final videos (in pixels)
resolution="3840x2160"
transcode_settings="-vcodec libx264 -c:a aac -b:a 160k -filter:v fps=25 -s ${resolution}"
font_size=128
font_settings="/System/Library/Fonts/Keyboard.ttf:fontcolor=white"
title_text_settings="drawtext=fontfile=${font_settings}:fontsize=$((font_size*2)):x=(w-text_w)/2:y=(h-text_h)/2"
daily_text_settings="drawtext=fontfile=${font_settings}:fontsize=${font_size}:box=1:boxcolor=black@0.5:boxborderw=5:x=(w*3/4):y=(h*3/4)"

declare -a filenames
declare -a timestamps

# Start index at one to avoid confusion
# with day we are currently processing
filename[1]="filename1.mp4"
timestamp[1]="00:00:00"
filename[2]="filename2.mp4"
timestamp[2]="00:00:00"
filename[3]="filename3.mp4"
timestamp[3]="00:00:00"
filename[4]="filename4.mp4"
timestamp[4]="00:00:00"
filename[5]="filename5.mp4"
timestamp[5]="00:00:00"
filename[6]="filename6.mp4"
timestamp[6]="00:00:00"
filename[7]="filename7.mp4"
timestamp[7]="00:00:00"
filename[8]="filename8.mp4"
timestamp[8]="00:00:00"
filename[9]="filename9.mp4"
timestamp[9]="00:00:00"
filename[10]="filename10.mp4"
timestamp[10]="00:00:00"
filename[11]="filename11.mp4"
timestamp[11]="00:00:00"
filename[12]="filename12.mp4"
timestamp[12]="00:00:00"
filename[13]="filename13.mp4"
timestamp[13]="00:00:00"
filename[14]="filename14.mp4"
timestamp[14]="00:00:00"
filename[15]="filename15.mp4"
timestamp[15]="00:00:00"
filename[16]="filename16.mp4"
timestamp[16]="00:00:00"
filename[17]="filename17.mp4"
timestamp[17]="00:00:00"
filename[18]="filename18.mp4"
timestamp[18]="00:00:00"
filename[19]="filename19.mp4"
timestamp[19]="00:00:00"
filename[20]="filename20.mp4"
timestamp[20]="00:00:00"
filename[21]="filename21.mp4"
timestamp[21]="00:00:00"
filename[22]="filename22.mp4"
timestamp[22]="00:00:00"
filename[23]="filename23.mp4"
timestamp[23]="00:00:00"
filename[24]="filename24.mp4"
timestamp[24]="00:00:00"
filename[25]="filename25.mp4"
timestamp[25]="00:00:00"
filename[26]="filename26.mp4"
timestamp[26]="00:00:00"
filename[27]="filename27.mp4"
timestamp[27]="00:00:00"
filename[28]="filename28.mp4"
timestamp[28]="00:00:00"
filename[29]="filename29.mp4"
timestamp[29]="00:00:00"
filename[30]="filename30.mp4"
timestamp[30]="00:00:00"

function add_missing_audio_stream() {
    local outfile=$1
    local daystr=$2
    num_streams=$(ffprobe -loglevel error -show_entries stream=codec_type -of csv=p=0 ${outfile} | wc -l)
    if [ ${num_streams} == 1 ]; then
        echo "Adding missing audio stream to day ${day_str}"
        ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 -i ${outfile} -c:v copy -c:a aac -shortest -y ./tmp/tmp_audio.mp4 &> /dev/null
        mv ./tmp/tmp_audio.mp4 ${outfile}
    fi
} 

# Check for correct number of input arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <month> <year> <output_filename>"
    exit 1
fi

month=$1
year=$2

# Check if correct number of days for inputted month and year
size=${#filename[@]}
echo "Creating video for ${month} ${year}"
num_days=$(cal ${month} ${year} | awk 'NF {DAYS = $NF}; END {print DAYS}')
if [ $num_days -ne $size ]; then
    echo "ERROR: Expected ${num_days} days for ${month} ${year} but saw ${size}"
    exit 1
fi

# Setup tmp directory
mkdir -p tmp
rm -rf ./tmp/*

echo "Creating title screen"
ffmpeg -f lavfi -i color=c=black:rate=25:size=${resolution}:duration=${title_duration} -vf "${title_text_settings}:text='${month} ${year}'" ./tmp/tmp_title.mp4 &> /dev/null
ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 -i ./tmp/tmp_title.mp4 -c:v copy -c:a aac -shortest -y ./tmp/title.mp4 &> /dev/null
echo "file title.mp4" >> ./tmp/concat_list.txt

for (( i=1; i<=$size; i++ )); do
    day_str=$(printf "%02d" $((i)))
    echo "Creating video file for day ${day_str}"
    outfile="day_${day_str}.mp4"
    # Double brackets used to properly handle filenames with spaces
    if [[ -f ${filename[$i]} ]] && [ ! -z "${timestamp[$i]}" ]; then
        ffmpeg -i "${filename[$i]}" -ss ${timestamp[$i]} -t ${duration} ${transcode_settings} ./tmp/tmp_${outfile} >& /dev/null
        # Check if file has audio stream
        add_missing_audio_stream ./tmp/tmp_${outfile} ${day_str}
        ffmpeg -i ./tmp/tmp_${outfile} -vf "${daily_text_settings}:text='Day ${day_str}'" ./tmp/${outfile} >& /dev/null
        echo "file ${outfile}" >> ./tmp/concat_list.txt
    else
        if [ ! -z "${timestamp[$i]}" ]; then
            echo "ERROR: File ${filename[$i]} for day ${day_str} does not exist"
        fi
        if [ -z "${timestamp[$i]}" ]; then
            echo "ERROR: Timestamp for day ${day_str} is not defined"
        fi
    fi
done

echo "Creating daily flash file - ${3}"
ffmpeg -y -f concat -safe 0 -i ./tmp/concat_list.txt -c copy $3 &> /dev/null