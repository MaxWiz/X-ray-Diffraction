//Variables essential to reading and printing the txt file
String filename="C:/Users/Max/Documents/GitHub/X-ray-Diffraction/Zn(2).txt";
String expected = "C:/Users/Max/Documents/GitHub/X-ray-Diffraction/GeEx.txt";
BufferedReader reader;
BufferedReader reader2;
String line;
int lineNumber;
int lineNumber2;

float Ymax=0.1;    //maximum Y-coordinate value, adjusted as data is read
float autoYscale=1.3; // variable for scaling the Y axis
int X1, Y1;        //integer variable for plotting
float startP, stopP;  //scan range

float[] Xdata=new float[50000];
float[] Ydata=new float[50000];
String[] ExpIndex = new String[100];
float[] ExpN1 = new float[100];
float[] ExpN2 = new float[100];
float[] ExpN3 = new float[100];
float[] OccuX = new float[2000];
float scanDir=1.0;
boolean newData=true;
int dataN=0;

int[] RGBvalues=new int[4];
float wavelength, R, G, B, T;

//Variables added for the maximum printing
float[] peaks=new float[20000];
int peakN;
float[] troughs=new float[20000];
int troughN;
float[] sortM=new float[20000];
int sortN;

int k;
float[] maxima=new float[1000];

float total;
float averageV;
float cutoff;

float[] unkTable=new float[20000];
boolean unk;
String shortName;

void setup(){
  lineNumber=0;
  lineNumber2=0;
  size(1300,800);  //sets the size of drawing window
  delay(1000);
  reader = createReader(filename);
  reader2 = createReader(expected);
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  while (line != null) {
    String[] pieces = split(line, TAB); 
    if (lineNumber==0) {
      startP = float(pieces[0]);
    }
    if (lineNumber < 50000) {
      Xdata[lineNumber] = float(pieces[0]);
      Ydata[lineNumber] = float(pieces[1]);
      stopP = Xdata[lineNumber];
      total+=float(pieces[1]);
    }
    lineNumber++;
    dataN++;
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
  }
  if (startP > stopP) {
    float t1 = startP;
    startP = stopP;
    stopP = t1;
  }
  try {
    line = reader2.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  while (line != null) {
    String[] pieces = split(line, TAB);
    ExpIndex[lineNumber2] = pieces[0];
    if (pieces[2] != "") {
      ExpN1[lineNumber2] = float(pieces[2]);
    }
    if (pieces[3] != "") {
      ExpN2[lineNumber2] = float(pieces[3]);
    }
    if (pieces[4] != "") {
      ExpN3[lineNumber2] = float(pieces[4]);
    }
    lineNumber2++;
    try {
      line = reader2.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      }
    }
  noLoop();
}

void draw() {
  Ymax=autoYscale*getMaxY(Ydata);
  plot();
}

void plot(){
  background(255);  //white background color
  fill(255);        //fill a close shape with white color
  stroke(0);        //black drawing color
  rect(100,50,1100,650);  //draw the rectangle
  for(int i=1;i<10;i++){  //to draw 9 grid lines horizontally and vertically
    stroke(200);    //choose a grey drawing color
    X1=int(map(startP+(stopP-startP)*i/10, startP, stopP, 0, 1100));
    line(X1+100,700,X1+100,50);
    Y1=int(map(Ymax*i/10,0,Ymax,0,650));
    line(100,Y1+50,1200,Y1+50);
  }
  fill(0);
  textSize(30);
  shortName = filename.substring(48, filename.length()-4) + "_Maximums.txt";  //Will likely need altering
  text(shortName,400,35);
  textSize(18);
  text(str(startP),80,730);
  text(str(stopP),1180,730);
  textSize(18);
  text("0.0 V",30,709);
  text(str(Ymax),30,39);
  
  textSize(24);
  text("Angle (2 theta)",570,750);
  
  pushMatrix();
  translate(55,420);
  rotate(-HALF_PI);
  text("Intensity (V)",0,0);
  popMatrix();
  
  stroke(255,0,0);  //pencil color red
  fill(255);        //fill closed shapes with white
  for (int j=0; j<dataN; j++){
    X1=int(map(Xdata[j], startP, stopP, 0, 1100));  //rescale to pixel numbers
    Y1=int(map(Ydata[j], 0, Ymax, 0, 650)); 
    RGBvalues=getRGB(Xdata[j]);
    R=RGBvalues[0];
    G=RGBvalues[1];
    B=RGBvalues[2];
    T=RGBvalues[3];
    stroke(int(R),int(G),int(B),int(T));  //set the color
    line(100+X1,700-Y1,100+X1,705-Y1);      //draw a vertical line
  }
  printMaxima();
}

int[] getRGB(float wavelength){
  if(wavelength<380) {
    R=0; G=0; B=0;T=wavelength/380;
  } else if((wavelength>=380) && (wavelength<440)) {
    R=-(wavelength-440)/(440-380); G=0; B=1;T=1;
  } else if((wavelength>=440) && (wavelength<490)) {
    R=0; G=(wavelength-440)/(490-440); B=1;T=1;
  } else if((wavelength>=490) && (wavelength<510)) {
    R=0; G=1; B=-(wavelength-510)/(510-490);T=1;
  } else if((wavelength>=510) && (wavelength<580)) {
    R=(wavelength-510)/(580-510); G=1; B=0;T=1;
  } else if((wavelength>=580) && (wavelength<645)) {
    R=1; G=-(wavelength-645)/(645-580); B=0;T=1;
  } else if((wavelength>=645) && (wavelength<781)) {
    R=1; G=0; B=0;T=1;
  } else if((wavelength>=781) && (wavelength<1172)){
    R=1; G=0; B=0;T=1-(wavelength-781)/781;
  } else {
    R=1; G=0; B=0; T=0.5;
  }
  RGBvalues[0]=int(R*255);
  RGBvalues[1]=int(G*255);
  RGBvalues[2]=int(B*255);
  RGBvalues[3]=int(T*255);
  return RGBvalues;
}

float getMaxY(float[] Y) {
  float maxY=0.0;
  for(int i=0; i < dataN; i++) {
    if(Y[i] > maxY) {
      maxY = Y[i];
    }
  }
  return maxY;
}

void printMaxima() {
  for(int i=0; i<29996; i++) {
    float x1,x2,y1,y2,x3,x4,y3,y4,m1,m2;
    x1=Xdata[i];
    y1=Ydata[i];
    x2=Xdata[i+1];
    y2=Ydata[i+1];
    x3=Xdata[i+2];
    y3=Ydata[i+2];
    x4=Xdata[i+3];
    y4=Ydata[i+3];
    m1 = (y2-y1)/(x2-x1);
    m2 = (y4-y3)/(x4-x3);
    if ((m1>0) && (m2<0)) {
      peaks[peakN] = ((x2+x3)/2);
      peaks[peakN+1] = ((y2+y3)/2);
      peakN+=2;
    }
    if ((m1<0) && (m2>0)) {
      troughs[troughN] = ((x2+x3)/2);
      troughs[troughN+1] = ((y2+y3)/2);
      troughN+=2;
    }
  }
  peakN=0;
  averageV=total/lineNumber;
  for (int i=0; i<=120; i+=2) {
    float[] max = findRelMax(i-2, i+2);
    //println(max[0] + "\t" + max[1]);
    unk=true;
    //for(int j=0; j<11999; j++) {
    //  if ((unkTable[j] >= max[0]) && (unkTable[j] != 0)) {
    //    unk=false;
    //    }
    //}
    if (unk) {
      unkTable[i] = max[0];
    }
    cutoff = 1.2*averageV;
    if ((max[1] > cutoff) && (unk)) {
      maxima[peakN]=max[0];
      maxima[peakN+1]=max[1];
      //println(max[0] + "\t" + max[1]);
      peakN+=2;
    }
  }
  println("Printing Maxima");
  for (int j=0; j<999; j+=2) {
    if (maxima[j+1]!=0.0) {
      X1=int(map(maxima[j], startP, stopP, 0, 1100));  //rescale to pixel numbers
      Y1=int(map(maxima[j+1], 0, Ymax, 0, 650)); 
      RGBvalues=getRGB(maxima[j]);
      R=RGBvalues[0];
      G=RGBvalues[1];
      B=RGBvalues[2];
      T=RGBvalues[3];
      stroke(0x0);  //set the color
      strokeWeight(2);
      line(X1+100,690-Y1,X1+100,670-Y1);      //draw a vertical line
      //println(maxima[j] + "\t" + maxima[j+1]);
      //println("Energy: " + energy + "eV");
      fill(0);
      textSize(16);
      int avgY = (int)(700-(averageV/Ymax)*600);
      text("Average V",1210,avgY+5);
      //println(averageV);
      strokeWeight(1);
      for (int i=0; i<32; i++) {
        line(105+(35*i),avgY,115+(35*i),avgY);
      }
      fill(0);
      textSize(18);
      text(str(maxima[j])+" degrees",X1+40,660-Y1);
      textSize(16);
      int cutoffV = (int)(700-(cutoff/Ymax)*600);
      text("Cutoff V",1210,cutoffV+5);
      strokeWeight(1);
      for (int i=0; i<32; i++) {
        line(105+(35*i),cutoffV,115+(35*i),cutoffV);
      }
    }
  }
  //println("Printing Expected Maxima");
  //for (int i = 0; i < 99; i++) {
  //  if ((ExpN1[i] != 0) && (ExpN1[i] >= startP) && (ExpN1[i] <= stopP)) {
  //    X1=int(map(ExpN1[i], startP, stopP, 0, 1100));  //rescale to pixel numbers
  //    Y1=int(map(cutoff, 0, Ymax, 0, 650));
  //    stroke(255, 0, 0);  //set the color
  //    strokeWeight(2);
  //    for (int j=2; j < 7; j++) {
  //      line(X1+100,690-Y1+(40*j),X1+100,670-Y1+(40*j));
  //    }
  //    fill(255, 0, 0);
  //    if (OccuX[X1+110]== 1) {
  //      line(X1+100, 725, X1+100, 740);
  //      text("(" + ExpIndex[i] + ")", X1+85, 760);
  //    } else {
  //      text("(" + ExpIndex[i] + ")", X1+85, 720);
  //      for (int k=0; k < 40; k++) {
  //        OccuX[X1+90+k]++;
  //      }
  //    }
  //  }
  //  if ((ExpN2[i] != 0) && (ExpN2[i] >= startP) && (ExpN1[i] <= stopP)) {
  //    X1=int(map(ExpN2[i], startP, stopP, 0, 1100));  //rescale to pixel numbers
  //    Y1=int(map(cutoff, 0, Ymax, 0, 650));
  //    stroke(0, 255, 0);  //set the color
  //    strokeWeight(3);
  //    for (int j=3; j < 7; j++) {
  //      line(X1+100,670-Y1+(40*j),X1+100,650-Y1+(40*j));
  //    }
  //    fill(0, 255, 0);
  //    if (OccuX[X1+110]== 1) {
  //      line(X1+100, 720, X1+100, 740);
  //      text("(" + ExpIndex[i] + ")", X1+85, 760);
  //    } else {
  //      text("(" + ExpIndex[i] + ")", X1+85, 720);
  //      for (int k=0; k < 40; k++) {
  //        OccuX[X1+90+k]++;
  //      }
  //    }
  //  }
  //  if ((ExpN3[i] != 0) && (ExpN3[i] >= startP) && (ExpN1[i] <= stopP)) {
  //    X1=int(map(ExpN3[i], startP, stopP, 0, 1100));  //rescale to pixel numbers
  //    Y1=int(map(cutoff, 0, Ymax, 0, 650));
  //    stroke(0, 0, 255);  //set the color
  //    strokeWeight(4);
  //    for (int j=3; j <7; j++) {
  //      line(X1+100,680-Y1+(40*j),X1+100,660-Y1+(40*j));
  //    }
  //    fill(0, 0, 255);
  //    if (OccuX[X1+110]== 1) {
  //      line(X1+100, 720, X1+100, 740);
  //      text("(" + ExpIndex[i] + ")", X1+85, 760);
  //    } else {
  //      text("(" + ExpIndex[i] + ")", X1+85, 720);
  //      for (int k=0; k < 40; k++) {
  //        OccuX[X1+90+k]++;
  //      }
  //    }
  //  }
  //}
  String filenameImage = filename.substring(0, filename.length()-4) + "_Maximums.png";
  String maxfilenameImage = filename.substring(0, 48) + "/Maximums/" + shortName.substring(0, shortName.length()-4) + ".png";
  println(maxfilenameImage);
  println(filenameImage);
  save(filenameImage);
  save(maxfilenameImage);
  println("Image saved.");
}

float[] findRelMax(float start, float end) {
  float[] pair={0.0, 0.0};
  for (int i=0; i < 19998; i+=2) {
    if ((peaks[i] > start) && (peaks[i] < end)) {
      sortM[sortN] = peaks[i];
      sortM[sortN+1] = peaks[i+1];
      sortN+=2;
    }
  }
  int current = 0;
  while (current < 19999) {
    if (sortM[current+1] > pair[1]) {
      pair[0] = sortM[current];
      pair[1] = sortM[current+1];
    }
    current+=2;
  }
  sortN = 0;
  return pair;
}
