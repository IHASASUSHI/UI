/*
  Stores miscellaneous methods that are part of the loop functions
*/

void Num_Pad_Clicked() {
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

void Focus_Text_box() {
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
