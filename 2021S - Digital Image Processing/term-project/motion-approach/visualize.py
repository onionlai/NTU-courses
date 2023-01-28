import cv2
import numpy as np
import time
import matplotlib.pyplot as plt
# import settings

global folder

def visualize_sparsefield(sparse_motion, image_shape, name=""):
    field = np.zeros((image_shape[0], image_shape[1], 2))
    indices = (sparse_motion[:, 0].astype(int), sparse_motion[:, 1].astype(int))
    values = sparse_motion[:, 2:]
    field[indices] = values

    plt.gca().invert_yaxis()
    plt.quiver(field[:, :, 1], field[:, :, 0], width=0.001, headwidth=2, headlength=2)
    plt.savefig(folder + "sparse_motion-" + name + ".png", dpi=200)
    plt.close()

    # hsv = np.zeros((image_shape[0], image_shape[1], 3), dtype=np.uint8)
    # hsv[..., 1] = 255
    # magnitude, angle = cv2.cartToPolar(field[..., 0], field[..., 1])
    # hsv[..., 0] = angle * 180 / np.pi / 2
    # hsv[..., 2] = cv2.normalize(magnitude, None, 0, 255, cv2.NORM_MINMAX)
    # bgr = cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)

    #cv2.imwrite(folder + "sparse_motion-" + name + ".png" , bgr)

def visualize_densefield(dense_motion, name=""):
    """
        Input:
            dense_motion: array(rows, cols, 2)
            image_shape: (rows, cols)
    """
    # some visualization code port from stackoverflow.
    hsv = np.zeros(
        (dense_motion.shape[0], dense_motion.shape[1], 3), dtype=np.uint8)
    hsv[..., 1] = 255
    magnitude, angle = cv2.cartToPolar(dense_motion[..., 0], dense_motion[..., 1])
    hsv[..., 0] = angle * 180 / np.pi / 2
    hsv[..., 2] = cv2.normalize(magnitude, None, 0, 255, cv2.NORM_MINMAX)

    # hsv[..., 2] = 200
    # hsv[..., 0] = cv2.normalize(magnitude, None, 0, 179, cv2.NORM_MINMAX)
    bgr = cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)


    # cv2.imwrite(folder + time.strftime("%H:%M:%S-")+name+"densemotion.png", bgr)
    cv2.imwrite(folder + "densemotion-" + name + ".png", bgr)


def visualize_image(img, name=""):
    # cv2.imwrite(folder + time.strftime("%H:%M:%S-")+name+"image.png", 255* img)
    cv2.imwrite(folder + name + ".png", 255* img)

def visualize_seperated_motion(bg_motion, rf_motion, image_shape, name=""):
    bgr = np.zeros((image_shape[0], image_shape[1], 3))

    indices = (bg_motion[:, 0].astype(int), bg_motion[:, 1].astype(int))
    bgr[indices] = [0, 0, 255]
    indices = (rf_motion[:, 0].astype(int), rf_motion[:, 1].astype(int))
    bgr[indices] = [0, 255, 0]

    # cv2.imwrite(folder + time.strftime("%H:%M:%S-")+name+"seperatemotion.png", bgr)
    cv2.imwrite(folder + "separate_motion-" + name + ".png", bgr)



