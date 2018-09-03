class Extender extends Thread {
  boolean running;
  int count = 0;
  boolean limitedFramerate = true; //Disables the frame limiting, go as fast as it can!

  Extender() {
    running = false;
    count = 0;
  }

  void start() {
    running = true;
    super.start();
  }

  void run() {
    while (running) {
      boolean runIt = false;
      
      if (limitedFramerate) {
        if (count > 1000) {
          runIt = true;
        }
      }
      else {
        runIt = true;
      }

      if (runIt) {
        if (Is_Main_Button_Pressed_true) {      //checks when a certain button is pressed with these series of if statements
          if (temp == 0) {                      //temp is used to store the initial frame count upon update position being called
            Main_checker = false;
            Back_checker = false;
            temp = 1;
          }
          else {
            Main_Button_Pressed(framerate);
          }
        }
        if (Is_Back_Button_Pressed) {
          if (temp == 0) {
            Main_checker = false;
            Back_checker = false;
            temp = 1;
          }
          else {
            Back_Button_Pressed(framerate);
          }
        }
        count = 0;
        delay(10);
      }
      count++;
    }
  }

  void quit() {
    running = false;
    interrupt();
  }
}
