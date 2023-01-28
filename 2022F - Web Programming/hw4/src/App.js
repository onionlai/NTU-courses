/****************************************************************************
  FileName      [ App.js ]
  PackageName   [ src ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [  ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import React from 'react';
import './App.css';
import MineSweeper from './containers/MineSweeper';

const App = () => {
  return (
    <div className='App'>
      <MineSweeper />
    </div>
  );
}

export default App;
