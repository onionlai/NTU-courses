import express from "express";
import cors from "cors";
import guessRoute from "./routes/guess";
import oxRoute from "./routes/ox";

const app = express();

app.use(cors());

app.use("/api/ox", oxRoute);
app.use("/api/guess", guessRoute);

const port = process.env.PORT || 4000;
app.listen(port, () => {
	console.log(`server is up on port ${port}`)
})
