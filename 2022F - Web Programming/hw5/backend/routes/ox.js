import express from 'express'
import {generateBoard, playerMove} from '../core/oxControl'
const router = express.Router()
router.use(express.json()); // <- 這樣他才會把request body 視為 javascript object parse 進 req.body。

router.post('/start', (_, res) => {
	generateBoard();
	res.json({msg: 'OX game has started'})
})

router.put('/oxing', (req, res) => {
	// console.log(req.body);
	const i = req.body.i;
	const j = req.body.j;
	const [board, msg] = playerMove(i, j);
	res.json({board, msg});
})

export default router;
