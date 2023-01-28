#include <iostream>
#include <vector>
#include <bits/stdc++.h>
#include<math.h>

using namespace std;

int N, x, y, z;
vector<int> A;

class Subset_info{
public:
    int l_idx;
    int r_idx;
    long long sum;
    Subset_info(int l, int r, long long s){
        l_idx = l;
        r_idx = r;
        sum = s;
    }
};

Subset_info MaxCrossSubArray(int i, int j, int k){
    // left-half: from k to i
    long long sum = (long long)A[k] * x;
    long long max_sum_left = sum;
    int max_left = k;

    int cur = k - 1;
    while(cur >= i){
        sum = sum + (long long)A[cur + 1] * (y - x) + (long long)A[cur] * x;
        if(sum > max_sum_left){
            max_left = cur;
            max_sum_left = sum;
        }
        cur --;
    }

    // right-half: from k + 1 to j
    sum = (long long)A[k + 1] * z;
    long long max_sum_right = sum;
    int max_right = k + 1;

    cur = k + 2;
    while(cur <= j){
        sum = sum + (long long)A[cur - 1] * (y - z) + (long long)A[cur] * z ;
        if(sum > max_sum_right){
            max_right = cur;
            max_sum_right = sum;
        }
        cur ++;
    }
    return Subset_info(max_left, max_right, max_sum_left + max_sum_right);
}

Subset_info MaxSubArray(int i, int j){
    if(i == j)
        return Subset_info(-1, -1, LLONG_MIN);
    if(j == i + 1)
        return Subset_info(i, j, x * (long long)A[i] + z * (long long)A[j]);

    // int k = floor((float)(i + j)/2); // middle index
    int k = (i + j) / 2;

    Subset_info left = MaxSubArray(i, k);
    Subset_info right = MaxSubArray(k + 1, j);
    Subset_info cross = MaxCrossSubArray(i, j, k);

    if(left.sum >= right.sum && left.sum >= cross.sum){
        return left;
    }else if (right.sum >= left.sum && right.sum >= cross.sum){
        return right;
    }else{
        return cross;
    }
}

int main(){
    cin >> N >> x >> y >> z;
    // cout << N << " " << x << " " << y << " " << z << endl;
    A.resize(N);
    for(int i = 0; i < N; i++){
        cin >> A[i];
        // cout << (long long)A[i]*z << " ";
    }

    cout << (long long)(MaxSubArray(0, N - 1)).sum;
}