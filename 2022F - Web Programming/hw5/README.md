# Web Programming HW#5
> Date: 2022/10/31 

Done all advanced & basic todos.

### Get Started
1. Run frontend: ```npm start``` or ```yarn start```
2. Prepare environment variables: MONGO_URL & PORT  
    Run backend: ```npm run server``` or ```yarn server```
### Notes
- server出問題導致的斷線，由於無法保證猜數字的答案和ooxx遊戲階段是否遺失，所以server回復時將重新開始client端的遊戲。
- 新增功能有兩種遊戲可以選，所以完成遊戲的restart改成回menu，讓使用者決定下一個遊戲要玩什麼。