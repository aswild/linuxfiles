#!/bin/bash
#######################################################################
#
# selectf.sh
#
# Copyright (c) 2016-2018 Allen Wild
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#######################################################################

print_help()
{
    local B=$(tput bold)
    local N=$(tput sgr0)
    {
        cat <<EOF
  Usage: $(basename $0) [options] [-e command] <pattern> [<find options>...]

  ${B}find${N} will be invoked with ${B}<pattern>${N}, and a menu will be presented
  to choose from the results. When a match is selected, selectf will exec the
  chosen command in the form '<command> <options> <matching file/directory>'

  ${B}Options:${N}
  ${B}-e <command>${N}  command to exec
  ${B}-c${N}            cd to directory before exec
  ${B}-p${N}            just print the selected file/directory, don't exec
  ${B}-D${N}            debug mode (print the find command run)
  ${B}-h${N}            Show help

  Vim Options:
  ${B}-a${N}            Open all matches in tabs rather than prompting for selection
  ${B}-g${N}            gvim instead of vim
  ${B}-t${N}            use gvim '--remote-tab-silent'
  ${B}-T${N}            Start a new gvim [default]

  Find Options:
  ${B}-C <dir>${N}      find in <dir> instead of pwd
  ${B}-L${N}            Follow symlinks
  ${B}-f${N}            find files [default]
  ${B}-d${N}            find directory names

  ${B}-n${N}            find names [default]
  ${B}-P${N}            find full path
  ${B}-r${N}            use regex in find (full path match)
  ${B}-i${N}            ignore case
EOF
    } >&2
}

###################################
# Settings and Defaults
###################################

FIND_IGNORE_DIRS=(
    '*/.git'
    '*/.pc'
    '*/.repo'
    '*/.cache'
)
FIND_IGNORE_FILES=(
    '*.swp'
    '*.pyc'
    '*.orig'
    '*.[ado]'
)


# option defaults
GVIM_REMOTE_TAB=false
FIND_DIR=.
FIND_TYPE=f
FIND_PATTERNTYPE=name

# Multi-Call modes
# Possible permutations of [g]vimf[r][i][a]
name=$(basename $0)
[[ $name == vimf*    ]] && COMMAND=vim
[[ $name == gvimf*   ]] && COMMAND=gvim
[[ $name == *vimfr*  ]] && FIND_PATTERNTYPE=regex
[[ $name == *vimf*i* ]] && IGNORE_CASE=true
[[ $name == *vimf*a  ]] && VIM_OPEN_ALL=true

###################################
# Parse Args
###################################

while getopts "e:cpDagtTLfdnPrih" opt; do
    case $opt in
        e) COMMAND="$OPTARG"        ;;
        c) CD_FIRST=true            ;;
        p) PRINT_ONLY=true          ;;
        D) DEBUG=true               ;;
        a) VIM_OPEN_ALL=true        ;;
        g) COMMAND=gvim             ;;
        t) GVIM_REMOTE_TAB=true     ;;
        T) GVIM_REMOTE_TAB=false    ;;
        L) FIND_SYMLINKS=true       ;;
        f) FIND_TYPE=f              ;;
        d) FIND_TYPE=d              ;;
        n) FIND_PATTERNTYPE=name    ;;
        P) FIND_PATTERNTYPE=path    ;;
        r) FIND_PATTERNTYPE=regex   ;;
        i) IGNORE_CASE=true         ;;
        h)
            print_help
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires an argument!" >&2
            print_help
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            print_help
            exit 1
            ;;
    esac
done
shift $(($OPTIND - 1))

# pattern to find
PATTERN="$1"
shift
USER_FINDARGS=("$@")

if [[ -z $PATTERN ]]; then
    echo "A pattern is required!" >&2
    print_help
    exit 1
fi

# command to exec
if [[ -z $COMMAND ]] && [[ $PRINT_ONLY != true ]]; then
    echo "A command is required!" >&2
    print_help
    exit 1
fi

# optional arguments to COMMAND
OPTIONS=()
if [[ $COMMAND == *vim ]] && [[ $VIM_OPEN_ALL == true ]]; then
    OPTIONS+=(-p)
fi
if [[ $COMMAND == gvim ]] && [[ $GVIM_REMOTE_TAB == true ]]; then
    OPTIONS+=(--remote-tab-silent)
fi

###################################
# build find command
###################################

FINDARGS=()
if [[ $FIND_SYMLINKS == true ]]; then
    FINDARGS+=(-L)
fi
FINDARGS+=("${USER_FINDARGS[@]}")

# files/paths to ignore
for ignore in "${FIND_IGNORE_DIRS[@]}"; do
    FINDARGS+=( -not \( -path "$ignore" -prune \) )
done
for ignore in "${FIND_IGNORE_FILES[@]}"; do
    FINDARGS+=( -not \( -name "$ignore" \) )
done

# wrap the pattern in wildcards if there's none in the specificed pattern
if [[ $FIND_PATTERNTYPE == name ]] && ( ! grep -q '[*?]' <<<"$PATTERN" ); then
    PATTERN="*${PATTERN}*"
fi
if [[ $IGNORE_CASE == true ]]; then
    FIND_PATTERNTYPE="i${FIND_PATTERNTYPE}"
fi

FINDARGS+=( -type $FIND_TYPE -$FIND_PATTERNTYPE "$PATTERN" -print0 )
if [[ $DEBUG == true ]]; then
    echo "find ${FINDARGS[*]}" >&2
fi

###################################
# Get the results from find
###################################

# while-read loop adapted from http://mywiki.wooledge.org/BashFAQ/020
RESULTS=()
count=0
while IFS= read -r -d $'\0' result; do
    RESULTS+=("$result")
done < <( find "${FINDARGS[@]}" 2>/dev/null )

if [[ -z "$RESULTS" ]] || [[ ${#RESULTS[@]} == 0 ]]; then
    echo "No matches found!" >&2
    exit 2
elif [[ ${#RESULTS[@]} == 1 ]]; then
    SELECTION=("${RESULTS[0]}")
elif [[ $VIM_OPEN_ALL == true ]]; then
    SELECTION=("${RESULTS[@]}")
else
    # Prompt to select the the match
    PS3="Select Match> "
    select sel in "${RESULTS[@]}"; do
        if [[ -n "$sel" ]]; then
            SELECTION=("$sel")
            break
        elif [[ $REPLY == q ]]; then
            # selecting 'q' bails with exit success
            echo "Abort" >&2
            exit 0
        else
            echo "Invalid Selection: $REPLY" >&2
        fi
    done
fi

###################################
# Take action
###################################

if [[ $PRINT_ONLY == true ]]; then
    # there's probably only one thing selected, but in case there's more,
    # print all with newline separators
    ( IFS=$'\n' ; echo "${SELECTION[*]}" )
    exit 0
fi

if [[ $CD_FIRST == true ]]; then
    # cd first only works for a single result
    cd "$(dirname "${SELECTION[0]}")"
    SELECTION=("$(basename ${SELECTION[0]})")
else
    # remove leading "./" from each selection
    SELECTION=("${SELECTION[@]#./}")
fi

# here we go!
echo "$COMMAND ${OPTIONS[@]} ${SELECTION[*]}" >&2
exec $COMMAND "${OPTIONS[@]}" "${SELECTION[@]}"
