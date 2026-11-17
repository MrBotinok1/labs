CC     := gcc
CFLAGS := -Wall -Wextra -O2 -Iinclude

SRCS := $(sort $(shell find src -name '*.c') src/mul.c)
OBJS := $(SRCS:src/%.c=build/%.o)
DEPS := $(OBJS:.o=.d)
DIRS := $(sort $(dir $(OBJS) build/genmul))

.PHONY: all clean test

all: build/calc

build/calc: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

build/%.o: src/%.c | $(DIRS)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

build/genmul: tools/genmul.c | $(DIRS)
	$(CC) $(CFLAGS) $< -o $@

src/mul.c include/mul.h &: build/genmul
	./build/genmul

build/mul.o: src/mul.c include/mul.h
build/main.o: include/mul.h

$(DIRS):
	mkdir -p $@

test: all
	bash tests/test.sh

clean:
	rm -rf build src/mul.c include/mul.h

-include $(DEPS)

