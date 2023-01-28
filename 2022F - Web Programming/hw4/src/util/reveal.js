/****************************************************************************
  FileName      [ reveal.js ]
  PackageName   [ src/util ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file states the reaction when left clicking a cell. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

export const revealed = (board, x, y, newNonMinesCount) => {
  board[x][y].revealed = true;
  newNonMinesCount -= 1;
  // Advanced TODO: reveal cells in a more intellectual way.
  // Useful Hint: If the cell is already revealed, do nothing.
  //              If the value of the cell is not 0, only show the cell value.
  //              If the value of the cell is 0, we should try to find the value of adjacent cells until the value we found is not 0.
  //              The input variables 'newNonMinesCount' and 'board' may be changed in this function.
  const boardSize = board.length;
  // console.log(boardSize);
  let visited = [];
  for (let x = 0; x < boardSize; x++) {
    let subCol = [];
    for (let y = 0; y < boardSize; y++) {
      subCol.push(false);
    }
    visited.push(subCol);
  }

  const dfs = (_x, _y) => {
    if (
      _x < 0 ||
      _x >= boardSize ||
      _y < 0 ||
      _y >= boardSize ||
      visited[_x][_y]
    )
      return;

    visited[_x][_y] = true;

    if (!board[_x][_y].revealed && !board[_x][_y].flagged) {
      board[_x][_y].revealed = true;
      newNonMinesCount -= 1;
    } // is impossible to meet "💣"

    if (board[_x][_y].value === 0) {
      dfs(_x - 1, _y);
      dfs(_x + 1, _y);
      dfs(_x, _y - 1);
      dfs(_x, _y + 1);
    }
  };
  dfs(x, y);

  // console.log(newNonMinesCount);

  return { board, newNonMinesCount };
};
