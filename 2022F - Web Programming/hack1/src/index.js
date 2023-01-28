/****************************************************************************
  FileName      [ index.js ]
  PackageName   [ src ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [  ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import './index.css';
import App from './App';
import React from 'react';
import ReactDOM from 'react-dom/client';


const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

