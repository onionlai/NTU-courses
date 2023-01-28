#include <iostream>
#include <vector>
using namespace std;

// brute force method O(n^2)
int main(){
    int N;
    long long a, b, c;
    vector<int> p, z;

    cin >> N >> a >> b >> c;
    p.resize(N);
    z.resize(N);

    for(int i = 0; i < N; i ++){
        cin >> p[i] >> z[i];
    }

    int ans = 0;
    for(int j = 0; j < N; j ++){
        for(int i = 0; i < N; i ++){
            if(i == j)
                continue;
            if(z[j] > z[i] && a * p[j] > (b * p[i] + c)){
                ans ++;
            }
        }
    }
    cout << ans;

}