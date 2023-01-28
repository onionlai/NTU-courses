#include "connect4.h"
#include <climits>
using namespace std;
// using namespace connect4_judge;

//////// START OF COPY/MODIFIED FROM TA's connect4.h /////////
static const std::pair<int, int> board_size = {6, 7}; // row * column
class Game {
  public:
    enum Result {
        ONGOING,
        TIE,
        P1_WIN,
        P2_WIN,
        INVALID_MOVE,
    };

    std::vector<std::vector<int>> board; // 0: empty, 1: P1, 2: P2
    int turn;
    Result status;

    Game(): board(board_size.first, std::vector<int>(board_size.second, 0)), turn(1), status(ONGOING) {}

    Result play(int col) {
        // if (status != ONGOING)
        //     return INVALID_MOVE; // Already ended
        if (col < 0 || col >= board_size.second)
            return INVALID_MOVE; // Not a valid column
        if (board[0][col] != 0)
            return INVALID_MOVE; // Top out

        int row = board_size.first - 1;
        while (board[row][col] != 0)
            row--;
        board[row][col] = turn;

        auto check_single = [&](int x, int y, int dx, int dy) -> int {
            if (!board[x][y] || x + dx * 3 >= board_size.first ||
                    y + dy * 3 >= board_size.second || y + dy * 3 < 0)
                return 0;
            for (int i = 1; i <= 3; i++)
                if (board[x + dx * i][y + dy * i] != board[x][y])
                    return 0;
            return board[x][y];
        };

        bool any_empty = false;
        for (int i = 0; i < board_size.first; i++)
            for (int j = 0; j < board_size.second; j++) {
                any_empty |= (board[i][j] == 0);
                int dx[4] = {0, 1, 1, 1}, dy[4] = {1, 0, 1, -1};
                for (int k = 0; k < 4; k++) {
                    int res = check_single(i, j, dx[k], dy[k]);
                    if (res == 1)
                        return status = P1_WIN;
                    else if (res == 2)
                        return status = P2_WIN;
                }
            }
        if (!any_empty)
            return status = TIE;
        turn = 3 - turn; // switch turn
        return ONGOING;
    }
    void withdraw(int col){
        status = ONGOING;
        for(int row = 0; row < board_size.first; row++){
            if(board[row][col] != 0){
                board[row][col] = 0;
                return;
            }
        }
        // cout << "strange" << endl;
    }
    void Reset(){
        board = vector<vector<int>>(board_size.first, std::vector<int>(board_size.second, 0));
        status = ONGOING;
        turn = 1;
    }
};
/////////// END OF COPY /////////////
int d = 4;
Game curGame;

int check_potential(int x_org, int y_org, int dx, int dy, int cur, Game& game, bool maximizing){ // the potential of creating a line from "cur" at the direction <dx, dy> centered at (x_org, y_org)
    int potential1 = 0; // continuous num of o/x besides (x,y) in dir(dx, dy)
    // int potential11 = 0; // non-continuous num of o/x besides (x,y) in dir(dx, dy)
    int potential2 = 0; // non-continuous num of o/x besides (x,y) in dir(-dx, -dy)
    // int potential22 = 0; // continuous num of o/x besides (x,y) in dir(-dx, -dy)
    int k1 = 0;         // total available space in dir(dx, dy)
    int k2 = 0;         // total available space in dir(-dx, -dy)
    int x = x_org + dx;
    int y = y_org + dy;
    bool continue_flag = true;
    while(x < board_size.first && y < board_size.second && x >= 0 && y >= 0){
        if(game.board[x][y] == cur){
            if(continue_flag) potential1 += 1;
            // potential11 += 1;
        }
        else if (game.board[x][y] == 0){ continue_flag = false; }
        else {break;}

        x += dx;
        y += dy;
        k1++;
    }
    continue_flag = true;
    x = x_org - dx;
    y = y_org - dy;
    while(x < board_size.first && y < board_size.second && x >= 0 && y >= 0){
        if(game.board[x][y] == cur){
            if(continue_flag) potential2 += 1;
            // potential22 += 1;
        }
        else if (game.board[x][y] == 0){ continue_flag = false; }
        else { break; }
        x -= dx;
        y -= dy;
        k2++;
    }
    if((k1 + k2) < 3) return 0;
    // /// guess
    // // if(!maximizing){
    // //     if((potential1 == 3) || (potential2 == 3)) return 30000;
    // //     else return 0;
    // // }
    // // my decision
    // if((potential1 == 3 && k1 >= 3) || (potential2 == 3 && k2 >= 3)) return 3000000;
    // if(potential1 + potential2 >= 3) return 100000;

    // // if(potential1 + potential2 >= 2) return (potential1+potential2)*100;
    // if(potential11 + potential22 >= 2) return 100*(potential11+potential22)+min(k1+k2, 5);

    if(potential1 >= 3 || potential2 >= 3) return 100000;
    if(potential1 + potential2 >= 3) return 80000;
    if(potential1 + potential2 >= 2) return 50000;
    // if(potential1 + potential2 >= 1 && (k1+k2)>=3) return k1+k2;
    return 0;
}

long long evaluation(Game &game, bool maximizing){
    switch (game.status){
        case Game::P1_WIN: return INT_MAX;
        case Game::P2_WIN: return INT_MIN + 3;
        case Game::TIE: return 0;
        // case Game::INVALID_MOVE: return INT_MIN;
        default: break;
    }
    long long potential_p1 = 0;
    long long potential_p2 = 0;
    int dx[4] = {0, 1, 1, 1}, dy[4] = {1, 0, 1, -1};
    for (int j = 0; j < 7; j++) {
        for (int i = 5; i >= 0; i--){
            if(game.board[i][j] != 0) continue; //[TODO] 改成不是以空格為中心
            // check total potential center at the blank (i, j)
            int cur_potential_p1 = 0;
            int cur_potential_p2 = 0;
            for(int k = 0; k < 4; k ++){
                int w = (k>=3?2:1);
                cur_potential_p1 += w*check_potential(i, j, dx[k], dy[k], 1, game, maximizing);
                cur_potential_p2 += w*check_potential(i, j, dx[k], dy[k], 2, game, maximizing);
            }
            // potential_p1 += (long long)pow(cur_potential_p1,4);
            // potential_p2 += (long long)pow(cur_potential_p2,4);
            potential_p1 += cur_potential_p1;
            potential_p2 += cur_potential_p2;
        }
    }
    return potential_p1 - potential_p2;
}

long long minimax(Game &game, int depth, bool maximizing, long long alpha, long long beta){
    if(game.status != Game::ONGOING){
        return evaluation(game, maximizing);
    }
    else if(depth == 0){
        long long tmp = evaluation(game, maximizing);
        if(tmp > INT_MAX || tmp < INT_MIN){cout << tmp << endl;}
        // return evaluation(game, maximizing);
        return tmp;
    }

    long long value;
    if(maximizing){ // my turn
        value = LLONG_MIN;
        // Game next_game = game;
        for(int c = 0; c <= 6; c++){
            game.turn = 1;
            game.status = game.play(c);
            if(game.status == Game::INVALID_MOVE){continue;}
            value = max(value, minimax(game, depth - 1, false, alpha, beta)); // next is not my turn
            game.withdraw(c);

            if(value >= beta){
                return beta;
            }
            alpha = value;
        }
    }
    else{ // not my turn
        value = LLONG_MAX;
        // game.turn = 2;
        // Game next_game = game;
        for(int c = 0; c <= 6; c++){
            game.turn = 2;
            game.status = game.play(c);
            if(game.status == Game::INVALID_MOVE){continue;}
            value = min(value, minimax(game, depth - 1, true, alpha, beta)); // next is my turn
            game.withdraw(c);

            if(value <= alpha){
                return alpha;
            }
            beta = value;
        }
    }
    return value;
}


// The columns are numbered from 0 to 6

int decide(int yp_move) {
    if (yp_move == -1) {
        // A new game starts
        // TODO: Please remember to reset everything here (if needed)
        curGame.Reset();
        curGame.turn = 1;
        curGame.play(3);
        return 3;
    }
    else {
        // YP placed his piece at column `yp_move`
        curGame.turn = 2;
        curGame.status = curGame.play(yp_move);

        int nextMove = 3;
        // int value = INT_MIN;
        long long alpha = LLONG_MIN;
        long long beta = LLONG_MAX;


        for(int c = 0; c <= 6; c++){
            curGame.turn = 1;
            curGame.status = curGame.play(c);
            if(curGame.status == Game::INVALID_MOVE){continue;}

            int new_value = minimax(curGame, d, false, alpha, beta);
            curGame.withdraw(c);
            // d = (d==4?5:4);
            if(new_value > alpha){
                alpha = new_value;
                nextMove = c;
            }
        }
        // cout << "debug2" << endl;

        curGame.turn = 1;
        curGame.status = curGame.play(nextMove);
        return nextMove;
    }
    return 3;
}
