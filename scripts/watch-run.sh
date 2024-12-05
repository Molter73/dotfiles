#!/usr/bin/env bash

set -u

function usage() {
    echo "$(basename "$0") [OPTIONS] -d <directory> cmd"
    echo ""
    echo "Wait for file changes on directory and run the given command."
    echo "Options:"
    printf "\t-d, --dir <directory>\n"
    printf "\t\tWatch the given directory for changes.\n"
    printf "\t-x, --exclude <patter>\n"
    printf "\t\tPattern for files to be excluded from watch\n"
}

if ! command -v inotifywait >/dev/null; then
    echo >&2 "inotifywait not found"
    exit 1
fi

TEMP=$(getopt -o 'd:x:h' -l 'dir:,exclude:,help,' -n "$0" -- "$@")

if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$TEMP"
unset TEMP

# Defaults
DIR="$PWD"
EXCLUDES=""

while true; do
    case "$1" in
        '-d' | '--dir')
            DIR="$2"
            shift 2
            ;;

        '-x' | '--exclude')
            if [[ -z "${EXCLUDES}" ]]; then
                EXCLUDES="--exclude '$2'"
            else
                EXCLUDES="${EXCLUDES::-1}|$2'"
            fi
            shift 2
            ;;

        '-h' | '--help')
            usage
            exit 0
            ;;

        '--')
            shift
            break
            ;;
    esac
done

if [[ $# -eq 0 ]]; then
    echo >&2 "A command was not provided"
    usage
    exit 1
fi

echo "Watching $DIR for changes..."

while true; do
    eval inotifywait -qq -e close_write -r "${EXCLUDES}" "$DIR"
    sleep 0.2
    "$@"
done
