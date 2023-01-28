import React from "react";
import Header from "./components/Header";
import Footer from "./components/Footer";
import Main from "./components/Main";
import { useState } from "react";

const App = () => {
  const [id_num, setId] = useState(2);
  const [todos, setTodos] = useState([
    {
      text: "hi",
      id: 1,
      checked: false,
      show: true,
    },
  ]);
  const deleteTodo = (_id) => {
    setTodos(todos.filter((todo) => todo.id !== _id));
  };
  const completeTodo = (_id) => {
    setTodos(
      todos.map((todo) =>
        todo.id === _id ? { ...todo, checked: !todo.checked } : todo
      )
    );
  };
  const deleteAllCompleted = () => {
    setTodos(todos.filter((todo) => !todo.checked));
  };
  const addTodo = (_text) => {
    setId(id_num + 1);
    const newTodo = {
      text: _text,
      id: id_num,
      checked: false,
      show: true,
    };
    setTodos([...todos, newTodo]);
  };
  const countUncompleteTodo = () => {
    return todos.reduce((a, todo) => (todo.checked ? a : a + 1), 0);
  };
  const countCompleteTodo = () => {
    return todos.reduce((a, todo) => (todo.checked ? a + 1 : a), 0);
  };
  const showAll = () => {
    setTodos(todos.map((todo) => ({ ...todo, show: true })));
  };
  const showActive = () => {
    setTodos(
      todos.map((todo) =>
        !todo.checked ? { ...todo, show: true } : { ...todo, show: false }
      )
    );
  };
  const showCompleted = () => {
    setTodos(
      todos.map((todo) =>
        todo.checked ? { ...todo, show: true } : { ...todo, show: false }
      )
    );
  };

  return (
    <div className="todo-app__root">
      <Header />
      <Main
        todos={todos}
        onAdd={addTodo}
        onDelete={deleteTodo}
        toggleComplete={completeTodo}
      />
      {todos.length > 0 && (
        <Footer
          uncompletedTodoCount={countUncompleteTodo()}
          completedTodoCount={countCompleteTodo()}
          showAll={showAll}
          showActive={showActive}
          showCompleted={showCompleted}
          deleteAllCompleted={deleteAllCompleted}
        />
      )}
    </div>
  );
};

export default App;
