/*
  Stores all the "Style" methods that are used to adjust the parameters of the "controllers" or if you would like to call it. All the UI elements
  
  fancy name for what it does
*/

void Style_Main_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/2, iy/4);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

void Style_Start_Button(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/4, iy/4);  
  c.setFont(font);
  c.setColorBackground(color(255, 0, 0));
  c.setColorForeground(color(255, 84, 112));
  c.setColorActive(color(255, 144, 144));
}

void Style_Sub_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/6, iy/6);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

void Style_Position_Buttons(String Name) {
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

void Style_Knob_Buttons(String Name) {
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

void Style_back_Buttons(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/8, iy/8);  
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

void Style_Number_Pad(String Name) {
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
void Style_Sub_Number_Pad(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(2 * (ix + 5)/10, iy/10);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

void Style_Sub_2_Number_Pad(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/10, (iy + 5)/10 + (iy)/10);
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}

void Style_Text_Feild(String Name) {
  PFont pfont = createFont("Standard 07_58", 5, false);
  ControlFont font = new ControlFont(pfont, 20);
  Controller c = cp5.getController(Name);

  c.setSize(ix/3, iy/15);  
  c.setFont(font);
  c.setColorBackground(color(67, 233, 255));
  c.setColorForeground(color(81, 255, 246));
  c.setColorActive(color(144, 255, 238));
}
