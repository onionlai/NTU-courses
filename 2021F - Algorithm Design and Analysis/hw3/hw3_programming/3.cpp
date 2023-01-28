#include <iostream>
#include <vector>
#include <queue>
#include <limits.h>
using namespace std;

typedef pair<long long, int> pr;

struct Node{
    vector<pair<int, int>> adj; // connected: <neighbor, edge_id>
    bool selected = false; // if already in R in dijkstra or already in T in Prim's
    int parent = -1; // parent in connected edge to R
    long long d = LLONG_MAX; // current shortest path length to 1
    int edge_id = 0; // connected edge to R in its current shortest path
};

vector<Node> G;
vector<long long> edge; // edge[edge_id] = edge weight
                // pair G[node_id].d, node_id that is being explored in dijkstra
int N;

void DebugPrintQueue(priority_queue<pr, vector<pr>, greater<pr>> queue);

vector<int> Dijkstra(vector<Node> G){ // s = 1
    vector<int> ans; // a sequence of edge_id
    // int last_selected = 1;
    priority_queue<pr, vector<pr>, greater<pr>> queue; //(G[u].d, u)
    G[1].d = 0;
    G[1].selected = false;
    queue.push(make_pair(0, 1));

    // for(int i = 0; i < (int)G[1].adj.size(); i++){ // initial, push all the edge connected to G[1]
    //     pr p = G[1].adj[i];
    //     G[p.first].parent = 1;

    //     if(G[p.first].d != LLONG_MAX && G[p.first].d < edge[p.second]){continue; }

    //     G[p.first].d = edge[p.second];
    //     G[p.first].edge_id = p.second;
    //     queue.push(make_pair(edge[p.second], p.first));
    // }

    while(!queue.empty()){
        pr u_pr = queue.top();
        queue.pop();
        int u = u_pr.second;
        if(G[u].selected){continue; }

        G[u].selected = true;
        // last_selected = u;
        // ans.push_back(G[u].edge_id);

        for(int i = 0; i < (int)G[u].adj.size(); i++){
            pr p = G[u].adj[i];
            int v = p.first;
            int e = p.second;

            // relax
            if(!G[v].selected && G[v].d > G[u].d + edge[e]){
                G[v].d = G[u].d + edge[e];
                G[v].edge_id = e;
                G[v].parent = u;
                queue.push(make_pair(G[v].d, v));
            }
            else if(G[v].d == G[u].d + edge[e] && edge[G[v].edge_id] > edge[e]){
                G[v].edge_id = e;
                G[v].parent = u;
            }
        }
    }
    for(int i = 2; i <= N; i ++){
        ans.push_back(G[i].edge_id);
    }
    return ans;
}

vector<int> Prim(vector<Node> G){ // is o.k. to use original G
    vector<int> ans;
    priority_queue<pr, vector<pr>, greater<pr>> queue; // edge[G[u].edge_id], u
    G[1].edge_id = 0;
    // G[1].selected = true;
    // G[1].selected = false;
    queue.push(make_pair(edge[0], 1));
    // for(int i = 0; i < G[1].adj.size(); i++){
    //     pr p = G[1].adj[i];
    //     G[p.first].edge_id = p.second;
    //     queue.push(make_pair(edge[p.second], p.first));
    // }

    while(!queue.empty()){
        // DebugPrintQueue(queue);
        pr u_pr = queue.top();
        queue.pop();
        int u = u_pr.second;
        if(G[u].selected){continue; }

        G[u].selected = true;
        if(u != 1){ans.push_back(G[u].edge_id);}

        for(int i = 0; i < G[u].adj.size(); i++){
            pr p = G[u].adj[i];
            int v = p.first;
            if(G[v].selected == true){continue; }

            int e = p.second;
            if(edge[G[v].edge_id] > edge[e]){
                G[v].edge_id = e;
                queue.push(make_pair(edge[e], v));
            }
        }
    }
    return ans;
}


long long SumUpPath(vector<int>& ans);
void PrintAns(vector<int>& ans);
int main(){
    int M;
    cin >> N >> M;
    G.resize(N + 1);
    edge.resize(M + 1);
    edge[0] = INT_MAX; // init
    for(int e = 1; e <= M; e ++){
        int u, v, w;
        cin >> u >> v >> w;
        G[u].adj.push_back(make_pair(v, e));
        G[v].adj.push_back(make_pair(u, e));
        edge[e] = w;
    }

    vector<int> shortest_path = Dijkstra(G);
    vector<int> mst = Prim(G);
    // PrintAns(shortest_path);
    // PrintAns(mst);

    // bool isSame = CheckMST(G, N);
    bool isSame = (SumUpPath(shortest_path) == SumUpPath(mst));
    if(isSame){
        cout << "Yes\n";
        PrintAns(shortest_path);
    }
    else{
        cout << "No\n";
    }

}

long long SumUpPath(vector<int>& ans){
    long long sum = 0;
    for(int i = 0; i < (int)ans.size(); i ++){
        sum += edge[ans[i]];
    }
    return sum;
}
void PrintAns(vector<int>& ans){
    for(int i = 0; i < (int)ans.size(); i ++){
        cout << ans[i] << " ";
    }
    cout << endl;
}
void DebugPrintQueue(priority_queue<pr, vector<pr>, greater<pr>> queue){
    while(!queue.empty()){
        pr p = queue.top();
        cout << p.first << "," << p.second << "  ";
        queue.pop();
    }
    cout << endl;
}