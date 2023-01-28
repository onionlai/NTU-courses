/****************************************************************************
  FileName      [ Dashnoard.js ]
  PackageName   [ src/components ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file generates the Dashboard. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import React, { useEffect, useState } from "react";
import "./css/Dashboard.css";
let timeIntervalId;

export default function Dashboard({ remainFlagNum, gameOver }) {
  let [time, setTime] = useState(0);
  let [sTime, setSTime] = useState(0);

  // Advanced TODO: Implement the timer on the Dashboard
  useEffect(() => {
    const intervalId = setInterval(() => { // setInterval裡如果有用到variable, 會被設定為當初呼叫的值，所以如果是要監測變動的variable，要記得寫成arrow function。 https://sebhastian.com/setinterval-react/
      setTime(t => t + 1); // 超級重要：setTime裡面要寫成arrow function，寫time+1會更新不到，time永遠=0+1
      // console.log(gameOver);
      // if (!gameOver) setSTime(t => t + 1); 這行不work。不會更新到gameOver的更新
    }, 1000);
    return () => {
      clearInterval(intervalId);
    }
  }, []);

  useEffect (() => {
    if (gameOver) {setSTime(time)}
    else {setTime(0)}
  }, [gameOver])

  return (
    <div className="dashBoard">
      <div id="dashBoard_col1">
        <div className="dashBoard_col">
          <p className="icon">🚩</p>
          {remainFlagNum}
        </div>
      </div>
      <div id="dashBoard_col2">
        <div className="dashBoard_col">
          <p className="icon">⏰</p>
          {gameOver ? sTime : time}
        </div>
      </div>
    </div>
  );
}
