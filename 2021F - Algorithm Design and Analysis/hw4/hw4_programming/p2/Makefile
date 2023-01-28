CC = g++
#CFLAGS = -std=c++17 -march=native -static -O2 -Wall -g
CFLAGS = -std=c++17 -O2 -Wall -g
EXEC = run
RM = rm -rf
source = 4.cpp

all: run
debug: CFLAGS += -DDEBUG
debug: run

.PHONY: clean

run: $(source)
	$(CC) $(CFLAGS) $(source) -o $(EXEC)
hw1: hw1.cpp
	$(CC) $(CFLAGS) hw1.cpp -o $(EXEC) -lglpk
hw2: connect4.cpp
	$(CC) $(CFLAGS) connect4.cpp -o $(EXEC)
hw3: ada-hw4-p3.cpp
	$(CC) $(CFLAGS) grader.cpp ada-hw4-p3.cpp -o $(EXEC)

clean:
	$(RM) $(EXEC)