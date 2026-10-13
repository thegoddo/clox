CC = gcc
CFLAGS = -Wall -Wextra -std=c11

TARGET = clox
SOURCES = main.c chunk.c debug.c memory.c value.c

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)


clean:
	rm -f $(TARGET)


.PHONY: clean
