#!/bin/bash

# Bash script for generating random test files in test/
VERBOSE_MODE=false
TEST_MODE=false
OTHER_ARGUMENTS=()

FILE_COUNT=5
MAX_FILE_COUNT=100
EXTENSION=".txt"
FOLDER="test"

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -v|--verbose) #verbose
            VERBOSE_MODE=true
            shift
            ;;
        -d|--dry-run) #dry-run
            TEST_MODE=true
            shift
            ;;
        *)
            OTHER_ARGUMENTS+=("$1")
            shift # Remove generic argument from processing
            ;;
    esac
done

# echo "# Other arguments: ${OTHER_ARGUMENTS[*]}"
# if we are passed in a number
if (( ${#OTHER_ARGUMENTS[@]} > 0 )) ; then
    re='^[0-9]+$'
    firstArg=${OTHER_ARGUMENTS[0]}
    if ! [[ $firstArg =~ $re ]] ; then
        echo "Error: Input not a number"
    else
        if (( $firstArg <= $MAX_FILE_COUNT )); then
            FILE_COUNT=$firstArg
        else
            printf "File count input number exceeds max file count: $MAX_FILE_COUNT \n"
        fi
    fi
fi

# make test/ if it does not already exist
# should we remove folder if it already exists?
if [[ -d $FOLDER ]]; then
    :
    # echo "test/ folder exists"
    # rm -rf $FOLDER
else 
    # echo "test/ folder does not already exist, making folder"
    mkdir $FOLDER
fi

printf "Generating $FILE_COUNT test files...\n"
for (( c=1; c<=$FILE_COUNT; c++ ))
do
    # generate random string of A-Za-z0-9, _, -, ., space
    NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9\_\-\. ' | fold -w 20 | head -n 1)
    filename="$FOLDER/$NEW_UUID$EXTENSION"
    if $VERBOSE_MODE || $TEST_MODE; then
        echo "$filename"
    fi
    if ! $TEST_MODE ; then
        touch "$filename"
    fi
done