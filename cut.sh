#environment
ffmpegFile=/var/packages/ffmpeg/target/bin/ffmpeg
targetPath=./

#args
argsNum=$#
if [[ $argsNum -eq 3 || $argsNum -eq 2 ]]; then
    concat=$1
    tar="${concat%%.*}"

    echo "inputfile:${concat}"
    echo "target:${targetPath}/${tar}.mp4"
    echo "log:${targetPath}/${tar}.log"

    if [ $argsNum -eq 2 ]; then
        nohup ${ffmpegFile} -ss $2 -i ${concat} -c copy ${targetPath}/${tar}.cut.mp4 >${targetPath}/${tar}.log 2>&1 &

    fi
    if [ $argsNum -eq 3 ]; then
        nohup ${ffmpegFile} -ss $2 -i ${concat} -to $3 -c copy ${targetPath}/${tar}.cut.mp4 >${targetPath}/${tar}.log 2>&1 &
    fi

else
    echo "1:filename1 2:strat time 3:end time"
    echo "e.g. cut 111.mp4 00:01:00 00:10:00"
    exit 1
fi
