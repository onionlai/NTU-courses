import mongoose from "mongoose";
const Schema = mongoose.Schema;

/******* ChatBox Schema *******/
const ChatBoxSchema = new Schema({
  name: { type: String, required: [true, "Name field is required."] },
  // users: [{ type: mongoose.Types.ObjectId, ref: "User" }],
  users: [{ type: String, ref: "User" }],
  messages: [{ type: mongoose.Types.ObjectId, ref: "Message" }],
});
const ChatBox = mongoose.model("ChatBox", ChatBoxSchema);

export default ChatBox;
