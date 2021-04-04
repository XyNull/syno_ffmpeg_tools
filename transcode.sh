#environment
ffmpegFile=/var/packages/ffmpeg/target/bin/ffmpeg
targetPath=/volume3/download2/encode/

#args
argsNum=$#
if [[ $argsNum -gt 2 || $argsNum -eq 1 ]]; then
    if [ $argsNum -gt 2 ]; then
        tar=${!argsNum}
        echo "target name:$tar"
        concat='concat:'

        for i in "$@"; do
            concat+=$i"|"
        done
        concat=${concat%$tar*}
        echo "merge file:${concat}"
        ${ffmpegFile} -i ${concat} -c copy ${targetPath}/${tar}.merge.mp4
        echo "merge over"
        concat=${targetPath}/${tar}.merge.mp4
    else
        concat=$1
        tar="${concat%%.*}"
    fi

    echo "inputfile:${concat}"
    echo "target:${targetPath}/${tar}.mp4"
    echo "log:${targetPath}/${tar}.log"

    nohup ${ffmpegFile} -hwaccel qsv -i ${concat} -f mp4 -c:v hevc_qsv -global_quality:v 18 -c:a copy -profile:v main -preset slow ${targetPath}/${tar}.mp4 >${targetPath}/${tar}.log 2>&1 &

else
    echo "USAGE:1:filename for transcode 1 file or 1:filename1 2:filename2... n-1:filenameX n:targetName for merge X file"
    exit 1
fi
