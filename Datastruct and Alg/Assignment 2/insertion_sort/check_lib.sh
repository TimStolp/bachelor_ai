#!/bin/bash

declare -r COLORS_SUPPORTED=0
export LIBC_FATAL_STDERR_=2
export _GRADE=0 # The current grade
export TOTAL_GRADE=0
export MAX_OUTPUT_SIZE=90000
export _ASAN_OK=0 # Have we seen a valgrind error
export _ASAN_ERR
export _ASAN=false
export ASAN_POINTS=-1 # points to add if no valgrind errors were found.
export _TIMEOUT_TIME=6 # The max time a command may run
export LC_NUMERIC="en_US.UTF-8"
export GRADE_OUTPUT
export _DONE_SETUP="false"
export _CUR_CAT
export _BAILED=false

setup_checks() {
    _DONE_SETUP="true"

    _GRADE=0
    TOTAL_GRADE=0
    GRADE_OUTPUT="${1}"
}

finalize_checks() {
    output_cat_grade

    printf -- '\n\n----------------------------------------------------'
    printf -- '---------------------------------------\n'
    printf "%-65s Preliminary grade: %.4g\n" "Tests done" "$TOTAL_GRADE"
    printf -- '----------------------------------------------------'
    printf -- '---------------------------------------\n'

    unset _CUR_CAT
    unset _GRADE
    unset TOTAL_GRADE
}

_errcho() {
    (>&2 echo "$@")
}

exit_trap() {
    if [[ -n "$_CUR_CAT" ]]; then
        output_cat_grade
    fi
}

trap exit_trap EXIT

test_log() {
    if "$_BAILED"; then
        return
    fi
    echo "$@"
}

output_cat_grade() {
    if [[ -z "$_GRADE" ]] || [[ -z "$_CUR_CAT" ]]; then
        return 0
    fi

    echo "${_CUR_CAT}: $_GRADE" >> "$GRADE_OUTPUT"

    if "$_BAILED"; then
        return
    fi

    printf "Grade for this category: %.g\n" $_GRADE
}

# Grant the given number of points. The number should be the first and only
# argument.
grant() {
    if "$_BAILED"; then
        return
    fi

    ok

    if [[ "${1:0:1}" = "-" ]]; then
        printf ", you get to keep %.4g points\n" "${1:1}"
    else
        printf ", you got %+.4g points\n" "$1"
        _GRADE=$(bc -l <<< "scale=1;$_GRADE + $1")
        TOTAL_GRADE=$(bc -l <<< "scale=1;$TOTAL_GRADE + $1")
    fi
}

not_grant() {
    if "$_BAILED"; then
        return
    fi

    fail

    if [[ "${1:0:1}" = "-" ]]; then
        printf ", you lose %.4g points\n" "${1:1}"
        _GRADE=$(bc -l <<< "scale=1;$_GRADE + $1")
        TOTAL_GRADE=$(bc -l <<< "scale=1;$TOTAL_GRADE + $1")
    else
        printf ", you missed %0.4g points\n" "$1"
    fi
}

simple_grant() {
    printf ", you got %+.4g points\n" "$1"
    _GRADE=$(bc -l <<< "scale=1;$_GRADE + $1")
    TOTAL_GRADE=$(bc -l <<< "scale=1;$TOTAL_GRADE + $1")
}

bail() {
    printf "\nBailing: %s\n\n" "$*"
    _BAILED=true
    return 1
}

header() {
    if ! "$_DONE_SETUP"; then
        exit 1
    fi

    if [[ -n "$_CUR_CAT" ]]; then
        output_cat_grade
    fi

    export _GRADE=0
    export _CUR_CAT="$1"
    shift

    if "$_BAILED"; then
        return
    fi

    printf -- '\n----------------------------------------------------'
    printf -- '------------------------\n'
    printf "%-70s Current grade: %.4g\n" "$*" "$TOTAL_GRADE"
    printf -- '----------------------------------------------------'
    printf -- '------------------------\n'
}

color() {
    if [[ $COLORS_SUPPORTED -eq 1 ]]; then
        printf "\033[1;%sm%s\033[0m" "$1" "${*:2}"
    else
        shift
        printf "%s" "$*"
    fi
}

ok() {
    color 32 "PASS"
}

fail() {
    color 31 "FAIL"
}

with_timeout () {
    local ret err

    if "$_ASAN"; then
        err="$(mktemp)"

        export ASAN_OPTIONS='exitcode=200:log_path=stderr:detect_leaks=true'
        timeout -k "$_TIMEOUT_TIME" "$_TIMEOUT_TIME" "$@" 2> "$err" >/dev/null;

        if [[ "$?" -eq 200 ]]; then
            _ASAN_OK=1
            echo "Error at command $*" >> "$_ASAN_ERR"
            cat "$err" >> "$_ASAN_ERR"
        fi

        rm "$err"
        export ASAN_OPTIONS='exitcode=200:log_path=stderr:detect_leaks=false'
    fi

    timeout -k "$_TIMEOUT_TIME" "$_TIMEOUT_TIME" "$@" | head -c $MAX_OUTPUT_SIZE
    ret="${PIPESTATUS[0]}"

    if [[ "$ret" -eq 200 ]]; then
        _ASAN_OK=1
    fi

    return "$ret"
}

# Grant the given amount of points after running the specified command.
#
# The points to grant should be specified in the first argument, the command to
# run in the rest arguments (no splitting is done). The command is not eval'd so
# you can only pass things that you can pass behind timeout.
#
# If the test is successful this is shown to the user and the amount of points
# is also shown. If the tests failed the output is shown including the amount of
# points missed. The return value of this function is the same as of the test
# command.
check_success() {
    local extra="$1" outfile ret
    shift

    if "$_BAILED"; then
        return
    fi

    outfile="$(mktemp)"

    with_timeout "$@" > "$outfile" 2>&1
    ret="$?"

    if [[ "$ret" -eq 0 ]]; then
        [[ "$extra" != "0" ]] && grant "$extra"
    else
        not_grant "$extra"
        echo 'Error output:'
        cat "$outfile"
        echo
    fi
    rm "$outfile"

    return "$ret"
}

# The same as `check_success` but in reverse.
check_error() {
    local extra="$1" outfile ret
    shift

    if "$_BAILED"; then
        return
    fi

    outfile="$(mktemp)"

    with_timeout "$@" > "$outfile" 2>&1
    ret="$?"
    if [[ "$ret" -ne 0 ]] && [[ "$ret" -ne 124 ]] && [[ "$ret" -ne 200 ]]; then
        [[ "$extra" != "0" ]] && grant "$extra"
    else
        not_grant "$extra"
        echo "Command: $*"
        echo 'Error output:'
        cat "$outfile"
        echo
    fi
    rm "$outfile"
    return "$ret"
}

# Exactly the same as `check_success()` only this function will bail on a
# unsuccessful test. The first argument should contain the bail message.
check_bail() {
    local msg="$1" ret
    shift
    echo "$@"
    check_success 0 "$@"
    ret="$?"
    if [[ "$ret" -ne 0 ]]; then
        bail "$msg"
    fi
    return "$ret"
}

# Grant the given amount of points after running the specified command and
# comparing its output to the reference output.
#
# The points to grant should be specified in the first argument, the file to
# diff with as the second argument and the command to run in the rest arguments.
# The command is not eval'd so you can only pass things that you can pass behind
# timeout.
#
# If the test is successful this is shown to the user and the amount of points
# is also shown. If the tests failed the output is shown including the amount of
# points missed. For a successful test the command should return 0 and its
# output should be equal to the reference output.
#
# The return value of this function is the same as of the test command.
check_equal() {
    local extra="$1" todiff="$2" diffout errout outfile ret
    shift; shift

    if "$_BAILED"; then
        return
    fi

    diffout="$(mktemp)"
    errout="$(mktemp)"
    outfile="$(mktemp)"

    with_timeout "$@" > "$outfile" 2> "$errout"

    ret="$?"

    if [[ "$ret" -eq 0 ]]; then
        diff -y "$outfile" "$todiff" > "$diffout"
        ret="$?"
        if [[ "$ret" -eq 0 ]]; then
            grant "$extra"
        else
            not_grant "$extra"
            echo "Command: $*"
            echo "Differences (left is your output, right is the reference):"
            cat "$diffout"
            echo
            echo "Output on stderr:"
            cat "$errout"
        fi
    elif [[ "$ret" -gt 100 ]]; then
        not_grant "$extra"
        echo "Command: $*"
        echo "There was a timeout or asan error. Output:"
        cat "$outfile"
        echo
        echo "Output on stderr:"
        cat "$errout"
    else
        echo
        not_grant "$extra"
        echo "Command: $*"
        echo "You're command exit with an error code, not diffing. Output:"
        cat "$outfile"
        echo
        echo "Output on stderr:"
        cat "$errout"
    fi

    rm "$outfile"
    rm "$diffout"
    rm "$errout"
    return "$ret"
}

# Exactly the same as `check_equal` only checking for not equal.
check_notequal() {
    local extra="$1" todiff="$2" diffout outfile ret
    shift; shift

    if "$_BAILED"; then
        return
    fi

    diffout="$(mktemp)"
    outfile="$(mktemp)"

    with_timeout "$@" > "$outfile" 2>&1
    ret="$?"

    if [[ "$ret" -eq 0 ]]; then
        ! diff -y "$outfile" "$todiff" > "$diffout"
        ret="$?"
        if [[ "$ret" -eq 0 ]]; then
            grant "$extra"
        else
            not_grant "$extra"
            echo "Command: $*"
            echo "Differences (left is your output, right is the reference):"
            cat "$diffout"
            echo
        fi
    elif [[ "$ret" -gt 100 ]]; then
        fail; echo
        echo "Command: $*"
        echo "There was a timeout or asan error. Output:"
        cat "$outfile"
        echo
    else
        fail; echo
        echo "Command: $*"
        echo "You're command exit with an error code, not diffing. Output:"
        cat "$outfile"
        echo
    fi

    rm "$outfile"
    rm "$diffout"
    return "$ret"
}

# Begin asan testing.
start_asan() {
    export ASAN_OPTIONS='exitcode=200:log_path=stderr:detect_leaks=false'
    _ASAN_ERR="$(mktemp)"
    export _ASAN_ERR
    export _ASAN=true
    export _ASAN_OK=0
    return 0
}

# Finalize the valgrind tests. The return code is 0 if no valgrind test failed
# and 1 otherwise.
finalize_asan() {
    local ret=2

    if ! "$_BAILED"; then
        if [[ "$_ASAN_OK" -eq 0 ]]; then
            grant "$ASAN_POINTS"
            ret=0
        else
            not_grant "$ASAN_POINTS"
            echo 'Asan output:'
            cat "$_ASAN_ERR"
            ret=1
        fi
    fi

    export _ASAN=false
    if [[ -n "$_ASAN_ERR" ]]; then
        rm "$_ASAN_ERR"
    fi
    unset _ASAN_ERR

    return "$ret"
}
