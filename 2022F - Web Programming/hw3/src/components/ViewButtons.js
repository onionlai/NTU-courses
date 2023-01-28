const ViewButtons = ({ showAll, showActive, showCompleted }) => {
  return (
    // [todo] change them to button
    <ul className="todo-app__view-buttons">
      <li>
        <button id="todo-all" onClick={showAll}>
          All
        </button>
      </li>
      <li>
        <button id="todo-active" onClick={showActive}>
          Active
        </button>
      </li>
      <li>
        <button id="todo-complete" onClick={showCompleted}>
          Completed
        </button>
      </li>
    </ul>
  );
};

export default ViewButtons;
