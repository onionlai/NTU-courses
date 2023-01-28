import cv2
import numpy as np
import matplotlib.pyplot as plt
import math


###################################################
############## Fourier Transform ##################
###################################################
def DFT(img):
    # plt.figure(figsize=(6*3, 5), constrained_layout=False)
    spectrum = np.fft.fft2(img)
    center_spectrum = np.fft.fftshift(spectrum)

    # plt.subplot(131), plt.imshow(img, "gray"), plt.title("Original")
    # plt.subplot(132), plt.imshow(np.log(1 + np.abs(spectrum)), "gray"), plt.title("Spectrum")
    # plt.subplot(133), plt.imshow(np.log(1 + np.abs(center_spectrum)), "gray"), plt.title("Centered spectrum")
    # plt.savefig('FFT_case.png', format='png')

    return center_spectrum

def find_horizontal_outlier(F):
    rows = len(F)
    cols = len(F[0])
    freq_histogram = np.zeros((int)(cols/2))
    for j in range((int)(cols/2), cols):
        freq_histogram[j - (int)(cols/2)] = np.abs(F[(int)(rows/2), j])
    # plt.clf()
    # plt.plot(freq_histogram), plt.title("Horizontal Frequency Spectrum")
    # plt.savefig('hspectrum.png', format = 'png')
    return

def remove_horizontal_outlier(F, thres):
    rows = len(F)
    cols = len(F[0])
    result = F.copy()
    for j in range((int)(cols/2)+10, cols):
        if abs(result[(int)(rows/2), j]) > thres:
            print('remove', j)
            result[(int)(rows/2), j] = 0
            result[(int)(rows/2), j - 2*(j - (int)(cols/2))] = 0
    return result

def inverseDFT(F):
    return np.abs(np.fft.ifft2(np.fft.ifftshift(F)))

img = cv2.imread("hw4_sample_images/sample3.png", 0)
fourier_spectrum = DFT(img)
output = np.log(1 + np.abs(fourier_spectrum))
cv2.imwrite("result10.png", 10*output)

find_horizontal_outlier(fourier_spectrum)
output2 = inverseDFT(remove_horizontal_outlier(fourier_spectrum, 500000))
cv2.imwrite("result11.png", output2)

