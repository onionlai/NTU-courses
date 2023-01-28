const ChatBox = {
	messages: async (parent) => {
		await parent.populate("messages", ["sender", "body"]);
		return parent.messages;
	}
}

export default ChatBox;