#!/usr/bin/env bash

#declare -r COLORS_SUPPORTED=0
export LIBC_FATAL_STDERR_=2

cd "$(dirname "$0")" || exit

source check_lib.sh

setup_checks "${1:-/dev/stdout}"; shift

header "Compilation" "Checking list.c and main.c compile"
check_bail "Compilation failed" make CFLAGS="-std=c11 -g3 -fsanitize=address -fno-omit-frame-pointer -O2"
grant 1.0

start_asan

header "List" "Checking list implementation"
check_success 2 ./check_list

header "Sort" "Checking basic sorting"
ref_output="$(mktemp)"
for i in $(seq 1 4); do
    t="t$i.txt"
    test_log "Testing: $t"
    ./mysort < "tests/$t" > "$ref_output"
    check_equal 0.5 "$ref_output" bash -c "cat \"sorted/$t\" "
done
rm -f "$ref_output"

header "Asan errors" "Checking if asan failed anywhere"
finalize_asan

finalize_checks

