# Filename Standardizer
Standardize the names of files to `PascalCase`, `snake_case`, or `with-hyphens`.
```
(1) PascalCase (ILikeCats123.txt)
(2) snake_case (i_like_cats_123.txt)
(3) hyphen-case (i-like-cats-123.txt)
```
- currently only works for relative paths
- handles input of a folder of files to rename and or a single file

## Running the script
```
./rename-files.sh
```
```
-v | --verbose : verbose output, prints out names of renamed file conversions
-d | --dry-run : test run, no files actually get created, prints out names of renamed file conversions
-p | --pascal-case : use pascal case
-s | --snake-case : use snake case
-h | --hyphen-case : use hyphen case
```
- if the script is not invoked with a filename you will be prompted for filename or folder of files to change
- if the script is not invoked with rename type you will be prompted for rename type
- to test, pass in `test/` as for the filename or folder input `rename-files.sh`
    - generate `test/` folder using `./generate-files.sh` (see [Testing](#Testing) section)
- `./rename-files.sh` : rename files, prompted for input of folder or filename to rename and rename type (as a number from 1 to 3), no verbose output
- `./rename-files.sh -d` : dry run of renaming files, files don't actually get renamed, prompted for input of folder or filename to rename and rename type (as a number from 1 to 3), shows file renames before and after with verbose output
- `./rename-files.sh -v -s` : rename files in snake case with verbose output, prompted for input of folder or filename to rename
- `./rename-files.sh -d -s test/ `: dry run of renaming files in `test/` using snake case


## Testing
Generate test files: empty `.txt` files with weird names to test in test folder `test/`
```
./generate-test-files.sh
```
```
-v | --verbose : verbose output, prints out names of created files
-d | --dry-run : test run, no files actually get created, out prints out filenames
number : number of test files to create, default is 5, max is 100
```
- `./generate-test-files.sh` : creates 5 test files, doesn't print out created filenames
- `./generate-test-files.sh 20` : creates 20 test files, doesn't print out created filenames
- `./generate-test-files.sh -d 20` : generates filenames for 20 testfiles, test run so files don't get created
- `./generate-test-files.sh -v 20` : creates 5 test files, prints out created filenames

## TODO
- for `./generate-test-files.sh`
    - flag to delete old `/test` flag
- for `./rename-files.sh`
    - handle absolute path
    - flag to rename folders
    - take in multiple inputs (filenames)
    - camel case

## Resources
- [Convert underscore to PascalCase](https://unix.stackexchange.com/a/196241)
- [Get absolute path of relative directory](https://stackoverflow.com/a/24112741)
- [Extract filename and extension](https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash)
- [Get File Directory from file path](https://stackoverflow.com/questions/6121091/get-file-directory-path-from-file-path)
- [Read multiple inputs](https://stackoverflow.com/questions/56145999/shell-script-read-multiple-inputs-from-user)   


-----

- [Generate random alphanumeric strings](https://gist.github.com/earthgecko/3089509)
- [test utilties documentation](https://pubs.opengroup.org/onlinepubs/009695399/utilities/test.html)
- [Parsing command line arguments and flags](https://pretzelhands.com/posts/command-line-flags)
