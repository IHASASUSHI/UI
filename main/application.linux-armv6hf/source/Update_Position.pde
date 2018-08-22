/*
  Stores the methods that are used to initiate the movement of buttons when needed to
  
  do note that these all work based on taking the frame rate of the program.
  This method is extremly crude but I cant think of any other stupid way.
*/

void Update_Position() {
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

void Main_Button_Pressed(float frames) {
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

void Back_Button_Pressed(float frames) {
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

void Text_Field_Pressed(float frames) {
  boolean Num_Pad = Extend_Num_Pad(frames);
  if (Num_Pad == true) {
    temp = 0;
  }
}

void Enter_Pressed(float frames) {
  boolean Num_Pad = Retract_Num_Pad(frames);
  if (Num_Pad == true) {
    Another_Stuid_Checker_The_Second = false;
    temp = 0;
  }
}
