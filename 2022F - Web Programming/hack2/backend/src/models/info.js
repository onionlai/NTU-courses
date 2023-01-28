// * ////////////////////////////////////////////////////////////////////////
// *
// * FileName     [ data.js ]
// * PackageName  [ server ]
// * Synopsis     [ Schema of restaurant info ]
// * Author       [ Chin-Yi Cheng ]
// * Copyright    [ 2022 11 ]
// *
// * ////////////////////////////////////////////////////////////////////////

import mongoose from 'mongoose'

const Schema = mongoose.Schema

const InfoSchema = Schema({
    id: { type: Number, required: true },
    name: { type: String, required: true },
    tag: [{ type: String }],
    img: { type: String },
    time: { type: Schema.Types.Mixed },
    distance: { type: Number },
    price: { type: Number }
}, {
    collection: 'Restaurant',
    timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }
})

const exportSchema = mongoose.model('Restaurant', InfoSchema)

export default exportSchema
