# search.py
# ---------
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


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()

class Node:
    def __init__(self, state, parent = None, direct = None, cost = 0):
        self.state = state
        self.parent = parent
        self.direct = direct # direction from parent
        self.cost = cost

    def solution(self):
        node = self
        path_to_start = []
        while node:
            path_to_start.append(node.direct)
            node = node.parent
        path = list(reversed(path_to_start))
        return path[1:]

    def child_list(self, problem):
        children = []
        children = problem.getSuccessors(self.state)

        return [Node(c[0], self, c[1], self.cost + c[2]) for c in children]

def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    "*** YOUR CODE HERE ***"
    #print problem.getStartState()
    #print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    #print "Start's successors:", problem.getSuccessors(problem.getStartState())

    node = Node(problem.getStartState())
    exploring_stack = util.Stack()
    explored = []
    exploring_stack.push(node)
    while not exploring_stack.isEmpty():
        node = exploring_stack.pop()
        print(node.state)
        explored.append(node.state)
        if problem.isGoalState(node.state):
            print(node.solution())
            return node.solution()
        for child in node.child_list(problem):
            if child.state not in explored:
                exploring_stack.push(child)
    return []


def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    node = Node(problem.getStartState())
    exploring_queue = util.Queue()
    explored = []
    exploring_queue.push(node)
    explored.append(node.state)
    while not exploring_queue.isEmpty():
        node = exploring_queue.pop()
        print(node.state)
        if problem.isGoalState(node.state):
            print(node.solution())
            return node.solution()
        for child in node.child_list(problem):
            if child.state not in explored:
                exploring_queue.push(child)
                explored.append(child.state)
    return []





def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    node = Node(problem.getStartState())
    exploring_queue = util.PriorityQueue()
    exploring_queue.push(node.state, node.cost)
    explored = {}
    explored[node.state] = node

    while not exploring_queue.isEmpty():
        nodestate = exploring_queue.pop()
        node = explored[nodestate]
        #print(node.state)
        if problem.isGoalState(node.state):
            return node.solution()

        for child in node.child_list(problem):
            if node.parent and child.state == (node.parent).state:
                continue
            if child.state not in explored:
                exploring_queue.push(child.state, child.cost)
                explored[child.state] = child
            else:
                #print("exist")
                oldcost = explored[child.state].cost
                if oldcost > child.cost:
                    explored[child.state] = child
                    exploring_queue.update(child.state, child.cost)
    return []


def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    node = Node(problem.getStartState())
    exploring_queue = util.PriorityQueue()
    exploring_queue.push(node.state, node.cost + heuristic(node.state, problem))
    explored = {}
    explored[node.state] = node

    while not exploring_queue.isEmpty():
        nodestate = exploring_queue.pop()
        node = explored[nodestate]
        #print(node.state)
        if problem.isGoalState(node.state):
            return node.solution()

        for child in node.child_list(problem):
            #child.cost += nullHeuristic(child.state, problem)
            if node.parent and child.state == (node.parent).state:
                continue
            if child.state not in explored:
                exploring_queue.push(child.state, child.cost + heuristic(child.state, problem))
                explored[child.state] = child
            else:
                #print("exist")
                oldcost = explored[child.state].cost
                if oldcost > child.cost:
                    explored[child.state] = child
                    exploring_queue.update(child.state, child.cost + heuristic(child.state, problem))
    return []


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
