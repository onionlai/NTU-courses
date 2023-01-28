import { v4 as uuidv4 } from 'uuidv4';

const checkOutChatbox = async ({ from, to, ChatBoxModel }) => {
  let chatBoxName = [from, to].sort().join("_");
  let box = await ChatBoxModel.findOne({ name: chatBoxName });
  if (!box) {
    console.log(chatBoxName);
    box = await new ChatBoxModel({ name: chatBoxName }).save();
  }
  return box;
}
const Mutation = {
  createChatBox: async (parent, { from, to }, { ChatBoxModel }) => {
    return await checkOutChatbox({ from, to, ChatBoxModel });
  },

  createMessage: async (parent, { from, to, body }, { pubsub, ChatBoxModel, MessageModel }) => {
    const chatBox = await checkOutChatbox({ from, to, ChatBoxModel });
    // get message
    const message = await new MessageModel({
      sender: from,
      body
    }).save();
    // update chatBox by new message
    chatBox.messages = [...chatBox.messages, message._id];
    await chatBox.save();

    let chatBoxName = [from, to].sort().join("_");
    pubsub.publish(`chatBox ${chatBoxName}`, {
      subscribeChatBox: message
    });
    return message;
  }

};

export default Mutation
