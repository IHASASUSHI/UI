void Num_Pad_Clicked() {
  if (Ammount.isFocus()) {
    if (Delete && !Ammount.getText().isEmpty()) {
      Ammount.setText(Ammount.getText().substring(0, Ammount.getText().length() - 1));
      Delete = false;
    }
    else {
      Ammount.setText(Ammount.getText() + holder);
    }
  }
  if (Bobbin_Diameter.isFocus()) {
    if (Delete && !Bobbin_Diameter.getText().isEmpty()) {
      Bobbin_Diameter.setText(Bobbin_Diameter.getText().substring(0, Bobbin_Diameter.getText().length() - 1));
      Delete = false;
    }
    else {
      Bobbin_Diameter.setText(Bobbin_Diameter.getText() + holder);
    }
  }
  Another_Stuid_Checker = false;
}

void Focus_Text_box() {
  if (Ammount.isFocus()) {
    Ammount.keepFocus(true);
  }

  if (Bobbin_Diameter.isFocus()) {
    Bobbin_Diameter.keepFocus(true);
  }
}
