#include <iostream>
#include <vector>
#include <set>
#include <bits/stdc++.h>
using namespace std;

// sequential recurrence O(nlogn)~O(n^2)

int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    int N;
    double a, b, c;

    cin >> N >> a >> b >> c;
    vector< int> p(N);
    vector< pair< int, int>> z(N);

    int z_tmp;
    for(int i = 0; i < N; i ++){
        cin >> p[i] >> z_tmp;
        z[i] = make_pair(z_tmp, i);
    } // 2*O(N)

    sort(z.begin(), z.end()); // O(NlogN)

    int z_idx = 0 ;
    int ans = 0;

    multiset<double> tmp_set;
    // int j = 0;

    // multiset<double>:: iterator it;


    for(int i = 0; i < N; i ++){
        // j = z[i].second;

        while(z_idx < N && z[z_idx].first < z[i].first){
            tmp_set.insert((b/a) * p[z[z_idx].second] + (c/a));
            z_idx ++;
        }

        // it = tmp_set.lower_bound(p[z[i].second]);
        ans += distance(tmp_set.begin(), tmp_set.lower_bound(p[z[i].second]));
    }

    cout << ans;
}