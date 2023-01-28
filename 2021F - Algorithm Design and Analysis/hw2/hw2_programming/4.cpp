#include <iostream>
#include <vector>
#include <queue>

using namespace std;

vector<int> A;
int N;
long long SUM;
vector<long long> ANS;

struct node { // pair sum node
    long long val;
    node* adr;
    node* left;
    node* right;
    bool isValid;
    node(node* a, long long v, node* l, node* r){
        adr = a;
        val = v;
        left = l;
        right = r;
        isValid = true;
    }
    node(){}
};

struct cmp{
    bool operator()(node a, node b){
        return a.val >= b.val;
    }
};

void DebugPrint(int n);
void DebugPrint(node* n);
void DebugPrint(priority_queue<node, vector<node>, cmp> queue);

void Preprocess(int n){
    int tmp;
    cin >> tmp;
    int max = tmp;
    int MAX = tmp; // for ANS[0] (k = 1)
    int prev = tmp;

    for(int i = 1; i < n; i ++){
        cin >> tmp;
        if((prev > 0) == (tmp > 0)){ // same sign
            if(tmp > max) max = tmp;
        }
        else{
            A.push_back(max);
            max = tmp;
        }
        prev = tmp;
        if(tmp > MAX) MAX = tmp;
    }
    A.push_back(max);
    // if( (A.size() != 0 && (tmp > 0) == (A.back() < 0)) || (A.size() == 0))
    //     A.push_back(tmp);

    ANS[0] = MAX;
}

node* CreateLinkedList(){
    SUM = A[0];
    if(N == 1) return nullptr;
    node* head = (node*)malloc(sizeof(node));
    *head = node(head, A[0], nullptr, nullptr);
    node* prev = head;

    for(int i = 1; i < N; i ++){
        SUM += A[i];
        node* newNode = (node*)malloc(sizeof(node));
        //cout << newNode << endl;
        *newNode = node(newNode, A[i], nullptr, nullptr);

        prev->val += newNode->val;
        newNode->left = prev;
        prev->right = newNode;
        prev = newNode;
    }
    prev->val += A[0];
    head->left = prev;
    prev->right = head;

    // cout << "sum=" << SUM << endl;
    return head;
}

priority_queue<node, vector<node>, cmp> InitialQueue(node* head){
    priority_queue<node, vector<node>, cmp> queue;
    if (head == nullptr) return queue;
    node* cur = head;
    queue.push(*cur);

    cur = cur->right;
    while(cur != head){
        queue.push(*cur);
        cur = cur->right;
    }
    return queue;
}

node UpdateNode(node* delNode){
    delNode->left->isValid = false;
    delNode->right->isValid = false;

    node* newNode = (node*)malloc(sizeof(node));
    *newNode = node(newNode, (long long)delNode->left->val + delNode->right->val - delNode->val, nullptr, nullptr);
    newNode->left = delNode->left->left;
    delNode->left->left->right = newNode;
    newNode->right = delNode->right->right;
    delNode->right->right->left = newNode;

    // cout << "to be deleted: ";
    // cout << delNode->left->val << ", ";
    // cout << delNode->right->val << endl;
    // cout << "added: "<< newNode->val << endl;
    return *newNode;
}

void FindSol(int k, priority_queue<node, vector<node>, cmp>& queue, bool isType2){
    while(k > 1){ // k is length
        // cout << '\n' << "k = " << k << endl;
        // DebugPrint(queue);
        while(!queue.top().adr->isValid) {
            // cout << "-- cleaning " << queue.top().val << endl;
            // free(queue.top().adr);
            queue.pop();
        }
        // DebugPrint(queue);
        node delNode = queue.top();
        SUM -= delNode.val;
        if(!isType2 || (isType2 && (SUM > ANS[k - 1]))) ANS[k - 1] = SUM;

        queue.pop();
        if(k != 2) queue.push(UpdateNode(delNode.adr));
        k -= 2;
    }
}

int main(){
    int PROBLEMNUM;
    bool flag;
    cin >> PROBLEMNUM >> flag;
    for(int j = 0; j < PROBLEMNUM; j ++ ){
        // cout << "//////////////////////////"<< endl;
        int n;
        A.clear();
        cin >> n;
        ANS.resize(n);
        Preprocess(n);
        N = A.size(); // N is the size after preprocess
        node* head = CreateLinkedList();
        priority_queue<node, vector<node>, cmp> queue = InitialQueue(head);
        // DebugPrint(N);
        // DebugPrint(head);
        // DebugPrint(queue);

        int k = n; // current answer size: k (put into ANS[k-1])
        while(k > N) {
            ANS[k - 1] = 0;
            k--;
        }
        ANS[k - 1] = SUM;
        FindSol(k - 2, queue, false);


        // cout << "///////////////" << endl;
        // int tmp = A[A.size() - 1];
        // A.pop_back();
        if(A[0] > A[N - 1]) {A.pop_back();}
        else {A.erase(A.begin());}
        N--;
        head = CreateLinkedList();
        queue = InitialQueue(head);
        // DebugPrint(N);
        // DebugPrint(head);
        // DebugPrint(queue); ////////////// DEBUG
        if(k - 2 >= 0) ANS[k - 2] = SUM;
        FindSol(k - 3, queue, false);

        // A.push_back(tmp);
        // A.erase(A.begin());
        // head = CreateLinkedList();
        // queue = InitialQueue(head);
        // // DebugPrint(N);
        // // DebugPrint(head);
        // // DebugPrint(queue); ////////////// DEBUG
        // if(k - 2 >= 0 && SUM > ANS[k - 2]) ANS[k - 2] = SUM;
        // FindSol(k - 3, queue, true);


        for(int i = 0; i < n; i ++){
            cout << ANS[i] << " ";
        }
        cout << '\n';
    }
}

void DebugPrint(int n){
    cout << "preprocess: ";
    for(int i = 0; i < n; i ++){
        cout << A[i] << " ";
    }
    cout << endl;
}
void DebugPrint(node* n){
    cout << "linked list: ";
    if(n == nullptr) {cout << "null" << endl; return;}
    node* cur = n;
    cout << cur->val << " ";
    cur = cur->right;

    while(cur != n){
        cout << cur->val << " ";
        cur = cur->right;
    }
    cout << endl;
}

void DebugPrint(priority_queue<node, vector<node>, cmp> queue){
    cout << "min heap: ";
    while(!queue.empty()){
        cout << queue.top().val << " ";
        queue.pop();
    }
    cout << endl;
}