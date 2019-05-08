#!/bin/bash

# ARGUMENTS
for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            TARGET_DIR)              TARGET_DIR=${VALUE} ;;
            LIMIT_SIZE_MB)           LIMIT_SIZE_MB=${VALUE} ;;
            REFRESH_PERIOD)          REFRESH_PERIOD=${VALUE} ;;
            REMOVE_LARGE_FILES)      REMOVE_LARGE_FILES=${VALUE} ;;
            *)
    esac


done

# ARGUMENTS DEFAULT VALUES
TARGET_DIR=${TARGET_DIR:-empty}
if [ $TARGET_DIR = empty ]
  then
    echo "Please insert target dir!"
    exit
fi
LIMIT_SIZE_MB=${LIMIT_SIZE_MB:-100}
REFRESH_PERIOD=${REFRESH_PERIOD:-60}
REMOVE_LARGE_FILES=${REMOVE_LARGE_FILES:false}

# LOGGING
user="$USER"
log_path=/home/$user/logs
log_file=/home/$user/logs/dir_monitoring_util.log
mkdir -p $log_path
touch $log_file

# SIGNAL HANDLING
exit_gracefully() {
    echo "The util finished gracefully in date:" $now >> $log_file
    trap - SIGINT SIGTERM # clear the trap
    kill -- -$$ # Sends SIGTERM to child/sub processes
}
trap exit_gracefully SIGINT SIGTERM

# Transform Mb --> Kb
limit_size_byte=$((1000000*$LIMIT_SIZE_MB))

check (){

  DIR_SIZE=$(du -s $DIR | grep -o '[0-9]*' 2>&1)

  if [ $DIR_SIZE -ge $limit_size_byte ]
    then
      echo "WARNING!: The directory size" $DIR "exceeds the" $limit_size_byte >> log_file
      if [ "$REMOVE_LARGE_FILES" = true ]
        then
          drop "$DIR"
      fi
  fi

}

drop(){
  rm -rf $DIR
  echo $DIR "Deleted Successfully!"
}

now=$(date)
echo "The util started in date:" $now >> $log_file

while true;
  do
    for DIR in $TARGET_DIR/**; do
      check "$DIR" "$limit_size_byte"
    done
    sleep "$REFRESH_PERIOD"
  done
