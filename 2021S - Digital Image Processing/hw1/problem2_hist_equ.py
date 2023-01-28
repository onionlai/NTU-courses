import cv2
import numpy as np
import matplotlib.pyplot as plt
import random

class pixel:
    def __init__(self, y = 0, x = 0):
        self.y = y
        self.x = x

image = cv2.imread('hw1_sample_images/sample3.jpg', 0)
avg = len(image)*len(image[0])/256

hist = {}
for i in range(256):
    hist[i] = []

for y in range(len(image)):
    for x in range(len(image[0])):
        hist[image[y][x]].append(pixel(y,x))

output = image.copy()
pointer = 0
for i in range(256):
    while len(hist[i]) < avg :
        if len(hist[pointer]) <=avg or pointer == i:
            pointer +=1
        change_p = hist[pointer].pop(random.randrange(len(hist[pointer])))
        #change_p = hist[pointer].pop(1)
        output[change_p.y][change_p.x] = i
        hist[i].append(change_p)
cv2.imwrite('5_result.jpg', output)

plt.hist(output.ravel(), 256, [0,256])
plt.show()