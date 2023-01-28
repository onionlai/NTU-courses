import { createContext, useContext, useState } from 'react';

const ADD_MESSAGE_COLOR = '#3d84b8';
const REGULAR_MESSAGE_COLOR = '#2b2e4a';
const ERROR_MESSAGE_COLOR = '#fb3640';

const ScoreCardContext = createContext({
  messages: [],

  clearMessages: () => {},
  addCardMessage: () => {},
  addRegularMessage: () => {},
  addErrorMessage: () => {},
}); // 定義context內容物, template

const makeMessage = (message, color) => {
  return { message, color };
};

const ScoreCardProvider = (children) => {
  const [messages, setMessages] = useState([]);

  const clearMessages = (ms) => {
    console.log('clear');
    setMessages([makeMessage(ms, REGULAR_MESSAGE_COLOR)]);
  }

  const addCardMessage = (message) => {
    setMessages([...messages, makeMessage(message, ADD_MESSAGE_COLOR)]);
  };

  const addRegularMessage = (...ms) => {
    setMessages([
      ...messages,
      ...ms.map((m) => makeMessage(m, REGULAR_MESSAGE_COLOR)),
    ]);
  };

  const addErrorMessage = (message) => {
    setMessages([...messages, makeMessage(message, ERROR_MESSAGE_COLOR)]);
  };

  return (
    <ScoreCardContext.Provider
      value={{
        messages,
        clearMessages,
        addCardMessage,
        addRegularMessage,
        addErrorMessage,
      }}
      {...children}
    />
  );
};

function useScoreCard() {
  return useContext(ScoreCardContext);
}

export { ScoreCardProvider, useScoreCard }; // export context provider (放在在最上層index.js裡，甚至在<App> tag之外) & consumer (所有要access ScoreCardContext.Provider 的 value 內的東西，都要呼叫 useScoreCard 建一個access橋樑)
