import cv2
import numpy as np
import matplotlib.pyplot as plt

image = cv2.imread('hw1_sample_images/sample7.jpg', 0)
# plt.hist(image.ravel(), 256, [0,256])
# plt.show()

thres = 100

def maxmin(a, b, c, d, e):
    return max( min(a,b,c) , min(b,c,d) , min(c,d,e) )

def minmax(a, b, c, d, e):
    return min( max(a,b,c) , max(b,c,d) , max(c,d,e) )

def pmed(a, b, c, d, e):
    return (maxmin(a, b, c, d, e) + minmax(a, b, c, d, e))/2

output = image.copy()
rows = len(image)
cols = len(image[0])

for y in range(1, rows-1):
    for x in range(1, cols-1):
        if image[y-1][x-1]/8 + image[y-1][x]/8 + image[y-1][x+1]/8 + image[y][x-1]/8 + image[y][x+1]/8 + image[y+1][x-1]/8 + image[y+1][x]/8 + image[y+1][x+1]/8 + image[y][x]/8 > 175:
            output[y][x] = minmax(image[y-1][x],image[y][x-1],image[y][x+1],image[y][x],image[y+1][x])
        else:
            output[y][x] = maxmin(image[y-1][x],image[y][x-1],image[y][x+1],image[y][x],image[y+1][x])

output1 = output.copy()

for y in range(1, rows-1):
    for x in range(1, cols-1):
        avg = (output[y-1][x-1]/8 + output[y-1][x]/8 + output[y-1][x+1]/8 + output[y][x-1]/8 + output[y][x+1]/8 + output[y+1][x-1]/8 + output[y+1][x]/8 + output[y+1][x+1]/8)
        if abs(output[y][x] - avg) > thres:
            output1[y][x] = avg

cv2.imwrite('9_result.jpg', output1)