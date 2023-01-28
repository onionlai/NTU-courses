#include "File.h"
#include "Ngram.h"
#include "Vocab.h"
#include "VocabMap.h"
#include <fstream>
#include <vector>
#include <queue>

#define DIR_LEN 128

using namespace std;

int width = 2000; // width for beam search

Vocab voc; // for vocabulary indexing in Ngram file
Vocab ZhuYin, big5; // for vocabulary indexing in mapping file

int ngram_order = 3;
Ngram lm(voc, ngram_order); // n-gram
VocabMap map(ZhuYin, big5); // map

typedef pair<int, int> pr;
struct Delta{
    LogP prob = LogP_Zero;
    int i1;
    int i2;
    Delta(LogP _prob, int _i1, int _i2){
        prob = _prob;
        i1 = _i1;
        i2 = _i2;
    }
};

struct comp{
    bool operator()(const Delta& a, const Delta& b){
        return a.prob < b.prob;
    }
};

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


// Unigram(w), unused
LogP getUnigramProb(VocabString w1){
    VocabIndex w1_idx = voc.getIndex(w1);
    if(w1_idx == Vocab_None) { w1_idx = voc.getIndex(Vocab_Unknown); } // OOV
    VocabIndex prefix[] = { Vocab_None};
    return lm.wordProb(w1_idx, prefix);
}

// Bigram(w2 | w1), unused
LogP getBigramProb(VocabString w2, VocabString w1){
    VocabIndex w1_idx = voc.getIndex(w1);
    VocabIndex w2_idx = voc.getIndex(w2);

    if(w1_idx == Vocab_None) { w1_idx = voc.getIndex(Vocab_Unknown); } // OOV
    if(w2_idx == Vocab_None) { w2_idx = voc.getIndex(Vocab_Unknown); } // OOV
    VocabIndex prefix[] = { w1_idx, Vocab_None};
    return lm.wordProb(w2_idx, prefix);
}

// Trigram(w3 | w1, w2)
LogP getTrigramProb(VocabString w3, VocabString w1, VocabString w2){
    VocabIndex w1_idx = voc.getIndex(w1);
    VocabIndex w2_idx = voc.getIndex(w2);
    VocabIndex w3_idx = voc.getIndex(w3);

    if(w1_idx == Vocab_None) { w1_idx = voc.getIndex(Vocab_Unknown); } // OOV
    if(w2_idx == Vocab_None) { w2_idx = voc.getIndex(Vocab_Unknown); } // OOV
    if(w3_idx == Vocab_None) { w3_idx = voc.getIndex(Vocab_Unknown); } // OOV
    VocabIndex prefix[] = { w2_idx, w1_idx, Vocab_None};
    return lm.wordProb(w3_idx, prefix);
}

vector<Delta> queue2Vector(priority_queue<Delta, vector<Delta>, comp> &queue, int width){
    vector<Delta> v;
    v.reserve(width);
    for(int i = 0; i < width && !queue.empty(); i++){
        v.push_back(queue.top());
        queue.pop();
    }
    return v;
}

// Viterbi
void Viterbi(VocabString* sentence, VocabString* output, int len){
    vector<vector<VocabIndex>> candidate(len);
    // candidates[t][c] = for sentence[t], c-th candidate word's index
    vector<vector<vector<int>>> bt(len);
    // bt[t][i2][i3] at[t] given last 2 are [i2], [i3], what is i1?

    int candidate_num[len];

    VocabString w1, w2, w3;
    bt[0] = vector<vector<int>>(1, vector<int>()); // null

    candidate_num[0] = 1;
    candidate[0].push_back(big5.getIndex(sentence[0]));

    priority_queue<Delta, vector<Delta>, comp> delta;
    vector<Delta> candidate_delta;
    vector<vector<int>> bt_t; // buf for t = ...

    //// --- first 2 words (t = 0, 1) --- ////
    VocabMapIter iter(map, ZhuYin.getIndex(sentence[1]));
    int i2 = 0;
    Prob p_tmp;
    VocabIndex vi2;

    while(iter.next(vi2, p_tmp)){
        bt_t.push_back(vector<int>(1, 0));
        w2 = big5.getWord(vi2);
        candidate[1].push_back(big5.getIndex(w2));
        if(voc.getIndex(w2) == Vocab_None){w2 = Vocab_Unknown;}
        delta.push(Delta(getBigramProb(w2, Vocab_SentStart), 0, i2));
        i2 ++;
    }
    bt[1] = bt_t;
    candidate_num[1] = i2;

    //// --- remaining all words (t = 2...len-1) ---- ////
    for(int t = 2; t < len; t ++){
        // for all possible states of t -> loop around iter(map, sen[t]), get w3 (use i3++ to get idx)
        iter = VocabMapIter(map, ZhuYin.getIndex(sentence[t]));
        VocabIndex vi3;
        int i3 = 0;

        candidate_delta = queue2Vector(delta, width);
        delta = priority_queue<Delta, vector<Delta>, comp>(); // clear the queue
        bt_t.clear();
        while(iter.next(vi3, p_tmp)){
            // for all possible states of t - 1 -> loop around i2 = 0 ~ candidate_num[t-1], candidates[t-1][i2] get w2
            w3 = big5.getWord(vi3);
            candidate[t].push_back(big5.getIndex(w3));
            if(voc.getIndex(w3) == Vocab_None){ w3 = Vocab_Unknown;}
            bt_t.push_back(vector<int>(candidate_num[t-1], 0));

            vector<LogP> delta_i2i3 = vector<LogP>(candidate_num[t-1], LogP_Zero);

            for(int i = 0; i < candidate_delta.size(); i ++){
                int i1 = candidate_delta[i].i1;
                int i2 = candidate_delta[i].i2;
                w1 = big5.getWord(candidate[t-2][i1]);
                w2 = big5.getWord(candidate[t-1][i2]);
                if(voc.getIndex(w1) == Vocab_None){ w1 = Vocab_Unknown;}
                if(voc.getIndex(w2) == Vocab_None){ w2 = Vocab_Unknown;}

                LogP P = getTrigramProb(w3, w1, w2); // P(w3 | w1, w2)
                if(P == LogP_Zero) {P = getBigramProb(w3, w2);}
                P += candidate_delta[i].prob; // P(w3 | w1, w2) * P(w1, w2)
                if(P > delta_i2i3[i2]){
                    delta_i2i3[i2] = P;
                    bt_t[i3][i2] = i1;
                }
            }
            for(int i2 = 0; i2 < candidate_num[t-1]; i2++ ){
                // if(delta_i2i3[i2] != LogP_Zero)
                    delta.push(Delta(delta_i2i3[i2], i2, i3));
            }
            i3++;
        }
        bt[t] = bt_t;
        candidate_num[t] = i3;
        // ------  [end] current t -------- //
    }

    // ---- backtracking ---- //
    int b1, b2;
    int t = len - 1;
    b1 = delta.top().i1;
    b2 = delta.top().i2;


    output[t] = big5.getWord(candidate[t][b2]);
    output[t-1] = big5.getWord(candidate[t-1][b1]);

    while(t >= 2){
        output[t-2] = big5.getWord(candidate[t-2][bt[t][b2][b1]]);
        int tmp = b1;
        b1 = bt[t][b2][b1];
        b2 = tmp;
        t--;
    }
}

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
        VocabString input_sentence[maxWordsPerLine];

        input_sentence[0] = Vocab_SentStart; // "<s>"
        int len = Vocab::parseWords(line, &(input_sentence[1]), maxWordsPerLine);
        input_sentence[len+1] = Vocab_SentEnd;
        len += 2;

        /// run viterbi here
        VocabString output_sentence[len];
        Viterbi(input_sentence, output_sentence, len);

        for(int t = 0; t < len; t ++){
            output_file << output_sentence[t];
            if(t != len - 1) output_file << " ";
        }
        output_file << endl;
    }
    test_file.close();
    output_file.close();
}