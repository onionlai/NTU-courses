const Subscription = {
	subscribeChatBox: {
		subscribe: (parent, {from, to}, {pubsub}) => {
			console.log("new subscription", from, to);
			let chatBoxName = [from, to].sort().join("_");
			return pubsub.subscribe(`chatBox ${chatBoxName}`);
		}
	}
}

export default Subscription;