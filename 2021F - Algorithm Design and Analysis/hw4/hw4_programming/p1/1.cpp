#include <iostream>
#include <bitset>
#include "ypglpk.hpp"

using namespace std;

vector<vector<double>> A;
vector<bitset<80>> N;
vector<vector<int>> mc;

int s = 0;
int n;


void Bronkerbosch(bitset<80> R, bitset<80> P, bitset<80> X){
    if(P.none() && X.none()){
        mc.push_back(vector<int>());
        for(int u = 0; u < n; u ++){
            if(R[u]){
                A[u][s] = -1;
                mc[s].push_back(u);
            }
        }
        s ++;
    }
    // if(P.none()){return; }
    int v = -1;
    for(int i = 0; i < n; i ++){
        if(P[i] | X[i]){v = i; break;}
    }
    if(v == -1){ return; }

    for(int u = 0; u < n; u ++){
        if(P[u] & ~N[v][u]){
            bitset<80> u_set(0);
            u_set.set(u);

            Bronkerbosch(R | u_set, P & N[u], X & N[u]);
            P &= ~u_set;
            X |= u_set;
        }
    }
}
void DebugPrint();
void DebugPrint(pair<double, vector<double>> &ans);
void printAns(pair<double, vector<double>> &ans){
    bitset<80> mask(0);
    cout << -ans.first << '\n';

    for(int i = 0; i < (int)ans.second.size(); i ++){
        if(ans.second[i] == 0) continue;
        vector<int> output;
        for(int j = 0; j < (int)mc[i].size(); j++){
            if(!mask[mc[i][j]]) {
                output.push_back(mc[i][j]);
                // cout << mc[i][j] << " ";
                mask.set(mc[i][j]);
            }
        }
        cout << output.size() << " ";
        for(int k = 0; k < (int)output.size(); k++){
            cout << output[k] << " ";
        }
        cout << '\n';
    }
}

int main(){
    int num;
    cin >> num;
    for(int p = 0; p < num; p ++){
        A = vector<vector<double>>(80, vector<double>(800,0));
        N = vector<bitset<80>>(80, 0);
        // b.clear();
        // c.clear();
        mc.clear();
        s = 0;

        int m;
        cin >> n >> m;
        int u, v;
        for(int i = 0; i < m; i ++){
            cin >> u >> v;
            N[u][v] = 1;
            N[v][u] = 1;
        }
        bitset<80> init(0);
        for(int i = 0; i < n; i++) init.set(i);
        Bronkerbosch(0, init, 0);
        // DebugPrint();
        for(int i = 0; i < n; i ++){
            A[i].resize(s);
        }
        A.resize(n + 2*s);
        for(int i = 0; i < s; i ++){
            A[n+i] = vector<double>(s, 0);
            A[n+i][i] = -1;
        }
        for(int i = 0; i < s; i ++){
            A[n+s+i] = vector<double>(s, 0);
            A[n+s+i][i] = 1;
        }

        vector<double> b(n, -1);
        vector<double> tmp_b(s, 0);
        b.insert(b.end(), tmp_b.begin(), tmp_b.end());
        tmp_b = vector<double>(s, 1);
        b.insert(b.end(), tmp_b.begin(), tmp_b.end());

        vector<double> c(s, -1);
        // ypglpk::set_output(true);
        pair<double, vector<double>> ans = ypglpk::mixed_integer_linear_programming(A, b, c, vector<bool>(s, true));
        // DebugPrint(ans);
        printAns(ans);

    }


}

void DebugPrint(){
    for(int i = 0; i < s; i ++){
        cout << "set" << i << " :";
        for(int j = 0; j < (int)mc[i].size(); j ++){
            cout << mc[i][j] << " ";
        }
        cout << endl;
    }
}
void DebugPrint(pair<double, vector<double>> &ans){
    cout << ans.first << endl;
    for(int i = 0; i < (int)ans.second.size(); i ++){
        cout << ans.second[i] << " ";
    }
    cout << endl;
}