#!/bin/bash

#######################################################
#                                                     #
# "del" command                                       #
# Is a safe version of "rm" just moving the           #
#  file/directory to a trash folder, allowing         #
#  the user to easily recover files                   #
# You still have the "rm" command                     #
#                                                     #
#######################################################

######################## Constants

TRASH_DIR=$HOME/.trash

########################

######################## Code

# Create the trash directory if it doesn't exist
if ! [[ -a "$TRASH_DIR" ]] ; then
  mkdir "$TRASH_DIR"
fi

# Fail if the path to the trash location is a file
if ! [[ -d "$TRASH_DIR" ]] ; then
  echo "\$HOME/.trash is a file!"
  echo "Remove it or rename"
  exit 1
fi

# Iterate over all file paths
for filepath in "$@" ; do 
  # If file/directory doesn't exit echo an error and go to the next filepath
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
    continue
  fi

  # In case duplicates exist insert the file/directory with "-counter" at the end
  counter=2
  while true ; do
    # Create the new filename according to the current counter
    # Put it on the new_filename variable
    printf -v new_filename "%s/%s-%03d" "$TRASH_DIR" "$filename" $counter

    # If a file with that counter already exists increment the counter and go to the next iteration
    if [[ -a "$new_filename" ]] ; then
      counter=$((counter+1))
      continue
    # If there is no other file with that counter move it to the trash with the new name
    else
      mv "$filepath" "$new_filename"
      continue
    fi
  done
done

######################## Code
