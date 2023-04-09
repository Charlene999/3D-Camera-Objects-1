// VertexAnimation Project - Student Version
/*
Charlene Creighton
CAP3027
Project 6
Professor Fox
December 6, 2022
*/
import java.io.*;
import java.util.*;

// Camera Object reused from Project 3, mouse controls position of grid
Camera myCam = new Camera();

void mouseWheel(MouseEvent event) {
  
  // Zoom in if less than 0, out if greater
  if (event.getCount() > 0)
  {
    for (float i = 0; i < event.getCount(); i++)
    {
      if (myCam == null)
        break;
      
      myCam.Radius /= .75;
      if (myCam.Radius >=200)
      {
        myCam.Radius =200;
        break;
      }
    }
    
  }
    
  else
  {
    for (float i =0; i > event.getCount(); i--)
    {
        if (myCam == null)
          break;
        
        myCam.Radius *= .75;
        if (myCam.Radius <= 30)
        {
          myCam.Radius = 30;
          break;
        }
    }
  }
}


class Camera
{
  // Initialize camera variables
  ArrayList<PVector> Targets = new ArrayList();
  float xPos;
  float yPos;
  float zPos;
  float Radius;
  float lookX;
  float lookY;
  float lookZ;
  float derX;
  float derY;
  float derZ;
  float Phi;
  float Theta;
  
  Camera()
  {
    lookX = 0;
    lookY = 0;
    lookZ = 0;
    Radius = 150;
  }
  
  void createGrid()
  {
    // Draw Entire Grid
    strokeWeight(3);
    stroke(0, 0, 0);
    for (float i = -100; i <= 100; i+=10)
      line(i, 0, -100, i, 0, 100);
    
    strokeWeight(5);
    stroke(0,0,255);
    line(0,0,-100,0,0,100);
    
    strokeWeight(3);
    stroke(0,0, 0);
    for (float i = -100; i <= 100; i+=10)
        line(-100, 0, i, 100, 0, i);
    
    strokeWeight(5);
    stroke(255,0,0);
    line(-100,0,0,100,0,0);
    stroke(0,0,0);
  }
  void Update()
  {
    // Set Angles and Camera view
    Phi = map(mouseX, 0, width - 1, 0, 360);
    Theta = map(mouseY, 0, height - 1, 1, 179);
    derX = Radius * cos(radians(Phi)) * sin(radians(Theta));
    derY = Radius * cos(radians(Theta));
    derZ = Radius * sin(radians(Phi)) * sin(radians(Theta));
    xPos = lookX + derX;
    yPos = lookY + derY;
    zPos = lookZ + derZ;
    camera
    (xPos, yPos, zPos,
    lookX, lookY, lookZ,
    0,1,0);
  }
  
}
/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually

ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

// TODO: Create animations for interpolators
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();

void setup()
{
  pixelDensity(2);
  size(1200, 800, P3D);

  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);
  
  // Set sphere animations
  spherePos = new Animation();
  PVector p1 = new PVector(-100, 0, 100);
  KeyFrame k1 = new KeyFrame();
  k1.time = 1.0f;
  k1.x = p1.x;
  k1.y = p1.y;
  k1.z = p1.z;
  spherePos.keyFrames.add(k1);
  PVector p2 = new PVector(-100, 0, -100);
  KeyFrame k2 = new KeyFrame();
  k2.time = 2.0f;
  k2.x = p2.x;
  k2.y = p2.y;
  k2.z = p2.z;
  spherePos.keyFrames.add(k2);
  PVector p3 = new PVector(100, 0, -100);
  KeyFrame k3 = new KeyFrame();
  k3.time = 3.0f;
  k3.x = p3.x;
  k3.y = p3.y;
  k3.z = p3.z;
  spherePos.keyFrames.add(k3);
  PVector p4 = new PVector(100, 0, 100);
  KeyFrame k4 = new KeyFrame();
  k4.time = 4.0f;
  k4.x = p4.x;
  k4.y = p4.y;
  k4.z = p4.z;
  spherePos.keyFrames.add(k4);
  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  int myX = -100;
  float speed = 0;
  for (int f = 0; f <= 10; f++)
  {
    PositionInterpolator cube = new PositionInterpolator();
    cube.animation = new Animation();
    PVector C1 = new PVector(myX, 0, 0);
    KeyFrame c1 = new KeyFrame();
    c1.time = .5f;
    c1.x = C1.x;
    c1.y = C1.y;
    c1.z = C1.z;
    cube.animation.keyFrames.add(c1);
    PVector C2 = new PVector(myX, 0, -100);
    KeyFrame c2 = new KeyFrame();
    c2.time = 1.0f;
    c2.x = C2.x;
    c2.y = C2.y;
    c2.z = C2.z;
    cube.animation.keyFrames.add(c2);
    PVector C3 = new PVector(myX, 0, 0);
    KeyFrame c3 = new KeyFrame();
    c3.time = 1.5f;
    c3.x = C3.x;
    c3.y = C3.y;
    c3.z = C3.z;
    cube.animation.keyFrames.add(c3);
    PVector C4 = new PVector(myX, 0, 100);
    KeyFrame c4 = new KeyFrame();
    c4.time = 2.0f;
    c4.x = C4.x;
    c4.y = C4.y;
    c4.z = C4.z;
    cube.animation.keyFrames.add(c4);
    myX += 20;
    cube.Update(speed);
    cubes.add(cube);
    speed += .1;
  }
  /*====== Create Animations For Spheroid ======*/
  
  // Create and set keyframes
  spherePosition.SetAnimation(spherePos);
}

void draw()
{
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);
  lights();
  background(0);
  lightFalloff(1.0, 0.001, 0.0001);
  
  // Use camera from project 3
  myCam.Update();
  DrawGrid();
  float playbackSpeed = .005f;
  float monsterSpeed = .005f;
  // TODO: Implement your own camera

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  //Orange 
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(monsterSpeed);
  shape(monsterForward.currentShape);
  popMatrix();
  
  /*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  // Green
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-monsterSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();
  
  /*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  // Brown
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(monsterSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();
  
  /*====== Draw Spheroid ======*/
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
  /*====== TODO: Update and draw cubes ======*/
  // For each interpolator, update/draw
  for (int i = 0; i < cubes.size(); i++)
  {
    cubes.get(i).Update(playbackSpeed);
    if (i % 2 == 0)
      fill(255, 0, 0);
    
    else
    {
      fill(255, 255, 0);
      //cubes.get(i).SetFrameSnapping(true);
    }
      
    pushMatrix();
    translate(cubes.get(i).currentPosition.x, cubes.get(i).currentPosition.y, cubes.get(i).currentPosition.z); 
    box(10);  
    popMatrix();
  }
  camera();
  perspective();
}


// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();

  String line;
  String lineData[];
  int numKeyFrames;
  int numDataPoints;
  float x, y, z; 
  float curTime;
  // The BufferedReader class will let you read in the file data
  try
  {
    BufferedReader reader = createReader(fileName);
    line = reader.readLine();
    numKeyFrames = parseInt(line);
    line = reader.readLine();
    numDataPoints = parseInt(line);
    
    // For each key frame, read all data
    for (int i = 0; i < numKeyFrames; i++)
    {
      KeyFrame curKey = new KeyFrame();
      
      // Get time
      line = reader.readLine();
      curKey.time = parseFloat(line);
      for (int j = 0; j < numDataPoints; j++)
      {
        line = reader.readLine();
        lineData = line.split(" ");
        x = parseFloat(lineData[0]);
        y = parseFloat(lineData[1]);
        z = parseFloat(lineData[2]);
        PVector myVec = new PVector(x,y,z);
        curKey.points.add(myVec);
        
      }
      animation.keyFrames.add(curKey);
      //animation.timesAndPoints.put(curKey.points, curKey.time);
    }
    reader.close();
  }
  catch (FileNotFoundException ex)
  {
    println("File not found: " + fileName);
  }
  catch (IOException ex)
  {
    ex.printStackTrace();
  }
 
  return animation;
}

void DrawGrid()
{
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  // Draw Entire Grid
    strokeWeight(3);
    stroke(255);
    for (float i = -100; i <= 100; i+=10)
      line(i, 0, -100, i, 0, 100);
    
    strokeWeight(5);
    stroke(255,0,0);
    line(0,0,-100,0,0,100);
    
    strokeWeight(3);
    stroke(255);
    for (float i = -100; i <= 100; i+=10)
        line(-100, 0, i, 100, 0, i);
    
    strokeWeight(5);
    stroke(0,0,255);
    line(-100,0,0,100,0,0);
    stroke(0,0,0);
}
