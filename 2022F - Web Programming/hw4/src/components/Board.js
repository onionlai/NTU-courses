/****************************************************************************
  FileName      [ Board.js ]
  PackageName   [ src/components ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file generates the Board. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import "./css/Board.css";
import Cell from "./Cell";
import Modal from "./Modal";
import Dashboard from "./Dashboard";
import { revealed } from "../util/reveal";
import createBoard from "../util/createBoard";
import React, { useEffect, useState } from "react";

const Board = ({ boardSize, mineNum, backToHome }) => {
  const [board, setBoard] = useState([]); // An 2-dimentional array. It is used to store the board.
  const [nonMineCount, setNonMineCount] = useState(0); // An integer variable to store the number of cells whose value are not '💣'.
  const [mineLocations, setMineLocations] = useState([]); // An array to store all the coordinate of '💣'.

  const [gameOver, setGameOver] = useState(false); // A boolean variable. If true, means you lose the game (Game over).
  const [remainFlagNum, setRemainFlagNum] = useState(0); // An integer variable to store the number of remain flags.
  const [win, setWin] = useState(false); // A boolean variable. If true, means that you win the game.

  useEffect(() => {
    // Calling the function
    freshBoard();
  }, []); // (ps) 他會被called twice，是因為<React.StrictMode>
  // (ps) useEffect() with empty dependency的效果跟componentDidMount一樣，只會一開始呼叫一次，可以用來當初使化function

  // Creating a board
  const freshBoard = () => {
    const newBoard = createBoard(boardSize, mineNum);
    // Basic TODO: Use `newBoard` created above to set the `Board`.
    // Hint: Read the definition of those Hook useState functions and make good use of them.
    setBoard(newBoard.board);
    setMineLocations(newBoard.mineLocations);
    setRemainFlagNum(mineNum);
    setNonMineCount(boardSize * boardSize - mineNum);
  };

  const restartGame = () => {
    freshBoard();
    setGameOver(false);
    setWin(false);
  };

  // On Right Click / Flag Cell
  const updateFlag = (e, x, y) => {
    // To not have a dropdown on right click
    e.preventDefault();
    if (board[x][y].revealed || gameOver) return;
    // Deep copy of a state
    let newBoard = JSON.parse(JSON.stringify(board));
    let newFlagNum = remainFlagNum;

    // Basic TODO: Right Click to add a flag on board[x][y]
    // Remember to check if board[x][y] is able to add a flag (remainFlagNum, board[x][y].revealed)
    // Update board and remainFlagNum in the end

    setBoard(
      board.map((row) =>
        row.map((cell) => {
          if (cell.x === x && cell.y === y) {
            if (cell.flagged) {
              setRemainFlagNum(remainFlagNum + 1);
            } else {
              if (remainFlagNum === 0) return cell;
              setRemainFlagNum(remainFlagNum - 1);
            }
            return { ...cell, flagged: !cell.flagged };
          }
          return cell;
        })
      )
    );
  };

  const revealCell = (x, y) => {
    if (board[x][y].revealed || gameOver || board[x][y].flagged) return;
    let newBoard = JSON.parse(JSON.stringify(board));

    // Basic TODO: Complete the conditions of revealCell (Refer to reveal.js)
    // Hint: If `Hit the mine`, check ...?
    //       Else if `Reveal the number cell`, check ...?
    // Reminder: Also remember to handle the condition that after you reveal this cell then you win the game.

    const revealRst = revealed(board, x, y, nonMineCount);
    setBoard(revealRst.board);
    setNonMineCount(revealRst.newNonMinesCount);
    // console.log(nonMineCount);

    if (board[x][y].value === "💣") {
      setGameOver(true);
    } else {
      // [todo] check win game
      if (revealRst.newNonMinesCount === 0) {
        console.log("win!");
        setWin(true);
        setGameOver(true);
      }
    }
  };

  return (
    <div className="boardPage">
      <div className="boardWrapper">
        <div className="boardContainer">
          <Dashboard remainFlagNum={remainFlagNum} gameOver={gameOver} />
          {board.map((row, index) => {
            return (
              <div
                id={`row${index}`}
                key={row[0].x}
                style={{ display: "flex" }}
              >
                {row.map((cell, index) => {
                  return (
                    <Cell
                      key={`${cell.x}-${cell.y}`}
                      rowIdx={cell.x}
                      colIdx={cell.y}
                      detail={cell}
                      updateFlag={updateFlag}
                      revealCell={revealCell}
                    />
                  );
                })}
              </div>
            );
          })}
        </div>
        {(gameOver) && (
          <Modal restartGame={restartGame} backToHome={backToHome} win={win} />
        )}
        {/* Advanced TODO: Implement Modal based on the state of `gameOver` */}

        {/* Basic TODO: Implement Board
                Useful Hint: The board is composed of BOARDSIZE*BOARDSIZE of Cell (2-dimention). So, nested 'map' is needed to implement the board.
                Reminder: Remember to use the component <Cell> and <Dashboard>. See Cell.js and Dashboard.js for detailed information. */}
      </div>
    </div>
  );
};

export default Board;
