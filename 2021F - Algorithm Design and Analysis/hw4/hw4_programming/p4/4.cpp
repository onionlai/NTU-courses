#include <iostream>
#include <vector>
#include <climits>
#include <cstdlib>
#include <ctime>
#include <cmath>
using namespace std;

typedef long long ll;
vector<vector<ll>> dp1; // dp[n][m]
vector<vector<ll>> dp2; // dp[n][m]
vector<int> a;

ll addOne(vector<int> &b, int l, int r){
    // l is the first element of the segment(or limit for left)
    // r is the element to be added
    if(l < 0) l = 0;

    ll value = 0;
    value += b[r];
    if(r-1 >= l){
        value -= (ll)abs(b[r]-b[r-1]);
    }
    if(r-2 >= l){
        value += (ll)b[r-1]*((b[r-2]&b[r-1])^(b[r-1]|b[r])^(b[r-2]+b[r]));
    }
    return value;
}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);


    int N, M;
    cin >> N >> M;
    a.resize(N);

    int times = N;
    if(N > 100){
        times = ceil(6*N/M);
        srand( 10 );
    }
    // vector<bool> KChosen(vector<bool>(N, false));

    for(int i = 0; i < N; i ++){
        cin >> a[i];
    }

    ll minRisk = LLONG_MAX;
    for(int t = 0; t < times; t ++){ // t is the first cut
        int k = t; // N < 100
        if(N > 100){
            k = rand() % N;
            // int m = 0;
            // while(KChosen[k] != false && m < 1000){
            //     k = rand() % N;
            //     m++;
            // }
            // KChosen[k] = true;
        }

        vector<int> b = vector<int>(N);

        for(int i = 0; i < N; i ++){
            b[i] = a[(i+k)%N];
        }

        dp1 = vector<vector<ll>>(N, vector<ll>(M)); // cut at i-1
        dp2 = vector<vector<ll>>(N, vector<ll>(M)); // do not cut at i-1

        for(int i = 0; i < N ;i ++){
            for(int m = 0; m < M; m ++){
                if(m > i){
                    dp1[i][m] = LLONG_MAX;
                    dp2[i][m] = LLONG_MAX;
                    continue;
                }
                if(m == 0){
                    if(i == 0){
                        dp1[i][m] = b[0];
                        dp2[i][m] = b[0];
                    }
                    else{
                        dp1[i][m] = LLONG_MAX;
                        if(dp2[i-1][m] == LLONG_MAX) dp2[i][m] = LLONG_MAX;
                        else dp2[i][m] = dp2[i-1][m] + addOne(b, 0, i);
                    }
                }
                else{
                    dp1[i][m] = LLONG_MAX;
                    if(dp1[i-1][m-1] != LLONG_MAX){
                        dp1[i][m] = dp1[i-1][m-1] + addOne(b, i, i);
                    }
                    if(dp2[i-1][m-1] != LLONG_MAX){
                        ll tmp = dp2[i-1][m-1] + addOne(b, i, i);
                        if(tmp < dp1[i][m]){
                            dp1[i][m] = tmp;
                        }
                    }
                    // dp1[i][m] = min(dp1[i-1][m-1], dp2[i-1][m-1]) + addOne(b, i, i); // cut at i-1

                    dp2[i][m] = LLONG_MAX;
                    if(dp1[i-1][m] != LLONG_MAX){
                        dp2[i][m] = dp1[i-1][m] + addOne(b, i-1, i);
                    }
                    if(dp2[i-1][m] != LLONG_MAX){
                        ll tmp = dp2[i-1][m] + addOne(b, i-2, i);
                        if(tmp < dp2[i][m]){
                            dp2[i][m] = tmp;
                        }
                    }

                    // dp2[i][m] = min(dp1[i-1][m] + addOne(b, i-1, i), dp2[i-1][m] + addOne(b, i-2, i));
                }
            }

        }
        if(min(dp1[N-1][M-1], dp2[N-1][M-1]) < minRisk){
            minRisk = min(dp1[N-1][M-1], dp2[N-1][M-1]);
        }
    }
    cout << minRisk << endl;
    // cout << dp[N-1][M] << endl;
    // int i = N-1;
    // for(int m = M; m >= 1; m --){
    //     cout << bt[i][m] << " ";
    //     if(i == bt[i][m] && i != 0){
    //         i = bt[i-1][m-1];
    //     }else{
    //         i = bt[i][m];
    //     }


    // }


}