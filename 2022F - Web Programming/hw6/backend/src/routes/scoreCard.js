import express from "express";
import ScoreCard from "../models/ScoreCard";

const router = express.Router();

const saveScoreCard = async (name, subject, score) => {
  const existedCard = await ScoreCard.findOne({ name, subject });
  try {
    if (existedCard) {
      await existedCard.updateOne({ score });
      console.log("update ScoreCard");
      return true;
    } else {
      const newScoreCard = new ScoreCard({ name, subject, score });
      console.log("create ScoreCard", newScoreCard);
      await newScoreCard.save();
      return false;
    }
  } catch (e) {
    throw e;
  }
};

const queryScoreCardByType = async (type, queryString) => {
  try {
    const queryCards =
      type === "name"
        ? await ScoreCard.find({ name: queryString })
        : await ScoreCard.find({ subject: queryString });

    return queryCards;
  } catch (e) {
    throw e;
  }
};

const queryAllData = async () => {
	try {
    var data = await ScoreCard.find(); // get all
    data = data.map((d) => {
      return {
        name: d.name,
        subject: d.subject,
        score: d.score,
      };
    });
		return data;
  } catch (e) {
    throw (e);
  }
}

router.get("/data", async (req, res) => {
  console.log("connection init request");
  try {
    const data = await queryAllData();
    res.status(200).json({ data });
  } catch (e) {
    console.log("init failed", e);
    res.status(500).json({ message: "Database error" });
  }
});

router.delete("/cards", async (req, res) => {
  console.log("delete request");
  try {
    await ScoreCard.deleteMany({});
    console.log("delete success");
    res.status(200).json({ message: "Database cleared" });
  } catch (e) {
    console.log("delete failed", e);
    res.status(500).json({ message: "Database error" });
  }
});
router.post("/card", async (req, res) => {
  console.log("post request");
  try {
    const existed = await saveScoreCard(
      req.body.name,
      req.body.subject,
      req.body.score
    );
    const card = {
      name: req.body.name,
      subject: req.body.subject,
      score: req.body.score,
    };
    if (existed) {
      res
        .status(200)
        .json({
          message: `Updating (${req.body.name}, ${req.body.subject}, ${req.body.score})`,
          card,
          update: true,
        });
    } else {
      res
        .status(200)
        .json({
          message: `Adding (${req.body.name}, ${req.body.subject}, ${req.body.score})`,
          card,
          update: false,
        });
    }
  } catch (e) {
    console.log("save failed", e);
    res.status(500).json({ message: `Database error.` });
  }
});
router.get("/cards", async (req, res) => {
  console.log("get request");
  try {
    const queryCards = await queryScoreCardByType(
      req.query.type,
      req.query.queryString
    );
    // console.log(queryCards);
    if (queryCards.length === 0) {
      res.json({
        message: `${req.query.type} (${req.query.queryString}) not found!`,
      });
      return;
    }
    let messages = [];
    queryCards.forEach((card) => {
      messages.push(
        `Found card with ${req.query.type}: (${card.name}, ${card.subject}, ${card.score})`
      );
    });
    res.json({ messages, queryCards });
  } catch (e) {
    console.log("get failed", e);
    res.status(500).json({ message: "Database error." });
  }
});

export default router;
