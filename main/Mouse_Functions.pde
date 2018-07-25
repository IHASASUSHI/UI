void mousePressed() {
  for (int i = 0; i < Button_num; i++) {
    dist[i][0] = py - by[i];
    dist[i][1] = -(iy + Buttons.get(i).getHeight() - dist[i][0]);  //to pop the button to the bottom of the screen
    dist[i][2] = iy + Buttons.get(i).getHeight() + dist[i][0];     //to pop the button to the top of the screen
  }
}

void mouseReleased() {
  IsHold = false;
  IsDragged = false;
  for (int i = 0; i < 2; i++) {
    updown[i] = 0;
  }
}

void mouseDragged() {
  IsDragged = true;
}
