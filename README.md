# Directory Monitoring Tool
A simple bash tool for monitoring the size of objects inside a directory.

## How to run
Make dir_monitoring_util.sh executable
```{shell}
cmhod +x dir_monitoring_util.sh
```
Run in the background and without creating nohup.out file

```{shell}
nohup ./dir_monitoring.sh TARGET_DIR=/home/geo/test_dir LIMIT_SIZE_MB=1 REFRESH_PERIOD=20 REMOVE_LARGE_FILES=true >/dev/null 2>&1 & 
```
Script parameters:
* `TARGET_DIR (string):` The path of the directory which you want to monitor.(default value=empty)
* `LIMIT_SIZE_MB (integer):` The max number(Mb) of the files/dirs which you want to keep in the target dir (default value=100)
* `REFRESH_PERIOD (interger):` The refreshing period of the tool in seconds (default value=60)
* `REMOVE_LARGE_FILES (boolean):` `true` if you want to delete the files/dirs higher than the `LIMIT_SIZE_MB` and `false` if you want to keep them and only log the event. (default value=false)

## Example
Let's take an example. Run the tool with `TARGET_DIR=\target_dir` & `LIMIT_SIZE_MB=100`.
Before the tool run:
```{shell}
\
|__target_dir\
   |__directory_one
   |__diretory_two
   |__directory_three
   |  |__directory_four
   |     |__large_file (file size 200Mb)
   |__small_file (file size: 19Mb)
```
After the run of the tool:
```{shell}
\
|__target_dir\
   |__directory_one
   |__diretory_two
   |__small_file (file size: 19Mb)
```


## Notes
* The log file is in /home/**user**/logs/dir_monitoring_util.log.
* Doesn't work with directories with numbers in the names (e.x dir_1).
* Loop in the sub-directories of the `TARGET_DIR`, not nested checks.
* Check the permissions of the folders if you want also to drop them.
* Can monitor files/dirs more than 1Mb `LIMIT_SIZE_MB>=1`.
