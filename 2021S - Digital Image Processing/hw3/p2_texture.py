import cv2
import numpy as np
import matplotlib.pyplot as plt
import math
from scipy import signal
import os
import time

# folder = ("rst"+ time.strftime("_%h%d-%H:%M")+"/")
# os.mkdir(folder)

def extend(img, w):
    rows = len(img)
    cols = len(img[0])
    result = np.zeros((rows + 2*w, cols + 2*w))
    result[w:rows+w, w:cols+w] = img[:]

    result[w:rows+w, 0:w] = img[:, w:0:-1]
    result[0:w, w:cols+w] = img[w:0:-1, :]
    result[w:rows+w, cols+w:cols+2*w] = img[:, cols-2: cols-w-2:-1]
    result[rows+w:rows+2*w, w:w+cols] = img[rows-2:rows-w-2:-1, :]

    result[0:w, 0:w] = img[w:0:-1, w:0:-1]
    result[0:w, cols+w:cols+2*w] = img[w:0:-1, cols-2:cols-w-2:-1]
    result[rows+w:2*rows+w, 0:w] = img[rows-2:rows-w-2:-1, w:0:-1]
    result[rows+w:rows+2*w,cols+w:cols+2*w] = img[rows-2:rows-w-2:-1, cols-2:cols-w-2:-1]
    return result


def law_method(img, windows_size):
    w = (int)((windows_size-1)/2)
    rows = len(img)
    cols = len(img[0])
    T = np.zeros((rows, cols, 9))

    H = {}
    H[0] = (np.array(([1, 2, 1],
                    [2, 4, 2],
                    [1, 2, 1])))/36
    H[1] = (np.array(([1, 0, -1],
                    [2, 0, -2],
                    [1, 0, -1]), float))/12
    H[2] = (np.array(([-1, 2, -1],
                    [-2, 4, -2],
                    [-1, 2, -1]), float))/12
    H[3] = (np.array(([-1, -2, -1],
                    [0, 0, 0],
                    [1, 2, 1]), float))/12
    H[4] = (np.array(([1, 0, -1],
                    [0, 0, 0],
                    [-1, 0, 1]), float))/4
    H[5] = (np.array(([-1, 2, -1],
                    [0, 0, 0],
                    [1, -2, 1]), float))/4
    H[6] = (np.array(([-1, 2, -1],
                    [2, 4, 2],
                    [-1, -2, -1]), float))/12
    H[7] = (np.array(([-1, 0, 1],
                    [2, 0, -2],
                    [-1, 0, 1]), float))/4
    H[8] = (np.array(([1, -2, 1],
                    [-2, 4, -2],
                    [1, -2, 1]), float))/4

    for law in range(9):
        m = signal.convolve2d(img, H[law], boundary = 'symm')
        M = extend(m, w)
        M2 = M*M
        max = 0
        for i in range(rows):
            for j in range(cols):
                T[i, j][law] = np.sum(M2[i:(i+2*w+2), j:(j+2*w+2)])**(1/2)
                if T[i, j][law] > max:
                    max = T[i, j][law]
        print("max is", law, max)
    #print(T)
    return T

# Classfication(clustering) by k centers
# return clusters = {n: [pixel_coords]}
# EXAMPLE: {1:[[100, 2], [223, 0], ...], 2:[...], ...., k:[...]}
def clustering(centers, T):
    rows = len(T)
    cols = len(T[0])
    k = len(centers)

    clusters = {}
    for n in range(k):
        clusters[n] = []

    for i in range(rows):
        for j in range(cols):
            min_dis = 100000
            category = -1
            for n in range(k):
                dis = np.linalg.norm(T[i, j] - centers[n])
                if dis < min_dis:
                    min_dis = dis
                    category = n
            clusters[category].append([i, j])
    # print("clusters")
    return clusters

# Calculate new centers for next iterate by the clustering result
def re_seed(clusters, T):
    k = len(clusters)
    new_centers = np.zeros((k, 9))

    for n, cluster in clusters.items():
        if(len(cluster) == 0):
            new_centers[n] = np.random.rand(9)*500
            continue

        sum = np.zeros(9)
        for pixels in cluster:
            sum += T[pixels[0], pixels[1]]
        new_centers[n] = sum/len(cluster)

    return new_centers

def kmeans(depth, k, centers, T):
    print("k means: ", depth)
    if depth == 0:
        if k != 5:
            centers = np.random.rand(k, 9)*700
            print(centers)
        else:
            centers = np.array(([566.48470224, 227.75523164, 138.15717123, 261.6863725, 270.97313604, 235.07146277, 99.37957653, 262.12325814, 603.66782527],[374.02215754, 436.84726798, 322.8709629, 175.27799294, 509.6322357, 322.68826267, 439.90534808, 139.9029608, 184.99736787], [269.97931113, 552.60073725, 61.52805218, 72.44008139, 341.61315254, 634.51759458, 430.28006772, 349.3070803, 6.22158143], [400.07873073, 400.79120945, 535.50966861, 603.52386775, 300.65707597, 104.51257339, 399.58080368, 682.73444454, 93.01980868], [437.90357538, 687.09225389, 198.14182742, 31.39250457, 163.39860123, 394.45834545, 389.92674112, 308.48520462, 338.22328482]))

    clusters = clustering(centers, T)
    cluster_img = np.zeros((len(T), len(T[0]), 3))
    pattern_color = [[255, 208, 235], [216, 255, 208], [208, 253, 255], [166, 183, 203], [193, 165, 70], [117, 117, 215], [49, 171, 126]]

    for n, cluster in clusters.items():
        for pixels in cluster:
            cluster_img[pixels[0], pixels[1]] = pattern_color[n]


    # cv2.imwrite(os.path.join(folder, "kmeans_no"+ str(depth)+ ".png"), cluster_img)

    new_centers = re_seed(clusters, T)
    if (new_centers != centers).all() and depth <= 50:
        return kmeans(depth + 1, k, new_centers, T)
    else:
        return cluster_img


def change_pattern(img, pattern_img, cluster_img, roffset = 0, coffset = 0):
    pattern_id = {}
    pattern_history = []
    rows = len(img)
    cols = len(img[0])
    prows = len(pattern_img)
    pcols = len(pattern_img[0])

    classification = np.zeros((rows, cols))
    class_id = 0

    for i in range(rows):
        for j in range(cols):
            if [cluster_img[i, j, 0], cluster_img[i, j, 1], cluster_img[i, j, 2]] not in pattern_history:
                print("new")
                class_id += 1
                pattern_id[class_id] = cluster_img[i, j]
                pattern_history.append([cluster_img[i, j, 0], cluster_img[i, j, 1], cluster_img[i, j, 2]])
                classification[i, j] = class_id
            else:
                for k, value in pattern_id.items():
                    if (value == cluster_img[i, j]).all():
                        classification[i, j] = k

    changeflower_img = np.zeros((rows, cols))
    for id in range(1, class_id+1):
        isflower_id = 0
        new_img = img.copy()
        for i in range(rows):
            for j in range(cols):
                if classification[i, j] == id:
                    new_img[i, j] = pattern_img[(i+roffset)%prows][(j+coffset)%pcols]
                    if i == rows-1 and j == cols - 1:
                        isflower_id = 1
        # cv2.imwrite("newpattern"+str(id)+".png", new_img)
        if(isflower_id == 1):
            changeflower_img = new_img.copy()
    return changeflower_img

img = cv2.imread("hw3_sample_images/sample2.png", 0)
T = law_method(img, 13)

output1 = kmeans(0, 4, [], T)
cv2.imwrite("result3.png", output1)

output3 = kmeans(0, 5, [], T)
cv2.imwrite("result4.png", output3)

pattern_img = cv2.imread("hw3_sample_images/sample3.png", 0)
output2 = change_pattern(img, pattern_img, output3, 205, 0)
cv2.imwrite("result5.png", output2)