boolean Extend_Main_button(float frames) {
  if (Buttons.get(0).getPosition()[0] >= 0) {
    return true;
  }
  else {
    for (int i = 0; i < Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] + (frames - temp), Buttons.get(i).getPosition()[1]);
    }
    return false;
  }
}

boolean Retract_Main_button(float frames) {
  if (Buttons.get(0).getPosition()[0] <= -x/2) {
    return true;
  }
  else {
    for (int i = 0; i < Button_num; i++) {
      Buttons.get(i).setPosition(Buttons.get(i).getPosition()[0] - (frames - temp), Buttons.get(i).getPosition()[1]);
    }
    return false;
  }
}

boolean Retract_Back_Button(float frames) {
  if (Back.getPosition()[1] <= -y/8) {
    return true;
  }
  else {
    Back.setPosition(0, Back.getPosition()[1] - (frames - temp)/5);
    return false;
  }
}

boolean Extend_Back_Button(float frames) {
  if (Back.getPosition()[1] >= 0) {
    return true;
  }
  else {
    Back.setPosition(0, Back.getPosition()[1] + (frames - temp)/5);
    return false;
  }
}

boolean Retract_Manual_Control(float frames) {
  if (Move_Carrage_Right.getPosition()[1] >= y + y/2) {
    return true;
  } else {
    Position.setPosition(Position.getPosition()[0], Position.getPosition()[1] - (frames - temp)*1.7);
    Move_Carrage_Right.setPosition(Move_Carrage_Right.getPosition()[0], Move_Carrage_Right.getPosition()[1] + (frames - temp)*1.7);
    Move_Carrage_Left.setPosition(Move_Carrage_Left.getPosition()[0], Move_Carrage_Left.getPosition()[1] + (frames - temp)*1.7);
    Move_Winder_Up.setPosition(Move_Winder_Up.getPosition()[0], Move_Winder_Up.getPosition()[1] + (frames - temp)*1.7);
    Move_Winder_Down.setPosition(Move_Winder_Down.getPosition()[0], Move_Winder_Down.getPosition()[1] + (frames - temp)*1.7);
    Carriage_Right_Limit.setPosition(Carriage_Right_Limit.getPosition()[0], Carriage_Right_Limit.getPosition()[1] - (frames - temp)*1.7);
    Carriage_Left_Limit.setPosition(Carriage_Left_Limit.getPosition()[0], Carriage_Left_Limit.getPosition()[1] - (frames - temp)*1.7);
    return false;
  }
}

boolean Extend_Manual_Control(float frames) {
  if (Move_Carrage_Right.getPosition()[1] <= y/2) {
    return true;
  }
  else {
    Position.setPosition(Position.getPosition()[0], Position.getPosition()[1] + (frames - temp)*1.7);
    Move_Carrage_Right.setPosition(Move_Carrage_Right.getPosition()[0], Move_Carrage_Right.getPosition()[1] - (frames - temp)*1.7);
    Move_Carrage_Left.setPosition(Move_Carrage_Left.getPosition()[0], Move_Carrage_Left.getPosition()[1] - (frames - temp)*1.7);
    Move_Winder_Up.setPosition(Move_Winder_Up.getPosition()[0], Move_Winder_Up.getPosition()[1] - (frames - temp)*1.7);
    Move_Winder_Down.setPosition(Move_Winder_Down.getPosition()[0], Move_Winder_Down.getPosition()[1] - (frames - temp)*1.7);
    Carriage_Right_Limit.setPosition(Carriage_Right_Limit.getPosition()[0], Carriage_Right_Limit.getPosition()[1] + (frames - temp)*1.7);
    Carriage_Left_Limit.setPosition(Carriage_Left_Limit.getPosition()[0], Carriage_Left_Limit.getPosition()[1] + (frames - temp)*1.7);
    return false;
  }
}

boolean Retract_Speed_Settings (float frames) {   
  if (Carriage_Speed_Down.getPosition()[1] >= y + y/2 - y/6) {
    return true;
  }
  else {
    Carriage_Speed_Down.setPosition(Carriage_Speed_Down.getPosition()[0], Carriage_Speed_Down.getPosition()[1] + (frames - temp)*1.7);
    Winder_Speed_Down.setPosition(Winder_Speed_Down.getPosition()[0], Winder_Speed_Down.getPosition()[1] + (frames - temp)*1.7);
    Carriage_Speed_Up.setPosition(Carriage_Speed_Up.getPosition()[0], Carriage_Speed_Up.getPosition()[1] + (frames - temp)*1.7);
    Winder_Speed_Up.setPosition(Winder_Speed_Up.getPosition()[0], Winder_Speed_Up.getPosition()[1] + (frames - temp)*1.7);
    Winder_Speed_Knob.setPosition(Winder_Speed_Knob.getPosition()[0], Winder_Speed_Knob.getPosition()[1] - (frames - temp)*1.7);
    Carriage_Speed_Knob.setPosition(Carriage_Speed_Knob.getPosition()[0], Carriage_Speed_Knob.getPosition()[1] - (frames - temp)*1.7);
    test.setPosition(test.getPosition()[0], test.getPosition()[1] - (frames - temp)/5);
    Stop.setPosition(Stop.getPosition()[0], Stop.getPosition()[1] - (frames - temp)/5);
    return false;
  }
}

boolean Extend_Speed_Settings (float frames) {   
  if (Carriage_Speed_Down.getPosition()[1] <= y/2 - y/6 - y/7) {
    return true;
  }
  else {
    Carriage_Speed_Down.setPosition(Carriage_Speed_Down.getPosition()[0], Carriage_Speed_Down.getPosition()[1] - (frames - temp)*1.7);
    Winder_Speed_Down.setPosition(Winder_Speed_Down.getPosition()[0], Winder_Speed_Down.getPosition()[1] - (frames - temp)*1.7);
    Carriage_Speed_Up.setPosition(Carriage_Speed_Up.getPosition()[0], Carriage_Speed_Up.getPosition()[1] - (frames - temp)*1.7);
    Winder_Speed_Up.setPosition(Winder_Speed_Up.getPosition()[0], Winder_Speed_Up.getPosition()[1] - (frames - temp)*1.7);
    Winder_Speed_Knob.setPosition(Winder_Speed_Knob.getPosition()[0], Winder_Speed_Knob.getPosition()[1] + (frames - temp)*1.7);
    Carriage_Speed_Knob.setPosition(Carriage_Speed_Knob.getPosition()[0], Carriage_Speed_Knob.getPosition()[1] + (frames - temp)*1.7);
    test.setPosition(test.getPosition()[0], test.getPosition()[1] + (frames - temp)/5);
    Stop.setPosition(Stop.getPosition()[0], Stop.getPosition()[1] + (frames - temp)/5);
    return false;
  }
}

boolean Retract_Bobbin_Settings(float frames) {   
  if (Ammount.getPosition()[1] >= y + y/2 - y/3) {
    return true;
  } else {
    Ammount.setPosition(Ammount.getPosition()[0], Ammount.getPosition()[1] + (frames - temp)*1.7);
    Bobbin_Diameter.setPosition(Bobbin_Diameter.getPosition()[0], Bobbin_Diameter.getPosition()[1] + (frames - temp)*1.7);
    return false;
  }
}

boolean Extend_Bobbin_Settings(float frames) {   
  if (Ammount.getPosition()[1] <= y/2 - y/3) {
    return true;
  } else {
    Ammount.setPosition(Ammount.getPosition()[0], Ammount.getPosition()[1] - (frames - temp)*1.7);
    Bobbin_Diameter.setPosition(Bobbin_Diameter.getPosition()[0], Bobbin_Diameter.getPosition()[1] - (frames - temp)*1.7);
    return false;
  }
}

boolean Retract_Num_Pad(float frames) {   
  if (Metric.getPosition()[0] >= x + x/1.8 + (((x + 5)/10) * 2)) {
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

boolean Extend_Num_Pad(float frames) {   
  if (Metric.getPosition()[0] <= x/1.8 + (((x + 5)/10) * 2)) {
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
