# Web Programming HW#9
> Date: 2022/12/26 

chatroom app ➡️ https://wp1111-production-7732.up.railway.app/

## I. 功能簡述
這次作業使用hw7來練習deploy。  
使用者初次登入輸入使用者名稱、密碼即可簡單註冊並立即登入，已經註冊過的直接輸入名稱及密碼登入即可。  

## II. Deploy流程
### 微幅修改hw7 code
1. backend/src/server.js
讓CORS只有development時使用，且deploy後，後端必須能connect到相對應build好的frontend app。利用NODE_ENV環境變數來判斷為development或production階段。  
插入下列code:
``` 
if (process.env.NODE_ENV === "development") { 
    // default is "development"
	app.use(cors());
}

if (process.env.NODE_ENV === "production") { 
    // build frontend when NODE_ENV="production"
	console.log("production mode");
	const __dirname = path.resolve();
	app.use(express.static(path.join(__dirname, "../frontend", "build")));
	app.use((req, res) => res.sendFile(path.join(__dirname, "../frontend", "build", "index.html")))
} 
```
2. frontend/src/useChat.js
前端的HOST位子應該會和後端一樣，用window.location.origin去抓，但我是用websocket，所以需將http取代為ws。(not sure)  
(in my case: https://wp1111-production-7732.up.railway.app 變成 wss://wp1111-production-7732.up.railway.app)

```
var HOST = "ws://localhost:4000" // use in development
if (process.env.NODE_ENV === "production") {
    HOST = window.location.origin.replace(/^http/, 'ws');
}
const clientSocket = new WebSocket(HOST);
```

### 建立Dockerfile

因為之後要deploy到[Railway](https://railway.app/)，需要能在Docker container裡跑。
```
FROM node:16-alpine

EXPOSE 4000

COPY . /app
WORKDIR /app

RUN corepack enable
RUN yarn install:prod

RUN yarn build
CMD ["yarn", "deploy"]
```

在package.json新增一些指令方便在docker裡用這些shortcut deploy後端、build前端、install package。
在./package.json中的"scripts"新增：
```
"install:prod": "cd frontend && yarn install --freeze-lockfile && cd ../backend && yarn install",
"build": "cd frontend && yarn build",
"deploy": "cd backend && yarn deploy"
```
在backend/package.json的"scripts"新增：

```
"deploy": "NODE_ENV=production babel-node src/server.js"
```
(frontend/package.json不用動，react本來就有生build的指令)

### Railway
在Railway中開啟一個project，連到github repo，他就會自動把docker run好。  
另外，因為我把source code整包放在wp1111這個repo裡的某個資料夾，所以要去設定那裡把目錄改到該資料夾(預設是根目錄)。
等他build好後，Railway會生一個domain，用他給的url就可使用前端服務了!