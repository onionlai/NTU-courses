import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

def GaussionFilter(img):
    gfilter = (np.array([[2, 4, 5, 4, 2],
                        [4, 9, 12, 9, 4],
                        [5, 12, 14, 12, 5],
                        [4, 9, 12, 9, 4],
                        [2, 4, 5, 4, 2]], float))/159

    result = cv2.filter2D(img,-1,gfilter)
    return result