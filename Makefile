CC      = gcc
CFLAGS  = -Wall -Wextra -std=c11
CPPFLAGS += -MMD -MP

# gcc on Windows (MinGW/MSYS2) always writes clox.exe; name the target to match
# so make can tell when it is up to date and `clean` removes it.
ifeq ($(OS),Windows_NT)
  EXE := .exe
endif

TARGET   = clox$(EXE)
BUILDDIR = build
SOURCES  = main.c chunk.c debug.c memory.c object.c value.c vm.c compiler.c \
           scanner.c table.c
HEADERS  = chunk.h common.h debug.h memory.h object.h value.h vm.h compiler.h \
           scanner.h table.h
OBJECTS  = $(SOURCES:%.c=$(BUILDDIR)/%.o)
DEPS     = $(OBJECTS:.o=.d)
FORMAT_FILES = $(SOURCES) $(HEADERS)

CLANG_FORMAT ?= clang-format
HAVE_CLANG_FORMAT := $(shell command -v $(CLANG_FORMAT) 2>/dev/null)

.PHONY: all build run format check-format clean

# Default: format first, then build.
all:
	$(MAKE) format
	$(MAKE) build

build: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BUILDDIR)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# make run            -> REPL
# make run ARGS=f.lox -> run a file
run: $(TARGET)
	./$(TARGET) $(ARGS)

format:
ifdef HAVE_CLANG_FORMAT
	$(CLANG_FORMAT) -i $(FORMAT_FILES)
else
	@echo "warning: $(CLANG_FORMAT) not found; skipping format" >&2
endif

check-format:
	$(CLANG_FORMAT) --dry-run --Werror $(FORMAT_FILES)

clean:
	rm -rf $(BUILDDIR) clox clox.exe

-include $(DEPS)
