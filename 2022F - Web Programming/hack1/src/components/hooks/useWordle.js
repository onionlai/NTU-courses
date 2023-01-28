/****************************************************************************
  FileName      [ useWordle.js ]
  PackageName   [ src/components/hook ]
  Author        [ Cheng-Hua Lu ]
  Synopsis      [ This file handles each action in the Wordle game. ]
  Copyright     [ 2022 10 ]
****************************************************************************/

import React, { useState } from "react";

const useWordle = (solution) => {
  const [turn, setTurn] = useState(0); // An integer whose default is 0. 0 <= turn <= 5.
  const [usedChars, setUsedChars] = useState({}); // A dictionary object which store characters' color that showed on the keyboard. (Ex: {e: 'yellow', c:'grey'})
//   const [curGuess, setCurGuess] = useState("npnus"); // A string whose default is "". 0 <= curGuess.length <= 5.
  const [curGuess, setCurGuess] = useState(""); // A string whose default is "". 0 <= curGuess.length <= 5.
  const [isCorrect, setIsCorrect] = useState(false); // A bool whose default is false. It will be set true only when curGuess === solution.
//   const [guesses, setGuesses] = useState([
//     [
//       { char: "c", color: "grey" },
//       { char: "o", color: "grey" },
//       { char: "d", color: "grey" },
//       { char: "e", color: "yellow" },
//       { char: "s", color: "grey" },
//     ],
//     [],
//     [],
//     [],
//     [],
//     [],
//   ]);
  const [guesses, setGuesses] = useState([...Array(6)]);          // An array whose length is 6. (Ex: [[{char:'c', color:'grey'},{char:'o', color:'grey'},{char:'d', color:'grey'},{char:'e', color:'yellow'},{char:'s', color:'grey'}],[],[],[],[],[]])

  // You can use this function to print all the parameters you want to know.
  const printTest = () => {
    console.log("*-----------------------*");
    console.log("solution: ", solution);
    console.log("turn: ", turn);
    console.log("usedChars:", usedChars);
    console.log("curGuess: ", curGuess);
    console.log("isCorrect: ", isCorrect);
    console.log("guesses: ", guesses);
  };

  // Handle the actions of `Enter`
  const handleEnter = () => {
    // (1) Enter is invalid if turn > 5
    if (turn > 5) {
      console.log("Error: You have used all your guesses");
      return;
    }
    // (2) Enter is invalid if curGuess is not a 5-character string
    if (curGuess.length !== 5) {
      console.log("Error: Only ", curGuess.length, " characters are entered!");
      return;
    }
    // (3) Press Enter, store curGuess to guesses, reset curGuess and update parameters .
    // TODO 4: Check each wordbox's color in `curGuess` and update `guess`, `turn` and `curGuess`
    // Hint: check green first, and then check yellow.

    // add the formatted guess generated into guesses.

    // turn += 1

    // set curGuess to default
    var solutionSet = solution.split("");
    // console.log(solutionSet);
    var solutionSetUsed = Array(5).fill(false);
    // var curGuessWordSet = curGuess.split("");


    var newGuesses = curGuess.split("").map((word, idx)=>{
        if (word === solution[idx]) {
            solutionSetUsed[idx] = true;
            return {char: word, color: 'green'}
        }
        return {char: word, color:'grey'}
    })
    newGuesses = newGuesses.map((guess) => {
        if (guess.color === 'grey') {
            var found = false;
            solutionSet.forEach((sol, idx) => {
                if (sol === guess.char && !solutionSetUsed[idx] && !found) {
                    found = true;
                    console.log('found');
                    solutionSetUsed[idx] = true;
                }
            })
            if (found) return {...guess, color: 'yellow'};
        }
        return guess;
    })
    // console.log(newGuesses);

    // set guesses tiles //
    var used = false;
    setGuesses(guesses.map((guess)=>{
        if (!guess && !used) {
            used = true;
            return newGuesses;
        } else {
            return guess;
        }
    }
    ))


    // TODO 5: update parameters, check each char usage and show in `Keyboard` and reset `curGuess`.
    // 5-1) check if curGuess === solution, if true, set `isCorrect` to true.
    // 5-2) usedChars update
    setIsCorrect(curGuess === solution);
    setCurGuess("");
    // var newUsedChars = {};
    var newUsedChars = usedChars;

    newGuesses.forEach((guess) => {
        // newUsedChars = {...newUsedChars, [guess.char]: guess.color};
        if (guess.color === 'grey') return;
        if (!newUsedChars[guess.char] || newUsedChars[guess.char] !== 'green')
          newUsedChars[guess.char] = guess.color;
    })
    // setUsedChars({...usedChars, ...newUsedChars});
    setUsedChars(newUsedChars);
    setTurn (turn + 1);
  };

  // Handle the action of `Backspace`
  const handleBackspace = () => {
    setCurGuess(curGuess.substring(0, curGuess.length - 1));
  };

  // Handle the action of pressing a character.
  const handleCharacter = (key) => {
    // If curGuess's length is longer than 5, do nothing
    if (curGuess.length < 5) {
      setCurGuess(curGuess + key);
    }
  };
  const handleKeyup = ({ key }) => {
    // console.log("You just press: ", key);
    if (key === "Enter") handleEnter();
    else if (key === "Backspace") handleBackspace();
    else if (/^[A-Za-z]$/.test(key)) handleCharacter(key);
  };
  return {
    turn,
    curGuess,
    guesses,
    isCorrect,
    usedChars,
    handleKeyup,
    printTest,
  };
};

export default useWordle;
