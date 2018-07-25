import processing.serial.*;
import controlP5.*;
import java.util.*;
import java.nio.*;
import java.io.*;

ControlP5 cp5;                                  //initializing controlp5
Serial myPort;                                  //required for serial communication
String val;
boolean firstContact = false;
ByteBuffer B = ByteBuffer.allocate(4);

Dong[][] d;                                     //Matrix for the UI background spinning dots
String[] Main_Button_names = {"Calibration", "Speed_Setting", "Bobbin_Setting"};
String[] Num_Pad_Button_names = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
Button zero;
Button enter;
Button Del;
Button Metric;
int Button_num = Main_Button_names.length;
int Num_Pad_Button_num = Num_Pad_Button_names.length;
List<Button> Buttons = new ArrayList<Button>(); //self explanatory self declaration for use later on to make UI elements for the main button
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
Knob Winder_Speed_Knob;
Knob Carriage_Speed_Knob;
Textfield Ammount;
Textfield Bobbin_Diameter;
float Bobbin_Length = 7011.46496815;          //hard coded value of the bobbin length
int[][] dist = new int[Button_num][3];        //distance of the mouse to the position of all the buttons and holds the values of both where the button should go if upon being hit by the edge of the screen
float x = 800;                                //Screen Length
float y = 600;                                //Screen Height
int ix = 800;                                 //Integer Screen Length
int iy = 600;                                 //Ineger Screen Height
int rx = 0;                                   //Mouse position x
int ry = 0;                                   //Mouse position y
int px = 0;                                   //Initial mouse position x
int py = 0;                                   //Initial mouse position y
int[] by = new int[Button_num];               //gets the y position of the buttons on the screens
int nx = 10;                                  //Background grafix x
int ny = 10;                                  //Background grafix y
int[] updown = new int[Button_num];           //Used to see if the main menu is being dragged up or down once a button hits the edge of the screen
int value = 0;                                //Tells the Arduino the value inputted by the user
int Main_Menu_Selected = 0;                   //Tells the Arduino which Main Menu was selected
int Sub_Menu_Selected = 0;                    //Tells the Arduino which Sub Menu was selected
boolean IsDragged = false;                    //tells if the main menu is being dragged
boolean Is_Main_Button_Pressed_true = false;  //tells if a main menu button has bee pressed
boolean Is_Back_Button_Pressed = false;       //tells if the user has pressed the back button
boolean Is_In_Submenu = false;                //tells if the UI is in a sub menu
boolean Is_Text_Pressed = false;
boolean Is_Action = false;                    //tells if there is a action to be preformed by the arduino
boolean IsHold = false;
boolean Another_Stuid_Checker = false;        //checks if there was a response from the nubmerpad
boolean Another_Stuid_Checker_The_Second = false; //checks if the enter button was pressed
boolean Delete = false;                       //Checks if delete button is pressed
float temp = frameCount;                      //Records the initial fame count upon the main menu being dragged
String holder = "";

void setup() {

  size(800, 480);
  println(Serial.list());
  String portNum = Serial.list()[3];
  myPort = new Serial(this, portNum, 115200);
  myPort.bufferUntil('\n');
  B.order(ByteOrder.BIG_ENDIAN);

  cp5 = new ControlP5(this);
  for (int i = 0; i < 2; i++) {
    updown[i] = 0;
  }

  for (int i = 0; i < Button_num; i++) {
    Buttons.add(cp5.addButton(Main_Button_names[i]).setPosition(0, ((y + (y/4))/Button_num) * i));
    Style_Main_Buttons(Main_Button_names[i]);
    updown[i] = 0;
  }
  Back = cp5.addButton("Back").setPosition(0, -y/8);
  Style_back_Buttons("Back");
  Position = cp5.addSlider("positon").setPosition(x/2 - ix/(2*2), y/22 - y)
    .setRange(0, Bobbin_Length)
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
    });
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
    });
  Style_Sub_Buttons("Move_Carrage_Right");
  Move_Winder_Up = cp5.addButton("Move_Winder_Up").setPosition(x/2 - x/(6*2), y + y/3);
  Style_Sub_Buttons("Move_Winder_Up");
  Move_Winder_Down = cp5.addButton("Move_Winder_Down").setPosition(x/2 - x/(12), y + y/1.5);
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
  Winder_Speed_Down = cp5.addButton("Winder_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/6 + y/3);
  Style_Sub_Buttons("Winder_Speed_Down");
  Carriage_Speed_Down = cp5.addButton("Carriage_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/6);
  Style_Sub_Buttons("Carriage_Speed_Down");
  Winder_Speed_Up = cp5.addButton("Winder_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/6 + y/3);
  Style_Sub_Buttons("Winder_Speed_Up");
  Carriage_Speed_Up = cp5.addButton("Carriage_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/6);
  Style_Sub_Buttons("Carriage_Speed_Up");
  Winder_Speed_Knob = cp5.addKnob("Winder_Speed_Knob").setPosition(x/2 - x/10, y/2 + (-y/6) - y/20 - y)
    .setRange(1, 20000/67)
    .setValue(20000/67)
    .setNumberOfTickMarks(50)
    .setRadius(25);
  Style_Knob_Buttons("Winder_Speed_Knob");
  Carriage_Speed_Knob = cp5.addKnob("Carriage_Speed_Knob").setPosition(x/2 - x/10, y/2 + (- y/6 - y/3) - y/20 - y)
    .setRange(1, 20000/67)
    .setValue(20000/67)
    .setNumberOfTickMarks(50)
    .setRadius(25);
  Style_Knob_Buttons("Carriage_Speed_Knob");  

  Ammount = cp5.addTextfield("Ammount").setPosition(x/2 - x/3, y + y/2 - y/3)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        Is_Text_Pressed = true;
      }
    }
    })
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
    })
  .setText("");
  Style_Text_Feild("Bobbin_Diameter");
  for (int i = 0, j = 0, k = 0; i < Num_Pad_Button_num; i++, k++) {
    Buttons.add(cp5.addButton(Num_Pad_Button_names[i])
      .setPosition(x + x/1.8 + (((x + 5)/10) * k), y/5 + (((y + 5)/10) * j)));
    Style_Number_Pad(Num_Pad_Button_names[i]);

    if (k == 2) {
      k = -1;
      j++;
    }
  }
  Metric = cp5.addButton("in").setPosition(x + x/1.8 + (((x + 5)/10) * 2), y/5 + (((y + 5)/10) * 3));
  Style_Number_Pad("in");
  zero = cp5.addButton("0").setPosition(x + x/1.8 + (((x + 5)/10) * 0), y/5 + (((y + 5)/10) * 3))
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        holder = theEvent.getController().getName();
        Another_Stuid_Checker = true;
      }
    }
    });
  Style_Sub_Number_Pad("0");
  enter = cp5.addButton("enter").setPosition(x + x/1.8 + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 0));
  Style_Sub_2_Number_Pad("enter");
  Del = cp5.addButton("Del").setPosition(x + x/1.8 + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 2));
  Style_Sub_2_Number_Pad("Del");

  d = new Dong[nx][ny];

  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y] = new Dong();
    }
  }

  noStroke();
  smooth();
}

void draw() {
  background(0);
  fill(255, 100);

  if (mousePressed == false) {
    py = mouseY;
    for (int i = 0; i < Button_num; i++) {
      by[i] = (int)Buttons.get(i).getPosition()[1];
    }
  }
  rx = mouseX;
  ry = mouseY;
  Update_Position();

  if (Is_Main_Button_Pressed_true) {
    if (temp == 0) {
      temp = frameCount;
    }
    Main_Button_Pressed(frameCount);
  }
  if (Is_Back_Button_Pressed) {
    if (temp == 0) {
      temp = frameCount;
    }
    Back_Button_Pressed(frameCount);
  }
  if (Ammount.isFocus() || Bobbin_Diameter.isFocus()) {
    Focus_Text_box();
    if (temp == 0) {
      temp = frameCount;
    }
    Text_Field_Pressed(frameCount);
    
    if (Another_Stuid_Checker) {
      Num_Pad_Clicked();
    }
  }
  if (Another_Stuid_Checker_The_Second) {
    Ammount.keepFocus(false);
    Ammount.setFocus(false);
    Bobbin_Diameter.keepFocus(false);
    Bobbin_Diameter.setFocus(false);
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

  pushMatrix();
  translate(width/2 + 150, height/2);
  rotate(frameCount*0.001);
  for (int x = 0; x<nx; x++) {
    for (int y = 0; y<ny; y++) {
      d[x][y].display();
    }
  }
  popMatrix();
}
