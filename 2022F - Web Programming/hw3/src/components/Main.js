import TodoAdd from "./TodoAdd";
import TodoList from "./TodoList";
const Main = ({ todos, onAdd, toggleComplete, onDelete }) => {
  return (
    <section className="todo-app__main">
      <TodoAdd todos={todos} onAdd={onAdd} />

      {todos.length > 0 && (
        <TodoList
          todos={todos}
          toggleComplete={toggleComplete}
          onDelete={onDelete}
        />
      )}
    </section>
  );
};

export default Main;
