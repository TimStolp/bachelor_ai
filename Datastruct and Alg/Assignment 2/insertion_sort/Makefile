# Change this to change the compiler used
# CC = clang
CC = gcc

# Turn on the address sanitizer
LDFLAGS = -fsanitize=address -fno-omit-frame-pointer -ldl -lm

# To turn off the address sanitizer, instead use
# LDFLAGS = -fno-omit-frame-pointer -ldl -lm

# Use C11, debugging and warnings flags
define CFLAGS
-std=c11 \
-g3 \
-Wpedantic \
-Wall \
-Wextra \
-Wformat=2 \
-Wsign-conversion \
-Wswitch-enum \
-Wno-switch-default \
-Wunused \
-Wfloat-equal \
-Wconversion \
-Wpointer-arith \
-Wtype-limits \
-Wcast-qual \
-Wenum-compare \
-Wsizeof-pointer-memaccess \
-Wstrict-prototypes 
endef

# Flags needed for the check library
CHECK_LDFLAGS = $(LDFLAGS) `pkg-config --libs check`

PROGS = mysort
TESTS = check_list

all: $(PROGS) $(TESTS)

list.o: list.c list.h

mysort: main.o list.o
	$(CC) -o $@ $^ $(LDFLAGS)

tarball: insertion_sort_submit.tar.gz

insertion_sort_submit.tar.gz: main.c list.c
	tar -czf $@ $^

check_list: check_list.o list.o
	$(CC) -o $@ $^ $(CHECK_LDFLAGS)

check: clean all
	@echo "\nChecking List"
	./check_list
	@echo "\nChecking Sort"
	./check2.sh

clean:
	rm -f *.o $(PROGS) $(TESTS)

