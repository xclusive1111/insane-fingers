import * as mongoose from 'mongoose';

const Schema = mongoose.Schema;

export const QuoteSchema = new Schema({
  content: {
    type: String,
    required: 'content must not be null or empty'
  },
  author: {
    type: String,
    required: 'author must not be null or empty'
  }
})
