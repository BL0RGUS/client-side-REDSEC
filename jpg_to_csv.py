from PIL import Image
import numpy as np
import argparse

parser = argparse.ArgumentParser(description='MNIST inference demo')
parser.add_argument('--image', dest='image', default="0.jpg")
args = parser.parse_args()

img = Image.open('mnist_sample/'+args.image)

# convert image object into array
imageToMatrix = np.asarray(img).flatten()
np.savetxt('mnist_image.csv', imageToMatrix[None], fmt="%i", delimiter=",")