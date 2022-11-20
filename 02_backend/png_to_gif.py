import imageio
import os

images = []
for filename in os.listdir("gif"):
    images.append(imageio.imread(f"gif/{filename}"))
imageio.mimsave('heatmap.gif', images)
