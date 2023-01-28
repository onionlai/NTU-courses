import cv2
import numpy as np

#####################
##### Dithering #####
#####################
def gaussianNoise(img):
    rows = len(img)
    cols = len(img[0])
    mean = 0
    var = 5
    sigma = var ** 0.5
    gauss = np.random.normal(mean, sigma, [rows, cols])
    result = img + gauss
    # cv2.imwrite("noise_tmp.png", result)
    return result


def dithering(img, dither_matrix):
    rows = len(img)
    cols = len(img[0])
    nois_img = gaussianNoise(img)

    n = len(dither_matrix)
    threshold_matrix = 255*(dither_matrix+0.5)/(n**2)


    result = np.zeros((rows, cols))
    for i in range(rows):
        for j in range(cols):
            if(nois_img[i, j] > threshold_matrix[i%n, j%n]):
                result[i, j] = 255
    return result

def create_dither_matrix(n):
    if(n == 2):
        return np.array([[1, 2], [3, 0]])
    else:
        m = 4* create_dither_matrix(n/2)
        return np.concatenate( (np.concatenate((m + 1, m + 2), axis = 1), np.concatenate((m + 3, m), axis = 1)), axis = 0)

###########################
##### Error Diffusion #####
###########################
def error_diffusion(img, rules = 1):

    def diffuse_1(i, j):
        F[i+1, j] += E[i, j]*(7/16)
        F[i, j+1] += E[i, j]*(5/16)
        F[i+1, j+1] += E[i, j]*(1/16)
        if (i-1) >= 0 :
            F[i-1, j-1] += E[i, j]*(3/16)

    def diffuse_2(i, j):
        F[i, j+1] += E[i, j]*(7/48)
        F[i, j+2] += E[i, j]*(5/48)
        F[i+1, j] += E[i, j]*(7/48)
        F[i+2, j] += E[i, j]*(5/48)
        F[i+1, j+1] += E[i, j]*(5/48)
        F[i+2, j+1] += E[i, j]*(3/48)
        F[i+1, j+2] += E[i, j]*(3/48)
        F[i+2, j+2] += E[i, j]*(1/48)

        if (i-1) >= 0:
            F[i-1, j+1] += E[i, j]*(5/48)
            F[i-1, j+2] += E[i, j]*(3/48)
        if (i-2) >= 0:
            F[i-2, j+1] += E[i, j]*(3/48)
            F[i-2, j+2] += E[i, j]*(1/48)


    rows = len(img)
    cols = len(img[0])
    F = img / 255
    F = np.append(F, np.zeros((rows, 2)), axis = 1)
    F = np.append(F, np.zeros((2, cols + 2)), axis = 0)

    G = np.zeros((rows, cols))
    E = np.zeros((rows, cols))

    for i in range(rows):
        for j in range(cols):
            if(F[i, j] > 0.5):
                G[i, j] = 1
            E[i, j] = F[i, j] - G[i, j]
            if rules == 1:
                diffuse_1(i, j)
            else:
                diffuse_2(i, j)
    return G*255




img = cv2.imread("hw4_sample_images/sample1.png", 0)
output = dithering(img, create_dither_matrix(2))
cv2.imwrite("result1.png", output)

output2 = dithering(img, create_dither_matrix(len(img)))
cv2.imwrite("result2.png", output2)

output3 = error_diffusion(img, 1)
cv2.imwrite("result3.png", output3)

output4 = error_diffusion(img, 2)
cv2.imwrite("result4.png", output4)