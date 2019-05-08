# directory-monitoring-util
Bash util for monitoring the size of directories in linux envs.

## How to run
```{shell}
# Make dir_monitoring_util.sh executable
cmhod +x dir_monitoring_util.sh

# Run in the background without creating nohup.out file
nohup ./dir_monitoring.sh TARGET_DIR=/home/geo/test_dir LIMIT_SIZE_MB=1 REFRESH_PERIOD=20 REMOVE_LARGE_FILES=true >/dev/null 2>&1 & 
```
## Notes
* The log file is in /home/**user**/logs/dir_monitoring_util.log
