# 111-1-Web-Hackathon#1 -- Wordle
## Prerequisite
1. If you have not done [preREADME](https://hackmd.io/@anitalu724/BkUm1KBQj) yet, please check it out first.

2. This in-class Hackathon is to implement a famous online puzzle game - Wordle. No matter you know how to play the game or not, please WATCH THIS INTRO VIDEO fist: [**Introduction video (MUST WATCH)**](https://www.youtube.com/watch?v=hTBUw2J_93s). It also explains how the code is designed and structured. 

3. Please sign in to Hackathon #1 thru this [Google Form](https://bit.ly/3gj6XNG). After you fill in your student ID, name, department and grade, you will see the link to the reference code. The downloaded file should be named "**hack1.zip**". Uncompress it and copy the files to the `wp1111/hack1` directory. (Note: If you see an extra `hack1` directory under `hack1`, copy the files under `hack1/hack1` instead.)

4. Check the structure of the files/directories under `hack1` and it should be like this:
![](https://i.imgur.com/vVB5vpt.png)


5. Run `yarn` or `npm install` to install all the dependencies, and run `yarn start` or `npm start` to start the app.

:::info
For Windows user, modify `package.json` --
Change:
```
"scripts": {
  "start": "PORT=8080 react-scripts start",
},
```
to
```
"scripts": {
  "start": "set PORT=8080 && react-scripts start",
},
```
:::

6. The initial mode should be like this:
![](https://i.imgur.com/iAPS6Ya.png)


## Introduction
If you haven't watched the [**Introduction video (MUST WATCH)**](https://www.youtube.com/watch?v=hTBUw2J_93s), watch it NOW!

Wordle is a famous online puzzle game. The goal is to guess the correct word in 6 tries. Each guess **must** be a 5-letter word. Press the enter button to submit. After each guess, the colors of the tiles will change to show how close your guess was to the word. To experience it, click [here](https://www.nytimes.com/games/wordle/index.html) to play.


![](https://i.imgur.com/F0lP7lD.png)

## Precautions and regulations
Hack#1 is a simplified version of [Wordle](https://www.nytimes.com/games/wordle/index.html). 

1. You do not need to check whether the 5-letter guess is an existing vocabulary.
![](https://i.imgur.com/hHcttSa.gif)

2. You do not need to support the `click` function of the keyboard as shown on the screen. 

3. All css files have been provided to you. **DO NOT** modify them.

4. You are not allowed to use modules which were not specified in the `package.json` of [preREADME](https://hackmd.io/@anitalu724/BkUm1KBQj).

5. Must program in **JavaScript** and **ReactJS**.

## Grading Rules/Reminders
1. A public testcase is provided for you (in cypress format: `./cypress/e2e/public.cy.js`). It is for your self-test only. When grading, the grading program **Gradescope** will change the testcases (i.e. `solutions` in `src/data/config.json`, like the picture shown below) with our private testcases and your code will be graded based on these private testcases.
![](https://i.imgur.com/aGDhgTU.png)

2. Although your code should have been graded by Gradescope during the test, however, **you should still push your codes** onto the `main` branch of your GitHub repo `wp111/hack1` before the end of Hack#1. We will check your codes if needed. Failure to push the code before the deadline will be treated as "no-submission" and your grade will become '0' point. 
    ```bash!
    git add .
    git commit -m "<your commit message>"
    git push
    ```
3. **Each key, id and className that have been defined in pictures below must be added correctly in your code.** If you miss adding the correct key/id/className or specify the incorrect key/id/className to the structure, your code will not be scored.

4. Anything modified outside the `src` folder will not be scored.

5. For further testing rules of Wordle in Hack#1, Please refer to the [**Introduction video (MUST WATCH)**](https://www.youtube.com/watch?v=hTBUw2J_93s) for details.


## Structure of the Reference Code
![](https://i.imgur.com/CEoZyoa.png)

![](https://i.imgur.com/YTACyRA.png)



## TODOs
1. Basic Keyboard Implementation (15%)
    * Files to be modified: `Wordle.js`, `Keyboard.js`

    1-1. In `Wordle.js`, render `Keyboard` by passing `usedChars` into it. 

    1-2. In `Keyboard.js`, slice `config.letters` into three parts. Please note that `thirdRowLetters` has been done for you and you do not need to modify it. You should implement the code for `firstRowLetters` and `secondRowLetters` as shown on the screen.
    ![](https://i.imgur.com/uN4ZZ7k.png)
    
    1-3. Please note that we have handled the "case-insensitive" character (English letter) comparison in `handleKeyup` in `useWordle`. In the later word checking process, you don't need to worry about the upper or lower letter case issues.


2. Board Implementation (15%)
    * Files to be modified: `Wordle.js`, `Board.js`
    * Refer to `Row.js`

    2-1. In `Wordle.js`, render `Board` by passing `turn`, `guesses`, `curGuess` into it. 

    2-2. In `Board.js`, display 6 rows (using `map` function is recommended) with the correctly defined row's `key` and `id`. (Be careful the usage of `Row` and `CurRow`.)
    ![](https://i.imgur.com/Q64J7rd.png)


  
3. Row Implementation: display in each `Row-wordbox` the corresponding letter and the color. (15%)
    * Files to be modified: `Row.js`, `CurRow.js`
    * Refer to `Row.css` for class definition.
    * Remember to add `id` and `key` to each `Row-wordbox` and change `className` based on the color of each `Row-wordbox`.
    
    ![](https://i.imgur.com/GfjldAk.png)  
    ![](https://i.imgur.com/KHpHmsJ.png)



4. Check each `Row-wordbox`'s color in `curGuess` and update `guess`, `turn` and `curGuess` (25%)
    * Prerequisite: TODO2 & 3 (Please finish 2 & 3 first)
    * Files to be modified: `useWordle.js`
    * Firstly, create a `set` (i.e. a structure to store data) formed by the letters in `solution` (i.e. the input parameter of `useWordle`, as called by `Wordle.js`). We call this set "solution letter set".
    * If some letters in `curGuess` match the `solution` with correct positions, mark these positions green, and remove these letters from the solution letter set.
    * For the remaining letters in `curGuess`, check if each of them, **from left to right**, exists in the solution letter set. If so, mark the encountered position(s) yellow and remove the letter(s) from the solution letter set. 
    * Hint: Check green first, and then check yellow. Therefore, if a letter in the solution letter set is removed during the "green" color check, it will not be considered during the "yellow" color check. See the second row in the example below.
    * Warning: If your code cannot trigger the color changing on your screen, you will not get the point.

    * Example:
    
        If the solution is `FUNNY`
        | curGuess | color |
        | -------- | ----- |
        | 'nnaaa' | ['yellow', 'yellow', 'grey', 'grey', 'grey'] |
        | 'aannn' | ['grey', 'grey', 'green', 'green', 'grey'] |
        | 'aaann' | ['grey', 'grey', 'grey', 'green', 'yellow'] |
        | 'nanan' | ['yellow', 'grey', 'green', 'grey', 'yellow'] |

    
5. Update parameters, check each char's usage and show in `Keyboard` and reset `curGuess` (20%)
    * Prerequisite: TODO1 (Please finish 1 first)
    * **YOU MUST WATCH THE [**Introduction video**](https://www.youtube.com/watch?v=hTBUw2J_93s)**.
    * Files to be modified: `useWordle.js`, `Keyboard.js`
    * If you do not implement the `Keyboard` correctly, you will not get the point.
    
    5-1. If `curGuess` is equal to `solution`, set `isCorrect` to `true`.

    5-2. Update `usedChars` so that the colors on the keyboard can be updated correcly with respect to `curGuess`

    
6. Implementation for showing the result of the game. (10%)
    * Prerequisite: TODO4 (Please finish 4 first)
    * Files to be modified: `Wordle.js`
    * Refer to `Wordle.css` for class definition.
    * Add some conditions in `useEffect` to maintain `result`, `gameOver`, `win`.
    * Show the `result` in the following format.
    ![](https://i.imgur.com/wVoZJ4K.gif)
   

## Cypress
We provide a public testcase for you to test your code. However, this public testcase result is **NOT** your final score. TAs will change the testcases and when Gradescope is grading your code, it will be tested by these private testcases. **Your final score will be the score as shown on Gradescope.**

* How to run the public testcase:
You should open two terminal windows. Use `yarn start` or `npm start` to start your app in the first window, and use `yarn test` or `npm test` in the other window. You should wait for a few minutes to get your result as displayed on the terminal.

An example of the result is like the picture below:
![](https://i.imgur.com/H6Qbf1k.png)

**Remind again, the self-test result of your cypress is NOT to your final score.**

## Gradescope submission

Please **zip your `src` folder** and submit it to Gradescope. The grading on Gradescope will be the final score of your Hack#1.
```bash!
zip -r src.zip src
```

:::warning
Please note that your score will be the **latest uploaded src.zip**. NOT the highest one. Please be careful NOT to submit a buggy version in the last minute.
:::

## GitHub submission
Please push your final version codes onto your GitHub repo `main` branch before the end of Hack#1. We will check your codes if needed. Failure to push the code before the deadline will be treated as "no-submission" and your grade will become '0' point. 
```bash!
git add .
git commit -m "<your commit message>"
git push
```


## Should you have any questions:
Go to this Hackathon #1 Q&As [repo](https://github.com/ntuee-web-programming/111-1_WebProgramming-Hack1_QA). Check if your question has been asked. If not, open a new issue.

Please read the [README.md](https://github.com/ntuee-web-programming/111-1_WebProgramming-Hack1_QA#readme) before you do so.



## Honor System
Please DO NOT discuss or consult with anyone during the exam. If you find someone who might violate this rule, or is cheating in the Hackathon, please help fill in this [Google Form](https://bit.ly/3EJJf7j).
