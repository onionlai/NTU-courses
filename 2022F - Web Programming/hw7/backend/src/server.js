import http from 'http'
import express from 'express'
import mongoose from 'mongoose'
import WebSocket from 'ws'
import wsConnect from './wsConnect'
import mongo from './mongo'
import {v4 as uuidv4} from 'uuid';

mongo.connect(); // connecting db

const app = express(); // middleware of node.js
const server = http.createServer(app);
const wss = new WebSocket.Server({server}); // server-side websocket object

const db = mongoose.connection;

db.once('open', () => { // define callback function when mongoose connection is open
	console.log("MongoDB connected");
	wss.on('connection', (ws) => {
		ws.id = uuidv4();
		console.log("connection new  ", ws.id);

		ws.box = '';
		ws.onmessage = wsConnect.onMessage(wss, ws); // define callback functino when receiving message from client-side websocket(ws)

		// ws.onclose = wsConnect.onClose(ws); // <- call everytime after onmessage
		ws.once('close', () => { // <- call when socket closed
			wsConnect.onClose(ws);
		})
	})
	}
);

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
	console.log(`listening on port ${PORT}.`)
});
