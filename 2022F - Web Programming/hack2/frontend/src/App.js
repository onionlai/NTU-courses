/****************************************************************************
  FileName      [ App.js ]
  PackageName   [ src ]
  Author        [ Chin-Yi Cheng ]
  Synopsis      [ Implement the router ]
  Copyright     [ 2022 11 ]
****************************************************************************/

import './css/App.css';

import { React, useState, useEffect } from 'react'
import NavBar from './components/navigationBar';
import MainPage from './container/mainPage';
import SearchPage from './container/searchPage';
import RestaurantPage from './container/restaurantPage';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

function App() {
    return (
        <Router>
            <NavBar />
            <Routes>
                <Route path="/" element={<MainPage />} />
                <Route path="/search" element={<SearchPage />} />
                <Route path="/restaurant/:id" element={<RestaurantPage />} />
            </Routes>

        </Router>
    );
}

export default App;
