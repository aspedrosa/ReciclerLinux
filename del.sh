#!/bin/bash

TRASH_DIR=$HOME/.trash

if ! [[ -a "$TRASH_DIR" ]] ; then
  mkdir "$TRASH_DIR"
fi

if ! [[ -d "$TRASH_DIR" ]] ; then
  echo "\$HOME/.trash is a file!"
  echo "Remove it or rename"
  exit 1
fi

for filepath in "$@" ; do 
  if ! [[ -a "$filepath" ]] ; then
    echo "No such file or directory $filepath"
    continue
  fi

  # Remove trailing slashes or spaces
  filename=$(echo $filepath | sed -e 's/[[:space:]]*$//' -e 's/\/*$//')
  # Get only the name of the file form the path
  filename=${filename##*/}

  if ! [[ -a "$TRASH_DIR/$filename" ]] ; then #if there is no file with the same name on the trash just move it
    mv "$filepath" "$TRASH_DIR"
    exit 0
  fi

  # In case duplicates exist
  counter=2
  while true ; do
    printf -v new_filename "%s/%s-%03d" "$TRASH_DIR" "$filename" $counter
    if [[ -a "$new_filename" ]] ; then
      counter=$((counter+1))
      continue
    else
      mv "$filepath" "$new_filename"
      break
    fi
  done
done

