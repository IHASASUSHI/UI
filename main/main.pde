import processing.serial.*;
import controlP5.*;
import java.util.*;
import java.nio.*;
import java.io.*;
import java.awt.Robot;

ControlP5 cp5;                                       //initializing controlp5
Serial myPort;                                       //required for serial communication
String val;
boolean firstContact = false;
ByteBuffer B = ByteBuffer.allocate(4);

int milisecs = 0;
Robot MouseRepositioner;
Dong[][] d;                                          //Matrix for the UI background spinning dots
String[] Main_Button_names = {"Calibration", "Speed_Setting", "Bobbin_Setting"};
String[] Num_Pad_Button_names = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
Button zero;
Button enter;
Button Del;
Button Metric;
int Button_num = Main_Button_names.length;
int Num_Pad_Button_num = Num_Pad_Button_names.length;
List<Button> Buttons = new ArrayList<Button>();      //self explanatory self declaration for use later on to make UI elements for the main button4
Button Start;
Button Back;
Button Move_Carrage_Right;
Button Move_Carrage_Left;
Button Move_Winder_Up;
Button Move_Winder_Down;
Button Carriage_Left_Limit;
Button Carriage_Right_Limit;
Button Winder_Speed_Down;
Button Carriage_Speed_Down;
Button Winder_Speed_Up;
Button Carriage_Speed_Up;
Button test;
Button Stop;
Toggle Right;
Slider Position;
Slider Winder_Speed_Knob;
Slider Carriage_Speed_Knob;
Textfield Ammount;
Textfield Bobbin_Length;
Textfield Bobbin_Diameter;
Extender Extender = new Extender();
Retractor Retractor = new Retractor();
CallbackListener cb;
float Bobbin_Default_Length = 7011.46496815;          //hard coded value of the bobbin length
int[][] dist = new int[Button_num][3];                //distance of the mouse to the position of all the buttons and holds the values of both where the button should go if upon being hit by the edge of the screen
float x = 800;                                        //Screen Length
float y = 480;                                        //Screen Height
int ix = 800;                                         //Integer Screen Length
int iy = 480;                                         //Ineger Screen Height
int rx = 0;                                           //Mouse position x
int ry = 0;                                           //Mouse position y
int px = 0;                                           //Initial mouse position x
int py = 0;                                           //Initial mouse position y
int[] by = new int[Button_num];                       //gets the y position of the buttons on the screens
int nx = 10;                                          //Background grafix x
int ny = 10;                                          //Background grafix y
int[] updown = new int[Button_num];                   //Used to see if the main menu is being dragged up or down once a button hits the edge of the screen
int value = 0;                                        //Tells the Arduino the value inputted by the user
int Main_Menu_Selected = 0;                           //Tells the Arduino which Main Menu was selected
int Sub_Menu_Selected = 0;                            //Tells the Arduino which Sub Menu was selected
boolean IsDragged = false;                            //tells if the main menu is being dragged
boolean Is_Main_Button_Pressed_true = false;          //tells if a main menu button has bee pressed
boolean Is_Back_Button_Pressed = false;               //tells if the user has pressed the back button
boolean Is_In_Submenu = false;                        //tells if the UI is in a sub menu
boolean Is_Text_Pressed = false;                      //tells if a text box is pressed
boolean Is_Action = false;                            //tells if there is a action to be preformed by the arduino
boolean IsHold = false;                               //tells if the user is holding down a button
boolean Another_Stuid_Checker = false;                //checks if there was a response from the nubmerpad
boolean Another_Stuid_Checker_The_Second = false;     //checks if the enter button was pressed
boolean Delete = false;                               //Checks if delete button is pressed
float temp = 0;                              //Records the initial fame count upon the main menu being dragged
String holder = "";
boolean Main_checker = false;
boolean Back_checker = false;
int framerate = 10;

void setup() {

  size(800, 480);
  try {
    println(Serial.list());
    String portNum = Serial.list()[0];
    myPort = new Serial(this, portNum, 115200);
    myPort.bufferUntil('\n');
  }
  catch (ArrayIndexOutOfBoundsException ex) {
    println("ERROR, Arduino is either not connected or is not communicating. Please check the line connected to the Arduino and restart the PI");
  }
  B.order(ByteOrder.BIG_ENDIAN);
  
  try {
    MouseRepositioner = new Robot();
    MouseRepositioner.setAutoDelay(0);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  
  cp5 = new ControlP5(this);
  Create_Buttons();                         //Go to this file to see the buttons being created

  for (int i = 0; i < 2; i++) {
    updown[i] = 0;                          //Initializes the updown array to hold the positions of where to place the menu buttons when scrolled out of the screen
  }

  d = new Dong[nx][ny];                     //Fancy background thingy

  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y] = new Dong();
    }
  }

  Extender.start();
  Retractor.start();

  noStroke();
  smooth();
}

void draw() {
  background(0);
  fill(255, 100);
  
  /*if (mousePressed == false) {             //Records the position of the mouse when not pressed
    py = mouseY;
    for (int i = 0; i < Button_num; i++) {
      by[i] = (int)Buttons.get(i).getPosition()[1];
    }
  }
  rx = mouseX;                            //Records the position of the mouse
  ry = mouseY;
  Update_Position();                      //Updates the position of the main menu*/
    
  if (Ammount.isFocus() || Bobbin_Diameter.isFocus() || Bobbin_Length.isFocus()) {
    Focus_Text_box();
    if (temp == 0) {
      temp = 1;
    }
    Text_Field_Pressed(framerate);

    if (Another_Stuid_Checker) {          //got lazy naming the buttons but this one checks of a numpad was clicked
      Num_Pad_Clicked();
    }
  }
  if (Another_Stuid_Checker_The_Second) {
    Ammount.keepFocus(false);
    Ammount.setFocus(false);
    Bobbin_Diameter.keepFocus(false);
    Bobbin_Diameter.setFocus(false);
    Bobbin_Length.keepFocus(false);
    Bobbin_Length.setFocus(false);
    if (temp == 0) {
      temp = 1;
    }
    Enter_Pressed(framerate);
  }

  if (IsHold) {
    Is_Action = true;
    if (!mousePressed) {
      Sub_Menu_Selected = 0;
      IsHold = false;
      Is_Action = true;
    }
  }
  
  pushMatrix();                          //Fancy graphic thingy
  translate(width/2 + 150, height/2);
  rotate(frameCount*0.001);

  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y].display();
    }
  }
  popMatrix();
  MouseRepositioner.mouseMove(800,480);
}
