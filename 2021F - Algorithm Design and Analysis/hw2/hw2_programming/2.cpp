#include <iostream>
#include <algorithm>
#include <numeric>
#include <vector>

using namespace std;

vector<int> A;
vector< vector<long long>> R;
vector< vector<int>> GCD;


long long GCD3(int a, int b, int c){
    if(GCD[a][b] == 1 || GCD[b][c] == 1 || GCD[a][c] == 1) return -1;
    return (long long)GCD[a][b] + GCD[b][c];
}

long long Clear3Merge2(long long r1, long long r2, int a, int b, int c){
    if(r1 == -1 || r2 == -1 || GCD3(a, b, c) == -1) return -1;
    return r1 + r2 + GCD3(a, b, c);
}

long long Clear3Merge1(long long r, int a, int b, int c){
    if(r == -1 || GCD3(a, b, c) == -1) return -1;
    return r + GCD3(a, b, c);
}

long long Clear2Merge1(long long r, int a, int b){
    if(r == -1 || GCD[a][b] == 1) return -1;
    return r + GCD[a][b];
}

long long Clear0Merge2(long long r1, long long r2){
    if(r1 == -1 || r2 == -1) return -1;
    return r1 + r2;
}

int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    int N;
    cin >> N;
    A.resize(N);
    R.resize(N, vector<long long>(N));
    GCD.resize(N, vector<int>(N));

    for(int i = 0; i < N; i ++){
        cin >> A[i];
    }

    for(int i = 0; i < N - 1; i ++){
        for(int j = i + 1; j < N; j ++){
            GCD[i][j] = __gcd(A[i], A[j]);
            // cout << i <<","<< j<< "gcd = "<< GCD[i][j] << endl;
        }
    }

    for(int i = 0; i < N; i ++) // length = 1
        R[i][i] = -1;

    long long tmp = -1;
    long long max = -1;



    for(int k = 2; k <= N; k ++){ // k is length
        for(int i = 0; i <= N - k; i ++ ){ // i is the starting point
            int j = i + k - 1; // j is the ending point
            // cout << "opt( "<< i << ", " << j << ") = ";
            if(k == 2){
                R[i][j] = (GCD[i][j] == 1? -1: GCD[i][j]);
                // cout << R[i][j] << endl;
                continue;
            }
            if(k == 3){
                R[i][j] = GCD3(i, i + 1, j);
                // cout << R[i][j] << endl;
                continue;
            }

            max = -1;
            tmp = Clear2Merge1(R[i + 2][j], i, i + 1);
            if(tmp > max) max = tmp;
            tmp = Clear2Merge1(R[i + 1][j - 1], i, j);
            if(tmp > max) max = tmp;
            tmp = Clear2Merge1(R[i][j - 2], j - 1, j);
            if(tmp > max) max = tmp;

            tmp = Clear3Merge1(R[i + 3][j], i, i + 1, i + 2);
            if(tmp > max) max = tmp;
            tmp = Clear3Merge1(R[i + 2][j - 1], i, i + 1, j);
            if(tmp > max) max = tmp;
            tmp = Clear3Merge1(R[i + 1][j - 2], i, j - 1, j);
            if(tmp > max) max = tmp;
            tmp = Clear3Merge1(R[i][j - 3], j - 2, j - 1, j);
            if(tmp > max) max = tmp;

            if(k > 5){
                for(int h = i + 4; h <= j - 2; h ++){
                    tmp = Clear3Merge2(R[i + 2][h - 1], R[h + 1][j], i, i + 1, h);
                    if(tmp > max) max = tmp;
                }
                for(int h = i + 2; h <= j - 4; h ++){
                    tmp = Clear3Merge2(R[i][h - 1], R[h + 1][j - 2], h, j - 1, j);
                    if(tmp > max) max = tmp;
                }
            }
            if(k > 6){
                for(int h = i + 3; h <= j - 3; h ++){
                    tmp = Clear3Merge2(R[i + 1][h - 1], R[h + 1][j - 1],i , h, j);
                    if(tmp > max) max = tmp;
                }
            }
            if(k > 7){
                for(int h = i + 3; h <= j - 4; h ++){
                    tmp = Clear0Merge2(R[i][h], R[h + 1][j]);
                    if(tmp > max) max = tmp;
                }
            }
            R[i][j] = max;
            // cout << R[i][j] << endl;

        }
    }
    cout << R[0][N - 1];


}