# multiAgents.py
# --------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
#
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


from util import manhattanDistance
from game import Directions
import math
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
      A reflex agent chooses an action at each choice point by examining
      its alternatives via a action evaluation function.

      The code below is provided as a guide.  You are welcome to change
      it in any way you see fit, so long as you don't touch our method
      headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {North, South, West, East, Stop}
        """
        # Collect legal moves and successor actions
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the action, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        #print("newPos", newPos)
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"
        score = 0
        # To win the game: (1) Not eaten by the ghost (2) Eat all food
        # If food is at our neighbor, score is higher
        # If ghost is away from me, score is higher
        ghosts_dis = []
        for ghostState in newGhostStates:
          if ghostState.scaredTimer < 3:
            d = manhattanDistance(ghostState.getPosition(), newPos)
            ghosts_dis.append(d)
          else:
            ghosts_dis.append(float("inf"))

        near_ghost_dis = min(ghosts_dis)

        foods_dis = []
        foodlist = newFood.asList()
        # Because the food eaten will not be in newFood,
        # which list the food remaining in successorGameState.
        # Compare currentGameState and successorGameState
        # to judge whether the food will be eaten if making this move.
        oldfoodlist = currentGameState.getFood().asList()
        if len(foodlist) != len(oldfoodlist):
          #print ("food eaten!")
          foods_dis.append(0)

        for foodpos in foodlist:
          f = manhattanDistance(foodpos, newPos)
          foods_dis.append(f)

        near_food_dis = min(foods_dis)

        #print "food", near_food_dis, "; ghost", near_ghost_dis
        if near_ghost_dis != 0:
          if near_ghost_dis > 7:
              score = 102 - 0.9*near_food_dis
          else:
            score = 100 - 0.5*near_food_dis - 20*(1/near_ghost_dis)
        else:
          score = 0
        #print "score: " ,score
        return score

def scoreEvaluationFunction(currentGameState):
    """
      This default evaluation function just returns the score of the action.
      The score is the same one displayed in the Pacman GUI.

      This evaluation function is meant for use with adversarial search agents
      (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
      This class provides some common elements to all of your
      multi-agent searchers.  Any methods defined here will be available
      to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

      You *do not* need to make any changes here, but you can if you want to
      add functionality to all your adversarial search agents.  Please do not
      remove anything, however.

      Note: this is an abstract class: one that should not be instantiated.  It's
      only partially specified, and designed to be extended.  Agent (game.py)
      is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
      Your minimax agent (question 2)
    """
    def minimizing(self, agent, depth, gameState): # the agent must be ghost
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      scores = []
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)

        if agent == (gameState.getNumAgents() - 1): # next will be Pacman's turn
          nextagent = 0
          nextdepth = depth + 1
          scores.append(self.maximizing(nextagent, nextdepth, nextgameState))
        else: # next is another ghost
          nextagent = agent + 1
          scores.append(self.minimizing(nextagent, depth, nextgameState))

      return min(scores)

    def maximizing(self, agent, depth, gameState): # the agent must be pacman = 0
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      scores = []
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)
        nextagent = agent + 1
        scores.append(self.minimizing(nextagent, depth, nextgameState))

      return max(scores)


    def minimax(self, gameState):
      if gameState.isWin() or gameState.isLose(): # win or lose at the beginning
        return Directions.STOP

      actions = gameState.getLegalActions(0)
      bestAction = Directions.EAST
      bestscore = float("-inf")
      for action in actions:
        nextgameState = gameState.generateSuccessor(0, action)
        score = self.minimizing(1, 0, nextgameState) # next will be ghost~
        if score > bestscore:
          bestscore = score
          bestAction = action

      return bestAction


    def getAction(self, gameState):
        """
          Returns the minimax action from the current gameState using self.depth
          and self.evaluationFunction.

          Here are some method calls that might be useful when implementing minimax.

          gameState.getLegalActions(agentIndex):
            Returns a list of legal actions for an agent
            agentIndex=0 means Pacman, ghosts are >= 1

          gameState.generateSuccessor(agentIndex, action):
            Returns the successor game action after an agent takes an action

          gameState.getNumAgents():
            Returns the total number of agents in the game
        """
        "*** YOUR CODE HERE ***"

        return self.minimax(gameState)



class AlphaBetaAgent(MultiAgentSearchAgent):
    """
      Your minimax agent with alpha-beta pruning (question 3)
    """
    def minimizing(self, agent, depth, gameState, alpha, beta): # the agent must be ghost
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      minscore = float("inf")
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)

        if agent == (gameState.getNumAgents() - 1): # next will be Pacman's turn
          nextagent = 0
          nextdepth = depth + 1
          score = self.maximizing(nextagent, nextdepth, nextgameState, alpha, beta)
        else: # next is another ghost
          nextagent = agent + 1
          score = self.minimizing(nextagent, depth, nextgameState, alpha, beta)

        if score < alpha: # Somewhere shallower waiting for a bigger value than "alpha"
                          # and because score is smaller than alpha,
                          # if after all expanding from here, we have "score" return
                          # it will become meanless at that shallower position.
            return score

        else:
          if score < minscore:
            minscore = score
            beta = min(minscore, beta)

      return minscore

    def maximizing(self, agent, depth, gameState, alpha, beta): # the agent must be pacman = 0
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      maxscore = float("-inf")
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)
        nextagent = agent + 1
        score = self.minimizing(nextagent, depth, nextgameState, alpha, beta)

        if score > beta: # Somewhere shallower waiting for a smaller value than "beta"
          return score
        else:
          if score > maxscore:
            maxscore = score
            alpha = max(maxscore, alpha)

      return maxscore


    def alphabetapruning(self, gameState):
      if gameState.isWin() or gameState.isLose(): # win or lose at the beginning
        return Directions.STOP

      actions = gameState.getLegalActions(0)
      bestAction = Directions.EAST
      bestscore = float("-inf")

      alpha = float("-inf")
      beta = float("inf")
      for action in actions:
        nextgameState = gameState.generateSuccessor(0, action)
        score = self.minimizing(1, 0, nextgameState, alpha, beta)
        if score > bestscore:
          bestAction = action
          bestscore = score
          alpha = bestscore

      return bestAction

    def getAction(self, gameState):
        """
          Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        return self.alphabetapruning(gameState)


class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """
    # We suppose the ghost might not choose the optimal moves, but randomly.
    # This was nearly same as minimax(),
    # only different at the return value of minimizing().

    def minimizing(self, agent, depth, gameState): # the agent must be ghost
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      scores = []
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)

        if agent == (gameState.getNumAgents() - 1): # next will be Pacman's turn
          nextagent = 0
          nextdepth = depth + 1
          scores.append(self.maximizing(nextagent, nextdepth, nextgameState))
        else: # next is another ghost
          nextagent = agent + 1
          scores.append(self.minimizing(nextagent, depth, nextgameState))

      return sum(scores)/len(scores)

    def maximizing(self, agent, depth, gameState): # the agent must be pacman = 0
      if gameState.isWin() or gameState.isLose() or depth == self.depth:
        return self.evaluationFunction(gameState)

      scores = []
      actions = gameState.getLegalActions(agent)
      for action in actions:
        nextgameState = gameState.generateSuccessor(agent, action)
        nextagent = agent + 1
        scores.append(self.minimizing(nextagent, depth, nextgameState))

      return max(scores)


    def expectimax(self, gameState):
      if gameState.isWin() or gameState.isLose(): # win or lose at the beginning
        return Directions.STOP

      actions = gameState.getLegalActions(0)
      bestAction = Directions.EAST
      bestscore = float("-inf")
      for action in actions:
        nextgameState = gameState.generateSuccessor(0, action)
        score = self.minimizing(1, 0, nextgameState) # next will be ghost~
        if score > bestscore:
          bestscore = score
          bestAction = action

      return bestAction

    def getAction(self, gameState):
        """
          Returns the expectimax action using self.depth and self.evaluationFunction

          All ghosts should be modeled as choosing uniformly at random from their
          legal moves.
        """
        "*** YOUR CODE HERE ***"

        return self.expectimax(gameState)

def betterEvaluationFunction(currentGameState):
    """
      Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
      evaluation function (question 5).

      DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()

# Abbreviation
better = betterEvaluationFunction

