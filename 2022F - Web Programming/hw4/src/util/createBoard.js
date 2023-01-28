/****************************************************************************
  FileName      [ createBoard.js ]
  PackageName   [ src/util ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file generates the pattern of mines and the board. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import randomNum from "./randomFixSeed";

export default (boardSize, mineNum) => {
  let board = [];
  let mineLocations = [];

  // Print Board function (For testing)
  const printBoard = () => {
    console.log("Current Board");
    for (let x = 0; x < boardSize; x++) {
      console.log(
        board[x].map((x) => {
          return x.value !== "💣" ? x.value.toString() + " " : x.value;
        })
      );
    }
  };

  // Create a blank board
  for (let x = 0; x < boardSize; x++) {
    let subCol = [];
    for (let y = 0; y < boardSize; y++) {
      subCol.push({
        value: 0, // To store the number of mines around the cell.
        revealed: false, // To store if the cell is revealed.
        x: x, // To store the x coordinate (the column index) of the cell.
        y: y, // To store the y coordinate (the row index) of the cell.
        flagged: false, // To store if the cell is flagged.
      });
    }
    board.push(subCol);
  }

  // Random bombs locations
  let mineCount = 0;
  while (mineCount < mineNum) {
    let x = randomNum(0, boardSize - 1);
    let y = randomNum(0, boardSize - 1);

    if (board[x][y].value === 0) {
      // Check this location has not been located a mine.
      board[x][y].value = "💣"; // Change the value of the cell to '💣'
      mineLocations.push([x, y]);
      mineCount++;
    }
  }

  for (let r = 0; r < boardSize; r++) {
    for (let c = 0; c < boardSize; c++) {
      if (board[r][c].value === "💣") continue;
      // Top
      if (r > 0 && board[r - 1][c].value === "💣") board[r][c].value++;
      // Top Right
      if (r > 0 && c < boardSize - 1 && board[r - 1][c + 1].value === "💣")
        board[r][c].value++;
      // Right
      if (c < boardSize - 1 && board[r][c + 1].value === "💣")
        board[r][c].value++;
      // Bottom Right
      if (
        r < boardSize - 1 &&
        c < boardSize - 1 &&
        board[r + 1][c + 1].value === "💣"
      )
        board[r][c].value++;
      // Bottom
      if (r < boardSize - 1 && board[r + 1][c].value === "💣")
        board[r][c].value++;
      // Bottom Left
      if (r < boardSize - 1 && c > 0 && board[r + 1][c - 1].value === "💣")
        board[r][c].value++;
      // Left
      if (c > 0 && board[r][c - 1].value === "💣") board[r][c].value++;
      // Top Left
      if (r > 0 && c > 0 && board[r - 1][c - 1].value === "💣")
        board[r][c].value++;
    }
  }

  // printBoard(); // Testing

  return { board, mineLocations };
};
