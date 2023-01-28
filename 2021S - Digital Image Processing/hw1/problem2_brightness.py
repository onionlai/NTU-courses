import cv2
import matplotlib.pyplot as plt

def change_brightness(origin_image, multi_value=1):
    image = origin_image.copy()
    for y in range(len(image)):
        for x in range(len(image[0])):
            if( image[y][x]*multi_value < 256):
                image[y][x] *= multi_value
            else:
                image[y][x] = 255
    return image

img = cv2.imread("./hw1_sample_images/sample2.jpg", 0)
img_dark = change_brightness(img, 1/5)
cv2.imwrite("3_result.jpg", img_dark)

img_bright = change_brightness(img, 5)
cv2.imwrite("4_result.jpg", img_bright)

# fig, axes = plt.subplots(3,1)
# axes[0].set_title('original')
# axes[0].hist(img.ravel(), 256, [0,256])
# axes[1].set_title('reduce brightness')
# axes[1].hist(img_dark.ravel(), 256, [0,256])
# axes[2].set_title('increase brightness')
# axes[2].hist(img_bright.ravel(), 256, [0,256])
# fig.suptitle('Histogram')
# for ax in axes.flat:
#     ax.set(ylabel='# of pixels')
# fig.tight_layout()
# plt.savefig('Histogram.png', format='png')
# plt.show()
# plt.close()
