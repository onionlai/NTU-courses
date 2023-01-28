#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../inc/hmm.h"
#include "../inc/data.h"


HMM hmm;
Data data;

void ParseArg(int argc, char* argv[], int* iteration, char* init_model_path, char* data_path, char* output_model_path){
    if(argc < 5){
        fprintf(stderr, "USAGE: ./train <iter> <model_init_path> <seq_path> <output_model_path>");
        exit(-1);
    }
    *iteration = atoi(argv[1]);
    strncpy(init_model_path, argv[2], MAX_FILENAME);
    strncpy(data_path, argv[3], MAX_FILENAME);
    strncpy(output_model_path, argv[4], MAX_FILENAME);
}
void InitArray(int size, double array[size]);
void InitArray2D(int size1, int size2, double array[size1][size2]);
void DebugPrintData(const Data data);

int main(int argc, char* argv[]){

    int iteration;
    char init_model_path[MAX_FILENAME];
    char data_path[MAX_FILENAME];
    char output_model_path[MAX_FILENAME];
    ParseArg(argc, argv, &iteration, init_model_path, data_path, output_model_path);

    FILE *outputFp = open_or_die(output_model_path, "w");
    loadData(&data, data_path);
    loadHMM(&hmm, init_model_path);

    // DebugPrintData(data);

    int stateN = hmm.state_num;
    int observN = hmm.observ_num;

    for(int iter = 0; iter < iteration; iter++){
        // some variables for updating model //
        double gamSumAll_t0[stateN];
        double gamSumAll_T_1[stateN]; // sum from 0 to T-1 and lines
        double gamSumAll_T_obsrv[observN][stateN]; // sum of all time and lines for certain observe
        double gamSumAll_T[stateN]; // sum of all time and lines
        double epsSumAll_T_1[stateN][stateN]; // sum from 0 to T-1 and lines

        InitArray(stateN, gamSumAll_t0);
        InitArray(stateN, gamSumAll_T_1);
        InitArray2D(observN, stateN, gamSumAll_T_obsrv);
        InitArray(stateN, gamSumAll_T);
        InitArray2D(stateN, stateN, epsSumAll_T_1);

        // ## --------- All lines ---------- ##//
        for(int line = 0; line < data.totalLines; line++){
            // --------- Alpha ---------- //
            double alp[data.T + 1][stateN];
            for(int i = 0; i < stateN; i ++){ // initialize for t = 0
                alp[0][i] = hmm.initial[i] * hmm.observation[data.o[line][0]][i];
            }

            for(int t = 1; t <= data.T; t ++){ // induction for t = 1 --> T
                for(int j = 0; j < stateN; j++){
                    double alp_a_sum = 0;
                    for(int i = 0; i < stateN; i++){
                        alp_a_sum += alp[t - 1][i] * hmm.transition[i][j];
                    }
                    alp[t][j] = alp_a_sum * hmm.observation[data.o[line][t]][j];
                }
            }
            // --------- Beta ---------- //
            double bet[data.T + 1][stateN];
            for(int i = 0; i < stateN; i ++){ // initialize for t = T
                bet[data.T][i] = 1;
            }
            for(int t = data.T - 1; t >= 0; t--){ // induction for t = T-1 --> 0
                for(int i = 0; i < stateN; i ++){
                    double bet_a_b_sum = 0;
                    for(int j = 0; j < stateN; j ++){
                        bet_a_b_sum += hmm.transition[i][j] * hmm.observation[data.o[line][t+1]][j] * bet[t+1][j];
                    }
                    bet[t][i] = bet_a_b_sum;
                }
            }

            // --------- Gamma ---------- //
            for(int t = 0; t <= data.T; t++){
                double gamStateSum = 0;
                double gam[stateN];
                for(int i = 0; i < stateN; i ++){
                    gam[i] = alp[t][i] * bet[t][i];
                    gamStateSum += gam[i];
                }
                for(int i = 0; i < stateN; i ++){
                    gam[i] /= gamStateSum;

                    gamSumAll_T[i] += gam[i];
                    gamSumAll_T_obsrv[data.o[line][t]][i] += gam[i];

                    if(t == 0){
                        gamSumAll_t0[i] += gam[i];
                    }
                    if(t != data.T) {
                        gamSumAll_T_1[i] += gam[i];
                    }
                }
            }

            // --------- Epsilon ---------- //
            for(int t = 0; t < data.T; t ++){
                double eps[stateN][stateN];
                double alp_a_b_bet_sum = 0;
                for(int i = 0; i < stateN; i ++){
                    for(int j = 0; j < stateN; j ++){
                        eps[i][j] = alp[t][i]*hmm.transition[i][j]*hmm.observation[data.o[line][t+1]][j]*bet[t+1][j];
                        alp_a_b_bet_sum += eps[i][j];
                    }
                }
                for(int i = 0; i < stateN; i ++){
                    for(int j = 0; j < stateN; j ++){
                        eps[i][j] /= alp_a_b_bet_sum;
                        if(t != data.T)
                            epsSumAll_T_1[i][j] += eps[i][j];
                    }
                }
            }
        }

        // ## --------- Update PI {pi_i} ---------- ##//
        for(int i = 0; i < stateN; i ++){
            hmm.initial[i] = gamSumAll_t0[i] / data.totalLines;
        }
        // ## --------- Update A {a_ij} ---------- ##//
        for(int i = 0 ; i < stateN; i ++){
            for(int j = 0; j < stateN; j++){
                hmm.transition[i][j] = epsSumAll_T_1[i][j] / gamSumAll_T_1[i];
            }
        }
        // ## --------- Update B {b_i(o)} ---------- ##//
        for(int i = 0; i < stateN; i++){
            for(int o = 0; o < observN; o++){
                hmm.observation[o][i] = gamSumAll_T_obsrv[o][i] / gamSumAll_T[i];
            }
        }
        // dumpHMM(stdout, &hmm);
    }
    dumpHMM(outputFp, &hmm);
}

void InitArray(int size, double array[size]){
    for(int i = 0; i < size; i++)
        array[i] = 0;
}
void InitArray2D(int size1, int size2, double array[size1][size2]){
    for(int i = 0; i < size1; i ++){
        for(int j = 0; j < size2; j ++){
            array[i][j] = 0;
        }
    }
}

void DebugPrintData(const Data data){
    for(int i = 0; i < data.totalLines; i++){
        for(int t = 0; t <= data.T; t++){
            printf("%c", data.o[i][t] + 'A');
        }
        printf("\n");
    }
}