import { useState, useContext, createContext, useEffect, useRef } from "react";
import { message } from "antd";

const savedMe = localStorage.getItem("save-me");
// const savedPassword = localStorage.getItem("save-password");

const ChatContext = createContext();

const ChatProvider = (props) => {
  const [messages, setMessages] = useState([]);
  const [status, setStatus] = useState({});
  const [me, setMe] = useState(savedMe || "");
  // const [password, setPassword] = useState(savedPassword || "");
  const [password, setPassword] = useState("");
  const [signedIn, setSignedIn] = useState(false);
  const [token, setToken] = useState("");

  // ------ initialize & define client socket ------ //
  const client = useRef(null);

  const newConnection = () => {
    const clientSocket = new WebSocket("ws://localhost:4001");

    clientSocket.onerror = (e) => {
      displayStatus({ type: "error", msg: "Server error. Try again later" });
      setTimeout(() => window.location.reload(), 2000);
    };

    clientSocket.onmessage = (byteString) => {
      const { data } = byteString;
      // data: ["output", [{name: "Erin", body: "hello"}, ...]]
      const [task, payload] = JSON.parse(data);
      switch (task) {
        case "output": {
          setMessages((messages) => [...messages, ...payload]);
          // setMessages([...messages, ...payload]); // <- this will not work!
          break;
        }
        case "status": {
          setStatus(payload);
          break;
        }
        case "init": {
          setMessages(payload);
          break;
        }
        case "cleared": {
          setMessages([]);
          break;
        }
        case "signIn": {
          const { token: newToken } = payload;
          setToken(newToken);
          setSignedIn(true);
          break;
        }
        default:
          break;
      }
    };
    clientSocket.onclose = () => {
      // <- this will call whenever client or server close
      console.log("socket closed. creating new connection to server...");
      setTimeout(() => window.location.reload(), 2000);
    };
    client.current = clientSocket;
  };

  useEffect(() => {
    newConnection();
    return () => {
      signOut();
    };
  }, []);

  useEffect(() => {
    if (signedIn) {
      localStorage.setItem("save-me", me);
      // localStorage.setItem("save-password", password);
    }
  }, [me, signedIn, password]);

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

  // ----- define startChat(when open another chatbox) ----- //
  const startChat = ({ from, to }) => {
    if (!from || !to) throw new Error("from or to required");
    sendData({
      type: "CHAT",
      payload: { from, to, token },
    });
  };

  // ---- define sendMessage(when send new chat message) ---- //
  const sendMessage = ({ from, to, body }) => {
    if (!from || !to || !body) throw new Error("from or to or body required");

    sendData({
      type: "MESSAGE",
      payload: { from, to, token, body },
    });
  };
  const sendData = (data) => {
    client.current?.send(JSON.stringify(data));
  };

  // ---- define signIn ---- //
  const requestSignIn = () => {
    sendData({
      type: "SIGNIN",
      payload: { name: me, password: password },
    });
  };

  const clearMessages = ({ from, to }) => {
    sendData({ type: "CLEAR", payload: { from, to, token } });
  }; // unused

  const signOut = async () => {
    await sendData({ type: "LOGOUT", payload: { token } });
    setSignedIn(false);
    setToken(false);
    setPassword("");
  };

  return (
    <ChatContext.Provider
      value={{
        status,
        me,
        signedIn,
        messages,
        password,
        setPassword,
        startChat,
        setMe,
        setSignedIn,
        sendMessage,
        clearMessages,
        displayStatus,
        requestSignIn,
        signOut,
      }}
      {...props}
    />
  );
};

const useChat = () => useContext(ChatContext);

export { ChatProvider, useChat };
