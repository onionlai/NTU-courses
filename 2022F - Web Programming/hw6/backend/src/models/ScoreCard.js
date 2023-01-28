import mongoose from 'mongoose'
// data model
const Schema = mongoose.Schema;
const ScoreCardSchema = new Schema({
	name: String,
	subject: String,
	score: Number
}); // Number is shorthand for {type: Number}

const ScoreCard = mongoose.model('ScoreCard', ScoreCardSchema);

export default ScoreCard;