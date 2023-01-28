/****************************************************************************
  FileName      [ filter.js ]
  PackageName   [ src ]
  Author        [ Chin-Yi Cheng ]
  Synopsis      [ Implement the filter ]
  Copyright     [ 2022 11 ]
****************************************************************************/

import React from "react";
import "../css/navigationBar.css";

const Filter = ({
  priceFilter,
  setPriceFilter,
  mealFilter,
  setMealFilter,
  typeFilter,
  setTypeFilter,
  setDisplay,
}) => {
  const PriceTag = ["$", "$$", "$$$"];
  const MealTag = ["Breakfast", "Lunch", "Dinner"];
  const TypeTag = [
    "Chinese",
    "American",
    "Italian",
    "Japanese",
    "Korean",
    "Thai",
  ];
  const getTagString = () => {
    const getSingleCategoryTag = (tag, filter, result) => {
      for (let i = 0; i < tag.length; i++) {
        if (filter.includes(tag[i])) {
          if (result !== "") result += ", ";
          result += tag[i];
        }
      }
      return result;
    };
    let result = "";

    result = getSingleCategoryTag(PriceTag, priceFilter, result);
    result = getSingleCategoryTag(MealTag, mealFilter, result);
    result = getSingleCategoryTag(TypeTag, typeFilter, result);

    return result;
  };

  const modifyFilter = (key, filter) => {
    if (filter.includes(key)) {
        filter = filter.filter((item) => item !== key);
    }
    else {
        filter.push(key);
    }
    console.log(filter);

    // TODO Part II-1: change filter state on clicking the pertaining checkboxes
    return filter;
    // return filter[key];
  };

  const modifyPriceFilter = (key) => {
    priceFilter = modifyFilter(key, priceFilter);
    setPriceFilter(priceFilter);
    setDisplay(getTagString());
  };

  const modifyMealFilter = (key) => {
    mealFilter = modifyFilter(key, mealFilter);
    setMealFilter(mealFilter);
    setDisplay(getTagString());
  };

  const modifyTypeFilter = (key) => {
    typeFilter = modifyFilter(key, typeFilter);
    setTypeFilter(typeFilter);
    setDisplay(getTagString());
  };

  return (
    <div className="filterDetail">
      <div className="category">
        {PriceTag.map((key) => (
          <div className="inputBlock" key={key} id={key}>
            <input
              type="checkbox"
              value={key}
              defaultChecked={priceFilter.includes(key)}
              onChange={(e) => modifyPriceFilter(e.target.value)}
            />
            <label htmlFor={key}> {key} </label>
          </div>
        ))}
      </div>
      <div className="category">
        {MealTag.map((key) => (
          <div className="inputBlock" key={key} id={key}>
            <input
              type="checkbox"
              value={key}
              defaultChecked={mealFilter.includes(key)}
              onChange={(e) => modifyMealFilter(e.target.value)}
            />
            <label htmlFor={key}> {key} </label>
          </div>
        ))}
      </div>
      <div className="category">
        {TypeTag.map((key) => (
          <div className="inputBlock" key={key} id={key}>
            <input
              type="checkbox"
              value={key}
              defaultChecked={typeFilter.includes(key)}
              onChange={(e) => modifyTypeFilter(e.target.value)}
            />
            <label htmlFor={key}> {key} </label>
          </div>
        ))}
      </div>
    </div>
  );
};
export default Filter;
