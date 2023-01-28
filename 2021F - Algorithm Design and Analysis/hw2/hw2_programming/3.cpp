#include <iostream>
#include <vector>
#include <queue>
#include <set>
#include <algorithm>
#include <bits/stdc++.h>
#include <math.h>

using namespace std;

typedef pair<int, int> pr;

struct Job{
    int s;
    int e;
    int x;
    int p;
    Job(int start, int end, int x_len, int pay){
        s = start;
        e = end;
        x = x_len;
        p = pay;
    }
    Job(){}
};

// struct Count{
//     int target;
//     int reserve;
//     Count(int _target, int _reserve){
//         target = _target;
//         reserve = _reserve;
//     }
// };

vector<Job> origJ;
struct cmp{
    bool operator()(const Job& a, const Job& b){
        return a.s < b.s;
    }
};
struct cmp1{
    bool operator()(const Job& a, const Job& b){
        return a.p > b.p;
    }
};


int min(const int & a, const int & b, const int & c){
    if(a <= b && a <= c) return a;
    else if(b <= a && b <= c) return b;
    return c;
}

vector<Job> J;
struct cmp2{
    bool operator()(const int& a, const int& b){
        return J[a].e > J[b].e;
    }
};

// int N;
void DebugPrint(priority_queue<int, vector<int>, cmp2> queue){
    cout << "print queue: ";
    while(!queue.empty()){
        cout << queue.top() << " ";
        queue.pop();
    }
    cout << endl;
}
void DebugPrint(){
    cout << "J: ";
    for(int i = 0; i < (int)J.size(); i ++){
        cout << J[i].s << " ";
    }
    cout << endl;
}


long long CountAvailableJobs(int t_end){
    sort(J.begin(), J.end(), cmp()); // start time earlier first
    // DebugPrint();

    priority_queue<int, vector<int>, cmp2> queue;
    int i = 0;
    long long sum = 0;
    int n = J.size();

    int t = J[0].s;
    int nextt;
    while(t <= t_end){
        // cout << t << " ";
        // DebugPrint(queue);

        while(i < n && J[i].s == t){queue.push(i++);}
        nextt = i < n ? J[i].s : t_end + 1;

        if(queue.empty()){t = nextt; continue;}

        int clear_x = min(J[queue.top()].x, nextt - t, J[queue.top()].e - t + 1);
        if(clear_x <= 0) { queue.pop();}
        else{
            sum += clear_x;
            t += clear_x;
            J[queue.top()].x -= clear_x;
            if(J[queue.top()].x == 0) queue.pop();
        }
    }
    // cout << sum << endl;
    return sum;
}

int main(){
    int N;
    cin >> N;
    origJ.resize(N);
    int s_tmp, e_tmp, x_tmp, p_tmp;
    int t_end = 0;

    for(int i = 0; i < N; i ++){
        cin >> s_tmp >> e_tmp >> x_tmp >> p_tmp;
        origJ[i] = Job(s_tmp, e_tmp, x_tmp, p_tmp);
        if(e_tmp > t_end) t_end = e_tmp;
    }

    sort(origJ.begin(), origJ.end(), cmp1());

    vector<Job> curJ;
    curJ.push_back(origJ[0]);
    J = curJ;
    long long fixjobs = CountAvailableJobs(t_end);
    long long SUM = origJ[0].p * fixjobs;
    for(int i = 1; i < N; i ++){
        // cout << i << endl;
        curJ.push_back(origJ[i]);
        J = curJ;
        long long newsum = CountAvailableJobs(t_end);
        curJ[i].x = newsum - fixjobs;
        SUM += curJ[i].p * (newsum - fixjobs);

        fixjobs = newsum;



        // int min_x = 0;
        // int max_x = curJ[i].x;
        // int cur_x = (min_x + max_x) / 2;
        // while(min_x != max_x){
        //     J = curJ;
        //     cur_x = ceil((float)(min_x + max_x)/2);
        //     J[i].x = cur_x;
        //     Count count = CountAvailableJobs(t_end, i);
        //     if(count.reserve == fixjobs){ // cur_x avaliable, increase x to find better
        //         min_x = cur_x;
        //     }
        //     else if(count.reserve < fixjobs){ // cur_x is not avaliable, should reduce x
        //         max_x = cur_x - 1;
        //     }
        // }
        // J = curJ;
        // J[i].x = min_x;
        // Count count = CountAvailableJobs(t_end, i);
        // SUM += count.target * origJ[i].p;
        // fixjobs += count.target;
    }
    cout << SUM << endl;

}