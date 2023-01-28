#include <iostream>
#include <vector>
#include <set>
using namespace std;

struct Node{
    vector<int> adj;
    bool isVisited = false; // is visited ?
    int f; // finish time
    int tag = 0; // for DAG, tag = one original node,
                 // for Gt, tag = DAG_id of the node
};

vector<Node> G;
vector<Node> Gt;
vector<Node> DAG;

vector<int> f_order;
int N, M;
int t = 0;

void DFS(vector<Node> &G, int u, int head, set<int> *out){
    G[u].isVisited = true;
    if(head != -1) {G[u].tag = head;}

    for(int i = 0; i < (int)G[u].adj.size(); i++){
        int v = G[u].adj[i];
        if(G[v].isVisited == false){
            DFS(G, v, head, out);
        }
        else{
            if(head != -1 && G[v].tag != head){ out->insert(G[v].tag);}
        }
    }
    G[u].f = t;
    if(head == -1) {f_order[t] = u;}
    t ++;
}

int DFS_find_sink_child(vector<Node> &G, int u){
    G[u].isVisited = true;
    int child;
    if(G[u].adj.size() == 0){ return u; }
    for(int i = 0; i < (int)G[u].adj.size(); i++){
        int v = G[u].adj[i];
        if(G[v].isVisited == false){
            child = DFS_find_sink_child(G, v);
            if(child != -1) {return child;}
        }
    }
    return -1;
}

void DebugPrint(vector<int> f_order);

int NUM, FLAG;
int main(){
    cin >> NUM >> FLAG;
    for(int p = 0; p < NUM; p++){
        G.clear();
        Gt.clear();
        DAG.clear();
        f_order.clear();

        cin >> N >> M;
        G.resize(N + 1);
        Gt.resize(N + 1);
        f_order.resize(N);

        for(int i = 0; i < M; i++){
            int u, v;
            cin >> u >> v;
            G[u].adj.push_back(v);
            Gt[v].adj.push_back(u);
        }

        ///////////// STEP-1 ///////////////
        //// run DFS(G) -> get f_order /////
        t = 0;
        for(int u = 1; u <= N; u++){
            if(G[u].isVisited == false){
                DFS(G, u, -1, nullptr);
            }
        }
        // DebugPrint(f_order);

        //////////// STEP-2 //////////////
        //// run DFS(G^T) -> get DAG ////
        t = 0;
        int id = 0;
        for(int i = f_order.size() - 1; i >= 0; i--){
            int u = f_order[i];
            if(Gt[u].isVisited == false){
                set<int> adj_set;
                DFS(Gt, u, id, &adj_set);
                Node n;
                n.adj = vector<int>(adj_set.begin(), adj_set.end());
                n.tag = u;
                DAG.push_back(n);
                id ++;
            }
        }

        ///////////// STEP-3 //////////////
        //// get # of source (node that out-degree = 0) ////
        //// get # of sink (node that out-degree = 0) ////
        vector<int> source; // in Gt
        vector<int> sink;
        vector<bool> zero_indegree(DAG.size(), true);

        for(int u = 0; u < (int)DAG.size(); u++){
            if(DAG[u].adj.empty()){
                sink.push_back(u);
            }
            else{
                for(int j = 0; j < (int)DAG[u].adj.size(); j++){
                    int v = DAG[u].adj[j];
                    zero_indegree[v] = false;
                }
            }
        }
        for(int u = 0; u < (int)DAG.size(); u ++){
            if(zero_indegree[u] == true){ source.push_back(u); }
        }

        int m = max((int)source.size(), (int)sink.size());
        if( DAG.size() == 1) { cout << 0 << endl;}
        else{ cout << m << endl;}

        ////////// STEP-4 //////////
        //// find new edges that connects sink to source
        if(FLAG == 0 || DAG.size() == 1 ){continue; }
        vector<int> match_source(m, 0);
        vector<int> match_sink(m, 0);
        vector<int> remain_source;

        vector<bool> remain_sink_table((int)DAG.size(), true);
        // for(int i = 0; i < (int)sink.size(); i++){remain_sink_table[sink[i]] = true;}

        id = 0;
        for(int i = 0; i < (int)source.size(); i++){
            int u = source[i];
            int s = DFS_find_sink_child(DAG, u);
            if(s != -1){
                match_source[id] = u;
                match_sink[id] = s;
                remain_sink_table[s] = false;
                id ++;
            }
            else{
                remain_source.push_back(u);
            }
        }
        // for those matching, shift one so that
        // child_sink not pair with its original parent_source
        int tmp = match_sink[id-1];
        for(int i = id-1; i >= 1; i --){
            match_sink[i] = match_sink[i-1];
        }
        match_sink[0] = tmp;

        // arbitrary pair up the remain sink & source
        // for the last remaining sources or sinks haven't paired
        // pair with any one (use the first ...[0])
        int j = 0;
        for(int i = 0; i < (int)sink.size(); i++){
            int s = sink[i];
            if(remain_sink_table[s] == true){
                match_sink[id] = s;
                if(j < (int)remain_source.size()){
                    match_source[id] = remain_source[j ++];
                }else{
                    match_source[id] = match_source[0];
                }
                id ++;
            }
        }
        while(j < (int)remain_source.size()){
            match_sink[id] = match_sink[0];
            match_source[id] = remain_source[j ++];
            id ++;
        }

        // output
        for(int i = 0; i < m; i++){
            cout << DAG[match_source[i]].tag << " " << DAG[match_sink[i]].tag << endl;
        }

    }


}

void DebugPrint(vector<int> f_order){
    for(int i = 0; i < (int)f_order.size(); i++){
        cout << f_order[i] << " ";
    }
    cout << endl;
}
