int rectx = 50;
int recty = 50;
PImage image;
Button[] buttons;
ArrayList<Button> vButtons = new ArrayList();
ArrayList<Button> cButtons = new ArrayList();
Button addButton;
Button andButton;
Button orButton;
Boolean and = true;
StringList col = new StringList("");
int colIndex = 0;
String[] val = new String[1];
String input = "";
Table file;
Boolean colDone = false;
Boolean inputDone = false;
float buttonHeight = 37.5;
int selected = 0;

void setup() {
  size(600, 300);
  image = loadImage("field_image.png");
}

void draw() {
  background(0);
  image(image, 0, 0, width, height);
  file = loadTable("points.csv");
  String[][] strings = new String[file.getRowCount()][];

  // Remove null columns
  for (int i = file.getColumnCount()-1; i >= 0; i--) {
    if (file.getRow(0).getString(i).length() >= 6) {
      if (file.getRow(0).getString(i).substring(0, 6).equals("Column")) {
        file.removeColumn(i);
      }
    }
  }

  // Add "color" column
  int colorIndex = 0;
  for (int i = 0; i < file.getColumnCount(); i++) {
    if (file.getRow(0).getString(i).equals("Robot")) {
      colorIndex = i;
    }
  }
  file.addColumn("Color");
  file.setString(0, "Color", "Color");
  for (int i = 1; i < file.getRowCount(); i++) {
    if (file.getString(i, colorIndex).length() >= 1) {
      if (file.getString(i, colorIndex).substring(0, 1).equals("r")) {
        file.setString(i, "Color", "blue");
      } else {
        file.setString(i, "Color", "red");
      }
    }
  }

  // Valid columns to check
  IntList indexes = new IntList();
  for (int i = 0; i < file.getColumnCount(); i++) {
    for (int j = 0; j < col.size(); j++) {
      if (file.getRow(0).getString(i).equals(col.get(j))) {
        indexes.append(i);
      }
    }
  }

  // Get the column
  int ss = 15;
  for (int i = 0; i < file.getColumnCount(); i++) {
    if (file.getRow(0).getString(i).toUpperCase().equals("SS")) {
      ss = i;
    }
  }

  for (int i = 0; i < file.getRowCount(); i++) {
    strings[i] = splitTokens(file.getString(i, ss), ",[]s");
  }

  // Convert to int
  IntList ints = new IntList();
  for (int i = 0; i < strings.length; i++) {
    for (int j = 0; j < strings[i].length; j++) {
      if (indexes.size() > 0) {
        if (check(i, indexes)) {
          ints.append(int(strings[i][j]));
        }
      } else {
        ints.append(int(strings[i][j]));
      }
    }
  }

  // Convert to pvector
  PVector[] points = new PVector[ints.size()];
  for (int i = 0; i < points.length; i++) {
    float x = (ints.get(i)-1) % 12;
    float y = (float)Math.floor((ints.get(i)-1)/12);
    points[i] = new PVector(x, y);
  }

  // Display points
  for (int i = 0; i < points.length; i++) {
    PVector point = new PVector(0, 0);
    point.x = points[i].x * rectx;
    point.y = points[i].y * recty;
    float alpha = 255 / (1 + 0.1 * (points.length-1));
    fill(255, 0, 0, alpha);
    noStroke();
    rect(point.x, point.y, rectx, recty);
  }

  // Gridlines
  stroke(0);
  for (int i = 1; i < 7; i++) {
    line(0, i * recty, width, i * recty);
  }
  for (int i = 1; i < 13; i++) {
    line(i * rectx, 0, i * rectx, height);
  }

  buttons = new Button[file.getColumnCount()];

  // UI
  addButton = null;
  andButton = null;
  orButton = null;
  if (!colDone) {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i] = new Button(width/8 - 60 + width/4 * (i % 4), (i - i % 4) * 11 + 5.5, 120, 25, file.getRow(0).getString(i));
      buttons[i].display();
    }
  } else if (!inputDone) {
    if (vButtons.size() == 0) {
      vButtons.add(new Button(width/2-60, height/2-12.5, 120, 25, input, col.get(0)));
      cButtons.add(new Button(width/2-90, height/2-12.5, 25, 25, "?"));
    }

    addButton = new Button(width/2-12.5, height/2-42.5, 25, 25, "+");
    andButton = new Button(width/2-32.5, height/2-72.5, 30, 25, "and");
    orButton = new Button(width/2+2.5, height/2-72.5, 30, 25, "or");
    for (int i = 0; i < vButtons.size(); i++) {
      vButtons.get(i).inputText = col.get(i);
      if (selected == i) {
        vButtons.get(i).selected = true;
      } else {
        vButtons.get(i).selected = false;
      }
      vButtons.get(i).display();
    }
    vButtons.get(selected).text = input;
    for (Button b : cButtons) {
      b.display();
    }

    if (and) {
      andButton.selected = true;
    } else {
      orButton.selected = true;
    }

    addButton.display();
    andButton.display();
    orButton.display();
  }
}

Boolean check(int n, IntList indexes) {
  if (and) {
    int matches = 0;
    for (int i = 0; i < val.length; i++) {
      for (int j = 0; j < indexes.size(); j++) {
        if (val[i] != null) {
          if (file.getRow(n).getString(indexes.get(j)).equals(val[i]) && file.getRow(0).getString(indexes.get(j)).equals(vButtons.get(i).inputText) && !val[i].equals("")) {
            matches++;
          }
        } else {
          matches++;
        }
      }
    }
    if (matches == val.length) {
      return true;
    } else {
      return false;
    }
  } else {
    for (int i = 0; i < val.length; i++) {
      for (int j = 0; j < indexes.size(); j++) {
        if (file.getRow(n).getString(indexes.get(j)).equals(val[i])) {
          return true;
        }
      }
    }
    return false;
  }
}

void mouseClicked() {
  for (int i = 0; i < buttons.length; i++) {
    if (buttons[i] != null) {
      if (buttons[i].hover() && !colDone) {
        col.set(colIndex, buttons[i].text);
        colDone = true;
        selected = colIndex;
      }
    }
  }

  if (colDone && !inputDone) {
    for (int i = 0; i < cButtons.size(); i++) {
      if (cButtons.get(i).hover()) {
        colDone = false;
        colIndex = i;
        addButton = null;
      }
    }
    for (int i = 0; i < vButtons.size(); i++) {
      if (vButtons.get(i).hover()) {
        selected = i;
        input = vButtons.get(i).text;
      }
    }
  }

  if (addButton != null) {
    if (addButton.hover()) {
      vButtons.add(new Button(width/2-60, height/2-12.5+buttonHeight, 120, 25, input, col.get(0)));
      cButtons.add(new Button(width/2-90, height/2-12.5+buttonHeight, 25, 25, "?"));
      col.append("");
      buttonHeight += 37.5;
    }
  }

  if (andButton != null) {
    if (andButton.hover()) {
      and = true;
    }
  }

  if (orButton != null) {
    if (orButton.hover()) {
      and = false;
    }
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;
  }
}

void keyTyped() {
  if (key == BACKSPACE) {
    if (!input.equals("")) {
      input = input.substring(0, input.length()-1);
    }
  } else if (key == ENTER) {
    val = new String[vButtons.size()];
    for (int i = 0; i < val.length; i++) {
      val[i] = vButtons.get(i).text;
    }
    inputDone = true;
  } else if (key == ESC) {
    if (inputDone) {
      val = new String[1];
      inputDone = false;
      addButton = null;
    } else {
      col.set(0, "");
      colDone = false;
    }
  } else {
    input = input + key;
  }
}
