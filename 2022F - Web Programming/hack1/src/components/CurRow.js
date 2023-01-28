/****************************************************************************
  FileName      [ CurRow.js ]
  PackageName   [ src/components ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file generates the CurRow. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import "./css/Row.css";
import React from "react";

const CurRow = ({ curGuess, rowIdx }) => {

  const renderEmptyTiles = (init, last) => {
    var tiles = [];
    for (let i = init; i < last; i++) {
      tiles.push(i);
    }
    return tiles.map((tile_id) => (
      <div
        id={`${rowIdx}-${tile_id}`}
        key={`${rowIdx}-${tile_id}`}
        className="Row-wordbox"
      ></div>
    ));
  };

  return (
    <div className="Row-container">
      {/* TODO 3: Row Implementation -- CurRow */}
      <div className={"Row-wrapper current"}>
        {curGuess.substring(0,5).split("").map((tile, idx) => (
            <div
              id={`${rowIdx}-${idx}`}
              key={`${rowIdx}-${idx}`}
              className={"Row-wordbox filled"}
            >{tile}</div>
          ))}
        {renderEmptyTiles(
          curGuess.length,
          5
        )}
      </div>
    </div>
  );
};

export default CurRow;
