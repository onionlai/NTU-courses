#include <iostream>
#include <map>
#include <vector>

using namespace std;

typedef map<int, int>:: iterator mit;
long long catPairs = 0;

struct Cat{
    int leader = -1;
    int pos;
    int total_cats = 0;
    int real_id = -1;
};
vector<Cat> cat;
map<int, int> leaderCat;

int Leader(int i){
    if (cat[i].leader != i){
        i = Leader(cat[i].leader);
        cat[i].leader = i;
    }
    return i;
}

int RealID(int i){
    if (cat[i].real_id != -1){
        i = RealID(cat[i].real_id);
        // cat[i].real_id = i;
    }
    return i;
}

void FeedCat(int p, int r){
    int new_leader = -1;
    int max_cats = 0;
    int total_cats = 0;

    mit it_start = leaderCat.lower_bound(p-r);
    mit it = it_start;
    while(it != leaderCat.end() && it->first <= (p + r)){ // find the new leader with most cats
        if(cat[it->second].total_cats > max_cats){
            new_leader = it->second;
            max_cats = cat[it->second].total_cats;
        }
        it ++;
    }
    if(new_leader == -1){return; }

    it = it_start;
    mit erase_it;
    bool exist_p = false;

    while(it != leaderCat.end() && it->first <= (p + r)){
        // if(cat[it->second].total_cats == 0){ // empty cat
        //     erase_it = it;
        //     it ++;
        //     leaderCat.erase(erase_it);
        //     continue;
        // }

        cat[it->second].leader = new_leader;
        catPairs += (long long)total_cats * cat[it->second].total_cats;
        total_cats += cat[it->second].total_cats;

        if(it->first == p){ // cat at p
            exist_p = true;
            it->second = new_leader;
            it ++;
        }
        else{ // cat at other place
            erase_it = it;
            it ++;
            leaderCat.erase(erase_it);
        }
    }
    if(!exist_p){
        leaderCat[p] = new_leader;
    }
    cat[new_leader].total_cats = total_cats; // leader cat store total # of cats
    cat[new_leader].pos = p; // leader cat should know its position
    cat[new_leader].leader = new_leader; // leader cat have leader as itself


}
void MoveCat(int i, int x){
    int id = RealID(i);
    int leader = Leader(id);

    // case 1: only one cat at the position
    //          i.e. no children cat under me, I can move anywhere!
    if(cat[leader].total_cats == 1){
        mit it = leaderCat.find(cat[leader].pos);
        leaderCat.erase(it); // maybe no need to erase here

        it = leaderCat.lower_bound(x);
        // move to empty x
        if(it == leaderCat.end() || it->first != x){
            it = leaderCat.insert(it, make_pair(x, id));
            cat[id].total_cats = 1;
            cat[id].leader = id;
            cat[id].pos = x;
        }
        // move to already occupied x
        else{
            catPairs += cat[it->second].total_cats;
            cat[it->second].total_cats += 1;
            cat[id].leader = it->second;
        }
    }


    // case 2: many cat at the position
    //          i.e. I should make a copy and leave, update inform
    else{
        cat[leader].total_cats -= 1;
        catPairs -= cat[leader].total_cats;

        int new_id = cat.size();
        cat[i].real_id = new_id;
        Cat new_cat;

        mit it = leaderCat.lower_bound(x);
        // move to empty x
        if(it == leaderCat.end() || it->first != x){
            leaderCat.insert(it, make_pair(x, new_id));
            new_cat.leader = new_id;
            new_cat.pos = x;
            new_cat.total_cats = 1;
        }

        // move to already occupied x
        else{
            catPairs += cat[it->second].total_cats;
            cat[it->second].total_cats += 1;
            new_cat.leader = it->second;
        }
        cat.push_back(new_cat);
    }
}

int main(){
    int N, Q;
    cin >> N >> Q;
    cat.resize(N+1);

    for(int i = 1; i <= N; i ++){
        int x;
        cin >> x;

        mit it = leaderCat.lower_bound(x);

        if(it == leaderCat.end() || it->first != x){
            leaderCat.insert(it, pair<int, int> (x, i));
            cat[i].total_cats = 1;
            cat[i].leader = i;
            cat[i].pos = x;
        }
        else{
            catPairs += cat[it->second].total_cats;
            cat[it->second].total_cats += 1;
            cat[i].leader = it->second;
        }
    }
    int type, a, b;
    for(int i = 0; i < Q; i ++){
        cin >> type >> a >> b;
        if(type == 1){
            FeedCat(a, b);

        }else if(type == 2){
            MoveCat(a, b);
        }
        cout << catPairs << '\n';
    }

}