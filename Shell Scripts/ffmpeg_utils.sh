function x265tox264() {
    if [ $# -ne 1 ]; then
        printf "One argument expected $# given\n"
        printf "Usage:\n\tx265tox264 movie.format\n"
        return 1
    fi
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    dest_dir="$root_dir""/x264"
    
    if [ ! -d "$dest_dir" ]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$file_name"
    
    echo "Trying to convert to x264.."
    ffmpeg -i "$@" -map 0 -c:a copy -c:s copy -c:v libx264 "$dest_file"
}

function clipVideo() {
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    dest_dir="$root_dir""/clipped"
    start=$2
    end=$3

    if [ ! -d "$dest_dir" ]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$start""_""$end""_""$file_name"
    
    echo -e "\nClipping $file_name from $start to $end\n"
    ffmpeg -i "$1" -map 0 -ss "$2" -to "$3" -c copy "$dest_file"
}

function addsub(){
    file_name=$(basename "$1")
    ext="${file_name##*.}"
    root_dir=$(dirname "$1")
    subtitles=$2

    dest_file="$root_dir""/subbed_""$file_name"
    echo -e "\nAdding subs:$subtitles to $file_name\n"

    # (xfce4-terminal --working-directory="$root_dir" --command="watch -n 1 \"du -h '$file_name' '$dest_file'\"")

    srt="mov_text" ## for mp4
    if [ $ext == "mkv" ]; then
        srt="srt"
    fi
    
    ffpb -i "$subtitles" -i "$1" -c copy -c:s $srt "$dest_file"

    if [ $? == 0 ]; then
        echo -e "Subtiles added successfullly\n"
        rm "$file_name" "$subtitles"
        mv "$dest_file" "$file_name"
    else
        echo -e "\nFailed to add subtitles\n"
        rm "$dest_file"
    fi
}

function addsub2all(){
    for file in *
    do
        file_name=$(basename "$file")
        name="${file_name%.*}"
        ext="${file_name##*.}"
        root_dir=$(dirname "$file")
        subtiles="$root_dir""/""$name".srt
        if  [ -f "$subtiles" ] && ([ $ext == "mkv" ] || [ $ext == "mp4" ] || [ $ext == "m4v" ]); then
            addsub "$file" "$subtiles"
        fi
    done
}

function tomp3(){
    mkdir mp3_tmp
    for i in *.$1
    do 
        (ffmpeg -i "$i" -acodec libmp3lame "./mp3_tmp/$(basename "${i/.$1}").mp3") 
        if [ $? -eq 0 ]
        then
            echo "Conversion successful"
            rm "$i"
        fi
    done
    mv -v mp3_tmp/* ./
    rm -rf mp3_tmp
}
