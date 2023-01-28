var answer = 0;
const generateNumber = () => {
	answer = 1 + Math.floor(Math.random() * 100);
	console.log("new answer: "+ answer)
}
const getNumber = () => {
	return answer;
}
export {generateNumber, getNumber}