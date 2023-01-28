const Button = ({ buttonLabel, onClick, myClassName, myStyle }) => {
  return (
    <button className={myClassName} onClick={onClick} style={myStyle}>
      {buttonLabel}
    </button>
  );
};

export default Button;
