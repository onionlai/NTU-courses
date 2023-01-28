import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

# first order edge detection
# k=1: Prewitt Mask ; k=2: Sobel Mask
# thres = 0: output the intensity of edge
def EDFirstOrder(img, k, thres):
    rows = len(img)
    cols = len(img[0])
    result = np.zeros((rows, cols))
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            Gr = (-(img[i-1, j-1] + k*img[i-1, j] + img[i-1, j+1]) + img[i+1, j-1] + k*img[i+1, j] + img[i+1, j+1])/(k+2)
            Gc = (img[i-1, j-1] + k*img[i, j-1] + img[i+1, j-1] - (img[i-1, j+1] + k*img[i, j+1] + img[i+1, j+1]))/(k+2)
            if(thres == 0):
                result[i, j] = math.sqrt(Gc**2 + Gr**2)
            elif( math.sqrt(Gc**2 + Gr**2) > thres):
                result[i, j] = 255

    return result


# second order edge detection
# using Laplacian impulse response for 4 neighbor
def EDSecondOrder(img, thres):
    img = img.astype(float)
    rows = len(img)
    cols = len(img[0])
    diff_result = np.zeros((rows, cols), float)

    # Generate the histogram of G(img),
    # G is a 2nd order differentiation filter
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            diff_result[i, j] = -(img[i-1, j] + img[i, j-1] + img[i+1, j] + img[i, j+1])/4 + img[i, j]
    #plt.hist(diff_result.ravel(), bins = 1000)
    #plt.show()

    # Thresholding to seperate zero and non-zero
    # set all nonzero to either -1 or 1
    t_result = np.zeros((rows, cols), int)
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            if(abs(diff_result[i, j]) < thres):
                t_result[i, j] = 0
            elif(diff_result[i, j] < 0):
                t_result[i, j] = -1
            else:
                t_result[i, j] = 1

    # decide whether it's zero-crossing position
    # by designing rules of edge map
    # (the relation of zero and its neighbor)
    result = np.zeros((rows, cols), np.uint8)
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            if(t_result[i, j] != 0):
                continue
            neighbor = [t_result[i-1, j-1], t_result[i-1, j+1], t_result[i+1, j-1], t_result[i+1, j+1], t_result[i-1, j], t_result[i, j-1], t_result[i, j+1], t_result[i+1, j]]
            if -1 in neighbor and 1 in neighbor:
                result[i, j] = 255

    return result

def Crispening(img):
    filt = np.array([[-1, -1, -1],
                    [-1, 9, -1],
                    [-1, -1, -1]])

    rows = len(img)
    cols = len(img[0])
    result = cv2.filter2D(img, -1, filt)
    return result

img = cv2.imread('hw2_sample_images/sample1.jpg', 0)

output1 = EDFirstOrder(img, 1, 70)
cv2.imwrite('result1.jpg', output1)

output2 = EDSecondOrder(img, 5)
cv2.imwrite('result2.jpg', output2)

output3 = Crispening(img)
cv2.imwrite('result4.jpg', output3)

output4 = EDFirstOrder(output3, 1, 80)
cv2.imwrite('result5.jpg', output4)


