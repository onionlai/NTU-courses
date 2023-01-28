import mongoose from "mongoose";

const itemSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    amount: { type: Number, required: true },
    category: { type: String, required: true },
    date: { type: Date, required: true },
    description: String,
  },
  {
    collection: "item",
  }
);

export default mongoose.model("item", itemSchema);
