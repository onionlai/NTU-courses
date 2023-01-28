#include "File.h"
#include "Ngram.h"
#include "Vocab.h"
#include "VocabMap.h"
#include <fstream>
#include <vector>

#define DIR_LEN 128

using namespace std;

Vocab voc; // for vocabulary indexing in Ngram file
Vocab ZhuYin, big5; // for vocabulary indexing in mapping file

int ngram_order = 2;
Ngram lm(voc, ngram_order); // n-gram
VocabMap map(ZhuYin, big5); // map

void ParseArg(int argc, char* argv[], char* test_path, char* map_path, char* lm_path, char* out_path ){
    if(argc < 5){
        cerr << "USAGE: ./disambig <test_path> <map_path> <lm_path> <output_path>";
        exit(-1);
    }
    strncpy(test_path, argv[1], DIR_LEN);
    strncpy(map_path, argv[2], DIR_LEN);
    strncpy(lm_path, argv[3], DIR_LEN);
    strncpy(out_path, argv[4], DIR_LEN);
}


// Unigram(w)
LogP UnigramP(VocabString w1){
    VocabIndex w1_idx = voc.getIndex(w1);
    if(w1_idx == Vocab_None) { w1_idx = voc.getIndex(Vocab_Unknown); } // OOV
    VocabIndex prefix[] = {Vocab_None};
    return lm.wordProb(w1_idx, prefix);
}

// Bigram(w2 | w1)
LogP BigramP(VocabString w2, VocabString w1){
    VocabIndex w2_idx = voc.getIndex(w2);
    VocabIndex w1_idx = voc.getIndex(w1);

    if(w1_idx == Vocab_None) { w1_idx = voc.getIndex(Vocab_Unknown); } // OOV
    if(w2_idx == Vocab_None) { w2_idx = voc.getIndex(Vocab_Unknown); } // OOV
    VocabIndex prefix[] = {w1_idx, Vocab_None};
    return lm.wordProb(w2_idx, prefix);
}

// Viterbi
// void Viterbi(VocabString* sentence, VocabString* output, int len){

// }

int main(int argc, char* argv[]){
    char test_path[DIR_LEN], map_path[DIR_LEN], lm_path[DIR_LEN], output_path[DIR_LEN];
    ParseArg(argc, argv, test_path, map_path, lm_path, output_path);


    // read n-gram language model
    File lm_file(lm_path, "r");
    lm.read(lm_file);
    lm_file.close();


    // read ZhuYin-big5 mapping file
    File map_file(map_path, "r");
    map.read(map_file);
    map_file.close();

    // read test_file, run Viterbi, write output to output_file
    ofstream output_file(output_path);
    if(!output_file){
        cerr << "output file open error" << endl;
    }
    File test_file(test_path, "r");
    char* line;
    while(line = test_file.getline()){
        VocabString sentence[maxWordsPerLine];
        sentence[0] = Vocab_SentStart; // "<s>"
        int len = Vocab::parseWords(line, &(sentence[1]), maxWordsPerLine);
        sentence[len + 1] = Vocab_SentEnd; // "</s>"
        len += 2;

        /////////////////////////////
        ///////// Viterbi ///////////
        /////////////////////////////

        VocabString output[len];
        vector<vector<LogP>> delta(len);
        vector< vector<VocabIndex>> candidate(len);
        // p.s. big5.getWord(w) would return the actual word string in type VocabString

        vector<vector<int>> bt(len);

        vector<LogP> delta_t; // buffer
        vector<int> bt_t; // buffer

        // --- initialize: t = 0 --- //
        delta[0] = { LogP_One };
        candidate[0].push_back(big5.getIndex(sentence[0])); // <s>

        // --- dp: t = 1 ~ len-1 --- //
        for(int t = 1; t < len; t ++){
            VocabMapIter iter(map, ZhuYin.getIndex(sentence[t])); // iter to traverse all candidates' word index
            VocabString w1, w2; // for calculating bi-gram(w2 | w1)
            int i2 = 0; // candidate idx
            Prob p_tmp; // ?
            VocabIndex vi2 = 0;

            delta_t.clear();
            bt_t.clear();

            while(iter.next(vi2, p_tmp)){
                w2 = big5.getWord(vi2);
                candidate[t].push_back(big5.getIndex(w2));
                if(voc.getIndex(w2) == Vocab_None){ w2 = Vocab_Unknown;}
                delta_t.push_back(LogP_Zero);
                bt_t.push_back(0);

                for(int i1 = 0; i1 < (int)candidate[t-1].size(); i1 ++){
                    w1 = big5.getWord(candidate[t-1][i1]);
                    if(voc.getIndex(w1) == Vocab_None){ w1 = Vocab_Unknown;}

                    LogP P = BigramP(w2, w1);
                    P += delta[t-1][i1]; // notes: multiply probability -> add up in log-scale
                    if(P > delta_t[i2]){
                        delta_t[i2] = P;
                        bt_t[i2] = i1;
                    }
                }
                i2++;
            }
            delta[t] = delta_t;
            bt[t] = bt_t;
        }

        // --- backtracking --- //
        LogP maxP = LogP_Zero;
        int bt_i = 0;
        int t = len - 1;
        for(int c = 0; c < (int)candidate[t].size(); c ++){
            if(delta[t][c] > maxP){
                maxP = delta[t][c];
                bt_i = c;
            }
        }
        output[t] = big5.getWord(candidate[t][bt_i]);
        t--;

        while(t >= 0){
            bt_i = bt[t+1][bt_i];
            output[t] = big5.getWord(candidate[t][bt_i]);
            t--;
        }

        for(int t = 0; t < len; t ++){
            output_file << output[t];
            if(t != len - 1) output_file << " ";
        }
        output_file << endl;
    }

    test_file.close();
    output_file.close();
}