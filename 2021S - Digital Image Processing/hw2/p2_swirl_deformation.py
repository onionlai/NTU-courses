import cv2
import numpy as np
import matplotlib.pyplot as plt
import math
# import sympy

# for scaling:
def conditional_quadratic(x):
    if x >= 1/3:
        return 1
    else:
        return (3*x)**(2/3)

def quadratic(x):
    return (x)**(2/3)

def linear(x):
    return (x)**(1/2)

def sdefault(x):
    return 1

# for rotating
def exponential(x):
    return 2.9*math.exp(-5.7*x)+0.2

def rdefault(x):
    return 0



def Swirl(point, rows, cols, sfunction, rfunction):
    X = np.array([point[1] + 0.5, -point[0] + rows -0.5]) # map to Cartesian coordinate
    cx = cols/2
    cy = rows/2
    X = X - np.array([cx, cy]) # coordinate centered (cx, cy)

    r = math.sqrt(X[0]**2 + X[1]**2)
    l = math.sqrt((rows/2)**2 + (cols/2)**2)
    x = r/l

    # do the nonlinear scaling
    sx = sfunction(x)
    sy = sx
    S = np.array([[1/sx, 0],
                     [0, 1/sy]])
    X = S.dot(X)

    # do the nonlinear rotation
    angle = rfunction(x)
    R = np.array([[math.cos(angle), math.sin(angle)],
                [-math.sin(angle), math.cos(angle)]])
    X = R.dot(X)

    X = X + np.array([cx, cy]) # coordinate centered (0,0)
    newpoint = [-X[1]-0.5+rows, X[0]-0.5] # map back to Row & Column coordinate
    a = 1
    return newpoint

def SwirlDeformation(img, sfunction=sdefault,rfunction=rdefault):
    rows = len(img)
    cols = len(img[0])
    result = np.zeros((rows, cols), float)
    for i in range(rows):
        for j in range(cols):
            Map = Swirl([i, j], rows, cols, sfunction, rfunction)
            if(Map[0] > rows-1 or Map[1] > cols-1 or Map[0] < 0 or Map[1] < 0): # over the boundary
                result[i, j] = 0
            elif(Map[0]%1 != 0 or Map[1]%1 != 0): # need interpolation
                p = (int)(Map[0])
                q = (int)(Map[1])
                a = Map[0] - p
                b = Map[1] - q
                if a == 0:
                    result[i, j] = (1-b)*img[p, q] + b*img[p, q+1]
                elif b == 0:
                    result[i, j] = (1-a)*img[p, q] + a*img[p+1, q]
                else:
                    result[i, j] = (1-a)*(1-b)*(img[p, q]) + (1-a)*b*(img[p, q+1]) + a*(1-b)*(img[p+1, q]) + a*b*(img[p+1, q+1])
            else:
                result[i, j] = img[(int)(Map[0]), (int)(Map[1])]

    return result


img = cv2.imread('hw2_sample_images/sample5.jpg', 0)
#img = cv2.imread('hw2_sample_images/sample5.jpg', 0)
# output1 = SwirlDeformation(img = img, sfunction=quadratic)
# output2 = SwirlDeformation(img = img, sfunction=linear)
# output3 = SwirlDeformation(img = img, rfunction=exponential)
output = SwirlDeformation(img = img, sfunction=conditional_quadratic,rfunction=exponential)

cv2.imwrite('result7.jpg', output)