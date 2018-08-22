import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import controlP5.*; 
import java.util.*; 
import java.nio.*; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {







ControlP5 cp5;                                       //initializing controlp5
Serial myPort;                                       //required for serial communication
String val;
boolean firstContact = false;
ByteBuffer B = ByteBuffer.allocate(4);

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
float Bobbin_Default_Length = 7011.46496815f;          //hard coded value of the bobbin length
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
float temp = frameCount;                              //Records the initial fame count upon the main menu being dragged
String holder = "";

public void setup() {

  
  println(Serial.list());
  String portNum = Serial.list()[0];
  myPort = new Serial(this, portNum, 115200);
  myPort.bufferUntil('\n');
  B.order(ByteOrder.BIG_ENDIAN);

  cp5 = new ControlP5(this);
  for (int i = 0; i < 2; i++) {
    updown[i] = 0;                          //Initializes the updown array to hold the positions of where to place the menu buttons when scrolled out of the screen
  }
  Create_Buttons();                         //Go to this file to see the buttons being created

  d = new Dong[nx][ny];                     //Fancy background thingy

  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y] = new Dong();
    }
  }

  noStroke();
  
}

public void draw() {
  background(0);
  fill(255, 100);

  if (mousePressed == false) {             //Records the position of the mouse when not pressed
    py = mouseY;
    for (int i = 0; i < Button_num; i++) {
      by[i] = (int)Buttons.get(i).getPosition()[1];
    }
  }
  rx = mouseX;                            //Records the position of the mouse
  ry = mouseY;
  Update_Position();                      //Updates the position of the main menu

  if (Is_Main_Button_Pressed_true) {      //checks when a certain button is pressed with these series of if statements
    if (temp == 0) {                      //temp is used to store the initial frame count upon update position being called
      temp = frameCount;                  //processing has a internal framecounter
    }
    Main_Button_Pressed(frameCount);
  }
  if (Is_Back_Button_Pressed) {
    if (temp == 0) {
      temp = frameCount;
    }
    Back_Button_Pressed(frameCount);
  }
  if (Ammount.isFocus() || Bobbin_Diameter.isFocus() || Bobbin_Length.isFocus()) {
    Focus_Text_box();
    if (temp == 0) {
      temp = frameCount;
    }
    Text_Field_Pressed(frameCount);

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
      temp = frameCount;
    }
    Enter_Pressed(frameCount);
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
  rotate(frameCount*0.001f);
  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y].display();
    }
  }
  popMatrix();
}
/*
This whole file is used to store all the methods for extending or retracting certain button sets
*/

public boolean Extend_Main_button(float frames) {
  if (Buttons.get(0).getPosition()[0] >= 0) {
    return true;
  }
  else {
    for (int i = 0; i < Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] + (frames - temp), Buttons.get(i).getPosition()[1]);
    }
     Start.setPosition(Start.getPosition()[0] - (frames - temp), Start.getPosition()[1]);
    return false;
  }
}

public boolean Retract_Main_button(float frames) {
  if (Buttons.get(0).getPosition()[0] <= -x/2) {
    return true;
  }
  else {
    for (int i = 0; i < Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] - (frames - temp), Buttons.get(i).getPosition()[1]);
    }
     Start.setPosition(Start.getPosition()[0] + (frames - temp), Start.getPosition()[1]);
    return false;
  }
}

public boolean Retract_Back_Button(float frames) {
  if (Back.getPosition()[1] <= -y/8) {
    return true;
  }
  else {
    Back.setPosition(0, Back.getPosition()[1] - (frames - temp)/5);
    return false;
  }
}

public boolean Extend_Back_Button(float frames) {
  if (Back.getPosition()[1] >= 0) {
    return true;
  }
  else {
    Back.setPosition(0, Back.getPosition()[1] + (frames - temp)/5);
    return false;
  }
}

public boolean Retract_Manual_Control(float frames) {
  if (Move_Carrage_Right.getPosition()[1] >= y + y/2) {
    return true;
  } else {
    Position.setPosition(Position.getPosition()[0], Position.getPosition()[1] - (frames - temp)*1.7f);
    Move_Carrage_Right.setPosition(Move_Carrage_Right.getPosition()[0], Move_Carrage_Right.getPosition()[1] + (frames - temp)*1.7f);
    Move_Carrage_Left.setPosition(Move_Carrage_Left.getPosition()[0], Move_Carrage_Left.getPosition()[1] + (frames - temp)*1.7f);
    Move_Winder_Up.setPosition(Move_Winder_Up.getPosition()[0], Move_Winder_Up.getPosition()[1] + (frames - temp)*1.7f);
    Move_Winder_Down.setPosition(Move_Winder_Down.getPosition()[0], Move_Winder_Down.getPosition()[1] + (frames - temp)*1.7f);
    Carriage_Right_Limit.setPosition(Carriage_Right_Limit.getPosition()[0], Carriage_Right_Limit.getPosition()[1] - (frames - temp)*1.7f);
    Carriage_Left_Limit.setPosition(Carriage_Left_Limit.getPosition()[0], Carriage_Left_Limit.getPosition()[1] - (frames - temp)*1.7f);
    return false;
  }
}

public boolean Extend_Manual_Control(float frames) {
  if (Move_Carrage_Right.getPosition()[1] <= y/2) {
    return true;
  }
  else {
    Position.setPosition(Position.getPosition()[0], Position.getPosition()[1] + (frames - temp)*1.7f);
    Move_Carrage_Right.setPosition(Move_Carrage_Right.getPosition()[0], Move_Carrage_Right.getPosition()[1] - (frames - temp)*1.7f);
    Move_Carrage_Left.setPosition(Move_Carrage_Left.getPosition()[0], Move_Carrage_Left.getPosition()[1] - (frames - temp)*1.7f);
    Move_Winder_Up.setPosition(Move_Winder_Up.getPosition()[0], Move_Winder_Up.getPosition()[1] - (frames - temp)*1.7f);
    Move_Winder_Down.setPosition(Move_Winder_Down.getPosition()[0], Move_Winder_Down.getPosition()[1] - (frames - temp)*1.7f);
    Carriage_Right_Limit.setPosition(Carriage_Right_Limit.getPosition()[0], Carriage_Right_Limit.getPosition()[1] + (frames - temp)*1.7f);
    Carriage_Left_Limit.setPosition(Carriage_Left_Limit.getPosition()[0], Carriage_Left_Limit.getPosition()[1] + (frames - temp)*1.7f);
    return false;
  }
}

public boolean Retract_Speed_Settings (float frames) {   
  if (Carriage_Speed_Down.getPosition()[1] >= y + y/2 - y/5) {
    return true;
  }
  else {
    Carriage_Speed_Down.setPosition(Carriage_Speed_Down.getPosition()[0], Carriage_Speed_Down.getPosition()[1] + (frames - temp)*1.7f);
    Winder_Speed_Down.setPosition(Winder_Speed_Down.getPosition()[0], Winder_Speed_Down.getPosition()[1] + (frames - temp)*1.7f);
    Carriage_Speed_Up.setPosition(Carriage_Speed_Up.getPosition()[0], Carriage_Speed_Up.getPosition()[1] + (frames - temp)*1.7f);
    Winder_Speed_Up.setPosition(Winder_Speed_Up.getPosition()[0], Winder_Speed_Up.getPosition()[1] + (frames - temp)*1.7f);
    Winder_Speed_Knob.setPosition(Winder_Speed_Knob.getPosition()[0], Winder_Speed_Knob.getPosition()[1] - (frames - temp)*1.7f);
    Carriage_Speed_Knob.setPosition(Carriage_Speed_Knob.getPosition()[0], Carriage_Speed_Knob.getPosition()[1] - (frames - temp)*1.7f);
    test.setPosition(test.getPosition()[0], test.getPosition()[1] - (frames - temp)/5);
    Stop.setPosition(Stop.getPosition()[0], Stop.getPosition()[1] - (frames - temp)/5);
    return false;
  }
}

public boolean Extend_Speed_Settings (float frames) {   
  if (Carriage_Speed_Down.getPosition()[1] <= y/2 - y/5) {
    return true;
  }
  else {
    Carriage_Speed_Down.setPosition(Carriage_Speed_Down.getPosition()[0], Carriage_Speed_Down.getPosition()[1] - (frames - temp)*1.7f);
    Winder_Speed_Down.setPosition(Winder_Speed_Down.getPosition()[0], Winder_Speed_Down.getPosition()[1] - (frames - temp)*1.7f);
    Carriage_Speed_Up.setPosition(Carriage_Speed_Up.getPosition()[0], Carriage_Speed_Up.getPosition()[1] - (frames - temp)*1.7f);
    Winder_Speed_Up.setPosition(Winder_Speed_Up.getPosition()[0], Winder_Speed_Up.getPosition()[1] - (frames - temp)*1.7f);
    Winder_Speed_Knob.setPosition(Winder_Speed_Knob.getPosition()[0], Winder_Speed_Knob.getPosition()[1] + (frames - temp)*1.7f);
    Carriage_Speed_Knob.setPosition(Carriage_Speed_Knob.getPosition()[0], Carriage_Speed_Knob.getPosition()[1] + (frames - temp)*1.7f);
    test.setPosition(test.getPosition()[0], test.getPosition()[1] + (frames - temp)/5);
    Stop.setPosition(Stop.getPosition()[0], Stop.getPosition()[1] + (frames - temp)/5);
    return false;
  }
}

public boolean Retract_Bobbin_Settings(float frames) {   
  if (Ammount.getPosition()[1] >= y + y/2 - y/3) {
    return true;
  } else {
    Ammount.setPosition(Ammount.getPosition()[0], Ammount.getPosition()[1] + (frames - temp)*1.7f);
    Bobbin_Diameter.setPosition(Bobbin_Diameter.getPosition()[0], Bobbin_Diameter.getPosition()[1] + (frames - temp)*1.7f);
    Bobbin_Length.setPosition(Bobbin_Length.getPosition()[0], Bobbin_Length.getPosition()[1] + (frames - temp)*1.7f);
    return false;
  }
}

public boolean Extend_Bobbin_Settings(float frames) {   
  if (Ammount.getPosition()[1] <= y/2 - y/3) {
    return true;
  } else {
    Ammount.setPosition(Ammount.getPosition()[0], Ammount.getPosition()[1] - (frames - temp)*1.7f);
    Bobbin_Diameter.setPosition(Bobbin_Diameter.getPosition()[0], Bobbin_Diameter.getPosition()[1] - (frames - temp)*1.7f);
    Bobbin_Length.setPosition(Bobbin_Length.getPosition()[0], Bobbin_Length.getPosition()[1] - (frames - temp)*1.7f);
    return false;
  }
}

public boolean Retract_Num_Pad(float frames) {   
  if (Metric.getPosition()[0] >= x + x/1.8f + (((x + 5)/10) * 2)) {
    return true;
  }
  else {
    for (int i = 3; i < Num_Pad_Button_num + Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] + (frames - temp), Buttons.get(i).getPosition()[1]);
    }
    Metric.setPosition(Metric.getPosition()[0] + (frames - temp), Metric.getPosition()[1]);
    enter.setPosition(enter.getPosition()[0] + (frames - temp), enter.getPosition()[1]);
    zero.setPosition(zero.getPosition()[0] + (frames - temp), zero.getPosition()[1]);
    Del.setPosition(Del.getPosition()[0] + (frames - temp), Del.getPosition()[1]);
    return false;
  }
}

public boolean Extend_Num_Pad(float frames) {   
  if (Metric.getPosition()[0] <= x/1.8f + (((x + 5)/10) * 2)) {
    return true;
  }
  else {
    for (int i = 3; i < Num_Pad_Button_num + Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] - (frames - temp), Buttons.get(i).getPosition()[1]);
    }
    Metric.setPosition(Metric.getPosition()[0] - (frames - temp), Metric.getPosition()[1]);
    enter.setPosition(enter.getPosition()[0] - (frames - temp), enter.getPosition()[1]);
    zero.setPosition(zero.getPosition()[0] - (frames - temp), zero.getPosition()[1]);
    Del.setPosition(Del.getPosition()[0] - (frames - temp), Del.getPosition()[1]);
    return false;
  }
}
/*
This whole file is used to store "most" the methods for what the buttons do

do note that some of the buttons have callback functions which act as a secondary method that is enacted depending on the way they were programmed to act
*/

public void Calibration() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 1;
  }
}
public void Speed_Setting() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 2;
  }
}
public void Bobbin_Setting() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 3;
  }
}
public void Start() {
   if (IsDragged == false) {
    Main_Menu_Selected = 4;
    Sub_Menu_Selected = 0;
    value = 0;
    Is_Action = true;
  }
}


public void Back() {
  if (IsDragged == false) {
    Is_In_Submenu = false;  
    Is_Back_Button_Pressed = true;
    value = 1;
  }
}

public void Move_Carrage_Right() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 2;
    value = 1;
  }
}
public void Move_Carrage_Left() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 1;
    value = 1;
  }
}

public void Move_Winder_Up() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 3;
    value = 1;
  }
}
public void Move_Winder_Down() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 4;
    value = 1;
  }
}
public void Zero() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 5;
    value = 1;
  }
}
public void Auto() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 6;
    value = 1;
  }
}
public void positon(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 7;
  value = position;
}


public void Winder_Speed_Down() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 1;
    if (Winder_Speed_Knob.getValue() * 67 - 100 < 0) {
      value = (int)Winder_Speed_Knob.getValue() * 67;
    }
    else {
      value = (int)Winder_Speed_Knob.getValue() * 67 - 100;
      Winder_Speed_Knob.setValue(Winder_Speed_Knob.getValue() - 100 / 67);
    }
    Winder_Speed_Knob.update();
  }
}

public void Carriage_Speed_Down() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 2;
    if (Carriage_Speed_Knob.getValue() * 67 - 100 < 0) {
      value = (int)Carriage_Speed_Knob.getValue() * 67;
    }
    else {
      value = (int)Carriage_Speed_Knob.getValue() * 67 - 100;
      Carriage_Speed_Knob.setValue(Carriage_Speed_Knob.getValue() - 100 / 67);
    }
    Carriage_Speed_Knob.update();
  }
}

public void Winder_Speed_Up() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 3;
    if (Winder_Speed_Knob.getValue() * 67 + 100 > 100000) {
      value = (int)Winder_Speed_Knob.getValue() * 67;
    }
    else {
      value = (int)(Winder_Speed_Knob.getValue() * 67) + 100;
      Winder_Speed_Knob.setValue(Winder_Speed_Knob.getValue() + 100 / 67);
    }
    Winder_Speed_Knob.update();
  }
}

public void Carriage_Speed_Up() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 4;
    if (Carriage_Speed_Knob.getValue() * 67 - 100 > 100000) {
      value = (int)Carriage_Speed_Knob.getValue() * 67;
    }
    else {
      value = (int)(Carriage_Speed_Knob.getValue() * 67) + 100;
      Carriage_Speed_Knob.setValue(Carriage_Speed_Knob.getValue() + 100 / 67);
    }
    Carriage_Speed_Knob.update();
  }
}

public void Winder_Speed_Knob(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 5;
  value = position * 67;
}

public void Carriage_Speed_Knob(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 6;
  value = position * 67;
}

public void test() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 7;
    value = 1;
    test.hide();
    test.setBroadcast(false);
    Stop.show();
    Stop.setBroadcast(true);
  }
}

public void Stop() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 8;
    value = 1;
    Stop.hide();
    Stop.setBroadcast(false);
    test.show();
    test.setBroadcast(true);
  }
}

public void enter() {
  if (IsDragged == false) {
    Is_Action = true;
    if (Ammount.isFocus()) {
      Sub_Menu_Selected = 1;
      if(Ammount.getText().equals("")) {
      value = 0;
      }
      else {
      value = parseInt(Ammount.getText(), 10);
      }
    }
    else if (Bobbin_Diameter.isFocus()) {
      Sub_Menu_Selected = 2;
      if(Bobbin_Diameter.getText().equals("")) {
      value = 0;
      }
      else {
      value = parseInt(Bobbin_Diameter.getText(), 10);
      }
    }
    else if (Bobbin_Length.isFocus()) {
      Sub_Menu_Selected = 3;
      if(Bobbin_Length.getText().equals("")) {
      value = 0;
      }
      else {
      value = parseInt(Bobbin_Length.getText(), 10);
      }
    }
    Another_Stuid_Checker_The_Second = true;
  }
}
public void Del() {
  if (IsDragged == false && !Ammount.getText().isEmpty()) {
    holder = "";
    Another_Stuid_Checker = true;
    Delete = true;
  }
}
/*
This whole file is used to store the long as fuck initialization of every single button

I hate seeing a large ass main file.
*/

public void Create_Buttons() {
    Start = cp5.addButton("Start").setPosition(x - x/4, 0);
  Style_Start_Button("Start");
  for (int i = 0; i < Button_num; i++) {
    Buttons.add(cp5.addButton(Main_Button_names[i]).setPosition(0, ((y + (y/4))/Button_num) * i));
    Style_Main_Buttons(Main_Button_names[i]);
    updown[i] = 0;
  }
  Back = cp5.addButton("Back").setPosition(0, -y/8);
  Style_back_Buttons("Back");

  Position = cp5.addSlider("positon").setPosition(x/2 - x/4, y/22 - y)
    .setRange(0, Bobbin_Default_Length)
    .setSliderMode(Slider.FLEXIBLE);
  Style_Position_Buttons("positon");
  Move_Carrage_Left = cp5.addButton("Move_Carrage_Left").setPosition(x/2 - x/4, y + y/2)
    .activateBy(ControlP5.PRESSED)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        IsHold = true;
      }
    }
  }
  );
  Style_Sub_Buttons("Move_Carrage_Left");
  Move_Carrage_Right = cp5.addButton("Move_Carrage_Right").setPosition(x/2 + x/(12), y + y/2)
    .activateBy(ControlP5.PRESSED)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        IsHold = true;
      }
    }
  }
  );
  Style_Sub_Buttons("Move_Carrage_Right");
  Move_Winder_Up = cp5.addButton("Move_Winder_Up").setPosition(x/2 - x/12, y + y/3);
  Style_Sub_Buttons("Move_Winder_Up");
  Move_Winder_Down = cp5.addButton("Move_Winder_Down").setPosition(x/2 - x/12, y + y/1.5f);
  Style_Sub_Buttons("Move_Winder_Down");
  Carriage_Right_Limit = cp5.addButton("Auto").setPosition(x/2 + x/6 + x/10, y/2 - y/3 - y);
  Style_Sub_Buttons("Auto");
  Carriage_Left_Limit = cp5.addButton("Zero").setPosition(x/2 - 2*x/6 - x/10, y/2 - y/3 - y);
  Style_Sub_Buttons("Zero");

  test = cp5.addButton("test").setPosition(x - x/8, -y/8);
  Style_back_Buttons("test");
  Stop = cp5.addButton("Stop").setPosition(x - x/8, -y/8)
    .hide()
    .setBroadcast(false);
  Style_back_Buttons("Stop");
  Winder_Speed_Down = cp5.addButton("Winder_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/5 + y/2);
  Style_Sub_Buttons("Winder_Speed_Down");
  Carriage_Speed_Down = cp5.addButton("Carriage_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/5);
  Style_Sub_Buttons("Carriage_Speed_Down");
  Winder_Speed_Up = cp5.addButton("Winder_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/5 + y/2);
  Style_Sub_Buttons("Winder_Speed_Up");
  Carriage_Speed_Up = cp5.addButton("Carriage_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/5);
  Style_Sub_Buttons("Carriage_Speed_Up");
  Winder_Speed_Knob = cp5.addSlider("Winder_Speed_Knob").setPosition(x/2 - x/5, y/2 + y/4 - y)
    .setNumberOfTickMarks(50)
    .snapToTickMarks(false)
    .setRange(1, 20000/67)
    .setValue(20000/67);
  Style_Knob_Buttons("Winder_Speed_Knob");
  Carriage_Speed_Knob = cp5.addSlider("Carriage_Speed_Knob").setPosition(x/2 - x/5, y/2 - y/4 - y)
    .setNumberOfTickMarks(50)
    .snapToTickMarks(false)
    .setRange(1, 20000/67)
    .setValue(20000/67);
  Style_Knob_Buttons("Carriage_Speed_Knob");  

  Ammount = cp5.addTextfield("Ammount").setPosition(x/2 - x/3, y + y/2 - y/3)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        Is_Text_Pressed = true;
      }
    }
  }
  )
  .setText("");
  Style_Text_Feild("Ammount");
  Bobbin_Diameter = cp5.addTextfield("Bobbin_Diameter").setPosition(x/2 - x/3, y + y/2 - y/5)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        Is_Text_Pressed = true;
      }
    }
  }
    )
  .setText("");
  Style_Text_Feild("Bobbin_Diameter");
  Bobbin_Length = cp5.addTextfield("Bobbin_Length").setPosition(x/2 - x/3, y + y/2 - y/15)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        Is_Text_Pressed = true;
      }
    }
  }
  )
  .setText("");
  Style_Text_Feild("Bobbin_Length");
  for (int i = 0, j = 0, k = 0; i < Num_Pad_Button_num; i++, k++) {
    Buttons.add(cp5.addButton(Num_Pad_Button_names[i])
      .setPosition(x + x/1.8f + (((x + 5)/10) * k), y/5 + (((y + 5)/10) * j)));
    Style_Number_Pad(Num_Pad_Button_names[i]);

    if (k == 2) {
      k = -1;
      j++;
    }
  }
  Metric = cp5.addButton("in").setPosition(x + x/1.8f + (((x + 5)/10) * 2), y/5 + (((y + 5)/10) * 3));
  Style_Number_Pad("in");
  zero = cp5.addButton("0").setPosition(x + x/1.8f + (((x + 5)/10) * 0), y/5 + (((y + 5)/10) * 3))
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        holder = theEvent.getController().getName();
        Another_Stuid_Checker = true;
      }
    }
  }
  );
  Style_Sub_Number_Pad("0");
  enter = cp5.addButton("enter").setPosition(x + x/1.8f + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 0));
  Style_Sub_2_Number_Pad("enter");
  Del = cp5.addButton("Del").setPosition(x + x/1.8f + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 2));
  Style_Sub_2_Number_Pad("Del");
}
/*
Fancy graphic thingy
*/

class Dong {
  float x, y;
  float s0, s1;

  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(150, 250);
    y = sin(f)*random(150, 250);
    s0 = random(2, 10);
  }

  public void display() {
    s1 += (s0-s1)*0.1f;
    ellipse(x, y, s1, s1);
  }

  public void update() {
    s1 = 50;
  }
}
/*
This whole file is used to store all the methods for mouse functions
*/

public void mousePressed() {
  for (int i = 0; i < Button_num; i++) {
    dist[i][0] = py - by[i];
    dist[i][1] = -(iy + Buttons.get(i).getHeight() - dist[i][0]);  //to pop the button to the bottom of the screen
    dist[i][2] = iy + Buttons.get(i).getHeight() + dist[i][0];     //to pop the button to the top of the screen
  }
}

public void mouseReleased() {
  IsHold = false;
  IsDragged = false;
  for (int i = 0; i < 2; i++) {
    updown[i] = 0;
  }
}

public void mouseDragged() {
  IsDragged = true;
}
/*
This whole file is where communication between the arduino and PI take place

The protocall for this communication is based on 6 bytes

byte 0 : tells which main menu button was pressed
byte 1 : tells which sub menu button was pressed within the main menu
byte 2 : data to be sent for the arduino to change in its program
byte 3 : data to be sent for the arduino to change in its program
byte 4 : data to be sent for the arduino to change in its program
byte 5 : data to be sent for the arduino to change in its program

do note that byte 2-4 is concatinated within the arduino to form a single float
*/

public void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');
  if (val != null) {
    val = trim(val);
    if (!val.equals("0")) {
    }
    if (firstContact == false) {
      if (val.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    }
    if (Is_Action == true) {
      B.putInt(value);
      byte[] result = B.array();
      ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
      outputStream.write((byte)Main_Menu_Selected);
      outputStream.write((byte)Sub_Menu_Selected);
      outputStream.write(result[0]);
      outputStream.write(result[1]);
      outputStream.write(result[2]);
      outputStream.write(result[3]);
      B.clear();
      byte c[] = outputStream.toByteArray();
      myPort.write(c);
      Is_Action = false;
    }
  }
}
/*
  Stores all the "Style" methods that are used to adjust the parameters of the "controllers" or if you would like to call it. All the UI elements
  
  fancy name for what it does
*/

public void Style_Main_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/2, iy/4);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

public void Style_Start_Button(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/4, iy/4);  
  c.setFont(font);
  c.setColorBackground(color(255, 0, 0));
  c.setColorForeground(color(255, 84, 112));
  c.setColorActive(color(255, 144, 144));
}

public void Style_Sub_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/6, iy/6);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

public void Style_Position_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/2, iy/30);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
  c.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  c.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
}

public void Style_Knob_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/3 + ix/15, iy/20);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
  c.getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

public void Style_back_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/8, iy/8);  
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

public void Style_Number_Pad(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/10, iy/10);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
  c.addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        holder = theEvent.getController().getName();
        Another_Stuid_Checker = true;
      }
    }
  }
  );
}

/*
fucking kill me
 */
public void Style_Sub_Number_Pad(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(2 * (ix + 5)/10, iy/10);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

public void Style_Sub_2_Number_Pad(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/10, (iy + 5)/10 + (iy)/10);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

public void Style_Text_Feild(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/3, iy/15);  
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}
/*
  Stores the methods that are used to initiate the movement of buttons when needed to
  
  do note that these all work based on taking the frame rate of the program.
  This method is extremly crude but I cant think of any other stupid way.
*/

public void Update_Position() {
  if (IsDragged && rx < x/2 && Is_In_Submenu == false) {
    for (int i = 0; i < Button_num; i++) {
      if (ry - dist[i][updown[i]] < 0 - Buttons.get(i).getHeight()) {
        if (updown[i] == 2 || updown[i] == 1) {
          Buttons.get(i).setPosition(0, y);
          updown[i] = 0;
        } else {
          Buttons.get(i).setPosition(0, y);
          updown[i] = 1;
        }
      } else if (ry - dist[i][updown[i]] > y) {
        if (updown[i] == 1 || updown[i] == 2) {
          Buttons.get(i).setPosition(0, 0 - Buttons.get(i).getHeight());
          updown[i] = 0;
        } else {
          Buttons.get(i).setPosition(0, 0 - Buttons.get(i).getHeight());
          updown[i] = 2;
        }
      } else {
        Buttons.get(i).setPosition(0, ry - dist[i][updown[i]]);
      }
    }
  }
}

public void Main_Button_Pressed(float frames) {
  boolean Main = Retract_Main_button(frames);
  boolean Back = Extend_Back_Button(frames);
  if (Main_Menu_Selected == 1) {
    boolean Manual = Extend_Manual_Control(frames);
  } else if (Main_Menu_Selected == 2) {
    boolean settings = Extend_Speed_Settings(frames);
  } else if (Main_Menu_Selected == 3) {
    boolean bobbin = Extend_Bobbin_Settings(frames);
  }
  if (Main == true && Back == true) {
    Is_Main_Button_Pressed_true = false;
    temp = 0;
  }
}

public void Back_Button_Pressed(float frames) {
  boolean Main = Extend_Main_button(frames);
  boolean Back = Retract_Back_Button(frames);
  switch (Main_Menu_Selected) {
  case 1 :
    boolean Manual = Retract_Manual_Control(frames);
  case 2 :
    boolean settings = Retract_Speed_Settings(frames);
  case 3 :
    if (Ammount.isFocus() || Bobbin_Diameter.isFocus()) {
      Another_Stuid_Checker_The_Second = true;
    }
    else {
      boolean bobbin = Retract_Bobbin_Settings(frames);
    }
  }
  if (Main == true && Back == true) {
    Is_Back_Button_Pressed = false;
    temp = 0;
  }
}

public void Text_Field_Pressed(float frames) {
  boolean Num_Pad = Extend_Num_Pad(frames);
  if (Num_Pad == true) {
    temp = 0;
  }
}

public void Enter_Pressed(float frames) {
  boolean Num_Pad = Retract_Num_Pad(frames);
  if (Num_Pad == true) {
    Another_Stuid_Checker_The_Second = false;
    temp = 0;
  }
}
/*
  Stores miscellaneous methods that are part of the loop functions
*/

public void Num_Pad_Clicked() {
  if (Ammount.isFocus()) {
    if (Delete && !Ammount.getText().isEmpty()) {
      Ammount.setText(Ammount.getText().substring(0, Ammount.getText().length() - 1));
      Delete = false;
    } else {
      Ammount.setText(Ammount.getText() + holder);
    }
  }
  if (Bobbin_Diameter.isFocus()) {
    if (Delete && !Bobbin_Diameter.getText().isEmpty()) {
      Bobbin_Diameter.setText(Bobbin_Diameter.getText().substring(0, Bobbin_Diameter.getText().length() - 1));
      Delete = false;
    } else {
      Bobbin_Diameter.setText(Bobbin_Diameter.getText() + holder);
    }
  }
  if (Bobbin_Length.isFocus()) {
    if (Delete && !Bobbin_Length.getText().isEmpty()) {
      Bobbin_Length.setText(Bobbin_Length.getText().substring(0, Bobbin_Length.getText().length() - 1));
      Delete = false;
    } else {
      Bobbin_Length.setText(Bobbin_Length.getText() + holder);
    }
  }
  Another_Stuid_Checker = false;
}

public void Focus_Text_box() {
  if (Ammount.isFocus()) {
    Ammount.keepFocus(true);
  }

  if (Bobbin_Diameter.isFocus()) {
    Bobbin_Diameter.keepFocus(true);
  }
  if (Bobbin_Length.isFocus()) {
    Bobbin_Length.keepFocus(true);
  }
}

  public void settings() {  size(800, 480);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
