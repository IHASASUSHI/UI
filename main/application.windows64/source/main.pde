import controlP5.*;
import java.util.*;

ControlP5 cp5;

Dong[][] d;
String[] Button_names = {"Calibration", "but 2", "but 3"};
int Button_num = Button_names.length;
List<controlP5.Button> Buttons = new ArrayList<controlP5.Button>();
boolean IsDrag = false;
int x = 800;
int y = 600;
int[][] dist = new int[Button_num][3];
int rx = 0;
int ry = 0;
int px = 0;
int py = 0;
int[] by = new int[Button_num];
int nx = 10;
int ny = 10;
int[] updown = new int[Button_num];
boolean IsDragged = false;

void setup() {
  
  size(800, 600);
  
  PFont pfont = createFont("Standard 07_58",5,false);
  ControlFont font = new ControlFont(pfont,40);

  cp5 = new ControlP5(this);
  
  for(int i = 0; i < Button_num ; i++) {
    Buttons.add(cp5.addButton(Button_names[i]).setPosition(0,((y + (y/4))/Button_num) * i)
    .setSize(x/2, y/4)
    .setFont(font)
    .setColorBackground(color(67,233,255))
    .setColorForeground(color(81,255,246))
    .setColorActive(color(144,255,238)));
  }
  for(int i = 0 ; i < Button_num ; i++) {
    updown[i] = 0;
  }
  
  d = new Dong[nx][ny];
  
  for (int x = 0;x<nx;x++) {
    
    for (int y = 0;y<ny;y++) {
      d[x][y] = new Dong();
    }
    
  }
  
  noStroke();
  smooth();
}


void draw() {
  background(0);
  fill(255, 100);
  
  if(mousePressed == false) {
    py = mouseY;
    for(int i = 0 ; i < 2 ; i++) {
      updown[i] = 0;
    }
    for(int i = 0 ; i < Button_num ; i++) {
    
    by[i] = (int)Buttons.get(i).getPosition()[1];
      
    }
  }
  
  rx = mouseX;
  ry = mouseY;
  
  if(IsDragged && rx < x/2) {
      println(ry + " - " + dist[2][updown[2]] + " = " + (ry - dist[2][updown[2]]));
      println(dist[2][0] + " : " + dist[2][1] + " : " + dist[2][2]);
    for(int i = 0 ; i < Button_num ; i++) {
      if(ry - dist[i][updown[i]] < 0 - Buttons.get(i).getHeight()) {
        if(updown[i] == 2 || updown[i] == 1){
          Buttons.get(i).setPosition(0 , y);
          updown[i] = 0;
        }
        else {
          Buttons.get(i).setPosition(0 , y);
          updown[i] = 1;
        }
      }
      else if(ry - dist[i][updown[i]] > y) {
        if(updown[i] == 1 || updown[i] == 2){
          Buttons.get(i).setPosition(0 , 0 - Buttons.get(i).getHeight());
          updown[i] = 0;
        }
        else {
          Buttons.get(i).setPosition(0 , 0 - Buttons.get(i).getHeight());
          updown[i] = 2;
        }
      }
      else {
        Buttons.get(i).setPosition(0 , ry - dist[i][updown[i]]);
      }
    }
  }
  
  pushMatrix();
  translate(width/2 + 150, height/2);
  rotate(frameCount*0.001);
  for (int x = 0;x<nx;x++) {
    for (int y = 0;y<ny;y++) {
      d[x][y].display();
    }
  }
  popMatrix();
}

void mousePressed() {
  for(int i = 0 ; i < Button_num ; i++) {
   dist[i][0] = py - by[i];
   dist[i][1] = -(y + Buttons.get(i).getHeight() - dist[i][0]);
   dist[i][2] = y + Buttons.get(i).getHeight() + dist[i][0];
  }
}

void mouseReleased(){
  IsDragged = false;
}

void mouseDragged() {
  IsDragged = true;
}
class Dong {
  float x, y;
  float s0, s1;

  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(100, 150);
    y = sin(f)*random(100, 150);
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
