// * ////////////////////////////////////////////////////////////////////////
// *
// * FileName     [ comment.js ]
// * PackageName  [ server ]
// * Synopsis     [ Schema of comment ]
// * Author       [ Chin-Yi Cheng ]
// * Copyright    [ 2022 11 ]
// *
// * ////////////////////////////////////////////////////////////////////////

import mongoose from 'mongoose'

const Schema = mongoose.Schema

const CommentSchema = Schema({
    restaurantId: { type: Number, required: true },
    name: { type: String, required: true },
    rating: { type: Number, required: true },
    content: { type: String, required: true }
}, {
    collection: 'Comment',
    timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }
})

const exportSchema = mongoose.model('Comment', CommentSchema)

export default exportSchema
