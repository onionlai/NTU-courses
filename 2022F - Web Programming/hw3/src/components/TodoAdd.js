import { useState } from "react";
const TodoAdd = ({ todos, onAdd }) => {
  const [inputText, setInput] = useState("");

  const onSubmit = (e) => {
    console.log("key press");
    if (e.key === "Enter") {
      inputText !== "" ? onAdd(inputText) : alert("enter your task");
      setInput("");
    }
  };
  return (
    <input
      className="todo-app__input"
      value={inputText}
      placeholder="What needs to be done?"
      onChange={(e) => setInput(e.target.value)}
      onKeyDown={(e) => onSubmit(e)}
    ></input>
  );
};

export default TodoAdd;
