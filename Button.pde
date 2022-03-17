class Button {
  float x;
  float y;
  float xsize;
  float ysize;
  String text;
  String inputText;
  Boolean selected = false;
  
  Button(float _x, float _y, float _xsize, float _ysize, String _text) {
    x = _x;
    y = _y;
    xsize = _xsize;
    ysize = _ysize;
    text = _text;
  }
  
  Button(float _x, float _y, float _xsize, float _ysize, String _text, String _inputText) {
    x = _x;
    y = _y;
    xsize = _xsize;
    ysize = _ysize;
    text = _text;
    inputText = _inputText;
  }
  
  void display() {
    fill(255);
    stroke(0);
    if (selected) {
      stroke(255, 0, 0);
    }
    if (this.hover()) {
      fill(128);
    }
    textSize(18);
    rect(x, y, xsize, ysize);
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(text, x + xsize/2, y + ysize/2 - 4);
    if (text.equals("") && inputText != null) {
      fill(64);
      text(inputText, x + xsize/2, y + ysize/2 - 4);
    }
  }
  
  Boolean hover() {
    if (mouseX > x && mouseX < x + xsize && mouseY > y && mouseY < y + ysize) {
      return true;
    } else {
      return false;
    }
  }
}
