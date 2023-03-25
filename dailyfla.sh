#!/bin/bash

# Adjustable parameters
## Duration of each daily video (in seconds)
duration="00:00:01"
## Duration of the title screen (in seconds)
title_duration="3"
## Resolution of the final videos (in pixels)
resolution="3840x2160"
## Resolution of the shorts final videos (in pixels)
shorts_width="1080"
shorts_height="1920"

transcode_settings="-vcodec libx264 -c:a aac -b:a 320k -filter:v fps=25 -s ${resolution}"
font_size=128
font_settings="/System/Library/Fonts/Keyboard.ttf:fontcolor=white"
title_text_settings="drawtext=fontfile=${font_settings}:fontsize=$((font_size*2)):x=(w-text_w)/2:y=(h-text_h)/2"
daily_text_settings="drawtext=fontfile=${font_settings}:fontsize=${font_size}:box=1:boxcolor=black@0.5:boxborderw=5:x=(w*0.75):y=(h*0.75)"

short_font_size=100
short_title_text_settings="drawtext=fontfile=${font_settings}:fontsize=$((short_font_size*2)):x=(w-text_w)/2"
short_daily_text_settings="drawtext=fontfile=${font_settings}:fontsize=${short_font_size}:box=1:boxcolor=black@0.5:boxborderw=5:x=(w*0.6):y=(h*0.85)"

## Thumbnail parameters
thumbnail_title_timeoffset="1"
thumbnail_video_timeoffset="0.5"
thumbnail_resolution="1280x720"
thumbnail_quality=80

declare -a filenames
declare -a timestamps
declare -a scales
declare -a offsets
declare -a tags

# Start index at one to avoid confusion
# with day we are currently processing
filename[1]="filename1.mp4"
timestamp[1]="00:00:00"
scale[1]=0.885
offset[1]=1166
tag[1]="tag1"
filename[2]="filename2.mp4"
timestamp[2]="00:00:00"
scale[2]=0.885
offset[2]=1166
tag[2]="tag2"
filename[3]="filename3.mp4"
timestamp[3]="00:00:00"
scale[3]=0.885
offset[3]=1166
tag[3]="tag3"
filename[4]="filename4.mp4"
timestamp[4]="00:00:00"
scale[4]=0.885
offset[4]=1166
tag[4]="tag4"
filename[5]="filename5.mp4"
timestamp[5]="00:00:00"
scale[5]=0.885
offset[5]=1166
tag[5]="tag5"
filename[6]="filename6.mp4"
timestamp[6]="00:00:00"
scale[6]=0.885
offset[6]=1166
tag[6]="tag6"
filename[7]="filename7.mp4"
timestamp[7]="00:00:00"
scale[7]=0.885
offset[7]=1166
tag[7]="tag7"
filename[8]="filename8.mp4"
timestamp[8]="00:00:00"
scale[8]=0.885
offset[8]=1166
tag[8]="tag8"
filename[9]="filename9.mp4"
timestamp[9]="00:00:00"
scale[9]=0.885
offset[9]=1166
tag[9]="tag9"
filename[10]="filename10.mp4"
timestamp[10]="00:00:00"
scale[10]=0.885
offset[10]=1166
tag[10]="tag10"
filename[11]="filename11.mp4"
timestamp[11]="00:00:00"
scale[11]=0.885
offset[11]=1166
tag[11]="tag11"
filename[12]="filename12.mp4"
timestamp[12]="00:00:00"
scale[12]=0.885
offset[12]=1166
tag[12]="tag12"
filename[13]="filename13.mp4"
timestamp[13]="00:00:00"
scale[13]=0.885
offset[13]=1166
tag[13]="tag13"
filename[14]="filename14.mp4"
timestamp[14]="00:00:00"
scale[14]=0.885
offset[14]=1166
tag[14]="tag14"
filename[15]="filename15.mp4"
timestamp[15]="00:00:00"
scale[15]=0.885
offset[15]=1166
tag[15]="tag15"
filename[16]="filename16.mp4"
timestamp[16]="00:00:00"
scale[16]=0.885
offset[16]=1166
tag[16]="tag16"
filename[17]="filename17.mp4"
timestamp[17]="00:00:00"
scale[17]=0.885
offset[17]=1166
tag[17]="tag17"
filename[18]="filename18.mp4"
timestamp[18]="00:00:00"
scale[18]=0.885
offset[18]=1166
tag[18]="tag18"
filename[19]="filename19.mp4"
timestamp[19]="00:00:00"
scale[19]=0.885
offset[19]=1166
tag[19]="tag19"
filename[20]="filename20.mp4"
timestamp[20]="00:00:00"
scale[20]=0.885
offset[20]=1166
tag[20]="tag20"
filename[21]="filename21.mp4"
timestamp[21]="00:00:00"
scale[21]=0.885
offset[21]=1166
tag[21]="tag21"
filename[22]="filename22.mp4"
timestamp[22]="00:00:00"
scale[22]=0.885
offset[22]=1166
tag[22]="tag22"
filename[23]="filename23.mp4"
timestamp[23]="00:00:00"
scale[23]=0.885
offset[23]=1166
tag[23]="tag23"
filename[24]="filename24.mp4"
timestamp[24]="00:00:00"
scale[24]=0.885
offset[24]=1166
tag[24]="tag24"
filename[25]="filename25.mp4"
timestamp[25]="00:00:00"
scale[25]=0.885
offset[25]=1166
tag[25]="tag25"
filename[26]="filename26.mp4"
timestamp[26]="00:00:00"
scale[26]=0.885
offset[26]=1166
tag[26]="tag26"
filename[27]="filename27.mp4"
timestamp[27]="00:00:00"
scale[27]=0.885
offset[27]=1166
tag[27]="tag27"
filename[28]="filename28.mp4"
timestamp[28]="00:00:00"
scale[28]=0.885
offset[28]=1166
tag[28]="tag28"
filename[29]="filename29.mp4"
timestamp[29]="00:00:00"
scale[29]=0.885
offset[29]=1166
tag[29]="tag29"
filename[30]="filename30.mp4"
timestamp[30]="00:00:00"
scale[30]=0.885
offset[30]=1166
tag[30]="tag30"

function add_audio_stream() {
    local infile=$1
    local outfile=$2
    ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 -i ${infile} -c:v copy -c:a aac -shortest -y ${outfile} &> /dev/null
}

function add_missing_audio_stream() {
    local outfile=$1
    local daystr=$2
    tempfile="./tmp/tmp_audio.mp4"
    num_streams=$(ffprobe -loglevel error -show_entries stream=codec_type -of csv=p=0 ${outfile} | wc -l)
    if [ ${num_streams} == 1 ]; then
        echo "Adding missing audio stream to day ${day_str}"
        add_audio_stream ${outfile} ${tempfile}
        mv ${tempfile} ${outfile}
    fi
} 

function save_daily_flash_files() {
    local outfile=$1

    echo "Creating daily flash file - ${outfile}"
    ffmpeg -y -f concat -safe 0 -i ./tmp/concat_list.txt -c copy ${outfile} &> /dev/null
    ffmpeg -y -f concat -safe 0 -i ./tmp/short_concat_list.txt -c copy short_${outfile} &> /dev/null
    #ffmpeg -y -f concat -safe 0 -i ./tmp/concat_list.txt -c copy ./tmp/tmp_$3 &> /dev/null
    #ffmpeg -i ./tmp/tmp_$3 -vcodec libx264 -x264-params keyint=5:scenecut=0 -acodec copy $3
}

function create_thumbnail() {
    local infile=$1
    local time_offset=$2
    local resolution=$3
    local quality=$4
    local outfile=$5

    ffmpeg -y -i ${infile} -ss ${time_offset} -s "${resolution}" -frames:v 1 ./tmp/temp_thumbnails.png
    convert ./tmp/temp_thumbnails.png -quality ${quality} ${outfile}
}

function output_unique_tags() {
    local array=("$@")

    echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

# Check for correct number of input arguments
if [ $# -ne 4 ]; then
    echo "Usage: $0 <month> <year> <output_filename> <thumbnail_dir>"
    exit 1
fi

month=$1
year=$2
thumbnail_dir=$4

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
mkdir ./tmp/thumbnails

echo "Creating title screens (normal and short)"
ffmpeg -f lavfi -i color=c=black:rate=25:size=${resolution}:duration=${title_duration} -vf "${title_text_settings}:text='${month} ${year}'" ./tmp/tmp_title.mp4 &> /dev/null
create_thumbnail ./tmp/tmp_title.mp4 ${thumbnail_title_timeoffset} ${thumbnail_resolution} ${thumbnail_quality} ./tmp/thumbnails/thumbnail_title.png
add_audio_stream ./tmp/tmp_title.mp4 ./tmp/title.mp4
echo "file title.mp4" >> ./tmp/concat_list.txt

ffmpeg -f lavfi -i color=c=black:rate=25:size=${shorts_width}x${shorts_height}:duration=${title_duration} -vf "${short_title_text_settings}:y=(h-text_h)*0.43:text='${month}'" ./tmp/tmp_short_title1.mp4 &> /dev/null
ffmpeg -i ./tmp/tmp_short_title1.mp4 -vf "${short_title_text_settings}:y=(h-text_h)*0.58:text='${year}'" ./tmp/tmp_short_title.mp4 &> /dev/null
add_audio_stream ./tmp/tmp_short_title.mp4 ./tmp/short_title.mp4
echo "file short_title.mp4" >> ./tmp/short_concat_list.txt

for (( i=1; i<=$size; i++ )); do
    day_str=$(printf "%02d" $((i)))
    echo "Creating video file for day ${day_str}"
    outfile="day_${day_str}.mp4"
    # Double brackets used to properly handle filenames with spaces
    if [[ -f ${filename[$i]} ]] && [ ! -z "${timestamp[$i]}" ]; then
        ffmpeg -i "${filename[$i]}" -ss ${timestamp[$i]} -t ${duration} ${transcode_settings} ./tmp/tmp_${outfile} >& /dev/null
        # Check if file has audio stream
        add_missing_audio_stream ./tmp/tmp_${outfile} ${day_str}
        create_thumbnail ./tmp/tmp_${outfile} ${thumbnail_video_timeoffset} ${thumbnail_resolution} ${thumbnail_quality} ./tmp/thumbnails/thumbnail_${day_str}.png
        ffmpeg -i ./tmp/tmp_${outfile} -vf "${daily_text_settings}:text='Day ${day_str}'" ./tmp/${outfile}
        echo "file ${outfile}" >> ./tmp/concat_list.txt

        ffmpeg -i ./tmp/tmp_${outfile} -vf "scale=iw*${scale[$i]}:ih*${scale[$i]}:force_original_aspect_ratio=decrease,pad=3414:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,crop=${shorts_width}:${shorts_height}:${offset[i]}:0" ./tmp/tmp_short_${outfile}
        ffmpeg -i ./tmp/tmp_short_${outfile} -vf "${short_daily_text_settings}:text='Day ${day_str}" ./tmp/short_${outfile}
        echo "file short_${outfile}" >> ./tmp/short_concat_list.txt
    else
        if [ ! -z "${timestamp[$i]}" ]; then
            echo "ERROR: File ${filename[$i]} for day ${day_str} does not exist"
        fi
        if [ -z "${timestamp[$i]}" ]; then
            echo "ERROR: Timestamp for day ${day_str} is not defined"
        fi
    fi
done

save_daily_flash_files $3
output_unique_tags "${tag[@]}"

# Copy thumbnails to thumbnail destination dir
mv ./tmp/thumbnails/* $4
