import cv2
import os
import time
import glob
import argparse

import visualize
from motion_field_init import initialize_motion_based_decomposition

def read_images(image_dir):
    image_paths = sorted(glob.glob(os.path.join(image_dir, "*")))
    images = [cv2.imread(image_path) for image_path in image_paths]
    return images

def make_result_folder():
    visualize.folder = (time.strftime("output-%m%d-%H-%M")+"/")
    os.mkdir(visualize.folder)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("images_dir", help="path to the image directory")
    args = parser.parse_args()

    make_result_folder()

    images = read_images(args.images_dir)
    print("read {} images".format(len(images)))

    It, Ir_init, Ib_init, Vr_init, Vb_init = initialize_motion_based_decomposition(images)

    ## todo: optimization

if __name__ == '__main__':
    main()