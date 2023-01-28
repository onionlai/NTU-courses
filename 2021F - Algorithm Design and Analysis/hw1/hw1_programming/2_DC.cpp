#include <iostream>
#include <vector>
#include <bits/stdc++.h>

using namespace std;

// Divide & Conquer method O(nlogn)

int a, b, c;
vector< pair< int, int>> A;
vector< pair< int, int>> A_merge;

void DebugPrint(vector< pair< int, int>> A, int l, int r){
    cout << "[ ";
    for(int i = l; i < r + 1; i ++)
        cout << A[i].first << "," << A[i].second << " ";
    cout << "]" << endl;
    cout << endl;
}

long long CountSmallerPairs(int l, int r){
    if(l >= r) return 0;
    // cout << "CountSmallerPairs( " << l << ", " << r << ")" << endl;
    // DebugPrint(A, l, r);
    int m = l + ((r - l) >> 1);
    long long res = CountSmallerPairs(l, m) + CountSmallerPairs(m + 1, r);

    // cout << "before merge: CountSmallerPairs( " << l << ", " << r << ") -- ";
    // DebugPrint(A, 0, A.size() - 1);

    int i = m, j = r;
    int j_merge = r, k = r - l;

    while(i >= l){
        while(j >= m + 1 && (long long)A[j].second * a > (long long)A[i].second * b + c) j --;
        res += (r - j);

        while(j_merge >= m + 1 && k >= 0 && A[j_merge].second > A[i].second) A_merge[k --] = A[j_merge --];
        A_merge[k --] = A[i --];
    }
    while(j_merge >= m + 1 && k >= 0) {
        A_merge[k --] = A[j_merge --];
    }

    copy_n(begin(A_merge), r - l + 1, begin(A) + l);
    // cout  << "after merge: CountSmallerPairs( " << l << ", " << r << ")----" ;
    // DebugPrint(A, 0, A.size() - 1);
    // cout << res << endl;
    return res;
}

long long SameIndexCountPairs(int l, int r){//left
    long long res = 0;
    int i = r, j = r;
    while(i >= l){
        while(j >= l && i < j && (long long)A[j].second * a > (long long)A[i].second * b + c) j--; // a multiply to left.
        res += (r - j);
        // if(i > j) res -= 1; // exclude itself
        i --;
    }
    return res;
}

int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);
    int N;
    cin >> N >> a >> b >> c;
    A.resize(N);
    A_merge.resize(N);
    int tmp_p, tmp_z;

    for(int i = 0; i < N; i ++){
        cin >> tmp_p >> tmp_z;
        A[i] = make_pair(tmp_z, tmp_p);
    }
    sort(A.begin(), A.end());
    // DebugPrint(A, 0, A.size() - 1);

    bool isSame = false;
    int l = 0, r = 0;
    long long exclude_res = 0;

    for(int i = 1; i < N; i ++){
        if(!isSame && A[i].first == A[i - 1].first){
            l = i - 1;
            isSame = true;
        }
        if(isSame){
            if(A[i].first != A[i - 1].first){
                exclude_res += SameIndexCountPairs(l, r);
                isSame = false;
            }
            else
                r = i;
        }
    }
    if(isSame){
        exclude_res += SameIndexCountPairs(l, r);
    }

    cout << CountSmallerPairs(0, N - 1) - exclude_res;
}
