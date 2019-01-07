#!/bin/bash

# where we will save photos and json (photo meta data)
CONTENT_DIR='/6TB/photos-flickr/raw_from_flickr/'
FLICKR_USERNAME='chadn'

# no matter where called from, set MYDIR to be directory containing this runme.sh script
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
LOGFILE=$CONTENT_DIR/runme.log
PID=$$
# redirects stderr and stdout to same place (exec &>) then add timestamp, then append to LOGFILE
exec &> >(while read line; do echo "$(date +'%Y-%m-%dT%H:%M:%S%z-%a') $PID $line" >> $LOGFILE; done;)


getTodo() {
  cd $MYDIR
  python flickr_download/flick_download.py --debug --download_user_photo_list $FLICKR_USERNAME
  cat photoIds-$FLICKR_USERNAME.txt | sort > $CONTENT_DIR/photoIds-todo.txt
}

# create todo list of photos that still need to be downloaded, removing any already downloaded.
updateTodo() {
  cd $CONTENT_DIR
  ls *.json |sed 's/.json//' |sort -u>photoIds-tmp.txt && mv photoIds-tmp.txt photoIds-done.txt
  diff --changed-group-format='%<' --unchanged-group-format='' photoIds-todo.txt photoIds-done.txt |sort -u >todo.tmp
  mv todo.tmp photoIds-todo.txt
  echo "Photos remaining to download: " $(wc -l photoIds-todo.txt) 
}

main() {
  if [ ! -f "$CONTENT_DIR/photoIds-todo.txt" ]; then
    # only fetch list of photos if have not done already
    getTodo
  fi
  updateTodo
  cd $MYDIR
  python flickr_download/flick_download.py --debug -n id --save_json --content_dir $CONTENT_DIR --photo_list_file photoIds-todo.txt
  updateTodo

  if [ -s photoIds-todo.txt ]; then
    # todo file is not empty, python probably crashed, try again
    echo "runme.sh try again"
    main
  fi
}

echo "runme.sh Start"
main
echo "runme.sh Done"
