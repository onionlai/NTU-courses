import { useState, useEffect, useRef } from "react";
import { Button, Input, Tabs } from "antd";
import styled from "styled-components";
import { useChat } from "./hooks/useChat";
import Title from "../components/Title";
import Message from "../components/Message";
import ChatModal from "../components/ChatModal";

const ChatBoxesTabWrapper = styled(Tabs)`
  width: 100%;
  height: 450px;
  background: #eeeeee52;
  border-radius: 10px;
  margin: 20px;
  padding: 20px;
  overflow: hidden;
`;

const ChatBoxWrapper = styled.div`
  width: 100%;
  height: 380px;
  border-radius: 10px;
  padding: 5px;
  margin: 0px 20px;
  overflow: auto;
`;
const FootRef = styled.div`
  height: 20px;
`;

const ChatRoom = () => {
  const { me, messages, sendMessage, displayStatus, startChat, setSignedIn } = useChat();
  const [msg, setMsg] = useState("");
  const [msgSent, setMsgSent] = useState(false);
  const [chatBoxes, setChatBoxes] = useState([]); // array of {label, children, key}. recognized by Tabs. each item represents a tab. 'children' is the dom node, 'label' is the title, 'key' is unique key
  const [activeKey, setActiveKey] = useState("");
  const [modalOpen, setModalOpen] = useState(false);

  //================= auto scroll & auto tab =================//
  const msgRef = useRef(null);
  const msgFootRef = useRef(null);

  const scrollToBottom = () => {
    msgFootRef.current?.scrollIntoView({ behavior: "smooth", block: "start" }); // msgFootRef這個reference指向的東西(.current)存在就呼叫scrollIntoView
  };

  useEffect(() => { // messages is in "chatBoxes.children". changes of "messages" won't trigger DOM rerender. So do this manually.
    setChatBoxes(
      chatBoxes.map((chatBox) => {
        if (chatBox.key === activeKey)
          return { ...chatBox, children: renderChat() };
        return chatBox;
      }) // when chatBoxes change, DOM will rerender
    );
  }, [messages]);

  useEffect(() => {
    scrollToBottom();
    setMsgSent(false);
  }, [msgSent, chatBoxes]);

  //================= message update & render =================//
  const renderChat = () => {
    return messages.length === 0 ? (
      <p style={{ color: "#ccc" }}> No messages... </p>
    ) : (
      <ChatBoxWrapper>
        {messages.map(({ sender, body }, i) => (
          <Message name={sender} isMe={sender === me} message={body} key={i} />
        ))}
        <FootRef ref={msgFootRef} />
      </ChatBoxWrapper>
    );
  };

  //================= switch chatbox tab =================//
  const createChatBox = (newKey) => {
    if (chatBoxes.some(({ key }) => key === newKey)) {
      throw new Error(newKey + "'s char box has already opened.");
    }
    const chat = renderChat();
    setChatBoxes([
      ...chatBoxes,
      { label: newKey, children: chat, key: newKey },
    ]); // append to array
    setMsgSent(true); // for scrollToBottom()
    return newKey;
  };

  const removeChatBox = (targetKey, activeKey) => {
    const index = chatBoxes.findIndex(({ key }) => key === activeKey);
    setChatBoxes(chatBoxes.filter(({ key }) => key !== targetKey));

    if (activeKey) {
      if (activeKey !== targetKey) return activeKey;
      if (activeKey === targetKey && index !== 0) {
        return chatBoxes[index - 1].key;
      }
    }
    return "";
  };
  //======================== DOM ==========================//

  return (
    <>
      <Title name={me} />
      <Button onClick={() => setSignedIn(false)}> Sign Out </Button>
      <ChatBoxesTabWrapper
        type="editable-card"
        tarbarstyle={{ height: "36px" }}
        activeKey={activeKey}
        onChange={(key) => {
          startChat({ from: me, to: key });
          setActiveKey(key);
        }}
        onEdit={(targetKey, action) => {
          if (action === "add") setModalOpen(true);
          else if (action === "remove")
            setActiveKey(removeChatBox(targetKey, activeKey));
        }}
        items={chatBoxes}
      />
      <ChatModal
        open={modalOpen}
        onCreate={({ name }) => {
          // after clicking 'Create'
          setActiveKey(() => createChatBox(name));
          setModalOpen(false);
          startChat({ from: me, to: name });
        }}
        onCancel={() => setModalOpen(false)} // after clicking 'Cancel'
      />
      <Input.Search
        disabled={!activeKey}
        enterButton="Send"
        placeholder="Type a message here..."
        value={msg}
        onChange={(e) => {
          if (e.target.value.length >= 3000) {
            displayStatus({
              type: "error",
              msg: "Message exceeds max length",
            });
            return;
          }
          setMsg(e.target.value)
        }}
        onSearch={(msg) => {
          // Enter or Button
          if (!msg) {
            displayStatus({
              type: "error",
              msg: "Please enter message body",
            });
            return;
          }
          sendMessage({ from: me, to: activeKey, body: msg });
          setMsg("");
          setMsgSent(true);
        }}
        ref={msgRef}
      ></Input.Search>
    </>
  );
};
export default ChatRoom;
