import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

def TSR(point, rows, translation, tx, ty, scaling, sx, sy, rotation, angle, cx=0, cy=0):
    X = np.array([point[1] + 0.5, -point[0] + rows -0.5]) # map to Cartesian coordinate
    if(translation):
        T = np.array([-tx, -ty])
        X = X + T
    if(scaling):
        S = np.array([[1/sx, 0],
                        [0, 1/sy]])
        X = S.dot(X)
    if(rotation):
        R = np.array([[math.cos(angle), math.sin(angle)],
                        [-math.sin(angle), math.cos(angle)]])
        X = R.dot(X - np.array([cx, cy])) + np.array([cx, cy])

    newpoint = [-X[1]-0.5+rows, X[0]-0.5] # map back to Row&Column coordinate
    return newpoint

def Deformation(img, translation=False, tx=0, ty=0, scaling=False, sx=1, sy=1, rotation=False, angle=0, cx=0, cy=0):
    rows = len(img)
    cols = len(img[0])
    result = np.zeros((rows, cols), float)
    for i in range(rows):
        for j in range(cols):
            Map = TSR([i, j], rows, translation, tx, ty, scaling, sx, sy, rotation, angle, cx*cols, cy*rows)
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


img = cv2.imread('hw2_sample_images/sample3.jpg', 0)

output = Deformation(img = img, translation = True, tx = -500, ty = -400, rotation = True, cx = 0.5, cy = 0.5, angle = 90/180*math.pi, scaling = True, sx = 1.5, sy = 1.5)
cv2.imwrite('result6.jpg', output)