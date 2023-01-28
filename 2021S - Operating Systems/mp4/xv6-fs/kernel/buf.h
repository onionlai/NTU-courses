struct buf { // buffer metadata
  int valid;   // has data been read from disk?
  int disk;    // does disk "own" buf?
  uint dev;
  uint blockno;
  struct sleeplock lock; // r/w lock of the block's buffered data
  uint refcnt; // refcnt != 0 means in use
  struct buf *prev; // LRU cache list
  struct buf *next;
  uchar data[BSIZE]; // every block contain # BSIZE data
};

