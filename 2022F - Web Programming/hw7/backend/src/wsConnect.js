import Message from "./models/message";
import ChatBox from "./models/chatbox";
import User from "./models/user";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const sendData = (data, ws) => {
  ws.send(JSON.stringify(data));
};
const sendStatus = (payload, ws) => {
  sendData(["status", payload], ws);
};

const makeName = (from, to) => {
  return [from, to].sort().join("_");
};

const validateChatBox = async (chatBoxName, participants) => {
  let box = await ChatBox.findOne({ name: chatBoxName });
  if (!box) {
    console.log(chatBoxName, participants);
    box = await new ChatBox({ name: chatBoxName, users: participants }).save();
  }
  return box;
};

const chatboxesWs = {};

export default {
  onMessage: (wss, ws) => async (byteString) => {
    const { data } = byteString;
    const { type, payload } = JSON.parse(data);

    if (type === "SIGNIN") {
      const { name, password } = payload;
      var loginUser = await User.findOne({ name });
      if (!loginUser) {
        sendStatus({ type: "info", msg: "Creating new loginUsers..." }, ws);
        loginUser = await User.create({ name, password });
      } else {
        const isMatch = await bcrypt.compare(password, loginUser.password);
        if (!isMatch) {
          sendStatus({ type: "error", msg: "Wrong Password" }, ws);
          return;
        }
      }
      const token = await loginUser.generateAuthToken(ws.id);
      sendStatus({ type: "info", msg: "Login success" }, ws);
      sendData(["signIn", { token }], ws);
      console.log("                 log in");
      return;
    }

    const { from, to, token } = payload; //payload should always contains from, to

    const user = await User.findOne({
      _id: await jwt.verify(token, "onion")._id,
      "tokens.token": token,
    });
    if (!user) {
      sendStatus({ type: "error", msg: "Access denied" }, ws);
      return;
    }

    const chatBoxName = makeName(from, to); // $from_$to

    // --- if client open a new chatbox --- //
    if (ws.box !== chatBoxName) {
      if (ws.box !== "") chatboxesWs[ws.box].delete(ws);
      ws.box = chatBoxName;
      if (!chatboxesWs[chatBoxName]) {
        chatboxesWs[chatBoxName] = new Set();
      }
      chatboxesWs[chatBoxName].add(ws);
    }

    // --- when receiving new messages --- //
    if (type === "MESSAGE") {
      const { body } = payload;
      // get chatBox
      const chatBox = await validateChatBox(chatBoxName, [from, to]);

      // get message
      const message = await new Message({
        sender: from,
        body,
        chatBox: chatBox._id,
      }).save();
      // update chatBox by new message
      chatBox.messages = [...chatBox.messages, message._id];
      await chatBox.save();
      // notify every clients opening this chatbox
      chatboxesWs[chatBoxName].forEach((connectedWs) => {
        sendData(["output", [{ name: from, body }]], connectedWs);
        if (connectedWs !== ws)
          sendStatus({ type: "info", msg: "New message" }, connectedWs);
      });
      sendStatus({ type: "success", msg: "Message sent" }, ws);
      return;
    }
    if (type === "CHAT") {
      const chatBox = await validateChatBox(chatBoxName, [from, to]);
      await chatBox.populate("messages", ["sender", "body"]);
      // chatBox.save(); // <- will not save populated result (after all it's ObjectId type)
      sendData(
        [
          "init",
          chatBox.messages.map(({ sender, body }) => ({ name: sender, body })),
        ],
        ws
      );
      sendStatus({ type: "info", msg: "Message loaded" }, ws);
      return;
    }
    if (type === "CLEAR") {
      // await ChatBox.findOne({name: chatBoxName}).clear();
    }
    if (type === "LOGOUT") {
      console.log("                 log out");
      user.tokens = user.tokens.filter(t => t.token !== token);
      user.save();
    }
  },
  onClose: async (ws) => {
    console.log("connection close", ws.id);
    if (ws.box !== "") chatboxesWs[ws.box].delete(ws);
    const user = await User.findOne({"tokens.wsId": ws.id});
    if (!user) return;
    user.tokens = user.tokens.filter(t => t.wsId !== ws.id);
    user.save();
  },
};
