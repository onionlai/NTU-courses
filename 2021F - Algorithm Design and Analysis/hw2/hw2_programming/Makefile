CC = g++
#CFLAGS = -std=c++17 -march=native -static -O2 -Wall -g
CFLAGS = -std=c++17 -O2 -Wall -g
EXEC = run
RM = rm -rf
source = 1.cpp

all: run
debug: CFLAGS += -DDEBUG
debug: run

.PHONY: clean

run: $(source)
	$(CC) $(CFLAGS) $(source) -o $(EXEC)
clean:
	$(RM) $(EXEC)