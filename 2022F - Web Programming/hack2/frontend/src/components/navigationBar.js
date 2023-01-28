/****************************************************************************
  FileName      [ navigationBar.js ]
  PackageName   [ src ]
  Author        [ Chin-Yi Cheng ]
  Synopsis      [ Implement the navigation bar ]
  Copyright     [ 2022 11 ]
****************************************************************************/

import React from 'react'
import { useState } from "react";
import '../css/navigationBar.css'
import Filter from './filter';
import { MdTune, MdOutlineKeyboardArrowDown, MdOutlineKeyboardArrowUp } from "react-icons/md";
import { useNavigate } from 'react-router-dom';

const NavBar = () => {

    const [priceFilter, setPriceFilter] = useState([])
    const [mealFilter, setMealFilter] = useState([])
    const [typeFilter, setTypeFilter] = useState([])

    const [display, setDisplay] = useState("")
    const options = ["price", "distance"];
    const [sortMethod, setSortMethod] = useState(options[0]);
    // Blank all
    const [filterExpanded, setFilterExpanded] = useState(false);

    const navigate = useNavigate();

    const changeDollarSignToInt = () => {
        var clone = JSON.parse(JSON.stringify(priceFilter))
        clone = clone.map((ele)=>{
            return ele.length
        })
        return clone;
    }
    const navigateToSearch = () => {
        setFilterExpanded(false)
        // TODO Part I-1: navigation to search page
        // See README for hint
        // FIXME - Modify below
        navigate('/search', {
            state: {
                priceFilter,
                mealFilter,
                typeFilter,
                sortBy: sortMethod
            }
        });

    };
    return (
        <div className='navBarContainer'>
            <a href="/">
                <div className='titleContainer'>
                    <h1>Hugo Eat</h1>
                </div>
            </a>
            <div className='functionRow'>
                <div className='filterContainer' onClick={e => setFilterExpanded(!filterExpanded)}>
                    <MdTune size={28} />
                    <div className='filter'>{display}</div>
                    {filterExpanded ? <MdOutlineKeyboardArrowUp size={28} /> :
                        <MdOutlineKeyboardArrowDown size={28} />}
                </div>
                <div className='sortContainer'>
                    <select value={sortMethod} onChange={e => setSortMethod(e.target.value)}>
                        {options.map((value) => (
                            <option value={value} key={value}>
                                {value}
                            </option>
                        ))}
                    </select>
                </div>
                <div className='searchContainer'>
                    <button onClick={navigateToSearch}>Search</button>
                </div>
            </div>
            {filterExpanded ?
                <Filter priceFilter={priceFilter} setPriceFilter={setPriceFilter}
                    mealFilter={mealFilter} setMealFilter={setMealFilter}
                    typeFilter={typeFilter} setTypeFilter={setTypeFilter}
                    setDisplay={setDisplay} />
                : <></>
            }
        </div>
    )
}
export default NavBar