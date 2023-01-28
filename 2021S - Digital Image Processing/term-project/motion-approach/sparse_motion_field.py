import numpy as np
from scipy import signal

# Below is a implementation of "Lucas-Kanade Optical Flow algorithm"

# input 2 images as sequence, output sparse motion field (U, V)
# window_size is the size that assume to have "convservation of pixels"
# i.e. the total strength of pixels don't change in that windows,
# which is a good approximation when scale of motion is small related to the window size.

# window_size >= 3 is better. (too large will cause computation slow)
def SparseMoField(I1, I2, window_size, tau=1e-2):

    kernel_x = np.array([[-1., 1.],
                        [-1., 1.]])
    kernel_y = np.array([[-1., -1.],
                        [1., 1.]])
    kernel_t = np.array([[1., 1.],
                         [1., 1.]])#*.25

    w = (int)(window_size/2)  # window_size is odd, all the pixels with offset in between [-w, w] are inside the window
    I1 = I1 / 255. # normalize pixels
    I2 = I2 / 255. # normalize pixels

    # for each point, calculate I_x, I_y, I_t
    mode = 'same'
    fx = signal.convolve2d(I1, kernel_x, boundary='symm', mode=mode)
    fy = signal.convolve2d(I1, kernel_y, boundary='symm', mode=mode)
    ft = signal.convolve2d(I2, kernel_t, boundary='symm', mode=mode) + \
        signal.convolve2d(I1, -kernel_t, boundary='symm', mode=mode)
    U = np.zeros(I1.shape)
    V = np.zeros(I1.shape)

    # within window window_size * window_size
    for i in range(w, I1.shape[0]-w):
        for j in range(w, I1.shape[1]-w):
            if(I1[i, j] == 1):
                Ix = fx[i-w:i+w+1, j-w:j+w+1].flatten()
                Iy = fy[i-w:i+w+1, j-w:j+w+1].flatten()
                It = ft[i-w:i+w+1, j-w:j+w+1].flatten()

                b = np.reshape(It, (It.shape[0],1)) # get b here
                A = np.vstack((Ix, Iy)).T # get A here

                # if threshold τ is larger than the smallest eigenvalue of A'A, get velocity
                if np.min(abs(np.linalg.eigvals(np.matmul(A.T, A)))) >= tau:
                    nu = np.matmul(np.linalg.pinv(A), b) # get velocity here. pinv(A) means pseudo inverse = (A'A)^(-1) A'
                    U[i,j] = nu[0]
                    V[i,j] = nu[1]

    return (U,V)