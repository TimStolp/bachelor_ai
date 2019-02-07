# Change this to change the compiler used
# CC = clang
CC = gcc

# Turn on the address sanitizer
LDFLAGS = -fsanitize=address -fno-omit-frame-pointer

# To turn off the address sanitizer, instead use
# LDFLAGS = -fno-omit-frame-pointer


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
-Wstrict-prototypes \
$(LDFLAGS)
endef

# Flags needed for the check library
CHECK_LDFLAGS = $(LDFLAGS) `pkg-config --libs check`

PROG = infix2rpn
TESTS = check_stack

all: $(PROG)

stack.o: stack.c stack.h

infix2rpn: infix2rpn.o stack.o
	$(CC) -o $@ $^ $(LDFLAGS)

clean:
	rm -f *~ *.o $(PROG) $(TESTS)

tarball: infix2rpn_submit.tar.gz

infix2rpn_submit.tar.gz: infix2rpn.c stack.c
	tar -czf $@ $^

check_stack: check_stack.o stack.o
	$(CC) -o $@ $^ $(CHECK_LDFLAGS)

check: clean all $(TESTS)
	@echo "Testing the stack implementation..."
	./check_stack 2> /dev/null
	@echo "\nRunning infix2rpn grading script..."
	./grade_infix2rpn.sh
	@echo "\nRunning any additional tests provided..."
	./test_expressions.sh

