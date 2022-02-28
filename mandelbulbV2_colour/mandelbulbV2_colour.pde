import peasy.*;

int DIM = 128;
int n = 8;
int MAXiterations = 10;

//adding a new array to register if zeta for that point in space goes to infinty 
int[][][] infinityMatrix= new int[DIM][DIM][DIM];

//ArrayList<PVector> mandelbulb = new ArrayList<PVector>();

PeasyCam cam;

void setup(){
  size(600, 600, P3D);
  colorMode(HSB, 9);
  windowMove(1200, 100);
  cam = new PeasyCam(this, 300);  
  for (int i = 0; i < DIM; i++){
    for (int j = 0; j < DIM; j++){
      for (int k = 0; k < DIM; k++){
        
        float x = map(i, 0, DIM, -1, 1);
        float y = map(j, 0, DIM, -1, 1);
        float z = map(k, 0, DIM, -1, 1);
        PVector zeta = new PVector(0,0,0);
        
        // rewrote the while(true) loop to a for loop
        // when zeta goes to infinity the value in the infinitymatrix will be set to 1
        //otherwise the value will stay at zero
        infinityMatrix[i][j][k] = 0; //init
        for (int iteration = 0; iteration < MAXiterations; iteration++){
          Spherical c = spherical(zeta.x,zeta.y,zeta.z);
          float newx = pow(c.r, n) * sin(c.theta*n) * cos(c.phi*n);
          float newy = pow(c.r, n) * sin(c.theta*n) * sin(c.phi*n);
          float newz = pow(c.r, n) * cos(c.theta*n);
          zeta.x = newx+x;
          zeta.y = newy+y;
          zeta.z = newz+z;
          
          if (c.r > 1){
            infinityMatrix[i][j][k] = 1;
            break;
          }
        }
      }
    }
  }
  
  //infinitymatrix is filled. Now I do a second iteration over this matrix to check if a
  //point is the edge of the mandelbulb.
}

class Spherical {
  float r, theta, phi;
  Spherical (float r, float theta, float phi){
    this.r=r;
    this.theta=theta;
    this.phi=phi;
  }
}

Spherical spherical(float x, float y, float z){
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x+y*y), z);
  float phi = atan2(y, x);
  return new Spherical(r, theta, phi); 
}

void draw() {
  background(0);
  //for (PVector v: mandelbulb){
  //  stroke(255);
  //  point(v.x, v.y, v.z);
  //}
  //moved from setup:
  
  for (int i = 1; i < DIM-1; i++){
    for (int j = 1; j < DIM-1; j++){
      for (int k = 1; k < DIM-1; k++){
        int neighbourcount=checkMatrix(i,j,k);
        if (neighbourcount>0){
          float x = map(i, 0, DIM, -100, 100);
          float y = map(j, 0, DIM, -100, 100);
          float z = map(k, 0, DIM, -100, 100);
          //mandelbulb.add(new PVector(x,y,z));
          stroke(neighbourcount,7,8);
          point(x,y,z);
 
        }
      }
    }
  }
}

//in second test I will try to look at a point and see if it's finite (value in matrix is zero) and has any neigbours who is infinite (one)
//it returns the value of infinite neighbours (for adding color) 
//the iteration does not include the border for simplicity 
int checkMatrix(int i, int j, int k){
  if (infinityMatrix[i][j][k]==1){
    return 0;
  }
  int neighbourcount=0;
  for (int di=-1; di<=1; di++){
    for (int dj=-1; dj<=1; dj++){
      for (int dk=-1; dk<=1; dk++){
        if(di!=0 && dj!=0 && dk!=0){
           if (infinityMatrix[i+di][j+dj][k+dk]==1){
             neighbourcount++;
           }
        }
      }
    }
  }
  return neighbourcount;
}
