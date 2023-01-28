/****************************************************************************
  FileName      [ restaurantPage.js ]
  PackageName   [ src ]
  Author        [ Chin-Yi Cheng ]
  Synopsis      [ Implement the restaurant page ]
  Copyright     [ 2022 11 ]
****************************************************************************/

import React, { useState, useEffect } from "react";
import "../css/restaurantPage.css";
import Information from "./information";
import Comment from "./comment";
import { useParams } from "react-router-dom";

import axios from "axios";
const instance = axios.create({
  baseURL: "http://localhost:4000/api",
});

const RestaurantPage = () => {
  const { id } = useParams();
  const [info, setInfo] = useState({});
  const [comments, setComments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [rating, setRating] = useState(0);
  const getInfo = async () => {
    // TODO Part III-2: get a restaurant's info
    const {
      data: { contents },
    } = await instance.get("/getInfo", { params: { id: id } });
    console.log(contents);
    setInfo(contents);
  };
  const getComments = async () => {
    // TODO Part III-3: get a restaurant's comments
    const {
      data: { contents },
    } = await instance.get("/getCommentsByRestaurantId", { params: { restaurantId: id } });
    // console.log("comments:", contents);
    ratingCalculate(contents.map(c => c.rating))
    setComments(contents);
    setLoading(false);
  };
  useEffect(() => {
    if (Object.keys(info).length === 0) {
      getInfo();
    }
    if (loading) getComments();
  }, []);

  useEffect(() => {
    // TODO Part III-3-c: update the comment display immediately after submission
    if (loading) getComments();
  }, [comments, loading]);

  /* TODO Part III-2-b: calculate the average rating of the restaurant */
  const ratingCalculate = (ratings) => {
    setRating(ratings.reduce((a, b) => a + b, 0) / ratings.length);
  }

  return (
    <div className="restaurantPageContainer">
      {Object.keys(info).length === 0 ? (
        <></>
      ) : (
        <Information info={info} rating={rating} />
      )}
      <Comment
        restaurantId={id}
        comments={comments}
        setComments={setComments}
        setLoad={setLoading}
      />
    </div>
  );
};
export default RestaurantPage;
