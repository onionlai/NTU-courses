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

def EDCanny(img, Th, Tl):
    rows = len(img)
    cols = len(img[0])
    k = 1
    G = np.zeros((rows, cols))
    T = np.zeros((rows, cols))
    gimg = GaussionFilter(img)
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            Gr = (-(gimg[i-1, j-1] + k*gimg[i-1, j] + gimg[i-1, j+1]) + gimg[i+1, j-1] + k*gimg[i+1, j] + gimg[i+1, j+1])/(k+2)
            Gc = (gimg[i-1, j-1] + k*gimg[i, j-1] + gimg[i+1, j-1] - (gimg[i-1, j+1] + k*gimg[i, j+1] + gimg[i+1, j+1]))/(k+2)
            G[i, j] = math.sqrt(Gc**2 + Gr**2)

            if(Gr == 0):
                T[i, j] = 90
            else:
                T[i, j] = math.atan(Gc/Gr)*180/(math.pi) # in degree

    #cv2.imwrite("1_Gaussion.jpg",gimg)
    #cv2.imwrite("2_Gradient.jpg",G)
    #plt.hist(G.ravel(), bins = 1000)
    #plt.show()

    # non maximal suppression
    Gn = np.zeros((rows, cols))
    Gt = np.zeros((rows, cols)) # for thresholding
    G1 = 0.0
    G2 = 0.0
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            if 19.5 <= T[i, j] < 70.5:
                G1 = G[i-1, j+1]
                G2 = G[i+1, j-1]
            elif 70.5 <= T[i, j] <= 90 or -90 <= T[i, j] < -70.5:
                G1 = G[i-1, j]
                G2 = G[i+1, j]
            elif -70.5 <= T[i, j] < -19.5:
                G1 = G[i-1, j-1]
                G2 = G[i+1, j+1]
            elif -19.5 <= T[i, j] <= 0 or 0 <= T[i, j] < 19.5:
                G1 = G[i-1, j]
                G2 = G[i+1, j]
            else:
                print(T[i, j])

            if(G[i, j] > G1 and G[i, j] > G2):
                Gn[i, j] = G[i, j]
                # hysteretic threshold
                if Gn[i, j] >= Th: # edge pixel
                    Gt[i, j] = 255
                elif Gn[i, j] >= Tl: # candidate pixel
                    Gt[i, j] = 100
            else:
                Gn[i, j] = 0
                Gt[i, j] = 0

    #cv2.imwrite("3_nonMaxSupress.jpg",Gn)
    #cv2.imwrite("4_threshold.jpg",Gt)

    # connected component labeling
    Gfinal = np.copy(Gt)
    for i in range(1, rows-1):
        for j in range(1, cols - 1):
            if Gt[i, j] == 100:
                if Gt[i-1, j] >= 100 or Gt[i+1, j] >= 100 or Gt[i, j-1] >= 100 or Gt[i, j+1] >= 100 or Gt[i-1, j-1] >= 100 or Gt[i+1, j-1] >= 100 or Gt[i-1, j+1] >= 100 or Gt[i+1, j+1] >= 100:
                # if Gt[i-1, j] >= 100 or Gt[i+1, j] >= 100 or Gt[i, j-1] >= 100 or Gt[i, j+1] >= 100 :
                    Gfinal[i, j] = 255
                else:
                    Gfinal[i, j] = 0
    #cv2.imwrite('5_CannyResult.jpg', Gfinal)
    return Gfinal

img = cv2.imread('hw2_sample_images/sample1.jpg', 0)
output = EDCanny(img, 50, 10)
cv2.imwrite('result3.jpg', output)