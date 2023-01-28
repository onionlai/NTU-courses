var board = [
  ["", "", ""],
  ["", "", ""],
  ["", "", ""],
];

const generateBoard = () => {
  board = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ];
};

const checkWin = () => {
  if (board[0][0] != '') {
    if (board[0][0] === board[0][1] && board[0][1] === board[0][2]) return true;
    if (board[0][0] === board[1][0] && board[1][0] === board[2][0]) return true;
    if (board[0][0] === board[1][1] && board[1][1] === board[2][2]) return true;
  }
  if (board[1][1] != '') {
    if (board[1][0] === board[1][1] && board[1][1] === board[1][2]) return true;
    if (board[0][1] === board[1][1] && board[1][1] === board[2][1]) return true;
    if (board[2][0] === board[1][1] && board[1][1] === board[0][2]) return true;

  }
  if (board[2][2] != '') {
    if (board[2][0] === board[2][1] && board[2][1] === board[2][2]) return true;
    if (board[0][2] === board[1][2] && board[1][2] === board[2][2]) return true;
  }
  return false;
};

const playerMove = (i, j) => {
  board[i][j] = "o";
  if (checkWin()) { return [board, "Win"]; }
  // next move by computer
  var available = [];
  board.forEach((row, i) => {
    row.forEach((ele, j) => {
      ele === "" && available.push({ i, j });
    });
  });

  if (available.length == 0) return [board, "Tie"];
  const next = available[Math.floor(Math.random() * available.length)];
  board[next.i][next.j] = "x";
  if (checkWin()) return [board, "Lose"];
  return [board, ""];
};

export {generateBoard, playerMove}
