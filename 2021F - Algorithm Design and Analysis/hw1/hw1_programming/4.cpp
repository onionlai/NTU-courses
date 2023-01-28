#include <iostream>
#include <vector>
#include <algorithm>
#include <bits/stdc++.h>

using namespace std;

// divide and conquer method

#define PN 0
#define NP 1
#define PP 2
#define NN 3

vector<int> A;

void ConcatenateAndCopy(vector<int>* v1, vector<int>* v2, vector<int> * target){
    (*target).clear();
    (*target).reserve((*v1).size() + (*v2).size());
    (*target).insert((*target).begin(), (*v1).begin(), (*v1).end());
    (*target).insert((*target).end(), (*v2).begin(), (*v2).end());
}

vector< pair<long long, vector<int>>> FindMax(int l, int r){
    if(l == r){
        if(A[l] == 0)
            return {make_pair(0, vector<int> {l + 1}), make_pair(0, vector<int> {l + 1}),\
             make_pair(0, vector<int> {l + 1}), make_pair(0, vector<int> {l + 1})};
        else if (A[l] > 0)
            return {make_pair(0, vector<int> {}), make_pair(0, vector<int> {}),\
             make_pair(A[l], vector<int> {l + 1}), make_pair(0, vector<int> {})};
        else
            return {make_pair(0, vector<int> {}), make_pair(0, vector<int> {}),\
             make_pair(0, vector<int> {}), make_pair(A[l], vector<int> {l + 1})};
    }
    int m = l + ((r - l) >> 1);
    vector< pair<long long, vector<int>>> left = FindMax(l, m);
    vector< pair<long long, vector<int>>> right = FindMax(m + 1, r);

    vector< pair<long long, vector<int>>> merge(4);
    long long max = LLONG_MIN;

    ////// PN /////
    if( left[PP].second.size() != 0 && right[NN].second.size() != 0 && left[PP].first + right[NN].first > max){
        max = left[PP].first + right[NN].first;
        ConcatenateAndCopy(&left[PP].second, &right[NN].second, &merge[PN].second);
    }
    if( left[PN].second.size() != 0 && right[PN].second.size() != 0 && left[PN].first + right[PN].first > max){
        max = left[PN].first + right[PN].first;
        ConcatenateAndCopy(&left[PN].second, &right[PN].second, &merge[PN].second);
    }

    if( left[PN].second.size() != 0 && left[PN].first > max){
        max = left[PN].first;
        merge[PN].second = left[PN].second;
    }

    if( right[PN].second.size() != 0 && right[PN].first > max){
        max = right[PN].first;
        merge[PN].second = right[PN].second;
    }
    if( merge[PN].second.size() != 0) merge[PN].first = max; // we have update.

    max = LLONG_MIN;
    ///// NP /////
    if( left[NN].second.size() != 0 && right[PP].second.size() != 0 && left[NN].first + right[PP].first > max){
        max = left[NN].first + right[PP].first;
        ConcatenateAndCopy(&left[NN].second, &right[PP].second, &merge[NP].second);
    }
    if( left[NP].second.size() != 0 && right[NP].second.size() != 0 && left[NP].first + right[NP].first > max){
        max = left[NP].first + right[NP].first;
        ConcatenateAndCopy(&left[NP].second, &right[NP].second, &merge[NP].second);
    }

    if( left[NP].second.size() != 0 && left[NP].first > max){
        max = left[NP].first;
        merge[NP].second = left[NP].second;
    }

    if( right[NP].second.size() != 0 && right[NP].first > max){
        max = right[NP].first;
        merge[NP].second = right[NP].second;
    }

    if(merge[NP].second.size() != 0) merge[NP].first = max; // we have update.
    max = LLONG_MIN;

    ///// PP /////
    if( left[PN].second.size() != 0 && right[PP].second.size() != 0 && left[PN].first + right[PP].first > max){
        max = left[PN].first + right[PP].first;
        ConcatenateAndCopy(&left[PN].second, &right[PP].second, &merge[PP].second);
    }
    if( left[PP].second.size() != 0 && right[NP].second.size() != 0 && left[PP].first + right[NP].first > max){
        max = left[PP].first + right[NP].first;
        ConcatenateAndCopy(&left[PP].second, &right[NP].second, &merge[PP].second);
    }

    if( left[PP].second.size() != 0 && left[PP].first > max){
        max = left[PP].first;
        merge[PP].second = left[PP].second;
    }

    if( right[PP].second.size() != 0 && right[PP].first > max){
        max = right[PP].first;
        merge[PP].second = right[PP].second;
    }
    if(merge[PP].second.size() != 0) merge[PP].first = max; // we have update.
    max = LLONG_MIN;
    ///// NN /////
    if( left[NP].second.size() != 0 && right[NN].second.size() != 0 && left[NP].first + right[NN].first > max){
        max = left[NP].first + right[NN].first;
        ConcatenateAndCopy(&left[NP].second, &right[NN].second, &merge[NN].second);
    }
    if( left[NN].second.size() != 0 && right[PN].second.size() != 0 && left[NN].first + right[PN].first > max){
        max = left[NN].first + right[PN].first;
        ConcatenateAndCopy(&left[NN].second, &right[PN].second, &merge[NN].second);
    }

    if( left[NN].second.size() != 0 && left[NN].first > max){
        max = left[NN].first;
        merge[NN].second = left[NN].second;
    }

    if( right[NN].second.size() != 0 && right[NN].first > max){
        max = right[NN].first;
        merge[NN].second = right[NN].second;
    }

    if(merge[NN].second.size() != 0) merge[NN].first = max; // we have update.

    return merge;

}

int main(){
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);
    int NUM, N;
    bool flag;
    vector< pair<long long, vector<int>>> fourAns(4);
    cin >> NUM >> flag;

    for(int i = 0; i < NUM; i ++){
        cin >> N;
        A.resize(N);
        for(int j = 0; j < N; j ++){
            cin >> A[j];
        }
        fourAns = FindMax(0, N - 1);

        int k = 0;
        long long max = fourAns[k].first;
        long long max_id = k;
        k ++;
        while(k <= 3){
            if(fourAns[k].first > max){
                max = fourAns[k].first;
                max_id = k;
            }
            k ++;
        }
        if(fourAns[max_id].second.size() == 0){
            // no candies is included, should output biggest candy in A
            int m = A[0];
            int m_id = 0;
            for(int j = 1; j < N; j ++){
                if(A[j] > m){
                    m = A[j];
                    m_id = j;
                }

            }
            cout << m << endl;
            if(flag == true){
                cout << 1 << " " << m_id + 1 << endl;
            }
        }else{
            cout << max << endl;
            if(flag == true){
                cout << fourAns[max_id].second.size() << " ";
                for(int l = 0; l < (int)fourAns[max_id].second.size(); l++)
                    cout << fourAns[max_id].second[l] << " ";
                cout << endl;
            }
        }
    }
}