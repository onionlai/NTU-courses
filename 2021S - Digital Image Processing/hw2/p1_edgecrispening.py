import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

def Crispening(img):
    filt = np.array([[-1, -1, -1],
                    [-1, 9, -1],
                    [-1, -1, -1]])

    rows = len(img)
    cols = len(img[0])
    result = cv2.filter2D(img, -1, filt)
    return result

img = cv2.imread('hw2_sample_images/sample1.jpg', 0)
output = Crispening(img)
cv2.imwrite('result4.jpg', output)