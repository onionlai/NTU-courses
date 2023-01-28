#include <iostream>
#include <string>
#include <vector>
#include <bits/stdc++.h>

using namespace std;
vector< vector< vector< long long>>> G;
vector< vector< long long>> A;
vector< vector< pair<int, int>>> B;
int N, M, K;
const string PASS = "Passable";
const string UNPASS = "Impassable";

long long g(int i, int j, int k){
    if(i < 0 || j < 0) return LLONG_MIN;
    return G[i][j][k];
}
// pair<int, int> b(int i, int j, int k){
//     if(i < 0 || j < 0) return
// }

void DebugPrintA();
void DebugPrintB();
void DebugPrintG();

void ButtonUp(){
    G[0][0][0] = 0;
    B[0][0] = make_pair(0, 0);
    for(int i = 0; i < N; i ++){
        for(int j = 0; j < M; j ++){
            if(i == 0 && j == 0) continue;
            // if(A[i][j] == LLONG_MIN) continue;
            // cout << "(" << i << "," << j << ")" << endl;

            for(int k = 1; k <= K; k ++){
                if(g(i - 1, j, k - 1) == LLONG_MIN && g(i, j - 1, k - 1) == LLONG_MIN) {
                    G[i][j][k] = LLONG_MIN;
                }
                else if(g(i - 1, j, k - 1) > g(i, j - 1, k - 1)){
                    G[i][j][k] = g(i - 1, j, k - 1);
                }
                else{
                    G[i][j][k] = g(i, j - 1, k - 1);
                }
            }
            // deal with k = 0!
            if(A[i][j] == LLONG_MIN) {
                G[i][j][0] = LLONG_MIN;
                continue;
            }

            long long max = LLONG_MIN;
            int kb = -1;
            for(int k = 1; k <= K; k ++){
                if(g(i, j, k) > max){
                    max = G[i][j][k];
                    kb = k;
                }
            }
            if(kb != -1){
                G[i][j][0] = max + A[i][j];
                for(int l = 0; l <= kb; l++){
                    int jj = j - l;
                    int ii = i - (kb - l);
                    // cout << ii << "," << jj << endl;
                    if(max == g(ii, jj, 0)) {
                        B[i][j] = make_pair(ii, jj);
                    }
                }
            }else{
                G[i][j][0] = LLONG_MIN;
            }

        }
    }
}
int main(){
    int PROBLEMNUM;
    cin >> PROBLEMNUM;
    for(int p = 0; p < PROBLEMNUM; p++){
        cin >> N >> M >> K;
        G.clear();
        A.clear();
        B.clear();

        G.resize(N, vector<vector<long long>>(M, vector<long long>(K + 1, LLONG_MIN)));
        A.resize(N, vector<long long>(M));
        B.resize(N, vector< pair<int, int>>(M, make_pair(-1, -1)));

        string buf;
        for(int i = 0; i < N; i ++){
            for(int j = 0; j < M; j ++){
                cin >> buf;
                A[i][j] = (buf == "X" ? LLONG_MIN : stoll(buf));
            }
        }
        // DebugPrintA();
        // DebugPrintB();

        ButtonUp();
        if(G[N-1][M-1][0] == LLONG_MIN) cout << UNPASS << endl;
        else{
            cout << PASS << endl;
            cout << G[N-1][M-1][0] << endl;
            vector< pair<int, int>> bt;// back tracking
            pair<int, int> cur = make_pair(N-1, M-1);
            bt.push_back(cur);
            while(cur != make_pair(0, 0)){
                cur = B[cur.first][cur.second];
                bt.push_back(cur);
            }
            cout << bt.size() << endl;
            for(int i = bt.size() - 1; i >= 0; i --){
                cout << bt[i].first + 1 << " " << bt[i].second + 1 << endl;
            }
        }
        // DebugPrintG();
        // DebugPrintB();
    }
}





void DebugPrintA(){
    cout << "array A: " << endl;
    for(int i = 0; i < N; i ++){
        for(int j = 0; j < M; j ++){
            if(A[i][j] == LLONG_MIN) cout << "x ";
            else cout << A[i][j] << " ";
        }
        cout << endl;
    }
    cout << endl;
}
void DebugPrintB(){
    cout << "array B: " << endl;
    for(int i = 0; i < N; i ++){
        for(int j = 0; j < M; j ++){
            cout << "(" << B[i][j].first << "," << B[i][j].second << ") ";
        }
        cout << endl;
    }
    cout << endl;
}
void DebugPrintG(){
    cout << "array G:(w/o k)" << endl;
    for(int i = 0; i < N; i ++){
        for(int j = 0; j < M; j ++){
            if(G[i][j][0] == LLONG_MIN) cout << "x ";
            else cout << G[i][j][0] << " ";
        }
        cout << endl;
    }
    cout << endl;
}
