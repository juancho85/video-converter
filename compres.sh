#!/bin/bash

# Remove accents and espaces from files and folders
find . -depth -name '* *' \
-execdir bash -c 'mv -- "$1" "${1// /-}"' bash {} \;
find . -depth -name '*Á*' \
-execdir bash -c 'mv -- "$1" "${1//Á/A}"' bash {} \;
find . -depth -name '*É*' \
-execdir bash -c 'mv -- "$1" "${1//É/E}"' bash {} \;
find . -depth -name '*Í*' \
-execdir bash -c 'mv -- "$1" "${1//Í/I}"' bash {} \;
find . -depth -name '*Ó*' \
-execdir bash -c 'mv -- "$1" "${1//Ó/O}"' bash {} \;
find . -depth -name '*Ú*' \
-execdir bash -c 'mv -- "$1" "${1//Ú/U}"' bash {} \;
find . -depth -name '*á*' \
-execdir bash -c 'mv -- "$1" "${1//á/a}"' bash {} \;
find . -depth -name '*é*' \
-execdir bash -c 'mv -- "$1" "${1//é/e}"' bash {} \;
find . -depth -name '*í*' \
-execdir bash -c 'mv -- "$1" "${1//í/i}"' bash {} \;
find . -depth -name '*ó*' \
-execdir bash -c 'mv -- "$1" "${1//ó/o}"' bash {} \;
find . -depth -name '*ú*' \
-execdir bash -c 'mv -- "$1" "${1//ú/u}"' bash {} \;

# Transform GIFS: into mp4 https://unix.stackexchange.com/questions/40638/how-to-do-i-convert-an-animated-gif-to-an-mp4-or-mv4-on-the-command-line
for format in gif GIF
do
  for file in $(find . -depth -name "*.${format}")
  do
    echo "Transforming gif into mp4: ${file}"
    ffmpeg -i "${file}" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${file}.mp4"
  done
done

# Convert MOV into mp4
for format in MOV mov
do
  for file in $(find . -depth -name "*.${format}")
  do
    echo "Transforming mov into mp4:: ${file}"
    ffmpeg -i "${file}" -vcodec h264 -acodec mp2 "${file}.mp4"
  done
done

# Compress mp4 and mov to ~ 2MB
for format in mp4 MP4 MOV mov
do
  echo "format: ${format}"
  for file in $(find . -depth -name "*.${format}")
  do
    size=$(stat -c '%s' "${file}")
    echo "file: ${file}"
    echo "size: ${size}"
    if [ $size -gt 2000000 ]
    then
      echo "test"
      duration=$(ffprobe -i "${file}" -show_entries format=duration -v quiet -of csv="p=0")
      bitrate=$(python -c "print(14000000/${duration})")
      echo "File: ${file}, Duration: ${duration}, Bitrate: ${bitrate}"
      newname=$(echo ${file} | sed -d "")
      ffmpeg -i "${file}" -b ${bitrate} "${file}.mini.${format}"
    fi
  done
done

# Remove extra extensions from file names
find . -depth -name '*MP4.*' \
-execdir bash -c 'mv -- "$1" "${1//MP4./}"' bash {} \;
find . -depth -name '*mp4.*' \
-execdir bash -c 'mv -- "$1" "${1//mp4./}"' bash {} \;
find . -depth -name '*MOV.*' \
-execdir bash -c 'mv -- "$1" "${1//MOV./}"' bash {} \;
find . -depth -name '*mov.*' \
-execdir bash -c 'mv -- "$1" "${1//mov./}"' bash {} \;
find . -depth -name '*GIF.*' \
-execdir bash -c 'mv -- "$1" "${1//GIF./}"' bash {} \;
find . -depth -name '*gif.*' \
-execdir bash -c 'mv -- "$1" "${1//gif./}"' bash {} \;