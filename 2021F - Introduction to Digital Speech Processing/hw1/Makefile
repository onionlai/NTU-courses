.PHONY: all clean run
CC=gcc
CFLAGS=-std=c99 -O2
LDFLAGS=-lm
TARGET=train test
TRAIN_ITER=100
MODEL_INIT_PATH=model_init.txt
MODEL_LIST_PATH=modellist.txt
TEST_SEQ_PATH=data/test_seq.txt
TEST_RESULT_PATH=result.txt

TEST_LABEL_PATH=data/test_lbl.txt

all: $(TARGET)

train: src/train.c
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) -Iinc

test: src/test.c
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) -Iinc

judge: src/judge.c
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) -Iinc

run:
	./train $(TRAIN_ITER) $(MODEL_INIT_PATH) data/train_seq_01.txt model_01.txt
	./train $(TRAIN_ITER) $(MODEL_INIT_PATH) data/train_seq_02.txt model_02.txt
	./train $(TRAIN_ITER) $(MODEL_INIT_PATH) data/train_seq_03.txt model_03.txt
	./train $(TRAIN_ITER) $(MODEL_INIT_PATH) data/train_seq_04.txt model_04.txt
	./train $(TRAIN_ITER) $(MODEL_INIT_PATH) data/train_seq_05.txt model_05.txt
	./test $(MODEL_LIST_PATH) $(TEST_SEQ_PATH) $(TEST_RESULT_PATH)

run_test:
	./test $(MODEL_LIST_PATH) $(TEST_SEQ_PATH) $(TEST_RESULT_PATH)

run_judge: judge
	./judge $(TEST_RESULT_PATH) $(TEST_LABEL_PATH)


clean:
	rm -f $(TARGET)

