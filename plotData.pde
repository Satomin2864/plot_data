// Chat Server 

import processing.net.*;
import java.util.Arrays;

float a, b, c;
float a_x, a_y, a_z, g_x, g_y, g_z;
float _a_x, _a_y, _a_z, _g_x, _g_y, _g_z;
int port = 13000;
boolean myServerRunning = true;
int bgColor = 0;
int direction = 1;
int textLine = 60;
String data;
String[] data_list = new String [7];
int[] plot_datalist = new int [100];
Server myServer;
graphMonitor AGraph, GGraph;

void setup()
{
  size(1920, 1080, P3D);
  frameRate(3);
  textFont(createFont("SanSerif", 16));
  myServer = new Server(this, port); // Starts a myServer on port 13000
  AGraph = new graphMonitor("A_data", 100, 100, 500, 400);
  GGraph = new graphMonitor("G_data", 700, 100, 500, 400);
}

void mousePressed()
{
  // If the mouse clicked the myServer stops
  myServer.stop();
  myServerRunning = false;
}

void draw()
{
    background(250);
    if (myServerRunning == true)
    {
      text("server", 15, 45);
      Client thisClient = myServer.available();
      if (thisClient != null) {
        if (thisClient.available() > 0) {
           thisClient.write('s');
          data = thisClient.readString();
          if (data != null) {
            println(data);
            data_list = split(data, ",");
            
            _a_x = a_x; 
            _a_y = a_y;
            _a_z = a_z;
            _g_x = g_x;
            _g_y = g_y;
            _g_z = g_z;
            a_x = float(data_list[0]);
            a_y = float(data_list[1]);
            a_z = float(data_list[2]);
            g_x = float(data_list[3]);
            g_y = float(data_list[4]);
            g_z = float(data_list[5]);
            //a_x = a_x - _a_x; 
            //a_y = a_y - _a_y;
            //a_z = a_z - a_z;
            //g_x = g_x - _g_x;
            //g_y = g_y - _g_y;
            //g_z = g_z - _g_z;
            
            AGraph.graphDraw(a_x, a_y, a_z);
            text("a_x = ", 300,600);
            text(a_x, 400,600);
            text("a_y = ", 300,620);
            text(a_y, 400,620);
            text("a_z = ", 300,640);
            text(a_z, 400,640);
            
            GGraph.graphDraw(g_x, g_y, g_z);
            text("g_x = ", 900,600);
            text(g_x, 1000,600);
            text("g_y = ", 900,620);
            text(g_y, 1000,620);
            text("g_z = ", 900,640);
            text(g_z, 1000,640);
          }
      }
    } 
    else 
    {
      text("server", 15, 45);
      text("stopped", 15, 65);
    }
  }
}

class graphMonitor {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 1;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
        maxRange = (abs(y3[i]) > maxRange ? abs(y3[i]) : maxRange);
      }

      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(240);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);

      textSize(25);
      fill(60);
      textAlign(LEFT, BOTTOM);
      text(TITLE, 20, -5);
      textSize(22);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2 + 7);
      text(nf(maxRange, 0, 1), -5, 18);
      text(nf(-1 * maxRange, 0, 1), -5, Y_LENGTH);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255, 0, 0);
        line(i, y1[i] * (Y_LENGTH / 2) / maxRange, i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(255, 0, 255);
        line(i, y2[i] * (Y_LENGTH / 2) / maxRange, i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(0, 0, 0);
        line(i, y3[i] * (Y_LENGTH / 2) / maxRange, i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      }
      popMatrix();
    }
}