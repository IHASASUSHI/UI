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

void serialEvent(Serial myPort) {
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
