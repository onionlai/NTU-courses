import { React, useState, useEffect } from "react";
import "./style.css";
import { startGame, guess, ox } from "./axios";

function App() {
  const [hasEnterGame, setHasEnterGame] = useState(false);
  const [hasEnd, setHasEnd] = useState(false);
  const [gameMode, setGameMode] = useState(""); // guess / ox
  const [gameMsg, setGameMsg] = useState("");
  const [offline, setOffline] = useState(false);

  useEffect( () => {
    if (offline === true) {
      setTimeout(() => {
        setOffline(false);
      }, 4000);
    }
  }, [offline])

  // --- game1: guess --- //
  const [number, setNumber] = useState("");
  // --- game2: ox --- //
  const [board, setBoard] = useState([
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ]);

  const handleGameStart = async (mode) => {
    try {
      const response = await startGame(mode);
      console.log(response);
      setHasEnterGame(true);
      setGameMode(mode);
      setHasEnd(false);
      setGameMsg("");
      setBoard([
        ["", "", ""],
        ["", "", ""],
        ["", "", ""],
      ]);
      setNumber("");

    } catch (error) {
      if (error.code === "ERR_NETWORK") {
        setOffline(true);
      }
    }
  };

  const handleMenuButton = () => {
    setHasEnterGame(false);
    setHasEnd(false);
  };

  const handleOXInput = async (i, j) => {
    try {
      // console.log("input: " + i + " " + j);
      const [newBoard, msg] = await ox(i, j);
      setBoard(newBoard);
      if (msg !== "") {
        setGameMsg(msg);
        setHasEnd(true);
      }

    } catch (error) {
      if (error.code === "ERR_NETWORK") {
        setHasEnd(true);
        setOffline(true);
      }
    }
  };

  const handleGuessInput = async () => {
    try {
      const response = await guess(number);

      if (response === "Equal") {
        setGameMsg("You won! the number was " + number);
        setHasEnd(true);
      } else {
        setGameMsg(response);
        setNumber("");
      }
    } catch (error) {
      setNumber("");
      if (error.code === "ERR_NETWORK") {
        setHasEnd(true);
        setGameMsg("");
        setOffline(true);
      }
    }
  };

  const menu = (
    <>
      <button className="startButton" onClick={() => handleGameStart("ox")}>
        start OX game
      </button>
      <button className="startButton" onClick={() => handleGameStart("guess")}>
        start Guess game
      </button>
    </>
  );

  const guessGame = hasEnd ? (
    <>
      <p> {gameMsg} </p>
      <button className="menuButton" onClick={handleMenuButton}>menu</button>
    </>
  ) : (
    <div className="gameBoard">
      <p> Guess a number between 1 to 100 </p>
      <div className="guessInputBox">
        <input
          type="textbox"
          value={number}
          onChange={(e) => setNumber(e.target.value)}
        ></input>
        <button onClick={handleGuessInput} disabled={!number}>
          guess!
        </button>
      </div>
      <p> {gameMsg} </p>
    </div>
  );

  const oxGame = (
    <div className='gameBoard'>
      {board.map((row, i) => (
        <div className="tileRow" key={i}>
          {row.map((tile, j) => (
            <button
              className="tile"
              key={i + j}
              onClick={() => handleOXInput(i, j)}
              disabled={tile !== "" || hasEnd}
            >
              {tile}
            </button>
          ))}
        </div>
      ))}
      {hasEnd && (
        <>
          <p className="gameMessage"> {gameMsg} </p>
          <button className="menuButton" onClick={handleMenuButton}>menu</button>
        </>
      )}
    </div>
  );

  const offlineMessage = (<p className="offlineMsg" style={{'opacity':offline?'1':'0'}}> Server not responding. Try again later... </p>);

  return (
    <div className="root">
      {offlineMessage}
      {!hasEnterGame ? menu : gameMode === "guess" ? guessGame : oxGame}
    </div>
  );
}

export default App;
