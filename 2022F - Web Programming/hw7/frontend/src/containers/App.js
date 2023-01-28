import "./App.css";
import { useEffect } from "react";
import { useChat } from "./hooks/useChat";
import styled from "styled-components";
import ChatRoom from "./ChatRoom"
import SignIn from "./SignIn";

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  width: 500px;
  margin: auto;
`;

const App = () => {
  const { status, me, signedIn, displayStatus } = useChat();
  useEffect(() => {
    displayStatus(status);
  }, [status]);

  return <Wrapper> {signedIn ? <ChatRoom /> : <SignIn me={me} />} </Wrapper>;
};

export default App;
