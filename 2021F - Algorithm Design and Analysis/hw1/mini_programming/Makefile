CC = g++
#CFLAGS = -std=c++17 -march=native -static -O2 -Wall -g
CFLAGS = -std=c++17 -O2 -Wall -g
EXEC = run
RM = rm -rf
source = hw2.cpp

all: run

.PHONY: clean

run: $(source)
	$(CC) $(CFLAGS) $(source) -o $(EXEC)
clean:
	$(RM) $(EXEC)