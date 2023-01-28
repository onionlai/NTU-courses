#include "ada-hw4-p3.h"
using namespace std;
// feel free to use global variables
vector<int> C; // C[p] = id @ p-th
vector<bool> hide = vector<bool>(3000, false); // sealing[id]
vector<int> hide_pair = vector<int>(3000, -1);

vector<int> hide_vector;
void updateHideVector(){
    hide_vector.clear();
    for(int i = 0; i < (int)C.size(); i ++)
        if(hide[C[i]] == true){ hide_vector.push_back(C[i]); }
    return;
}
void hidePair(int id1, int id2, bool isHide){
    if(isHide){
        hide[id1] = true;
        hide[id2] = true;
        hide_pair[id1] = id2;
        hide_pair[id2] = id1;
    }
    else{
        hide[id1] = false;
        hide[id2] = false;
        hide_pair[id1] = -1;
        hide_pair[id2] = -1;
    }
}

// compare(a, b) = true, if s(a) < s(b)
vector<int> init(int N) {
    C.resize(N);
    vector<int> unhide_p;

    for (int p = 0; p < N; ++p){
        C[p] = p;
        if(unhide_p.size() != 0){
            int near_p = unhide_p.back();
            if(compare(C[near_p], C[p])) {
                unhide_p.push_back(p);
            }
            else {
                hidePair(C[near_p], C[p], true);
                unhide_p.pop_back();
            }
        }
        else {
            unhide_p.push_back(p);
        }
    }

    updateHideVector();
    return hide_vector;
}

vector<int> insert(int p, int id) {
    C.insert(C.begin() + p, id);
    int near_p = p - 1;
    // case 1: check if fail with left un-hide element
    while(near_p >= 0 && hide[C[near_p]]) near_p --;
    if(near_p >= 0 && !compare(C[near_p], id)){ // if fail, hide both
        hidePair(C[near_p], id, true);
        updateHideVector();
    }
    else{ // case 2: check if fail with right un-hide element
        near_p = p + 1;
        while(near_p < (int)C.size() && hide[C[near_p]]) near_p ++;
        if(near_p < (int)C.size() && !compare(id, C[near_p])){
            hidePair(C[near_p], id, true);
            updateHideVector();
        }
    }

    return hide_vector;
}

vector<int> remove(int p) {
    int id = C[p];
    C.erase(C.begin() + p);

    if(!hide[id]) return hide_vector;

    // if id is hid, try to put back the pair with it.
    // do the same thing as insert
    int id2 = hide_pair[id];
    hidePair(id, id2, false); // unhide both

    int p2 = 0;
    for(int p = 0; p < (int)C.size(); p ++){
        if(C[p] == id2) {
            p2 = p;
            break;
        }
    }
    int near_p = p2 - 1;
    // case 1: check if fail with left un-hide element
    while(near_p >= 0 && hide[C[near_p]]) near_p --;
    if(near_p >= 0 && !compare(C[near_p], id2)){ // if fail, hide both
        hidePair(C[near_p], id2, true);
    }
    else{ // case 2: check if fail with right un-hide element
        near_p = p2 + 1;
        while(near_p < (int)C.size() && hide[C[near_p]]) near_p ++;
        if(near_p < (int)C.size() && !compare(id2, C[near_p])){
            hidePair(C[near_p], id2, true);
        }
    }
    updateHideVector();
    return hide_vector;
}
