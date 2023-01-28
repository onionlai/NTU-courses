import Todo from "./Todo";

const TodoList = ({ todos, toggleComplete, onDelete }) => {
  return (
    <ul className="todo-app__list" id="todo-list">
      {todos.map(
        (todo) =>
          todo.show && (
            <Todo
              key={todo.id}
              todo={todo}
              toggleComplete={toggleComplete}
              onDelete={onDelete}
            />
          )
      )}
    </ul>
  );
};

export default TodoList;
