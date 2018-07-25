class Dong {
  float x, y;
  float s0, s1;

  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(150, 250);
    y = sin(f)*random(150, 250);
    s0 = random(2, 10);
  }

  void display() {
    s1 += (s0-s1)*0.1;
    ellipse(x, y, s1, s1);
  }

  void update() {
    s1 = 50;
  }
}
