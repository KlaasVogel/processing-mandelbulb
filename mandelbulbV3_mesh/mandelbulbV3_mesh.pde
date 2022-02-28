import peasy.*;

int DIM = 128;
int n = 8;
int MAXiterations = 10;
MandelBulb mandelbulb;
PeasyCam cam;

void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 9);
  windowMove(1200, 100);
  cam = new PeasyCam(this, 500);
  mandelbulb = new MandelBulb(DIM);
}

class LatticePoint {
  boolean infinite, edge;
  int neighbours;
  LatticePoint () {
    this.infinite=false;
    this.edge=false;
    this.neighbours=0;
  }
}

class MandelBulb {
  int dim;
  LatticePoint[][][] points;
  MandelBulb(int dim) {
    this.dim=dim;
    this.points = new LatticePoint[dim][dim][dim];
    this.calculate();
    this.find_edge();
  }

  void calculate() {
    for (int i = 0; i < this.dim; i++) {
      for (int j = 0; j < this.dim; j++) {
        for (int k = 0; k < this.dim; k++) {
          this.points[i][j][k] = new LatticePoint();
          float x = map(i, 0, this.dim, -1, 1);
          float y = map(j, 0, this.dim, -1, 1);
          float z = map(k, 0, this.dim, -1, 1);
          PVector zeta = new PVector(0, 0, 0);
          for (int iteration = 0; iteration < MAXiterations; iteration++) {
            Spherical c = spherical(zeta.x, zeta.y, zeta.z);
            float newx = pow(c.r, n) * sin(c.theta*n) * cos(c.phi*n);
            float newy = pow(c.r, n) * sin(c.theta*n) * sin(c.phi*n);
            float newz = pow(c.r, n) * cos(c.theta*n);
            zeta.x = newx+x;
            zeta.y = newy+y;
            zeta.z = newz+z;

            if (c.r > sqrt(3)) {
              this.points[i][j][k].infinite = true;
              break;
            }
          }
        }
      }
    }
  }

  void find_edge() {
    for (int i = 1; i < this.dim-1; i++) {
      for (int j = 1; j < this.dim-1; j++) {
        for (int k = 1; k < this.dim-1; k++) {
          if (!this.points[i][j][k].infinite) {
            for (int di=-1; di<=1; di++) {
              for (int dj=-1; dj<=1; dj++) {
                for (int dk=-1; dk<=1; dk++) {
                  if (this.points[i+di][j+dj][k+dk].infinite) {
                    this.points[i][j][k].edge=true;
                    this.points[i][j][k].neighbours++;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void draw_edge() {
    for (int i = 1; i < this.dim-1; i++) {
      for (int j = 1; j < this.dim-1; j++) {
        for (int k = 1; k < this.dim-1; k++) {
          if (this.points[i][j][k].edge) {
            stroke(this.points[i][j][k].neighbours, 7, 8);
            float x = map(i, 0, this.dim, -200, 200);
            float y = map(j, 0, this.dim, -200, 200);
            float z = map(k, 0, this.dim, -200, 200);
            point(x, y, z);
          }
        }
      }
    }
  }

  void draw_mesh() { //doesn't work right.
    for (int i = 0; i < this.dim; i++) {
      for (int j = 0; j < this.dim; j++) {
        for (int k = 0; k < this.dim; k++) {
          if (this.points[i][j][k].edge) {
            for (int di=-1; di<=1; di++) {
              for (int dj=-1; dj<=1; dj++) {
                for (int dk=-1; dk<=1; dk++) {
                  if (this.points[i+di][j+dj][k+dk].edge) {
                    stroke(this.points[i][j][k].neighbours, 7, 8);
                    float x1 = map(i, 0, this.dim, -100, 100);
                    float x2 = map(i+di, 0, this.dim, -100, 100);
                    float y1 = map(j, 0, this.dim, -100, 100);
                    float y2 = map(j+dj, 0, this.dim, -100, 100);
                    float z1 = map(k, 0, this.dim, -100, 100);
                    float z2 = map(k+dk, 0, this.dim, -100, 100);
                    line(x1, y1, z1, x2, y2, z2);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void draw_infinite_points() {
    stroke(255);
    for (int i = 0; i < this.dim; i++) {
      for (int j = 0; j < this.dim; j++) {
        for (int k = 0; k < this.dim; k++) {
          if (this.points[i][j][k].infinite) {
            float x = map(i, 0, this.dim, -100, 100);
            float y = map(j, 0, this.dim, -100, 100);
            float z = map(k, 0, this.dim, -100, 100);
            point(x, y, z);
          }
        }
      }
    }
  }

  void draw_lattice() {
    stroke(128);
    for (int i = 0; i < this.dim; i++) {
      for (int j = 0; j < this.dim; j++) {
        for (int k = 0; k < this.dim; k++) {
          float x = map(i, 0, this.dim, -100, 100);
          float y = map(j, 0, this.dim, -100, 100);
          float z = map(k, 0, this.dim, -100, 100);
          point(x, y, z);
        }
      }
    }
  }
}

class Spherical {
  float r, theta, phi;
  Spherical (float r, float theta, float phi) {
    this.r=r;
    this.theta=theta;
    this.phi=phi;
  }
}

Spherical spherical(float x, float y, float z) {
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x+y*y), z);
  float phi = atan2(y, x);
  return new Spherical(r, theta, phi);
}

void draw() {
  background(0);
  //mandelbulb.draw_lattice();
  //mandelbulb.draw_infinite_points();
  mandelbulb.draw_edge();
  //mandelbulb.draw_mesh();
}
