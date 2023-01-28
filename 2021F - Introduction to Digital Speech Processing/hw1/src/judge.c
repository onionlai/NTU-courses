#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_FILENAME    64
#define MAX_MODELNAME   20


void ParseArg(int argc, char* argv[], char* test_output_path, char* test_label_path){
    if(argc < 3){
        fprintf(stderr, "USAGE: ./judge <output_test_path> <test_label_path>");
        exit(-1);
    }
    strncpy(test_output_path, argv[1], MAX_FILENAME);
    strncpy(test_label_path, argv[2], MAX_FILENAME);
}

static FILE *open_or_die( const char *filename, const char *ht )
{
    FILE *fp = fopen( filename, ht );
    if( fp == NULL ){
        perror( filename);
        exit(1);
    }

    return fp;
}

int main(int argc, char* argv[]){
    char test_output_path[MAX_FILENAME];
    char test_label_path[MAX_FILENAME];
    ParseArg(argc, argv, test_output_path, test_label_path);

    FILE* TestFp = open_or_die(test_output_path, "r");
    FILE* LabelFp = open_or_die(test_label_path, "r");

    char resultModel[MAX_MODELNAME];
    char labelModel[MAX_MODELNAME];
    double prob;
    int count = 0;
    int rightCount = 0;
    while(fscanf(TestFp, "%s%le", resultModel, &prob) > 0 && fscanf(LabelFp, "%s", labelModel) > 0){
        // printf("%le\n", prob);
        if(strncmp(resultModel, labelModel, MAX_MODELNAME) == 0)
            rightCount ++;
        count ++;
    }
    // printf("Accuracy = %.2f %%\n", (float)100 * rightCount / count);
    printf(" %.2f", (float)100 * rightCount / count);

}