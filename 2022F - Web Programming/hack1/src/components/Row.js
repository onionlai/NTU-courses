/****************************************************************************
  FileName      [ Row.js ]
  PackageName   [ src/components ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file generates the Row. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import "./css/Row.css";
import React from 'react';


const Row = ({ guess, rowIdx }) => {
    const renderEmptyTiles = () => {
        var tiles = [];
        for (let i = 0; i < 5; i++) {
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
        <div className='Row-container'>
            {/* TODO 3: Row Implementation -- Row */}
            <div className='Row-wrapper'>
                    {/* {console.log(guess)} */}
                    {guess !== undefined ?
                        (guess.map((tile, idx)=>(
                            <div id={`${rowIdx}-${idx}`} key={`${rowIdx}-${idx}`} className={"Row-wordbox " + tile.color}>{tile.char}</div>
                        ))) :
                        renderEmptyTiles()
                    }
            </div>
        </div>
    )
}

export default Row;