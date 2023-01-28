#include <iostream>
#include <vector>
#include <stack>
#include <algorithm>
using namespace std;

vector< pair< int, int>> A;
vector< pair< int, int>> A_merge;
int N;

// Divide and conquer
// T(n) = 2*T(n/2) + n log n + n
// O(NlogN)

bool compareSmallerY(const pair<int, int>& left, const pair<int, int>& right){
    return left.second < right.second;
}
bool compareBiggerY(const pair<int, int>& left, const pair<int, int>& right){
    return left.second > right.second;
}

long long GoodRectanglePairs(int l, int r){
    if (l == r) return 0; // 1 remaining points
    else if (l == r - 1) {
        if(A[l].second > A[r].second)
            swap(A[l], A[r]);
        return 1; // 2 remaining points
    }

    int m = l + ((r - l) >> 1);
    long long rst = GoodRectanglePairs(l, m) + GoodRectanglePairs(m + 1, r);

    stack< pair< int, int>> left;
    vector< pair< int, int>> right;

    // check rectangle of LeftTop-RightDown
    // Merge-sort at the same time~
    int j = m + 1, i = l;
    int k = 0;
    vector< pair< int, int>>:: iterator d;
    vector< pair< int, int>>:: iterator u;

    while (i <= m){
        while (!left.empty() && left.top().first < A[i].first)
            left.pop();

        while (j <= r && A[i].second > A[j].second){
            while (!right.empty() && right.back().first > A[j].first)
                right.pop_back();

            A_merge[k++] = A[j];
            right.push_back(A[j++]);
        }

        u = lower_bound(right.begin(), right.end(), A[i], compareSmallerY);
        if(!left.empty()){
            d = lower_bound(right.begin(), right.end(), left.top(), compareSmallerY);
            rst += u - d;
        }
        else{
            rst += u - right.begin();
        }
        A_merge[k++] = A[i];
        left.push(A[i++]);
    }

    while (j <= r)
        A_merge[k++] = A[j++];

    // check rectangle of LeftDown-RightUP
    i = m, j = r;
    while(!left.empty()){ left.pop(); }
    right.clear();

    while(i >= l){
        while(!left.empty() && left.top().first < A[i].first)
            left.pop();

        while(j >= m + 1 && A[i].second < A[j].second){
            while(!right.empty() && right.back().first > A[j].first)
                right.pop_back();
            right.push_back(A[j--]);
        }
        u = lower_bound(right.begin(), right.end(), A[i], compareBiggerY);
        if(!left.empty()){
            d = lower_bound(right.begin(), right.end(), left.top(), compareBiggerY);
            rst += u - d;
        }
        else{
            rst += u - right.begin();
        }
        left.push(A[i--]);
    }
    copy(A_merge.begin(), A_merge.begin() + r - l + 1, A.begin() + l);

    return rst;
}

int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);

    cin >> N;
    A.resize(N);
    A_merge.resize(N);

    int tmp_x, tmp_y;
    for (int i = 0; i < N; i++){
        cin >> tmp_x >> tmp_y;
        A[i] = make_pair(tmp_x, tmp_y);
    }
    sort(A.begin(), A.end());

    cout << GoodRectanglePairs(0, N - 1) << endl;
}