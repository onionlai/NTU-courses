import cv2
import numpy as np
import matplotlib.pyplot as plt

image = cv2.imread('hw1_sample_images/sample4.jpg', 0)
# plt.hist(image.ravel(), 256, [0,256])
# plt.show()

def fct(x):
    xpos = 200
    ypos = 128
    if x <=ypos:
        return xpos*x/ypos
    else:
        return xpos+(255-xpos)*(x-ypos)/(255-ypos)

output = image.copy()
rows = len(image)
cols = len(image[0])

for y in range(1, rows-1):
    for x in range(1, cols-1):
        output[y][x] = fct(image[y][x])

plt.hist(output.ravel(), 256, [0,256])
plt.show()
cv2.imwrite('7_result.jpg', output)