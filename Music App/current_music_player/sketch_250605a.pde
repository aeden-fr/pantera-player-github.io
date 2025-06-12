import ddf.minim.*;

Minim minim;
AudioPlayer song;
PImage albumImg;
PFont mvBoliFont;

boolean isPlaying = false;

String[] titles = {
  "thunderstruck",
  "heart shaped box",
  "all apologies"
};

String[] audioPaths = {
  "data/01 Thunderstruck.mp3",
  "data/09 Heart-Shaped Box.mp3",
  "data/13 All Apologies.mp3"
};

String[] imagePaths = {
  "data/Razorsedge.jpg",
  "data/heart shaped box.jpg",
  "data/3476108"
};

color[] titleColors = {
  color(0, 0, 255),     //
  color(255, 165, 0),   //
  color(0, 200, 0)      //
};

int currentSongIndex = 0;

// Dimensions as floats for smooth positioning
float appWidth, appHeight;
float titleHeight = 60.0;
float topMargin = 20.0;
float albumX, albumWidth, albumY, albumHeight;
float buttonWidth, buttonHeight, buttonY;
float barY, barHeight;
float quitSize, quitX, quitY;

void setup() {
  fullScreen();
  appWidth = (float) displayWidth;
  appHeight = (float) displayHeight;

  mvBoliFont = createFont("MVBoli", 32);
  textFont(mvBoliFont);
  minim = new Minim(this);

  // Calculate dimensions based on screen size (floats)
  albumX = appWidth * 0.25f;
  albumWidth = appWidth * 0.5f;
  albumY = topMargin + titleHeight + 20.0f;
  albumHeight = appHeight / 3.0f;

  buttonWidth = appWidth / 6.0f;
  buttonHeight = buttonWidth * 0.6f;
  buttonY = albumY + albumHeight + 20.0f;

  barY = buttonY + buttonHeight + 20.0f;
  barHeight = 40.0f;

  quitSize = 40.0f;
  quitX = appWidth - quitSize - 10.0f;
  quitY = 10.0f;

  loadCurrentSong();
}

void draw() {
  background(255);

  drawTitleBar();
  drawAlbumImage();
  drawButtons();
  drawProgressBar();
  drawQuitButton();
}

void drawTitleBar() {
  fill(220);
  stroke(0);
  strokeWeight(2);
  rect(albumX, topMargin, albumWidth, titleHeight);

  fill(titleColors[currentSongIndex]);
  textAlign(CENTER, CENTER);
  textSize(28);
  text(titles[currentSongIndex], appWidth / 2.0f, topMargin + titleHeight / 2.0f);
}

void drawAlbumImage() {
  if (albumImg != null) {
    image(albumImg, albumX, albumY, albumWidth, albumHeight);
  } else {
    fill(200);
    rect(albumX, albumY, albumWidth, albumHeight);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Image not found", albumX + albumWidth / 2.0f, albumY + albumHeight / 2.0f);
  }
}

void drawButtons() {
  String[] labels = {"PREV", "PLAY", "NEXT", "STOP"};

  for (int i = 0; i < labels.length; i++) {
    float buttonX = albumX + (i * (buttonWidth + 10));
    fill(mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight ? 150 : 180);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
   
    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(labels[i], buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  }
}

void drawProgressBar() {
  stroke(0);
  strokeWeight(2);
  fill(155);
  rect(albumX, barY, albumWidth, barHeight);

  if (song != null && song.length() > 0) {
    float progress = map(song.position(), 0, song.length(), 0, albumWidth);
    fill(0);
    noStroke();
    rect(albumX, barY, progress, barHeight);
  }
}

void drawQuitButton() {
  boolean hover = (mouseX > quitX && mouseX < quitX + quitSize && mouseY > quitY && mouseY < quitY + quitSize);
  stroke(0);
  strokeWeight(2);
  fill(hover ? color(255, 220, 220) : color(255));
  rect(quitX, quitY, quitSize, quitSize, 5);

  fill(255, 0, 0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("QUIT", quitX + quitSize / 2, quitY + quitSize / 2);
}

void mousePressed() {
  for (int i = 0; i < 4; i++) {
    float buttonX = albumX + (i * (buttonWidth + 10));
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      handleButtonPress(i);
    }
  }

  if (mouseX > quitX && mouseX < quitX + quitSize && mouseY > quitY && mouseY < quitY + quitSize) {
    exit();
  }
}

void handleButtonPress(int index) {
  switch (index) {
    case 0: prevSong(); break;
    case 1: togglePlayPause(); break;
    case 2: nextSong(); break;
    case 3: stopSong(); break;
  }
}

void loadCurrentSong() {
  if (song != null) {
    song.close();
  }
  song = minim.loadFile(audioPaths[currentSongIndex]);
  albumImg = loadImage(imagePaths[currentSongIndex]);
  isPlaying = false;
}

void togglePlayPause() {
  if (song == null) return;
  if (isPlaying) {
    song.pause();
    isPlaying = false;
  } else {
    song.play();
    isPlaying = true;
  }
}

void stopSong() {
  if (song == null) return;
  song.pause();
  song.rewind();
  isPlaying = false;
}

void nextSong() {
  currentSongIndex = (currentSongIndex + 1) % titles.length;
  loadCurrentSong();
}

void prevSong() {
  currentSongIndex = (currentSongIndex - 1 + titles.length) % titles.length;
  loadCurrentSong();
}
