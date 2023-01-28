// import mongoose from "mongoose";
// const Schema = mongoose.Schema;
// import jwt from "jsonwebtoken";
// import bcrypt from "bcryptjs";

// /******* User Schema *******/
// const UserSchema = new Schema({
//   name: { type: String, required: [true, "Name field is required."] },
//   password: { type: String, required: [true, "Password field is required."] },
//   tokens: [{
//     token: {
//       type: String,
//       required: true
//     },
// 		wsId: {
// 			type: String,
// 			required: true
// 		}
//   }]
// });
// UserSchema.pre('save', async function (next) {
//   if (this.isModified('password')) {
//     this.password = await bcrypt.hash(this.password, 8);
//   }
//   next();
// })
// UserSchema.methods.generateAuthToken = async function (wsId){
//   const token = jwt.sign({_id: this._id.toString()}, 'onion')
// 	// console.log('generate token for', wsId, token);
//   this.tokens = [...this.tokens, {token, wsId}];
//   await this.save();
//   return token
// }
// const User = mongoose.model("User", UserSchema);

// export default User