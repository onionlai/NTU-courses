import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

def BDextraction(img):
    rows = len(img)
    cols = len(img[0])
    f = np.zeros((rows, cols))
    output = np.zeros((rows, cols))

    for i in range(1, rows-1):
        for j in range(1, cols-1):
            if all(img[i-1:i+2, j-1:j+2].ravel()):
                f[i, j] = 255
            else:
                f[i, j] = 0

    # cv2.imwrite("tmp.png", f)
    output[:, :] = img[:, :] - f[:, :]
    return output


img = cv2.imread("hw3_sample_images/sample1.png", 0)
output = BDextraction(img)
cv2.imwrite("result1.png", output)
