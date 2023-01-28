import axios from "axios";

const instance = axios.create({baseURL: "http://localhost:4000/api"});

const startGame = async (gameMode) => {
  try {
    const {
      data: { msg },
    } = await instance.post(`${gameMode}/start`);
    return msg;
  } catch (error) {
    console.log("Error! " + error);
		throw error;
  }
};

const guess = async (number) => {
  try {
    const {
      data: { msg },
    } = await instance.get("guess/guessing", { params: { number } }); // 用 {data: {msg}} 來接deconstructed的回傳response, 也就是回傳的response 封包物件中的data attribute內容存進msg這個變數名稱裡。
    // get的第二個參數為 config。這裡的params為URL上要代的參數 就是 ~url?number=100，用req.query去接。
    return msg;
  } catch (error) {
    console.log("Error! " + error);
		throw error;
  }
};

const ox = async (i, j) => {
  try {
    const { data: { board, msg }} = await instance.put("ox/oxing", {i, j}); // 這裡第二個參數為 data，用req.body去接，第三個參數(這裡沒設定)一樣是config。

    // await axios({
    //   method: 'put',
    //   url: "http://localhost:4000/api/ox/oxing",
    //   data: {i, j}})

		console.log(board, msg);
    return [board, msg];
  } catch (error) {
    console.log("Error! " + error);
		throw error;
  }
};

export {startGame, guess, ox}