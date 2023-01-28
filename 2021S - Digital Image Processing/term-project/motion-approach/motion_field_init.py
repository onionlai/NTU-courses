import cv2
import numpy as np
from scipy import signal
from scipy.interpolate import griddata
from visualize import visualize_densefield
from visualize import visualize_sparsefield
from visualize import visualize_image
from visualize import visualize_seperated_motion

global no

def get_edgemap(img):
    global no
    # edgemap = cv2.Canny(img, threshold1=150, threshold2=65) # plaid-shirt
    # edgemap = cv2.Canny(img, threshold1=200, threshold2=80) # school
    edgemap = cv2.Canny(img, threshold1=80, threshold2=28) # my windows
    visualize_image(255* edgemap, "canny-{}".format(no))
    no += 1
    return edgemap

def get_sparse_motion(I1, I2, window_ratio = 0.01, tau=1e-2):
    """
        Implementation of "Lucas-Kanade Optical Flow algorithm"
        Input:
            I1: edge map of the image at time t
            I2: edge map of the image at time t+1 i.e. next frame
            window_size: size that assume to have "convservation of pixels"
            i.e. the total strength of pixels don't change in that windows,
            which is a good approximation when scale of motion is small related to the window size. >= 3 is better.
        Output:
            sparse_motions: [[point_y, point_x, v_y, v_x],[...],...]
    """
    window_size = I1.shape[1]*window_ratio
    w = (int)(window_size/2)  # window_size is odd, all the pixels with offset in between [-w, w] are inside the window
    print("extracting sparse motion, image size {} with window size {}".format(I1.shape, window_size))

    kernel_x = np.array([[-1., 1.],
                        [-1., 1.]])
    kernel_y = np.array([[-1., -1.],
                        [1., 1.]])
    kernel_t = np.array([[1., 1.],
                         [1., 1.]])#*.25

    I1 = I1 / 255. # normalize pixels
    I2 = I2 / 255. # normalize pixels

    # for each point, calculate I_x, I_y, I_t
    mode = 'same'
    fx = signal.convolve2d(I1, kernel_x, boundary='symm', mode=mode)
    fy = signal.convolve2d(I1, kernel_y, boundary='symm', mode=mode)
    ft = signal.convolve2d(I2, kernel_t, boundary='symm', mode=mode) + \
        signal.convolve2d(I1, -kernel_t, boundary='symm', mode=mode)
    # U = np.zeros(I1.shape)
    # V = np.zeros(I1.shape)
    sparse_motion = []

    # within window window_size * window_size
    for i in range(w, I1.shape[0]-w):
        for j in range(w, I1.shape[1]-w):
            if(I1[i, j] == 1):
                Ix = fx[i-w:i+w+1, j-w:j+w+1].flatten()
                Iy = fy[i-w:i+w+1, j-w:j+w+1].flatten()
                It = ft[i-w:i+w+1, j-w:j+w+1].flatten()

                b = np.reshape(It, (It.shape[0],1)) # get b here
                A = np.vstack((Iy, Ix)).T # get A here

                # if threshold τ is larger than the smallest eigenvalue of A'A, get velocity
                if np.min(abs(np.linalg.eigvals(np.matmul(A.T, A)))) >= tau:
                    nu = np.matmul(np.linalg.pinv(A), b) # get velocity here. pinv(A) means pseudo inverse = (A'A)^(-1) A'
                    # U[i,j] = nu[0]
                    # V[i,j] = nu[1]
                    sparse_motion.append([i, j, nu[0][0], nu[1][0]])

    #return (U,V)
    return sparse_motion

def seperate_sparse_motion(sparse_motions_points, thres=0.07):
    """
        Using cv2.findHomography method with RANSAC.
        Input:
            sparse_motions: [[point_y, point_x, v_y, v_x],[...],...]
        Output:
            2 subset of sparse_motions as array:
            array(inlier_points), array(outlier_points)

    """

    motion_points = np.array(sparse_motions_points)

    source_points = motion_points[:, :2]
    target_points = (source_points + motion_points[:, 2:])

    transform_mat, mask = cv2.findHomography(
        srcPoints=source_points,
        dstPoints=target_points,
        method=cv2.RANSAC,
        ransacReprojThreshold=thres,
    )

    inlier_points = [motion_points[i] for i in range(len(source_points)) if mask[i] == 1]
    outlier_points = [motion_points[i] for i in range(len(source_points)) if mask[i] == 0]

    return np.array(inlier_points), np.array(outlier_points)

def get_dense_motion(sparse_motion, image_shape, flag = "bg1"):
    """
        Input:
            sparse_motion:
            [[point_y, point_x, v_y, v_x],[...],...]
            image_shape: rows, cols
        Output:
            dense_motion: array(rows, cols, 2)
            [[[vy,vx], [vy,vx],...,[vy,vx]],
            [[vy,vx], [vy,vx],...,[vy,vx]],
            ...
            [[vy,vx], [vy,vx],...,[vy,vx]]]

    """
    grid_x, grid_y = np.mgrid[0:image_shape[0], 0:image_shape[1]]
    motion_points = sparse_motion[:,:2]
    motion_y_values = sparse_motion[:,2]
    motion_x_values = sparse_motion[:,3]

    interpolate_y = griddata(motion_points, motion_y_values, (grid_x, grid_y), method='nearest', fill_value=0)
    interpolate_x = griddata(motion_points, motion_x_values, (grid_x, grid_y), method='nearest', fill_value=0)

    dense_motion = np.stack([interpolate_y, interpolate_x], axis=-1)
    visualize_densefield(dense_motion, flag)
    return dense_motion

def initial_motion(images):
    """
        Input:
            images: sequence of image frame
            [array(rows, cols), array(rows, cols), ...]
        Output:
            background_motions:
            [array(rows, cols, 2), array(rows, cols, 2), ...]
            reflection_motions:
            [array(rows, cols, 2), array(rows, cols, 2), ...]

    """
    global no
    no = 1
    edge_maps = [get_edgemap(img) for img in images]
    # edge_maps = [cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) for img in images]
    sparse_motions = [get_sparse_motion(edge_maps[i], edge_maps[i+1]) for i in range(len(edge_maps)-1)]

    no = 1
    background_motions = []
    reflection_motions = []
    for sparse_motion in sparse_motions:
        # background, remain = seperate_sparse_motion(sparse_motion, thres = 0.08)
        # reflection, _ = seperate_sparse_motion(remain, thres = 0.16)
        reflection, remain = seperate_sparse_motion(sparse_motion, thres = 0.07)
        background, _ = seperate_sparse_motion(remain, thres = 0.16)

        ###
        print("find {} motion points; classify {} as background, {} as reflection".format(len(sparse_motion), len(background), len(reflection)))
        visualize_sparsefield(background, images[0].shape, "bg{}".format(no))
        visualize_sparsefield(reflection, images[0].shape, "rf{}".format(no))
        visualize_seperated_motion(background, reflection, images[0].shape, str(no))
        ###

        background_motions.append(get_dense_motion(background, images[0].shape, flag = "bg{}".format(no)))
        reflection_motions.append(get_dense_motion(reflection, images[0].shape, flag = "rf{}".format(no)))
        no += 1

    return background_motions, reflection_motions

def warping_image(img, motions):
    """
        Input:
            img: one image frame. normalized
            motions:
        Output: 3 1d-array to discribe new warping image.
            warp_y: index_y in image
            warp_x: index_x in image
            warp_img: pixel of warp_img[idx] correspond to (index_y[idx], index_x[idx])

    """
    rows, cols = img.shape[:2]
    x_index, y_index = np.meshgrid(range(cols), range(rows))
    warp_x = x_index + motions[y_index, x_index, 1]
    warp_y = y_index + motions[y_index, x_index, 0]
    # new warp index = index + motion

    warp_valid_y, warp_valid_x = np.where((warp_y >= 0) & (warp_x >= 0) & (warp_y < rows) & (warp_x < cols))

    # warp_y, warp_x -> 1-dim array with valid index_ys, index_xs
    warp_y = warp_y[warp_valid_y, warp_valid_x].astype(int)
    warp_x = warp_x[warp_valid_y, warp_valid_x].astype(int)

    # warp_img -> 1-dim array with valid pixel
    warp_img = img[y_index[warp_valid_y, warp_valid_x], x_index[warp_valid_y, warp_valid_x]]
    return warp_y, warp_x, warp_img

def align_background(It, background_motions):
    """
        Input:
            It: sequence of image frame
            [array(rows, cols), array(rows, cols), ...]
            background_motions:
            [array(rows, cols, 2), array(rows, cols, 2), ...]
        Output:
            Ib: a single aligned background image
            array(rows, cols, channel)
    """
    print("Use frame {} as reference".format(len(background_motions)//2))

    rows, cols, channel = It.shape[1:4]
    Ib = np.ones((rows, cols, channel)) # init as all 1 (max)
    for frame_id in range(len(background_motions)):
        warp_y, warp_x, warp_img = warping_image(It[frame_id,:,:,:], background_motions[frame_id])
        Ib[warp_y, warp_x, :] = np.minimum(Ib[warp_y, warp_x, :], warp_img) # each iterate, update Ib
        # the "hole"(idx not in warp_y, warp_x) automatically filled with original 1
    return Ib

def initialize_motion_based_decomposition(images):
    reflection_motions, background_motions = initial_motion(images)

    reflection_motions = np.array(reflection_motions[:2] + [np.zeros_like(reflection_motions[0])] + reflection_motions[2:]) # zero motion at reference frame[2]
    background_motions = np.array(background_motions[:2] + [np.zeros_like(background_motions[0])] + background_motions[2:]) # zero motion at reference frame[2]

    Vr_init = reflection_motions
    Vb_init = background_motions
    It = np.array([img / 255. for img in images])
    Ib_init = align_background(It, background_motions)
    # Ir_init = align_background(It, reflection_motions)
    Ir_init = It[2] - Ib_init

    visualize_image(Ib_init, "bg")
    visualize_image(Ir_init, "rf")
    return It, Ir_init, Ib_init, Vr_init, Vb_init
