/*
This whole file is used to store the long as fuck initialization of every single button
 
 I hate seeing a large ass main file.
 */

void Create_Buttons() {
  Start = cp5.addButton("Start").setPosition(x - x/4, 0);
  Style_Start_Button("Start");
  for (int i = 0; i < Button_num; i++) {
    Buttons.add(cp5.addButton(Main_Button_names[i]).setPosition(0, ((y + (y/8))/Button_num) * i)
      .activateBy(ControlP5.PRESSED)
      .addCallback(
      new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getController().isMouseOver() == true) {
          try {
            MouseRepositioner.mouseMove(1080, 1080);
            theEvent.getController().setMousePressed(true);
          }
          catch(Exception e) {
            println("fuck you");
          }
        }
      }
    }));
    Style_Main_Buttons(Main_Button_names[i]);
    updown[i] = 0;
  }
  Back = cp5.addButton("Back").setPosition(0, -y/8)
    .activateBy(ControlP5.PRESSED)
    .addCallback(
    new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getController().isMouseOver() == true) {
        try {
          MouseRepositioner.mouseMove(1080, 1080);
          Back.setMousePressed(true);
        }
        catch(Exception e) {
          e.printStackTrace();
        }
      }
    }
  });
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
  Move_Winder_Up = cp5.addButton("Move_Winder_Up").setPosition(x/2 - x/12, y + y/3)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Move_Winder_Up");
  Move_Winder_Down = cp5.addButton("Move_Winder_Down").setPosition(x/2 - x/12, y + y/1.5)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Move_Winder_Down");
  Carriage_Right_Limit = cp5.addButton("Auto").setPosition(x/2 + x/6 + x/10, y/2 - y/3 - y)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Auto");
  Carriage_Left_Limit = cp5.addButton("Zero").setPosition(x/2 - 2*x/6 - x/10, y/2 - y/3 - y)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Zero");

  test = cp5.addButton("test").setPosition(x - x/8, -y/8)
    .activateBy(ControlP5.PRESSED);
  Style_back_Buttons("test");
  Stop = cp5.addButton("Stop").setPosition(x - x/8, -y/8)
    .activateBy(ControlP5.PRESSED)
    .hide()
    .setBroadcast(false);
  Style_back_Buttons("Stop");
  Winder_Speed_Down = cp5.addButton("Winder_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/5 + y/2)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Winder_Speed_Down");
  Carriage_Speed_Down = cp5.addButton("Carriage_Speed_Down").setPosition(x/2 - x/6 - x/5, y + y/2 - y/5)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Carriage_Speed_Down");
  Winder_Speed_Up = cp5.addButton("Winder_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/5 + y/2)
    .activateBy(ControlP5.PRESSED);
  Style_Sub_Buttons("Winder_Speed_Up");
  Carriage_Speed_Up = cp5.addButton("Carriage_Speed_Up").setPosition(x/2 + x/5, y + y/2 - y/5)
    .activateBy(ControlP5.PRESSED);
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
      .activateBy(ControlP5.PRESSED)
      .setPosition(x + (((x + 5)/10) * k), y/5 + (((y + 5)/10) * j)));
    Style_Number_Pad(Num_Pad_Button_names[i]);

    if (k == 2) {
      k = -1;
      j++;
    }
  }
  Metric = cp5.addButton("in").setPosition(x + (((x + 5)/10) * 2), y/5 + (((y + 5)/10) * 3))
    .activateBy(ControlP5.PRESSED);
  Style_Number_Pad("in");
  zero = cp5.addButton("0").setPosition(x + (((x + 5)/10) * 0), y/5 + (((y + 5)/10) * 3))
    .activateBy(ControlP5.PRESSED)
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
  enter = cp5.addButton("enter").setPosition(x + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 0))
    .activateBy(ControlP5.PRESSED);
  Style_Sub_2_Number_Pad("enter");
  Del = cp5.addButton("Del").setPosition(x + (((x + 5)/10) * 3), y/5 + (((y + 5)/10) * 2))
    .activateBy(ControlP5.PRESSED);
  Style_Sub_2_Number_Pad("Del");
}
