/****************************************************************************
  FileName      [ index.js ]
  PackageName   [ src ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [  ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import React from "react";
import ReactDOM from "react-dom/client";

import App from "./App";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
