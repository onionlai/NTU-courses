import Info from './models/info'
import infoData from '../data.json'
import Comment from './models/comment'
import commentData from '../comment.json'

const dataInit = async () => {
    const checkData = await Info.find()
    
    if (checkData.length !== 19) {
      console.log("Total restaurants are not equal to default ", checkData.length)
      await Info.deleteMany({})
      await Info.insertMany(infoData)
    }
    else{
      console.log("The number of restaurants is correct", checkData.length)
    }
    const checkComment = await Comment.find()
    if (checkComment.length !== 51) {
      console.log("Total comments are not equal to default ", checkComment.length)
      await Comment.deleteMany({})
      await Comment.insertMany(commentData)
    }
    else{
      console.log("The number of comments is correct", checkComment.length)
    }
}
  

export { dataInit }