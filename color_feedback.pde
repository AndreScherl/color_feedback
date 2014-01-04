/*
 *  Color Feedback
 *
 *  @author Andre Scherl
 *  @date 2014/01/03
 */

import processing.video.*;
import gab.opencv.*;
import java.awt.Color;

// Change parameters here
int hue_tolerance = 5;

Capture cam;                           // instance of the Capture class 
OpenCV opencv;                         // instance of the OpenCV class
color[] colors = new color[4];         // the colors you're looking for


void setup()
{
  //frameRate(2);
  size(640, 480, P2D);
  cam = new Capture(this, width, height);
  opencv = new OpenCV(this, cam);
  //opencv.threshold(5);
  cam.start();
}

void draw(){
  image(cam, 0, 0);
  
  opencv.useColor(RGB);
  opencv.loadImage(cam);
  opencv.useColor(HSB);
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(int(hue(colors[0])-hue_tolerance), int(hue(colors[0])+hue_tolerance));
  print("color-hue: ");println(int(hue(colors[0])-hue_tolerance));
  
  image(opencv.getInput(), 0*width/4, 3*height/4, width/4,height/4);
  image(opencv.getOutput(), 3*width/4, 3*height/4, width/4,height/4);
  
}

/*
 *  Things to be done if new frame of capture is available
 */
void captureEvent(Capture c) {  
  c.read();
}

/*
 *  Set colors to detect by releasing key 1 to 4
 */
void keyReleased() {
  //println("released " + int(key) + " " + keyCode);
  switch(int(key)) {
    case 49: // 1
      colors[0] = cam.pixels[mouseY*width+mouseX];
      break;
    case 50: // 2
      colors[1] = cam.pixels[mouseY*width+mouseX];
      break;
    case 51: // 3
      colors[2] = cam.pixels[mouseY*width+mouseX];
      break;
    case 52: // 4
      colors[3] = cam.pixels[mouseY*width+mouseX];
      break;
    default:
      break;
  }
  //print("colors: ");println(colors);
}

/*
 *  Statistics
 */
/*void showStatistics() {
  int[] stats = new int[colors.length];
  for(int i=0; i<matchingPixel.length; i++) {
    stats[matchingPixel[i].pColor]++;
  }
  
  for(int i=0; i<stats.length; i++) {
    if(stats[i] == 0) break;
    int percent = (int)(stats[i]*100/matchingPixel.length);
    //fill(255);
    //rect(10+i*150, height-100-30-percent, 130, 30+percent);
    textSize(30+percent);
    fill(colors[i]);
    text(percent+"%", 10+i*150, height-100);
  }
}*/
