import java.net.DatagramPacket;
import java.net.DatagramSocket;

int port = 3333;
DatagramSocket dsocket = null;
boolean initializedCanvas = false;

// Create a buffer to read datagrams into. If a
// packet is larger than this buffer, the
// excess will simply be discarded!
byte[] buffer = new byte[2048];

// Create a packet to receive data into the buffer
DatagramPacket packet = new DatagramPacket(buffer, buffer.length);

PImage img;
int currentSizeFactor = 2;

int lastTimeSaved;

void setup() {
  size(300,700);
  img = loadImage("glass_beer.png");
  
  try{
    dsocket = new DatagramSocket(port);
  }catch(Exception se){}

  lastTimeSaved = millis();
}

void draw() {
  background(255, 255, 255);
  
  int nextImageWidth = img.width / currentSizeFactor;
  int imagePositionX = width / 2 - nextImageWidth / 2;
  image(img, imagePositionX, 30, nextImageWidth, img.height / currentSizeFactor);
  
  if(millis() - lastTimeSaved > 2000){
    lastTimeSaved = millis();
    pushBack();
  }
  
  if( ! initializedCanvas){
    initializedCanvas = true;
  }else{
    try{
      dsocket.receive(packet);
    
      // Convert the contents to a string, and display them
      String message = new String(buffer, 0, packet.getLength());
      System.out.println(packet.getAddress().getHostName() + ": "
         + message);
      
      String[] stringValues = message.split(";");

      int valueChannel0 = Integer.parseInt(stringValues[0]);
  
      System.out.println(valueChannel0);
          
      /*
        Your code goes here.
        
        1. Analyze the raw data you receive from the EMG toolkit
        2. Based on your analysis, either 
          (a) do nothing; 
          (b) call pushBack(); or 
          (c) call moveForward();
       */
    
      // Reset the length of the packet before reusing it.
      packet.setLength(buffer.length);
      
    }catch(Exception e){}
  }
}

void pushBack(){
  currentSizeFactor++;
}

void moveForward(){
  if(currentSizeFactor > 1){
    currentSizeFactor--;
  }
}
