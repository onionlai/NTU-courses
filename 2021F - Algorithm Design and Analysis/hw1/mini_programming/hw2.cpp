#include <iostream>
#include <vector>
#include <algorithm>
#include <queue>
using namespace std;

int N, M;
struct City{
    vector<int> neighbor;
    bool isVisited = false;
};
vector<City> C;
vector<int> DFS;
vector<int> BFS;

void DFS_visit(int u){
    C[u].isVisited = true;
    DFS.push_back(u);
    for(int i = 0; i < (int)C[u].neighbor.size(); i ++){
        int v = C[u].neighbor[i];
        if(C[v].isVisited == false){
            DFS_visit(v);
        }
    }
}

void PrintAns(){
    for(int i = 0; i < N; i ++)
        cout << DFS[i] << " ";
    cout << '\n';
    for(int i = 0; i < N; i ++)
        cout << BFS[i] << " ";
    cout << '\n';

}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    cin >> N >> M;
    C.resize(N+1);

    int u, v;
    for(int i = 0; i < M; i ++){
        cin >> u >> v;
        C[u].neighbor.push_back(v);
        C[v].neighbor.push_back(u);
    }
    for(int i = 1; i <= N; i ++){
        sort(C[i].neighbor.begin(), C[i].neighbor.end());
    }

    // DFS
    DFS_visit(1);

    // clear visited
    for(int i = 1; i <= N; i ++)
        C[i].isVisited = false;

    // BFS
    queue<int> q;

    q.push(1);
    while(!q.empty()){
        vector<int> q_n;
        while(!q.empty()){
            u = q.front();
            q.pop();
            if(!C[u].isVisited){
                BFS.push_back(u);
                C[u].isVisited = true;
                for(int i = 0; i < (int)C[u].neighbor.size(); i ++){
                    int v = C[u].neighbor[i];
                    if(!C[v].isVisited) q_n.push_back(v);
                }
            }
        }

        sort(q_n.begin(), q_n.end());
        for(int i = 0; i < (int)q_n.size(); i ++){
            q.push(q_n[i]);
        }
    }
    PrintAns();
}