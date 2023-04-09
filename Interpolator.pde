abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
  void UpdateTime(float time)
  {
    // TODO: Update the current time
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly=
    
    if (currentTime > animation.GetDuration())
    {
      currentTime = 0;
    }
      
    if (currentTime < 0)
    {
      currentTime = animation.keyFrames.get(animation.keyFrames.size() - 1).time;
    }
   
    currentTime += time;
    return;
    
  }
  
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  void Update(float time)
  {
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    
    UpdateTime(time);
    
    // Tume ratio is ratio used in lerp
    float timeRatio;
    
    // Next stores index of next key frame, prev stores index of previous one
    int next = 0, prev = animation.keyFrames.size()-1;
    
    // Determine next and previous indexes of keyframes based on current time
    for (int i = 0; i < animation.keyFrames.size() - 1; i++)
    {
      if (currentTime >= animation.keyFrames.get(animation.keyFrames.size()-1).time || currentTime == 0)
      {
        prev = animation.keyFrames.size()-1;
        next = 0;
        break;
      }
      
      else 
      {
        if (currentTime >= animation.keyFrames.get(i).time && currentTime <= animation.keyFrames.get(i+1).time)
        {
          prev = i;
          next = i+1;
          break;
        }
      }
    }
    
    // Calculate time ratio and adjust if it is greater than 1
    timeRatio = (currentTime - animation.keyFrames.get(prev).time) / (animation.keyFrames.get(next).time - animation.keyFrames.get(prev).time);
    
    if (timeRatio > 1)
      timeRatio = currentTime / animation.keyFrames.get(next).time;
      
    noStroke();
    
    // Create shape using lerp if snapping is set to false
    currentShape = new PShape();
    currentShape = createShape();
    currentShape.beginShape(TRIANGLES);
    
    currentShape.fill(fillColor);
    
    // Prev stores previous key frames points, next stores next points
    ArrayList<PVector> Prev = animation.keyFrames.get(prev).points;
    ArrayList<PVector> Next = animation.keyFrames.get(next).points;
    
    // Draw vertices
    for (int i = 0; i < Prev.size(); i++)
    {
      float newX, newY, newZ;
      
        newX = lerp(Prev.get(i).x, Next.get(i).x, timeRatio);
        newY = lerp(Prev.get(i).y, Next.get(i).y, timeRatio);
        newZ = lerp(Prev.get(i).z, Next.get(i).z, timeRatio);
        
        if (snapping == false)
          currentShape.vertex(newX, newY, newZ); 
          
        else
        {
          currentShape.vertex(Prev.get(i).x, Prev.get(i).y, Prev.get(i).z); 
        }
      
    }
    
   currentShape.endShape(CLOSE);
   
  }
}

class PositionInterpolator extends Interpolator
{
  PVector currentPosition;
  
  void Update(float time)
  {
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
    
    // Update currentTime
    UpdateTime(time);
    float timeRatio;
    int next = 0, prev = animation.keyFrames.size()-1;
    
    // next is index of next keyframe, prev is index of previous one
    
    if (animation.keyFrames.size() <= 0)
      return;
    
    for (int i = 0; i < animation.keyFrames.size() - 1; i++)
    {
      if (currentTime >= animation.keyFrames.get(animation.keyFrames.size()-1).time)
      {
        prev = animation.keyFrames.size()-1;
        next = 0;
        break;
      }
      else 
      {
        if (currentTime >= animation.keyFrames.get(i).time && currentTime <= animation.keyFrames.get(i+1).time)
        {
          prev = i;
          next = i+1;
          break;
        }
      }
    } // for loop ending
    
    // Update time ratio
    timeRatio = (currentTime - animation.keyFrames.get(prev).time) / (animation.keyFrames.get(next).time - animation.keyFrames.get(prev).time);
    
    if (timeRatio > 1)
      timeRatio = currentTime / animation.keyFrames.get(next).time;
      
    float newX, newY, newZ;
    PVector Prev = new PVector(animation.keyFrames.get(prev).x, animation.keyFrames.get(prev).y, animation.keyFrames.get(prev).z);
    PVector Next = new PVector(animation.keyFrames.get(next).x, animation.keyFrames.get(next).y, animation.keyFrames.get(next).z);
      
    // Store postion of object based on lerp unless snapping is set to true
    newX = lerp(Prev.x, Next.x, timeRatio);
    newY = lerp(Prev.y, Next.y, timeRatio);
    newZ = lerp(Prev.z, Next.z, timeRatio);
        
    if (snapping == false)
       currentPosition = new PVector(newX, newY, newZ);
          
    else
       currentPosition = new PVector(Prev.x, Prev.y, Prev.z); 
  }
}
