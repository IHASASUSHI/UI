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
