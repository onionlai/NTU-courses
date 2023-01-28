#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../inc/hmm.h"
#include "../inc/data.h"

HMM hmm[MAX_MODEL];
Data data;

void ParseArg(int argc, char* argv[], char* model_list_path, char* data_path, char* output_path){
    if(argc < 4){
        fprintf(stderr, "USAGE: ./test <models_list_path> <seq_path> <output_result_path>");
        exit(-1);
    }
    strncpy(model_list_path, argv[1], MAX_FILENAME);
    strncpy(data_path, argv[2], MAX_FILENAME);
    strncpy(output_path, argv[3], MAX_FILENAME);
}

double CalculateProb(int line, int m){
    int stateN = hmm[m].state_num;
    double sig[data.T + 1][stateN];
    // --------- Sigma --------- //
    for(int i = 0; i < stateN; i ++){ // initialize for t = 0
        sig[0][i] = hmm[m].initial[i] * hmm[m].observation[data.o[line][0]][i];
    }
    for(int t = 1; t <= data.T; t++){ // induction for t = 1 --> T
        for(int j = 0; j < stateN; j++){
            double max_sig_a = 0;
            for(int i = 0; i < stateN; i ++){
                double sig_a = sig[t-1][i] * hmm[m].transition[i][j];
                if(sig_a > max_sig_a) max_sig_a = sig_a;
            }
            sig[t][j] = max_sig_a * hmm[m].observation[data.o[line][t]][j];
        }
    }
    // ---- Max probability = max(sig_T[i]) ---- //
    double maxProb = 0;
    for(int i = 0; i < stateN; i ++){
        if(sig[data.T][i] > maxProb) maxProb = sig[data.T][i];
    }
    return maxProb;
}

int main(int argc, char* argv[]){
    char model_list_path[MAX_FILENAME];
    char data_path[MAX_FILENAME];
    char output_path[MAX_FILENAME];
    ParseArg(argc, argv, model_list_path, data_path, output_path);

    FILE *outputFp = open_or_die(output_path, "w");

    int modelN = load_models(model_list_path, hmm, MAX_MODEL);
    loadData(&data, data_path);

    for(int line = 0; line < data.totalLines; line ++){
        double bestProb = 0;
        int bestModelID = -1;
        for(int m = 0; m < modelN; m ++){
            double curProb = CalculateProb(line, m); // get the probability of the max possible path by Viterbi
            if(curProb > bestProb) {
                bestProb = curProb;
                bestModelID = m;
            }
        }
        fprintf(outputFp, "%s %.6e\n", hmm[bestModelID].model_name, bestProb);
    }
}