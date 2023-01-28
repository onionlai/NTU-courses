// import xIcon from "../../public/images/x.png";
const Todo = ({ todo, toggleComplete, onDelete }) => {
  const completeStyle = {
    textDecoration: "line-through",
    opacity: "0.5",
  };
  const uncompleteStyle = {
    textDecoration: "auto",
    opacity: "1",
  };
  const onToggleComplete = () => {
    toggleComplete(todo.id);
  };
  return (
    <li className="todo-app__item">
      <div className="todo-app__checkbox">
        <input
          type="checkbox"
          defaultChecked={todo.checked}
          id={todo.id}
          onChange={() => toggleComplete(todo.id)} // 要寫這樣才可以傳參歐（他才會是一個function而非return值）
        ></input>
        <label htmlFor={todo.id}></label>
      </div>
      <h1
        className="todo-app__item-detail"
        style={todo.checked ? completeStyle : uncompleteStyle}
      >
        {todo.text}{" "}
      </h1>
      <img
        src="/images/x.png"
        className="todo-app__item-x"
        alt="x"
        onClick={() => onDelete(todo.id)}
      />
    </li>
  ); // img src="Path", Path is at /public
};

export default Todo;
