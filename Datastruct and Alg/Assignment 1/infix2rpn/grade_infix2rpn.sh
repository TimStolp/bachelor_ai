#!/usr/bin/env bash

get_expr() {
    local to_convert="$1" ignore_whitespace="$2" got ret

    got="$($PROG "$to_convert")"
    ret="$?"

    if [[ -n "$ignore_whitespace" ]]; then
        got="$(echo "$got" | sed -e 's/\s\+/ /g' | sed -e 's/^\s\+//g' | sed -e 's/\s\+$//g' )"
        :;
    fi

    echo "$got"
    return "$ret"
}
export -f get_expr

cd "$(dirname "$0")" || exit

source check_lib.sh

setup_checks "${1:-/dev/stdout}"; shift
make clean;

export PROG='./infix2rpn'

header "Compilation" "Checking infix2rpn.c and stack.c compile"
check_bail "Compilation failed" make check_stack infix2rpn CFLAGS="-std=c11 -g3 -fsanitize=address -fno-omit-frame-pointer -O2"
grant 1.0

start_asan


header "Stack" "Checking stack implementation"
check_success 1.0 ./check_stack

header "Simple exprs" "Checking simple expressions"
check_equal 0.25 /dev/stdin bash -c "get_expr '3+3' true" <<< '3 3 +'
check_equal 0.25 /dev/stdin bash -c "get_expr '3+4-5' true" <<< '3 4 + 5 -'
check_equal 0.25 /dev/stdin bash -c "get_expr '3+3+3+3+3+3' true" <<< '3 3 + 3 + 3 + 3 + 3 +'
check_equal 0.25 /dev/stdin bash -c "get_expr '3/8' true" <<< '3 8 /'
check_equal 0.25 /dev/stdin bash -c "get_expr '6*7' true" <<< '6 7 *'
check_equal 0.25 /dev/stdin bash -c "get_expr '6*7/3*5' true" <<< '6 7 * 3 / 5 *'

header "Hard exprs" "Checking difficult expressions"
check_equal 0.25 /dev/stdin bash -c "get_expr '1+2*3' true" <<< '1 2 3 * +'
check_equal 0.25 /dev/stdin bash -c "get_expr '1+7*5/4+6*3' true" <<< '1 7 5 * 4 / + 6 3 * +'
check_equal 0.25 /dev/stdin bash -c "get_expr '100*10/20' true" <<< '100 10 * 20 /'
check_equal 0.25 /dev/stdin bash -c "get_expr '1236+722*890/3-675' true" <<< '1236 722 890 * 3 / + 675 -'

header "Invalid characters" "Checking if invalid characters are handled."
check_error 0.25 ./infix2rpn 'ab+cd'
check_error 0.25 ./infix2rpn '3!5@4'


if ! "$_BAILED"; then
    header "Compiling" "Checking if compiling works with and without warnings"
    echo "With warnings:"
    check_success -1 make

    header "Asan errors" "Checking if asan failed anywhere"
    finalize_asan
fi

finalize_checks
