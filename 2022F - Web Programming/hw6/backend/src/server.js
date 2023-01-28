import express from "express";
import cors from "cors";
import db from './db'
import routes from './routes/index';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/', routes);

const port = process.env.PORT || 4002;
app.get("/", (req, res) => {
  res.send("Hello World");
});
app.listen(port, () => console.log(`listening on port ${port}`));

db.connect();
