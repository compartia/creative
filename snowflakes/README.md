
# Snowcode

The aim of this project is to build an aesthetically attractive graphical data coding system similar in a way to QR-codes.

![Grid](grid.png)



## Idea

Data is converted to hexadecimal representation, so we have 6 digits. 
Graphically, a digit is encoded in one of 6 colors and / or as a combination of 3 different rotations X two colors.

![Legend](order.png)

The triangular segment of the hexagonal grid was selected as the structure for placing the digits.

Triangles (or sectors) are organized by rotation and reflection into a hexagonal structure, similar to a snowflake.
Thus, the data is duplicated 12 times. This level of redundancy minimizes the error rate of a recognition system.
 
## Recognision

We've built Tensoflow/Keras ML model on top of EfficientNet to make sure the data could be reconstruted by Neural Network.
So far, the data encoded in these pretty low-res (256x256) augmented 
graphical patterns might be recoverd with ~95% accuracy. 

### Preliminary tresuts
The resuts are very promising, but more work yet to be done. 
For details, have a look at this Colab Notebook: [notebooks/snowcode_recogition.ipynb](notebooks/snowcode_recogition.ipynb)

![Some results](training_results.png)

## More sampes

![Sample](sample3.png)

![Sample](sample1.png)

![Sample](grid2.png)
