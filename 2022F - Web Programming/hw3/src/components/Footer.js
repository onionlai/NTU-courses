import Button from "./Button";
import ViewButtons from "./ViewButtons";
const Footer = ({
  uncompletedTodoCount,
  completedTodoCount,
  showAll,
  showActive,
  showCompleted,
  deleteAllCompleted,
}) => {
  return (
    <footer className="todo-app__footer" id="todo-footer">
      <div className="todo-app__total">
        <span id="todo-count"> {uncompletedTodoCount} </span> left
      </div>
      <ViewButtons
        showAll={showAll}
        showActive={showActive}
        showCompleted={showCompleted}
      />
      <Button
        buttonLabel="Clear completed"
        myClassName="todo-app__clean"
        onClick={deleteAllCompleted}
        // myStyle={
        //   completedTodoCount > 0
        //     ? { visibility: "visible" }
        //     : { visibility: "hidden" }
        // } // <- both work!
        myStyle={{ visibility: completedTodoCount > 0 ? "visible" : "hidden" }}
      />
    </footer>
  );
};

export default Footer;
