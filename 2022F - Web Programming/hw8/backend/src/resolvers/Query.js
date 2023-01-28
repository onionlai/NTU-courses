const Query = {
  chatbox: async (_, { from, to }, {ChatBoxModel}) => {
    console.log("new query ", from, to);
    let chatBoxName = [from, to].sort().join("_");
    let box = await ChatBoxModel.findOne({ name: chatBoxName });
    if (!box) {
      console.log(chatBoxName);
      box = await new ChatBoxModel({ name: chatBoxName }).save();
    }
    return box;
  },
}

export default Query;
