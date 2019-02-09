# TrashLinux

## Intro

Did ever happen to you accidentally removing a file or an entire directory by using the `rm` command? Well, it happen to
  me unfortunately on some important work. At that time I search for solutions try to get my work back. I end up giving up and
  doing all the work all over again (Still able to finish the work :sweat_smile:).

However one way that I found while searching how to recover my data was to have another command that instead of removing
  the files/directories just moves them to another folder.

You might be thinking "But you can get that `rm` prompts you when removing files or folders!". You are right, but this
  will lead to unnecessary prompts for some files that you are 100% sure that you want to remove.

My solution was to create two bash scripts:

- `del.sh` - Creates a new `del` command
- `clean_trash.sh` - Cleans the trash folder

Because the new `del` command is just a move of files/directories you will end up with a lot of files stored in disk
  that you really wanted to remove. To solve this I developed a script that executes every time you login and checks
  since when each file is in the trash folder. The ones that are there over a defined time are removed.
By creating a new command and not just name it also `rm` you and other programs are still able to used the `rm` command.

## Installation

1. Make the `del` command accessible
For this you can either:

- Add the directory where the `del.sh` is stored to the `PATH` environment variable `PATH="$PATH:CURRENT_DIR"` (
the dot sh will be on the command though)
- Create a symbolic link on ones of the `PATH`'s directories to `del.sh`, e.g. `/usr/bin`.

You can also do this to the `clean_trash.sh` script so you can run it whenever you want.

2. Make the clean trash script run on every login
Add a symbolic link to `clean_trash.sh` in `/etc/profile.d`
On this script you can change the max delay of how long the files can stay on the trash directory.
