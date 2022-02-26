# processing-mandelbulb
First attempt at using processing and optimization of a code from thecodingtrain.com

- there are two versions

# V1 - new edge detection
- moved n and maxinerations to global vars
- changed the while(true)-loop for a for-loop 
- added a matrix to register if the iteration for that points goes to infinity.

# V2_colour
- removed the mandelbulb-array and uses the matrix to find/render all points.
- new check returns now the number of neighbours of an edge which go to infinity
- this number also defines the colour of this point
