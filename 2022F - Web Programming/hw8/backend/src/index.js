import server from './server'
import mongo from './mongo'

mongo.connect(); // connecting db

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
	console.log(`listening on port ${PORT}.`)
});
