import controlP5.*;
import processing.sound.*;
SoundFile music;
ControlP5 cp5;
int myColor = color(0, 0, 0);

int sliderValue = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;

ArrayList<PVector> stars;
int numberOfStars;
int x = 0;
int y = 0;

int sunInitR;
int sunInitG;
int sunInitB;
int sunInitSize;
int blurFactor;
PImage sun;

PImage earth;
int earthDist;
float earthX;
float earthY;
PVector earthRotation;
int earthSpeed;

int moonDist;
int moonSpeed;
PVector moonRotation;

boolean isPlaying = true;

int planetSize = 20;
int planetOrbitSpeed = 1;
int planetMoonSpeed = 2;
int planetRotateSpeed = 1;
int distToSun = 200;
boolean hasAMoon = true;
int distToMoon = 50;
int planetMoonSize = 10;
color planetColor;
int _r = 50;
int _g = 50;
int _b = 50;

class Planet {
  public int _planetSize = 20;
  public int _planetOrbitSpeed = 1;
  public int _planetMoonSpeed = 2;
  public int _planetRotateSpeed = 1;
  public int _distToSun = 200;
  public boolean _hasAMoon = true;
  public int _distToMoon = 50;
  public int _planetMoonSize = 10;
  public color _planetColor = color(_r, _g, _b);
  public PVector _planetRotation = new PVector(1, 0);
  public PVector _moonRotation = new PVector(1, 0);
}

ArrayList<Planet> planets = new ArrayList<Planet>();

void setup()
{  
  // set up base
  size(700, 700);
  background(0);

  // set up sound
  music = new SoundFile(this, "melancholy-11828.mp3");
  music.loop();

  // set up default stars
  numberOfStars = 100;
  setupStars();

  // set up default earth
  earth = loadImage("earth.png");
  earthDist = 200;
  earthRotation = new PVector(earthDist, 0);
  earthSpeed = 1;

  // set up default moon
  moonDist = 50;
  moonRotation = new PVector(moonDist, 0);
  moonSpeed = 2;

  // set up GUI
  noStroke();
  cp5 = new ControlP5(this);

  // create slider to control distance from earth to sun
  cp5.addSlider("earth_to_sun")
    .setPosition(width-180, height-100)
    .setSize(100, 10)
    .setRange(0, 400)
    .setValue(200)
    ;

  // create slider to control distance from moon to earth
  cp5.addSlider("moon_to_earth")
    .setPosition(width-180, height-80)
    .setSize(100, 10)
    .setRange(0, 300)
    .setValue(50)
    ;

  // create slider to control orbit speed of earth
  cp5.addSlider("earth_speed")
    .setPosition(width-180, height-60)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(1)
    .setNumberOfTickMarks(10)
    ;

  // create slider to control orbit speed of moon
  cp5.addSlider("moon_speed")
    .setPosition(width-180, height-40)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(2)
    .setNumberOfTickMarks(10)
    ;

  // create a animation toggle
  cp5.addToggle("play_animation")
    .setPosition(20, height-100)
    .setSize(100, 15)
    .setValue(true)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;     

  // create a text input field for number of stars
  cp5.addTextfield("Number of Stars")
    .setPosition(20, height-75)
    .setSize(100, 15)
    .setFocus(true)
    .setColor(color(255, 255, 255))
    ;

  // create a new button to take screen shot
  cp5.addButton("screen_shot")
    .setValue(0)
    .setPosition(20, height-40)
    .setSize(100, 15)
    ;


  // create slider to control planet size
  cp5.addSlider("planet_size")
    .setPosition(300, height-100)
    .setSize(100, 10)
    .setRange(1, 100)
    .setValue(20)
    .setNumberOfTickMarks(50)
    ;

  // create slider to control orbit speed of this planet
  cp5.addSlider("orbit_speed")
    .setPosition(300, height-80)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(1)
    .setNumberOfTickMarks(10)
    ;

  // create slider to control orbit speed of this planet
  cp5.addSlider("rotate_speed")
    .setPosition(300, height-60)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(1)
    .setNumberOfTickMarks(10)
    ;

  // create slider to control distance from planet to sun
  cp5.addSlider("dist_to_sun")
    .setPosition(300, height-40)
    .setSize(100, 10)
    .setRange(0, 300)
    .setValue(50)
    ;

  // create a new button to generate planet
  cp5.addButton("create")
    .setValue(0)
    .setPosition(470, height-100)
    .setSize(40, 30)
    ;

  // create a new button to remove custom planets
  cp5.addButton("remove")
    .setValue(0)
    .setPosition(470, height-60)
    .setSize(40, 30)
    ;

  // create a new button to reset all
  cp5.addButton("reset")
    .setValue(0)
    .setPosition(width-40, 20)
    .setSize(30, 15)
    ;

  // create toggle button of moon option for new planet
  cp5.addToggle("has_a_moon")
    .setPosition(130, height-100)
    .setSize(100, 15)
    .setValue(true)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;   

  // create toggle button of red option for new planet
  cp5.addToggle("r")
    .setPosition(235, height-100)
    .setSize(15, 15)
    .setValue(true)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;  

  // create toggle button of green option for new planet
  cp5.addToggle("g")
    .setPosition(255, height-100)
    .setSize(15, 15)
    .setValue(true)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;  

  // create toggle button of blue option for new planet
  cp5.addToggle("b")
    .setPosition(275, height-100)
    .setSize(15, 15)
    .setValue(true)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;  

  // create slider to control distance from moon to new planet
  cp5.addSlider("dist_to_moon")
    .setPosition(130, height-60)
    .setSize(100, 10)
    .setRange(0, 300)
    .setValue(50)
    ;

  // create slider to control planet's moon size
  cp5.addSlider("moon_size")
    .setPosition(130, height-80)
    .setSize(100, 10)
    .setRange(1, 30)
    .setValue(10)
    .setNumberOfTickMarks(30)
    ;

  // create slider to control orbit speed of moon
  cp5.addSlider("child_speed")
    .setPosition(130, height-40)
    .setSize(100, 10)
    .setRange(0, 10)
    .setValue(2)
    .setNumberOfTickMarks(10)
    ;

  drawSun();
  smooth();
}

void draw() {
  if (isPlaying) {
    background(0);
    loadSun();
    drawStars();
    drawEarth();
    drawMoon();
    getStarNumInput();
  }
}

String textValue = "100";
void getStarNumInput() {
  text(cp5.get(Textfield.class, "Number of Stars").getText(), 360, 130);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    numberOfStars = Integer.valueOf(theEvent.getStringValue());
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }
}

void earth_to_sun(int newDist) {
  earthDist = newDist;
  earthRotation = new PVector(earthDist, 0);
}

void moon_to_earth(int newDist) {
  moonDist = newDist;
  moonRotation = new PVector(moonDist, 0);
}

void earth_speed(int speed) {
  earthSpeed = speed;
}

void moon_speed(int speed) {
  moonSpeed = speed;
}

void play_animation(boolean flag) {
  isPlaying = flag;
}

void screen_shot() {
  save("screenshot.png");
}

void planet_size(int size) {
  planetSize = size;
}

void orbit_speed(int speed) {
  planetOrbitSpeed = speed;
}

void rotate_speed(int speed) {
  planetRotateSpeed = speed;
}

void dist_to_sun(int dist) {
  distToSun = dist;
}

void has_a_moon(boolean flag) {
  hasAMoon = flag;
}

void dist_to_moon(int dist) {
  distToMoon = dist;
}

void moon_size(int size) {
  planetMoonSize = size;
}

void child_speed(int size) {
  planetMoonSize = size;
}

void r(boolean flag) {
  if (flag) {
    _r = 200;
  } else
  {
    _r = 50;
  }
}

void g(boolean flag) {
  if (flag) { 
    _g = 200;
  } else
  {
    _g = 50;
  }
}

void b(boolean flag) {
  if (flag) { 
    _b = 200;
  } else
  {
    _b = 50;
  }
}

void create() {
  Planet newP = new Planet();
  newP._planetSize = planetSize;
  newP._planetOrbitSpeed= planetOrbitSpeed;
  newP._planetRotateSpeed = planetRotateSpeed;
  newP._distToSun = distToSun;
  newP._hasAMoon = hasAMoon;
  newP._distToMoon = distToMoon;
  newP._planetMoonSize = planetMoonSize;
  newP._planetColor = color(_r, _g, _b);
  newP._planetRotation = new PVector(distToSun, 0);
  newP._moonRotation = new PVector(distToMoon, 0);
  planets.add(newP);
}

void remove() {
  planets = new ArrayList<Planet>();
}

void reset() {
  planets = new ArrayList<Planet>();
  // set up default stars
  numberOfStars = 100;

  // set up default earth
  earthDist = 200;
  earthRotation = new PVector(earthDist, 0);
  earthSpeed = 1;

  // set up default moon
  moonDist = 50;
  moonRotation = new PVector(moonDist, 0);
  moonSpeed = 2;
}

void drawSun() {
  background(0);

  // draw sun
  sunInitR = 255;
  sunInitG = 0;
  sunInitB = 0;
  sunInitSize = 100;
  blurFactor= 25;
  noStroke();
  ellipseMode(CENTER);
  for (int i = 1; i < 5; i++)
  {
    fill(sunInitR*i, sunInitG*i, sunInitB);
    ellipse(width/2, height/2, sunInitSize, sunInitSize);
    filter(BLUR, blurFactor);  
    sunInitR += 20;
    sunInitG += 30;
    sunInitSize -= 15;
    blurFactor -=5;
    if (i == 3) {
      sunInitR = 255;
      sunInitG = 255;
      sunInitB = 255;
      sunInitSize = 30;
    }
  }

  // save for use
  save("sun.png");
  sun = loadImage("sun.png");
}

void loadSun() {
  imageMode(CENTER);
  image(sun, width/2, height/2, width, height);
}

void setupStars() {
  stars = new ArrayList<PVector>();
  for (int i=0; i< 1000; i++) {
    x = int(random(width));
    y = int(random(width));
    stars.add(new PVector(x, y));
  }
}

void drawStars()
{
  // draw stars
  noiseSeed(0);
  stroke(255);
  if (numberOfStars < 0) {
    numberOfStars = 0;
  } else   if (numberOfStars > 1000) {
    numberOfStars = 1000;
  }
  for (int i=0; i< numberOfStars; i++) {
    ellipse(stars.get(i).x, stars.get(i).y, 1, 1);
  }
}

void drawEarth()
{
  // display earth
  imageMode(CENTER);
  earthRotation.rotate(radians(earthSpeed));
  earthX = screenX(width/2-earthRotation.x, height/2-earthRotation.y);
  earthY = screenY(width/2-earthRotation.x, height/2-earthRotation.y);
  image(earth, earthX, earthY, 22, 22);
}

void drawMoon()
{
  // display moon 
  moonRotation.rotate(radians(moonSpeed));
  fill(255);
  noStroke();
  ellipse(earthX - moonRotation.x, earthY - moonRotation.y, 10, 10);

  Planet planet;
  for (int i = 0; i < planets.size(); i++)
  {
    planet = planets.get(i);
    planet._planetRotation.rotate(radians(planet._planetOrbitSpeed));
    fill(planet._planetColor);
    ellipse(width/2 - planet._planetRotation.x, height/2 - planet._planetRotation.y, planet._planetSize, planet._planetSize);
    fill(255);
    if (planet._hasAMoon) {

      planet._moonRotation.rotate(radians(planet._planetMoonSpeed));
      float x = screenX((width/2)-planet._planetRotation.x, (height/2)-planet._planetRotation.y);
      float y = screenY((width/2)-planet._planetRotation.x, (height/2)-planet._planetRotation.y);
      ellipse(x- planet._moonRotation.x, y - planet._moonRotation.y, planet._planetMoonSize, planet._planetMoonSize);
    }
  }
}
