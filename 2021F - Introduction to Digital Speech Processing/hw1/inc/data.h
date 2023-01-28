#include "hmm.h"

#ifndef MAX_DATA
#   define MAX_DATA     10000
#endif

#ifndef MAX_FILENAME
#   define MAX_FILENAME 64
#endif

typedef struct {
    int T; // T: last time
    int totalLines; // lines in total
    int* o[MAX_DATA]; // all of the obsevation sequence
} Data;

void loadData(Data* newData, const char* filename){
    FILE *fp = open_or_die(filename, "r");
    int curLine = 0;
    char buf[MAX_SEQ];
    while(fscanf(fp, "%s", buf) > 0){
        newData->o[curLine] = (int*) malloc(sizeof(int) * strlen(buf));
        for(int i = 0; i < strlen(buf); i ++){
            newData->o[curLine][i] = buf[i] - 'A';
        }
        curLine ++;
    }
    newData->T = strlen(buf) - 1;
    newData->totalLines = curLine;
}