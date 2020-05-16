#!/bin/bash

# Bash script to enable easy standardizing of file name formatting

TEST_MODE=false
VERBOSE_MODE=false
OTHER_ARGUMENTS=()

DEFAULT_VALUE=-1
renameType=DEFAULT_VALUE

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
        -p |--pascal-case)
            renameType=1
            shift
            ;;
        -s |--snake-case)
            renameType=2
            shift
            ;;
        -h |--hyphen-case)
            renameType=3
            shift
            ;;
        *)
            OTHER_ARGUMENTS+=("$1")
            shift # Remove generic argument from processing
            ;;
    esac
done

# check if filename was given as an input
# TODO handle multiple filenames or folders
if (( ${#OTHER_ARGUMENTS[@]} < 1 )) ; then
    # TODO handle absolute path
    echo "Input (relative) path of folder with files or a filename"
    echo "folder format: 'folder/' filename format: 'folder/filename.txt' "
    echo "To test, input 'test/'"
    read filenameOrFolder
else  # we were passed in the foldername
    filenameOrFolder=${OTHER_ARGUMENTS[0]}
fi 

# see if we need to prompt for rename type
if (( $renameType == $DEFAULT_VALUE )) ; then
    echo "Take an input of rename type: (enter 1, 2, or 3)"
    echo "(1) PascalCase (ILikeCats123.txt)"
    echo "(2) snake_case (i_like_cats_123.txt)"
    echo "(3) hyphen-case (i-like-cats-123.txt)"
    # # TODO: camel case
    read renameType
fi

re='^[1-3]$'
if ! [[ $renameType =~ $re ]] 
then
    echo "Error: Not a number or not in the domain" >&2; exit 1
fi

# # tester, comment this out
# TEST_RUN=false 
# if $TEST_RUN ; then
#     echo "using test run files"
#     renameType=2 # tester
#     filenameOrFolder="test/" # tester 
#     # filenameOrFolder="test/test1.txt" #tester
# fi

if $TEST_MODE ; then
    echo "Test mode"
fi

# TODO: handle both relative and absolute paths
parentPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function moveToRenamedFile(){
    local currPath="$1"
    local src="$2"
    local dest="$3"

    if $VERBOSE_MODE || $TEST_MODE; then
        echo "$src --> $dest"
    fi
    # dest is not the same as src and dest does not already exist
    if [[ $src != $dest ]] && [[ ! -a $dest ]]; then
    # only move if not test mode
        if ! $TEST_MODE ; then
            mv "$currPath/$src" "$currPath/$dest"
        fi
    fi
}

# else a file
# current directory
if [[ "$filenameOrFolder" == '' || "$filenameOrFolder" == '/' ]]; then
    echo "Disabled renaming of the current directory (for safety)"
else # for sub folders and file
    currPath="$parentPath/$filenameOrFolder"

    # make sure it exists
    if [[ -e "$filenameOrFolder" ]]; then
        # for directories
        if [[ -d "$filenameOrFolder" ]]; then
            iterfolder="$currPath*"
            printf "Renaming files in folder: $currPath \n"
        # for file
        elif [[ -f "$filenameOrFolder" ]]; then
            iterfolder="$currPath"
            printf "Renaming file: $currPath \n"
        else 
            echo "Error: input not a folder or filename"
        fi
    else
        echo "Error: filename or folder does not exist"
        exit 1
    fi
    
    # print converstion case
    case $renameType in 
        1)
            printf "Pascal Case Conversion \n"
            ;;
        2) 
            printf "Snake Case Conversion \n"
            ;;
        3) 
            printf "Hyphen Case Conversion \n"
            ;;
        *) # default
            echo "Error: Invalid rename type"
            exit 1
            ;;
    esac

    for fullfile in $iterfolder; do
        filename="${fullfile##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
        currPath="$(dirname "${fullfile}")"

        # ignore filenames without extensions, ignore folders
        # TODO have a flag that bypasses this
        if [[ "$extension" == "$filename" ]]; then
            if $VERBOSE_MODE ; then
                echo "Bypassing renaming of:" $filename
            fi
            continue
        fi

        case $renameType in 
            1)
                # printf "PASCAL CONVERSION: "
                seed="sed -r 's/(^|_|-| |\.)+([A-Za-z0-9])/\U\2/g'"
                dest=$(echo $filename | eval $seed)."$extension"
                src="$filename.$extension"
                moveToRenamedFile "$currPath" "$src" "$dest" 
                ;;
            2) 
                # printf "UNDERSCORE CONVERSION: "
                # lowercase everything
                # sed -e "s/\(.*\)/\L\1/"
                # replace all dots, dashes, spaces with an underscore # replace capital letters with underscore and lowercased letter # remove leading underscores
                seed="sed -r 's/(^|_|-| |\.)+([A-Za-z0-9])/\U\2/g' | perl -pe 's/([A-Z]|[0-9]+|(?<=[0-9])[a-z]|(?![a-z])[0-9]+)/_\L\1/g' | sed -r 's/^_+//g'"
                dest=$(echo $filename | eval $seed)."$extension"
                src="$filename.$extension"
                moveToRenamedFile "$currPath" "$src" "$dest" 
                ;;
            3) 
                # printf "HYPHEN CONVERSION: "
                # convert to pascal case # replace capital letters with dash and lowercased letter # remove leading dash
                # seed="sed -r 's/(^|\.|_| )/-/g' | sed -r 's/([A-Z])/-\L\1/g' | sed -r 's/^-+//g'"
                seed="sed -r 's/(^|_|-| |\.)+([A-Za-z0-9])/\U\2/g' | perl -pe 's/([A-Z]|[0-9]+|(?<=[0-9])[a-z]|(?![a-z])[0-9]+)/-\L\1/g' | sed -r 's/^-+//g'"
                # ^(?!(?:[^|]*\|){2})
                dest=$(echo $filename | eval $seed)."$extension"
                src="$filename.$extension"
                moveToRenamedFile "$currPath" "$src" "$dest" 
                ;;
            *) # default
                echo "Error"
                exit 1
                ;;
        esac
    done
fi