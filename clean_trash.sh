#!/bin/bash
IFS=$'\n' # use newline as seperator insted of spaces
          # needed for files with spaces

###############################################################
#                                                             #
# This script executes every time a user logs in              #
# Goes over all the files on the trash directory and removes  #
#  the ones that are there more than the delay defined        #
#                                                             #
###############################################################

#################################################### Constants

TRASH_DIR="$HOME/.trash"          # Path to the trash directory
LOG_FILE="$HOME/.clean_trash.log" # Path to the log file of removes from trash
MAX_DELAY=$((2 * 25 * 60 * 60))   # Time after which files on the trash are removed

####################################################

#################################################### Code

# If the trash directory doesn't exist
# -create the directory
# -exit (Nothing to remove)
if ! [[ -a $TRASH_DIR ]] ; then
  mkdir $TRASH_DI
  exit 0
fi

removes=() # Holds the logs of removes

# Iterate over all files on the trash
for filename in $(ls -A $TRASH_DIR) ; do
  filepath="$TRASH_DIR/$filename"

  # Time when the file was moved to the trash
  time_last_change=$(stat -c "%Z" "$filepath")

  # Calculate the time that has passed since the move to the trash
  delay=$(($(date +"%s") - time_last_change))

  # If the delay calculated exceeded the max delay defined remove it
  if [[ delay -gt MAX_DELAY ]] ; then
    if [[ -d "$filepath" ]] ; then
      removes+=("Removed directory $filename | Last change on $(stat -c '%z' "$filepath")")
      rm -r "$filepath"
    else
      removes+=("Removed file $filename | Last change on $(stat -c '%z' "$filepath")")
      rm "$filepath"
    fi
  fi
done

# If anything was removed log it (appends to the log file)
if [[ ${#removes[@]} -gt 0 ]] ; then 
  date >> $LOG_FILE
  for log in "${removes[@]}" ; do
    echo $log >> $LOG_FILE
  done
fi

#################################################### Code
