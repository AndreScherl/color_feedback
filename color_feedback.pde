/*
 *  Color Feedback
 *
 *  @author Andre Scherl
 *  @date 2014/01/03
 */
 
/* How it works (or should work)
 * 1. set colors to search for by picking it within the cam pic
 * 2. do the following for every color
 *  a) filter pic by color (hue), convert hue value into grayscale value
 *  b) if pixel color is in range change it to white, if not make it black
 *  c) find contours within the black and white image and count them
 * 3. show stats
 */

import processing.video.*;
import gab.opencv.*;

// Change parameters here
int hue_tolerance = 20;

Capture cam;                           // instance of the Capture class 
OpenCV opencv;                         // instance of the OpenCV class
color[] colors = new color[4];         // the colors you're looking for
ArrayList<Contour> contours;


void setup()
{
  //frameRate(2);
  size(640, 480, P2D);
  cam = new Capture(this, width, height);
  opencv = new OpenCV(this, cam);
  
  cam.start();
}

void draw(){
  image(cam, 0, 0);
  
  opencv.useColor(RGB);
  opencv.loadImage(cam);
  opencv.useColor(HSB);
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(int((hue(colors[0])-hue_tolerance)/2), int((hue(colors[0])+hue_tolerance)/2)); // opencv hue range 0-180
  print("color-hue: ");println(int(hue(colors[0])-hue_tolerance));
  
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  noFill();
  strokeWeight(3);
  
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
  }
  
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
