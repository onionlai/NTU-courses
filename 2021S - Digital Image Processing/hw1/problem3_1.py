import cv2
import numpy as np
import matplotlib.pyplot as plt

image = cv2.imread('hw1_sample_images/sample5.jpg', 0)
# plt.hist(image.ravel(), 256, [0,256])
# plt.show()

image = cv2.imread('hw1_sample_images/sample6.jpg', 0)
# plt.hist(image.ravel(), 256, [0,256])
# plt.show()

f = [[1/16,2/16,1/16],[2/16,4/16,2/16],[1/16,2/16,1/16]]
rows = len(image)
cols = len(image[0])
output = image.copy()
for y in range(1, rows-1):
    for x in range(1, cols-1):
        output[y][x] = f[0][0]*image[y-1][x-1] + f[0][1]*image[y-1][x]+f[0][2]*image[y-1][x+1]+f[1][0]*image[y][x-1]+f[1][1]*image[y][x]+f[1][2]*image[y][x+1]+f[2][0]*image[y+1][x-1]+f[2][1]*image[y+1][x]+f[2][2]*image[y+1][x+1]

for y in range(1, rows-1):
    output[y][0] = f[0][0]*image[y-1][1] + f[0][1]*image[y-1][0]+f[0][2]*image[y-1][1]+f[1][0]*image[y][1]+f[1][1]*image[y][0]+f[1][2]*image[y][1]+f[2][0]*image[y+1][1]+f[2][1]*image[y+1][0]+f[2][2]*image[y+1][1]

    x = cols-1
    output[y][x] = f[0][0]*image[y-1][x-1] + f[0][1]*image[y-1][x]+f[0][2]*image[y-1][x-1]+f[1][0]*image[y][x-1]+f[1][1]*image[y][x]+f[1][2]*image[y][x-1]+f[2][0]*image[y+1][x-1]+f[2][1]*image[y+1][x]+f[2][2]*image[y+1][x-1]

for x in range(1, cols-1):
    output[0][x] = f[0][0]*image[1][x-1] + f[0][1]*image[1][x]+f[0][2]*image[1][x+1]+f[1][0]*image[0][x-1]+f[1][1]*image[0][x]+f[1][2]*image[0][x+1]+f[2][0]*image[1][x-1]+f[2][1]*image[1][x]+f[2][2]*image[1][x+1]

    y = rows-1
    output[y][x] = f[0][0]*image[y-1][x-1] + f[0][1]*image[y-1][x]+f[0][2]*image[y-1][x+1]+f[1][0]*image[y][x-1]+f[1][1]*image[y][x]+f[1][2]*image[y][x+1]+f[2][0]*image[y-1][x-1]+f[2][1]*image[y-1][x]+f[2][2]*image[y-1][x+1]


cv2.imwrite('8_result.jpg', output)