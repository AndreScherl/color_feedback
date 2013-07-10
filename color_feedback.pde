/*
 *  Color Feedback
 *
 *  @author Andre Scherl
 *  @date 2013/07/08
 */

import processing.video.*;

// Change parameters here
int CONST_MIN_DISTANCE = 50;
float CONST_COLOR_TOLERANCE = 10.0;
int CONST_ELLIPSE_RADIUS = 10;

Capture cam;                           // instance of the Capture class 
color[] colors = new color[4];         // the colors you're looking for
Pixel[] matchingPixel = new Pixel[0];

void setup()
{
  // set window size:
  //size(640, 360);
  size(640, 512); // USB Schwanenhalscam
  frameRate(2);
  
  // get capture list and chose one camera
  String[] cameras = Capture.list();
  println(cameras);
  //cam = new Capture(this, cameras[4]);
  cam = new Capture(this, "name=Vimicro USB2.0 PC Camera ,size=640x512,fps=15");
  cam.start();
}

void draw(){
  // draw the current frame of the camera on the screen
  image(cam, 0, 0);
  //filter(BLUR, 6);
  // draw a dot at the matchingPixel
  if (matchingPixel.length > 0) { 
    for (int i=0; i<matchingPixel.length; i++) {
      fill(colors[matchingPixel[i].pColor]);
      ellipse(matchingPixel[i].column, matchingPixel[i].row, CONST_ELLIPSE_RADIUS, CONST_ELLIPSE_RADIUS);
    }
    showStatistics();
  }
}

/*
 *  Things to be done if new frame of capture is available
 */
void captureEvent(Capture cam) {
  matchingPixel = new Pixel[0];   
  // read the cam and update the pixel array:
  cam.read();
  // scan over the pixels  to look for a pixel
  // that matches the target color:
  for(int row=0; row<height; row++) { 
    for(int column=0; column<width; column++) {
      //get the color of this pixel
      //find pixel in linear array using formula: pos = row*rowWidth+column
      color pixelColor = cam.pixels[row*width+column];
      
      // if this is closest to our target color, take note of it
      if(colors[0] == 0) break;
      int result = pixelMatchesColor(pixelColor, colors, CONST_COLOR_TOLERANCE);
      
      if (result >= 0) {
        Pixel currentPosition = new Pixel();
        currentPosition.row = row; 
        currentPosition.column = column;
        currentPosition.pColor = result;
        
        // first matching pixel
        if (matchingPixel.length == 0) {
          matchingPixel = (Pixel[])append(matchingPixel, currentPosition);
        }
        // only append matchingPixel with current pixel if it's not contained yet
        for(int i=0; i<matchingPixel.length; i++) {
          if(sqrt(sq(matchingPixel[i].row - currentPosition.row) + sq(matchingPixel[i].column - currentPosition.column)) <= CONST_MIN_DISTANCE){
            break;
          }
          if(i == matchingPixel.length-1) {
           matchingPixel = (Pixel[])append(matchingPixel, currentPosition);
          }
        }
      }  
    }
  }
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
 *  Return the index of matching color in colors array
 */
int pixelMatchesColor(color pixelColor, color[] colorArray, float colorTolerance) {
  int result = -1;
  for (int i=0; i<colorArray.length; i++) {
    if(colorArray[i] == 0) continue; // no absolute black color
    float diff = abs(red(colorArray[i]) - red(pixelColor)) + abs(green(colorArray[i]) - green(pixelColor)) + abs(blue(colorArray[i]) - blue(pixelColor))/3;
    if(diff<=colorTolerance) {
      result = i;
      break;
    }
  }
  return result;
}

/*  ToDo!
 *  Average color of selected pixel and its sourrounding pixels
 */
//color averageColorOfPixel(Pixel px) {
  
//}

/*
 *  Statistics
 */
void showStatistics() {
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
}
