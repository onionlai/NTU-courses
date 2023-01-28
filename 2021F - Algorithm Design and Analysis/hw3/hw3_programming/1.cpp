#include <iostream>
#include <vector>
#include <queue>
#include <cmath>
using namespace std;

struct Node{
    vector<int> adj;
    bool isVisited = false;
    int pi = -1;
};
struct diaNode{
    int ip = -1;
    int sub_branch = 0;
    int dia1;
};

vector<Node> G;
int n;

void ClearN(){
    for(int i = 1; i <= n; i ++){
        G[i].isVisited = false;
    }
}

pair<int, int> BFSdeepest(int s, int exc1, int exc2, bool setPi){
    if(exc1 != -1){G[exc1].isVisited = true;}
    if(exc2 != -1){G[exc2].isVisited = true;}

    queue<int> cur_queue;
    queue<int> next_queue;
    cur_queue.push(s);
    G[s].isVisited = true;
    int cur_node = s;

    int depth = -1;
    while(!cur_queue.empty()){
        depth += 1;
        while(!cur_queue.empty()){
            cur_node = cur_queue.front();
            cur_queue.pop();

            for(int i = 0; i < (int)G[cur_node].adj.size(); i ++){
                int new_node = G[cur_node].adj[i];
                if(!G[new_node].isVisited) {
                    next_queue.push(new_node);
                    if(setPi) { G[new_node].pi = cur_node;}
                    G[new_node].isVisited = true;
                }
            }
        }
        swap(cur_queue, next_queue);
    }
    // ClearN();
    return make_pair(depth, cur_node);
}
int max(int a, int b, int c){
    if(a >= b && a >= c) return a;
    else if(b >= a && b >= c) return b;
    else return c;
}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cin >> n;
    G.resize(n + 1);
    for(int i = 0; i < n - 1; i ++){
        int u, v;
        cin >> u >> v;
        G[u].adj.push_back(v);
        G[v].adj.push_back(u);
    }

    int d_leaf = BFSdeepest(1, -1, -1, false).second;
    ClearN();
    pair<int, int> tmp_ans = BFSdeepest(d_leaf, -1, -1, true);
    ClearN();

    vector<diaNode> Nd;
    Nd.resize(n + 1); // can reduce ?

    int head = tmp_ans.second;
    int diameter = tmp_ans.first;
    int h = head;
    int exc1 = G[h].pi;
    int exc2 = -1;
    int l1 = 0;
    int max_dia1 = 0;

    while(true){

        Nd[h].sub_branch = BFSdeepest(h, exc1, exc2, false).first;
        if(Nd[h].sub_branch + l1 > max_dia1) max_dia1 = Nd[h].sub_branch + l1;
        Nd[h].dia1 = max_dia1;
        // cout << "on diameter: " << h << ", sub_branch: " << Nd[h].sub_branch << ", max dia1: " << max_dia1 << endl;


        if(G[h].pi == -1) break;

        Nd[G[h].pi].ip = h;

        exc2 = h;
        h = G[h].pi;
        exc1 = G[h].pi;
        l1 ++;
    }
    int min = diameter;
    int l2 = 0;
    l1 = diameter - 1;
    int max_dia2 = 0;
    while(Nd[h].ip != -1){
        if(Nd[h].sub_branch + l2 > max_dia2){ max_dia2 = Nd[h].sub_branch + l2; }
        // cout << "cut between " << Nd[h].ip << "," << h << ". diameter: " << Nd[Nd[h].ip].dia1 << "," << max_dia2 << endl;
        int new_diameter = max( ceil((float)( Nd[Nd[h].ip].dia1 ) / 2) + ceil((float)( max_dia2 ) / 2) + 1, Nd[Nd[h].ip].dia1, max_dia2);
        if(new_diameter < min) min = new_diameter;


        h = Nd[h].ip;
        l1--; l2++;
    }
    cout << min << endl;

}