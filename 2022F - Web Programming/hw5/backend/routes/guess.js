import express from 'express'
import {generateNumber, getNumber} from '../core/getNumber'
const router = express.Router()

router.post('/start', (_, res) => {
	generateNumber();
	res.json({msg: 'Guess game has started'})
})

router.get('/guessing', (req, res) => {
	const answer = getNumber(); // todo!!!
	const inputNumber = req.query.number;
	if (inputNumber < 1 || inputNumber > 100) {
		res.status(406).send({msg: 'Not a legal number.'})
	}
	if (inputNumber == answer) {
		res.json({msg: 'Equal'})
	}
	else if (inputNumber <= answer) {
		res.json({msg: 'bigger'})
	}
	else {
		res.json({msg: 'smaller'})
	}
})

// router.post('/restart', (_, res) => {
// 	generateNumber();
// 	res.json({msg: 'The game has started'})
// })

export default router;
