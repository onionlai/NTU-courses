#include <iostream>
#include <vector>
#include <queue>
using namespace std;

vector< queue<int>> H(3);
int k = 998244353;
int ANS = 0;

int PowTakeMod(int n){
    int ans = 1;
    if(n <= 29){
        ans = (1 << n);
        return ans;
    } else{
        int tmp;
        tmp = PowTakeMod(n >> 1);
        ans = ((long long)tmp * tmp) % k;
        if (n % 2 == 1){
            ans *= 2;
            ans %= k;
        }
    }
    return ans;
}
int FindHanoiState(int target, int src, int dest, int spare){
    if(target <= 0) return 0;

    if(H[dest].front() == target){
        H[dest].pop();
        if(!(H[dest].empty() && H[src].empty())){ // else: i was placed, no hanois up to me, and no bigger hanoi on source. means i just moved here. this is the step.
            // cout << "n=" << target << " go right" << endl;
            ANS -= FindHanoiState(target - 1, spare, dest, src); // i was placed, smaller hanois are heading to me from "spare"
        }
    }
    else if(H[src].front() == target){ // i was not yet placed. smaller hanois are moving away (to "spare") to give me space (to move from "src" to "dest")
        H[src].pop();
        // cout << "n=" << target << " go left" << endl;
        ANS += FindHanoiState(target - 1, src, spare, dest);
    }
    else{
        cout << -1 << endl;
        exit(0);
    }
    ANS %= k;
    return PowTakeMod(target - 1);
}
int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    int N, n, tmp;
    cin >> N;
    for(int i = 0; i < 3; i ++){
        cin >> n;
        if(i == 0 && n == N) {
            cout << PowTakeMod(N) - 1;
            exit(0);
        }
        for(int j = 0; j < n; j ++){
            cin >> tmp;
            H[i].push(tmp);
        }
    }
    ANS += FindHanoiState(N, 0, 2, 1) % k;
    ANS %= k;
    if(ANS < 0) ANS += k;
    cout << ANS - 1;
}