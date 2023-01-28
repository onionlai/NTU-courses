/****************************************************************************
  FileName      [ information.js ]
  PackageName   [ src ]
  Author        [ Chin-Yi Cheng ]
  Synopsis      [ display the information of restaurant ]
  Copyright     [ 2022 11 ]
****************************************************************************/

import React from "react";
import Stars from "../components/stars";
import "../css/restaurantPage.css";

const Information = ({ info, rating }) => {
  const dayKey = ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"];

  const getTag = (tags) => {
    // return <>{/* TODO Part III-2-a render tags */}</>;
    return (
      <>
        {tags.map((tag) => (
          <div className="tag" key={tag}>
            {tag}
          </div>
        ))}
      </>
    );
  };
  const getPriceTag = (price) => {
    let priceText = "";
    for (let i = 0; i < price; i++) priceText += "$";
    return (
      // TODO Part III-2-a render price tags; hint: convert price number to dollar signs first
      <div className="tag" key={priceText}> {priceText} </div>
    );
  };

  const getBusiness = (time) => {
    // console.log(time);

    return (
      <div className="businessTime">
        {/* TODO Part III-2-c: render business time for each day*/}

        {time["All"]
          ? dayKey.map((day, i) => (
              <div className="singleDay" key={i}>
                <div className="day">{day}</div>
                <div className="time">{time["All"]}</div>
              </div>
            ))
          : dayKey.map((day, i) =>
              time[day] ? (
                <div className="singleDay" key={i}>
                  <div className="day">{day}</div>
                  <div className="time">{time[day]}</div>
                </div>
              ) : (
                <div className="singleDay" key={i}>
                  <div className="day">{day}</div>
                  <div className="time">Closed</div>
                </div>
              )
            )}
      </div>
    );
  };

  return (
    <div className="infoContainer">
      <h2>{info.name}</h2>
      <div className="infoRow">
        <div className="rate">
          {rating === 0 ? (
            <p>No Rating</p>
          ) : (
            <Stars rating={rating} displayScore={true} />
          )}
        </div>
        <div className="distance">{info.distance / 1000} km</div>
      </div>
      <div className="infoRow">
        {getPriceTag(info.price)}
        {getTag(info.tag)}
      </div>
      <h5>Business hours:</h5>
      {getBusiness(info.time)}
    </div>
  );
};
export default Information;
