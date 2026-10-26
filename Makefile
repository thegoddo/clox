CC = gcc
CFLAGS = -Wall -Wextra -std=c11

TARGET = clox
SOURCES = main.c chunk.c debug.c memory.c object.c value.c vm.c compiler.c scanner.c
HEADERS = chunk.h common.h debug.h memory.h object.h value.h vm.h compiler.h scanner.h
FORMAT_FILES = $(SOURCES) $(HEADERS)

.PHONY: all build format check-format clean

# Default: format first, then build.
all:
	$(MAKE) format
	$(MAKE) build

build: $(TARGET)

$(TARGET): $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)

format:
	clang-format -i $(FORMAT_FILES)

check-format:
	clang-format --dry-run --Werror $(FORMAT_FILES)

clean:
	rm -f $(TARGET)
