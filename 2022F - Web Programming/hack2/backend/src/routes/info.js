// * ////////////////////////////////////////////////////////////////////////
// *
// * FileName     [ info.js ]
// * PackageName  [ server ]
// * Synopsis     [ Get restaurant info from database ]
// * Author       [ Chin-Yi Cheng ]
// * Copyright    [ 2022 11 ]
// *
// * ////////////////////////////////////////////////////////////////////////

import Info from "../models/info";

exports.GetSearch = async (req, res) => {
  /*******    NOTE: DO NOT MODIFY   *******/
  const priceFilter = req.query.priceFilter; // price
  const mealFilter = req.query.mealFilter; // tag
  const typeFilter = req.query.typeFilter; // tag
  const sortBy = req.query.sortBy;
  /****************************************/

  // NOTE Hint:
  // use `db.collection.find({condition}).exec(err, data) {...}`
  // When success,
  //   do `res.status(200).send({ message: 'success', contents: ... })`
  // When fail,
  //   do `res.status(403).send({ message: 'error', contents: ... })`

  console.log(priceFilter);
  //   console.log(mealFilter);
  //   console.log(typeFilter);

  try {
    // TODO Part I-3-a: find the information to all restaurants
    var restaurants = await Info.find();
    // console.log(restaurants);
    if (priceFilter) {
      const filter = priceFilter.map((p) => {
        if (p === "$") return 1;
        if (p === "$$") return 2;
        if (p === "$$$") return 3;
      });

      restaurants = restaurants.filter((r) => {
        return filter.includes(r.price);
      });
      //   console.log("after price filter: ", restaurants);
    }
    if (mealFilter) {
      //   console.log(mealFilter);
      restaurants = restaurants.filter((r) => {
        var find = false;
        r.tag.forEach((t) => {
          if (mealFilter.includes(t)) find = true;
        });
        if (find) return true;
        return false;
      });
      //   console.log("after meal filter", restaurants);
    }
    console.log(typeFilter);
    if (typeFilter) {
      restaurants = restaurants.filter((r) => {
        var find = false;
        r.tag.forEach((t) => {
          if (typeFilter.includes(t)) find = true;
        });
        if (find) return true;
        return false;
      });
      console.log("after type filter", restaurants);
    }
    // console.log(restaurants);
    // TODO Part II-2-b: revise the route so that the result is sorted by sortBy
    console.log(sortBy);
    if (sortBy === "price") {
      restaurants.sort((a, b) => (a.price > b.price ? 1 : -1));
    } else {
      restaurants.sort((a, b) => (a.distance > b.distance ? 1 : -1));
    }
    console.log("after sort", restaurants);

    res.status(200).send({
      message: "success",
      contents: restaurants,
    });
  } catch (e) {
    res.status(403).send({
      message: "error",
      contents: [],
    });
  }
};

exports.GetInfo = async (req, res) => {
  /*******    NOTE: DO NOT MODIFY   *******/
  const id = req.query.id;
  /****************************************/

  // NOTE USE THE FOLLOWING FORMAT. Send type should be
  // if success:
  // {
  //    message: 'success'
  //    contents: the data to be sent. Hint: A dictionary of the restaruant's information.
  // }
  // else:
  // {
  //    message: 'error'
  //    contents: []
  // }

  // TODO Part III-2: find the information to the restaurant with the id that the user requests
  try {
    console.log(id);
    const restaurant = await Info.findOne({ id: id });
    console.log(restaurant);
    res.status(200).send({
      message: "success",
      contents: restaurant,
    });
  } catch (e) {
    res.status(403).send({
      message: "error",
      contents: [],
    });
  }
};
