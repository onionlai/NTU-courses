const mongoose = require("mongoose");
require("dotenv-defaults").config({ path: "backend/.env" });

const itemSchema = new mongoose.Schema(
  {
    id: { type: String, unique: true },
  },
  {
    collection: "item",
    strict: false,
  }
);
  
const model = mongoose.model("item", itemSchema);

const initDB = async (examples) => {
  // connect to MongoDB if not connected
  try{ 
    if (!mongoose.connection.readyState) {
      await mongoose.connect(process.env.MONGO_URL);
    }
    await model.deleteMany({});
    await model.insertMany(examples);
    await mongoose.connection.close();
  } catch (err) {
    console.error(err);
    throw err;
  } finally {
    return null;
  }
}

module.exports = initDB;
