import { useState, useContext, createContext, useEffect, useRef } from "react";
import { message } from "antd";
import { useMutation, useLazyQuery } from "@apollo/client";
import { CHATBOX_QUERY, CREATE_CHATBOX_MUTATION, CREATE_MESSAGE_MUTATION, MESSAGE_SUBSCRIPTION } from "../../graphql";

const savedMe = localStorage.getItem("save-me");

const ChatContext = createContext();

const ChatProvider = (props) => {
  const [messages, setMessages] = useState([]);
  const [me, setMe] = useState(savedMe || "");
  const [signedIn, setSignedIn] = useState(false);
  const [unsubscribeFn, setUnsubscribeFn] = useState(() => { });

  const [queryChatBox, { data, loading, subscribeToMore }] = useLazyQuery(CHATBOX_QUERY)

  useEffect(() => {
    data && setMessages(data.chatbox.messages);
  }, [data]);

  useEffect(() => {
    if (!signedIn) {
      unsubscribeFn && unsubscribeFn();
    }
  }, [signedIn])

  // ----- define startChat(when open another chatbox) ----- //
  const [createChatBox] = useMutation(CREATE_CHATBOX_MUTATION);
  const startChat = async ({ from, to }) => {
    await createChatBox({ variables: { from, to } });
    queryChatBox({
      variables: { from, to },
      fetchPolicy: "network-only" // 重要：不然切換聊天室不會真的query，會用瀏覽器裡的cached data。
    })

    unsubscribeFn && unsubscribeFn();

    try {
      const fn = subscribeToMore({
        document: MESSAGE_SUBSCRIPTION,
        variables: { from, to },
        updateQuery: (oldData, { subscriptionData }) => {
          // console.log("new subscription");
          console.log(oldData);
          // console.log(subscriptionData.chatbox);
          console.log(subscriptionData);
          const newMessage = subscriptionData.data.subscribeChatBox;
          if (newMessage.sender === me) {
            displayStatus({
              type: "success",
              msg: "Message sent"
            })
          }
          else {
            displayStatus({
              type: "info",
              msg: "Message received"
            })
          }

          return {
            chatbox: {
              ...oldData.chatbox,
              messages: [...oldData.chatbox.messages, newMessage]
            }
          }
        }
      });
      // setUnsubscribeFn(() => {
      //   console.log("unsubscribe", from, to);
      //   fn(); <- 這樣的話會被馬上呼叫...
      // })
      setUnsubscribeFn(() => fn)
    } catch (e) {
      console.log(e);
    }

  }

  // ---- define sendMessage(when send new chat message) ---- //
  const [createMessage] = useMutation(CREATE_MESSAGE_MUTATION);
  const sendMessage = ({ from, to, body }) => {
    console.log(`send new Message from: ${from}, to ${to}, content: `, body);
    createMessage({
      variables: { from, to, body }
    })
  }

  useEffect(() => {
    if (signedIn) {
      localStorage.setItem("save-me", me);
    }
  }, [me, signedIn]);

  // ----- define displayStatus(when receive 'status' notification) ----- //
  const displayStatus = (s) => {
    if (s.msg) {
      const { type, msg } = s;
      const content = { content: msg, duration: 0.6 };
      switch (type) {
        case "success":
          message.success(content);
          break;
        case "error":
          message.error(content);
          break;
        case "info":
          message.info(content);
          break;
        default:
          break;
      }
    }
  };

  return (
    <ChatContext.Provider
      value={{
        me,
        signedIn,
        messages,
        startChat,
        setMe,
        setSignedIn,
        sendMessage,
        displayStatus,
      }}
      {...props}
    />
  );
};

const useChat = () => useContext(ChatContext);

export { ChatProvider, useChat };
