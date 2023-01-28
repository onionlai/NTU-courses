import cv2
import numpy as np
import matplotlib.pyplot as plt
import math

def getneighbor(i, j, label):
    if i == 0:
        up = -1
    else:
        up = label[i-1, j] #  left must be >= upper
    if j == 0:
        left = -1
    else:
        left = label[i, j-1]

    return [left, up]

# labelling connected-component with sequential method
# label different object with not sequential but distinct number
def Labelling(img, bgcolor):
    rows = len(img)
    cols = len(img[0])

    label = np.zeros((rows, cols), int)
    output = np.zeros((rows, cols))

    labelnum = 0
    link_history = set()
    link_table = {}
    link_dic = {}

    for i in range(rows):
        for j in range(cols):
            if img[i, j] == bgcolor:
                label[i, j] = -1
                continue
            neighbor = getneighbor(i, j, label)
            if neighbor[0] == -1 and neighbor[1] == -1: # new label
                label[i, j] = labelnum
                labelnum += 1
                #print(newlabel)

            elif neighbor[0] == neighbor[1] or neighbor[1] == -1: # inherit the label
                label[i, j] = neighbor[0]
            elif neighbor[0] == -1: # inherit the label
                label[i, j] = neighbor[1]
            elif neighbor[0] != neighbor[1]:
                l1 = min(neighbor)
                l2 = max(neighbor)
                label[i, j] = l1

                if l1 in link_history and l2 in link_history:
                    key1 = 0
                    set1 = set()
                    key2 = 0
                    set2 = set()
                    for key, link_set in link_table.items():
                        if l1 in link_set:
                            if l2 in link_set:
                                break
                            key1 = key
                            set1 = link_set
                            if(set2):
                                break
                        elif l2 in link_set:
                            key2 = key
                            set2 = link_set
                            if(set1):
                                break
                    if(not set1):
                        continue

                    link_table[key1] = set1.union(set2) # merge set2 into set1
                    for n in set2: # remap items in set2
                        link_dic[n] = key1
                    link_table.pop(key2) # remove set2

                elif l1 in link_history:
                    for key, link_set in link_table.items():
                        if l1 in link_set:
                            link_set.add(l2)
                            link_dic[l2] = key
                            link_history.add(l2)
                            break

                elif l2 in link_history:
                    for key, link_set in link_table.items():
                        if l2 in link_set:
                            link_set.add(l1)
                            link_dic[l1] = key
                            link_history.add(l1)
                            break

                else: # both not link yet
                    link_history.add(l1)
                    link_history.add(l2)
                    s = set()
                    s.add(l2)
                    s.add(l1)
                    link_table[l1] = s
                    link_dic[l2] = l1
                    link_dic[l1] = l1

    # print(link_table)
    for i in range(1, rows):
        for j in range(1, cols):
            if label[i, j] in link_history:
                label[i, j] = link_dic[label[i, j]]
            # if(label[i, j] != 0.0 and label[i, j] != -1.0):
            #     print(label[i, j])

    # cv2.imwrite("tmp_label.png", label+20)
    label_history = []
    seqlabel_dic = {}
    labelnum = 0
    for i in range(1, rows):
        for j in range(1, cols):
            if label[i, j] == -1:
                continue
            if label[i, j] not in label_history:
                label_history.append(label[i, j])
                seqlabel_dic[label[i, j]] = labelnum
                label[i, j] = labelnum
                labelnum += 1
            else:
                label[i, j] = seqlabel_dic[label[i, j]]
    # print(seqlabel_table)
    return label, labelnum


# implement hole-filling by
# labelling connected-component with sequential method
# to speed up the procedure

def Holefilling(img):
    label = Labelling(img, 255)[0] # use white as background, find black object
    bg = label[1, 1]
    rows = len(img)
    cols = len(img[0])
    hole = np.zeros((rows, cols))

    for i in range(rows):
        for j in range(cols):
            if label[i, j] != -1 and label[i, j] != bg:
                hole[i, j] = 255
    # cv2.imwrite("tmp_hole.png", hole)
    output = hole[:] + img[:]
    return output

def diagonal_fill(img):
    rows = len(img)
    cols = len(img[0])
    output = img.copy()
    for i in range(1, rows-1):
        for j in range(1, cols-1):
            if img[i, j] == 255:
                continue
            elif img[i-1, j] and img[i, j+1] and not img[i-1, j+1]:
                output[i, j] = 255
            elif img[i-1, j] and img[i, j-1] and not img[i-1, j-1]:
                output[i, j] = 255
            elif img[i+1, j] and img[i, j-1] and not img[i+1, j-1]:
                output[i, j] = 255
            elif img[i+1, j] and img[i, j+1] and not img[i+1, j+1]:
                output[i, j] = 255
    # cv2.imwrite("tmp_diagonalfill.png", output)
    return output



img = cv2.imread("hw3_sample_images/sample1.png", 0)
output = Holefilling(img)
cv2.imwrite("result2.png", output)

components = Labelling(output, 0)[1]
print("# Components after hole-filling:",components)

output2 = diagonal_fill(output)
components = Labelling(output2, 0)[1]
print("# Components after hole-filling & diagonal-fill:",components)





