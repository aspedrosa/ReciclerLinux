#!/bin/bash

TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.clean_trash.log"
MAX_DELAY=$((3 * 24 * 60 * 60))   # Time after which files on the trash are removed

if ! [[ -a $TRASH_DIR ]] ; then # In the trash dir don't exit
  mkdir $TRASH_DIR
  exit 0
fi

removes=() # Holds the outputs of the removes

for filename in $(ls $TRASH_DIR) ; do
  time_last_change=$(stat -c "%Z" $filename)
  delay=$(($(date +"%s") - time_last_change))
  if [[ delay -gt MAX_DELAY ]] ; then
    if [[ -d $filename ]] ; then
      rm -r $filename
      removes+=("Removed dir $filename | Last change on $(stat -c '%z' $filename)")
    else
      rm $filename
      removes+=("Removed file $filename | Last change on $(stat -c '%z' $filename)")
    fi
  fi
done

if [[ ${#removes[@]} -gt 0 ]] ; then # If anything was removed log it
  date >> $LOG_FILE
  for log in "${removes[@]}" ; do
    echo $log >> $LOG_FILE
  done
fi
