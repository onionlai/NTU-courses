import mongoose from "mongoose";
const Schema = mongoose.Schema;

/******* Message Schema *******/
const MessageSchema = new Schema({
  chatBox: { type: mongoose.Types.ObjectId, ref: "ChatBox" },
  // sender: { type: mongoose.Types.ObjectId, ref: "User" },
	sender: {type: String, required: [true, "Sender field is required."]},
  body: { type: String, required: [true, "Body field is required."], maxLength: 3000 },
});
const Message = mongoose.model("Message", MessageSchema);

export default Message;