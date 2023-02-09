#!/usr/bin/env bash

NIXOS=1
OPTIND=1

SOURCE=${BASH_SOURCE[0]}
# resolve $SOURCE until the file is no longer a symlink
while [ -L $SOURCE ]; do
    TARGET=$(readlink "$SOURCE")
    if [[ $TARGET == /* ]]; then
	SOURCE=$TARGET
    else
	DIR=$( dirname "$SOURCE" )
	# if $SOURCE was a relative symlink, we need to resolve it relative
	# to the path where the symlink file was located
	SOURCE=$DIR/$TARGET
    fi
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

IDENTIFIER="poxuy"

NC='\033[0m'
BRED='\033[1;31m'
BBLUE='\033[1;34m'
BYELLOW='\033[1;33m'

function usage() {
    echo -e "Usage: ${SOURCE/$DIR/.} [-r/-c <string>]"
    echo "-c -- create"
    echo "-r -- remove"
}

function create() {
    if [ $(is_exist $DIR/$IDENTIFIER) = true ]; then
	echo "${BYELLOW}Sorry, but this one already exists.${NC}"
	return 0
    fi
    
    mkdir $DIR/$IDENTIFIER
    rsync -a --exclude='.build' --exclude='svg-inkscape' --exclude 'pic' $DIR/template/ $DIR/$IDENTIFIER
    echo $IDENTIFIER > $DIR/$IDENTIFIER/tex/index.tex
    echo "$(date +'%d %B %Y г.')" > $DIR/$IDENTIFIER/tex/date.tex
    echo "${BBLUE}Successfully created labs/$IDENTIFIER.${NC}"
}

function remove() {
    if [ $(is_exist $DIR/$IDENTIFIER) = false ]; then
	echo "${BYELLOW}Sorry, but this one doesn't exist.${NC}"
	return 0
    fi

    if ! [ -z "$(git -C $DIR status --porcelain)" ]; then
	echo "${BRED}You can't use this option while having uncommitted changes.${NC}\n"
	return 0
    fi
    rm -r $DIR/$IDENTIFIER
    echo "${BBLUE}Successfully removed labs/$IDENTIFIER.${NC}"
    return 0
}

function is_exist() {
    if [ -d $1 ]; then
	echo "true"; return 0
    fi
    echo "false"; return 0
}

usagep=true
createp=false
removep=false

if getopts 'c:r:' OPTION; then
    case $OPTION in
	c)
	    createp=true
	    usagep=false
	    IDENTIFIER=$OPTARG
	    ;;
	r)
	    removep=true
	    usagep=false
	    IDENTIFIER=$OPTARG
	    ;;
    esac
fi

if [ $usagep = true ]; then
    usage
elif [ $removep = true ]; then
    echo -e $(remove)
elif [ $createp = true ]; then
    echo -e $(create)
fi
