/*
This whole file is used to store "most" the methods for what the buttons do

do note that some of the buttons have callback functions which act as a secondary method that is enacted depending on the way they were programmed to act
*/

void Calibration() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 1;
  }
}
void Speed_Setting() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 2;
  }
}
void Bobbin_Setting() {
  if (IsDragged == false) {
    Is_Main_Button_Pressed_true = true;
    Is_In_Submenu = true;
    Main_Menu_Selected = 3;
  }
}
void Start() {
   if (IsDragged == false) {
    Main_Menu_Selected = 4;
    Sub_Menu_Selected = 0;
    value = 0;
    Is_Action = true;
  }
}


void Back() {
  if (IsDragged == false) {
    Is_In_Submenu = false;  
    Is_Back_Button_Pressed = true;
    value = 1;
  }
}

void Move_Carrage_Right() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 2;
    value = 1;
  }
}
void Move_Carrage_Left() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 1;
    value = 1;
  }
}

void Move_Winder_Up() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 3;
    value = 1;
  }
}
void Move_Winder_Down() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 4;
    value = 1;
  }
}
void Zero() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 5;
    value = 1;
  }
}
void Auto() {
  if (IsDragged == false) {
    Is_Action = true;
    Sub_Menu_Selected = 6;
    value = 1;
  }
}
void positon(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 7;
  value = position;
}



void Winder_Speed_Down() {
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

void Carriage_Speed_Down() {
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

void Winder_Speed_Up() {
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

void Carriage_Speed_Up() {
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

void Winder_Speed_Knob(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 5;
  value = position * 67;
}

void Carriage_Speed_Knob(int position) {
  Is_Action = true;
  Sub_Menu_Selected = 6;
  value = position * 67;
}

void test() {
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

void Stop() {
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

void enter() {
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
void Del() {
  if (IsDragged == false && !Ammount.getText().isEmpty()) {
    holder = "";
    Another_Stuid_Checker = true;
    Delete = true;
  }
}
