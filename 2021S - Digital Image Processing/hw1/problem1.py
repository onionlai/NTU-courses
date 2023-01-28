import cv2
import numpy as np

def average(pixels):
    return round(pixels[0]*0.114 + pixels[1]*0.587 + pixels[2]*0.299)

def grayimage(image):
    gray = np.zeros((len(image), len(image[0]), 3), np.uint8)
    for y in range(len(image)):
        for x in range(len(image[0])):
            gray[y][x][0] = average(image[y][x])
            gray[y][x][1] = gray[y][x][0]
            gray[y][x][2] = gray[y][x][0]
    return gray

def rotate(image):
    flip = np.zeros((len(image), len(image[0]), 3), np.uint8)
    for y in range(len(image)):
        for x in range(len(image[0])):
            flip[y][x] = image[len(image) - y - 1][len(image[0]) - x - 1]
    return flip

image = cv2.imread('hw1_sample_images/sample1.jpg')
gray = grayimage(image)
cv2.imwrite('1_result.jpg', gray)

flip = rotate(image)
cv2.imwrite('2_result.jpg', flip)