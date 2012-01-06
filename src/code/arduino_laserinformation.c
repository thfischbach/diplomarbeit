/****************************
 ** Author: Thomas Fischbach
 ** Date: 26.09.2011
 **
 ** Description:
 ** This Arduino-program delivers average-values over
 ** [integrate] values of all 4 times of the counters
 ** on the EDF0611Boe in microseconds.
 ** It also delivers the time-jitter of the two lasers
 ** and the FSR-number relative to the starting FSR.
 ** Be careful, FSR-hop-detection only works if the
 ** laser-frequency changes not more than FSR/2.
 ** Otherwise you have to detect FSR-hops on your own.
 ** (also see "data_validation")
 ** There is also a data-validation-integer "dataOkay":
 **  1: Data is probably valid.
 **  0: Take care! Not plausible values were cancelled!
 ** Data is delivered over RS232 (USB) with a baud-rate
 ** of 115200 in a string:
 ** "*begin*workingTime offsetfringe_reference-laser
 ** offsetfringe_diode-laser interfringe_reference-laser
 ** interfringe_diode-laser jitter-time_reference-laser
 ** jitter-time_diode-laser FSR_number_ref FSR_number_DL
 ** data_validation*end*"
 ** The unit of workingTime is millisecond. The unit of
 ** the laser-times is microsecond.
 ** If [integrate] is >1, workingTime is multiplied
 ** by this value. 
 ** Depending on the Clock Rate (1.25, 2.5, 5 or 10 MHz)
 ** the constant clock must be changed.
 ** (for max. times/resolution see EDF0611Boe manual)
 ** For Pin-Setup check the constants below and the
 ** EDF0611Boe manual.
 **
 **
 ** OR: Offset-Fringe He:Ne
 ** IR: Inter-Fringe He:Ne
 ** OD: Offset-Fringe Diodenlaser
 ** ID: Inter-Fringe Diodenlaser
 ****************************/

 
//define signal number
#define sigNumberOR 0
#define sigNumberIR 1
#define sigNumberOD 2
#define sigNumberID 3

//define signal description strings
#define sigStringOR "Offset-Fringe He:Ne"
#define sigStringIR "Inter-Fringe He:Ne"
#define sigStringOD "Offset-Fringe Diodenlaser"
#define sigStringID "Inter-Fringe Diodenlaser"

//databits for all 4 Signals
boolean dataLowerByte[4][8]; //lower byte
boolean dataUpperByte[4][8]; //upper byte

//addressbits
boolean enable;
boolean addr0;
boolean addr1;
boolean addr2;

//define pins for databits
const int pinDatabit[] = {22, 23, 24, 25, 26, 27, 28, 29};

//define pins for statusbits
const int pinDORR = 36;
const int pinDIRR = 37;
const int pinDODR = 38;
const int pinDIDR = 39;

//define pins for addressbits
const int pinEnable = 41;
const int pinAddr[] = {42, 43, 40};

//already read data
boolean alreadyReadDOR = false;
boolean alreadyReadDIR = false;
boolean alreadyReadDOD = false;
boolean alreadyReadDID = false;

//already printed data (not used)
boolean alreadyPrinted = false;

//dummies / support-vars
long start_time, workingTime;
double const clock = 1.25; //clockrate [MHz]

//sum-values
long timeOR_sum;
long timeOD_sum;
long timeIR_sum;
long timeID_sum;

//mean-values
double timeOR_mean;
double timeOD_mean;
double timeIR_mean;
double timeID_mean;

//alltime mean-values
double timeIR_alltime_mean;
double timeID_alltime_mean;

//old times of previous ramp
long oldTimeOR;
long oldTimeOD;

//init current FSR as zero-reference
int FSR_number_DL = 0;
int FSR_number_ref = 0;

//FSR-numbers for first values of each mean-value
//(used as reference to calculate correct times
//if FSR-hops occure within one mean-value) 
int first_FSR_number_DL;
int first_FSR_number_ref;

//jitter-values
double jitterTimeDL;
double jitterTimeRef;

//1: okay
//0: corrupt
int dataOkay;

boolean firstLoop = true;

const int integrate = 10; //intended integration of values
int realIntegrate; //real integration of values
long count = 0; // count of valid values

void setup(){
  Serial.begin(115200);
  
  //init pins for databits
  for(int i = 0; i < 8; i++){
    pinMode(pinDatabit[i], INPUT);
  }
  
  //init pins for statusbits
  pinMode(pinDORR, INPUT); //DORR
  pinMode(pinDIRR, INPUT); //DIRR
  pinMode(pinDODR, INPUT); //DODR
  pinMode(pinDIDR, INPUT); //DIDR
  
  //init pins for address
  pinMode(pinEnable, OUTPUT); //enable pin
  for(int i = 0; i < 3; i++){
    pinMode(pinAddr[i], OUTPUT);
  }
  
  pinMode(32, OUTPUT); //dummy
  pinMode(33, OUTPUT); //dummy
}

void loop() {
  start_time = millis();
  
  timeOR_sum = 0;
  timeOD_sum = 0;
  timeIR_sum = 0;
  timeID_sum = 0;
  
  dataOkay = 1; //init data okay 
  
  //integrate minus count of corrupt ramps
  realIntegrate = integrate;
  
  //bundles of [integrate] offset-fringe-values
  long timeOR[integrate];
  long timeOD[integrate];
  long timeIR[integrate];
  long timeID[integrate];
  
  //correct offset-fringes
  long correctedTimeOR[integrate];
  long correctedTimeOD[integrate];
  
  //use FSR of first ramp as reference-FSR
  //of all values used for one mean-value
  first_FSR_number_DL = FSR_number_DL;
  first_FSR_number_ref = FSR_number_ref;
  
  for (int i = 0; i < integrate; i++){
    //wait counter-reset
    while (digitalRead(pinDORR) || digitalRead(pinDODR) ||
           digitalRead(pinDIRR) || digitalRead(pinDIDR));
    
    readData();
    
    //fill bundle with fringe-values
    timeOR[i] = generateTime(sigNumberOR);
    timeOD[i] = generateTime(sigNumberOD);
    timeIR[i] = generateTime(sigNumberIR);
    timeID[i] = generateTime(sigNumberID);
    //Serial.println(timeIR[i]);
    
    if (firstLoop){
      //init values in first loop
      timeIR_alltime_mean = timeIR[i];
      timeID_alltime_mean = timeID[i];
      oldTimeOR = timeOR[i];
      oldTimeOD = timeOD[i];
      firstLoop = false;
    } else {
      count++;
      
      //calculate interfringe-deviation from interfringe-mean-value
      int time_IR_mean_dev = timeIR[i] - timeIR_alltime_mean;
      int time_ID_mean_dev = timeID[i] - timeID_alltime_mean;
      //Serial.println(timeIR[i]);
      
      //detect too big deviations of interfringes from
      //interfringe-mean-values (e.g. caused by large
      //temperature-hops, FPI-/ramp-problems (during scan),
      //or counter-problems) and skip corrupt values
      if ((abs(time_IR_mean_dev) < 0.1 * timeIR_alltime_mean) &&
          (abs(time_ID_mean_dev) < 0.1 * timeID_alltime_mean)){
        
        //detect FSR-hops
        if ((timeOR[i] - oldTimeOR) > (0.5 * timeIR[i])){
          FSR_number_ref -= 1;
          //Serial.println("Ref_FSR - 1");      
        } else if ((timeOR[i] - oldTimeOR) < -(0.5 * timeIR[i])){
            FSR_number_ref += 1;
            //Serial.println("Ref_FSR + 1");       
          } else {    
            if (((timeOD[i] - timeOR[i]) - (oldTimeOD - oldTimeOR))
                > (0.5 * timeID[i])){
              FSR_number_DL -= 1;
              //Serial.println("DL_FSR - 1");      
            }
            
            if (((timeOD[i] - timeOR[i]) - (oldTimeOD - oldTimeOR))
                < -(0.5 * timeID[i])){
              FSR_number_DL += 1;
              //Serial.println("DL_FSR + 1");       
            }
          }
        
        //correct wrong times caused by potential
        //FSR-hops for right mean-values
        correctedTimeOR[i] = timeOR[i]
         + (FSR_number_ref - first_FSR_number_ref) * timeIR[i];
        correctedTimeOD[i] = timeOD[i]
         + (FSR_number_DL - first_FSR_number_DL) * timeID[i];
        
        timeOR_sum += correctedTimeOR[i];
        timeOD_sum += correctedTimeOD[i];
        timeIR_sum += timeIR[i];
        timeID_sum += timeID[i];
        
        //current offset-times are old times during next ramp
        oldTimeOR = timeOR[i];
        oldTimeOD = timeOD[i];
        
        //new interfringe-mean-values
        timeIR_alltime_mean = (timeIR_alltime_mean * count + timeIR[i])
                              / (count + 1);
        timeID_alltime_mean = (timeID_alltime_mean * count + timeID[i])
                              / (count + 1);
        
      } else {
        realIntegrate--;
        dataOkay = 0;
      }
    }
  }
  
  if (realIntegrate > 1){ //enough values for mean-values
    
    //calculate mean_values
    timeOR_mean = timeOR_sum / realIntegrate;
    timeOD_mean = timeOD_sum / realIntegrate;
    timeIR_mean = timeIR_sum / realIntegrate;
    timeID_mean = timeID_sum / realIntegrate;
    
    //calculate jitter
    jitterTimeRef = jitter(correctedTimeOR, timeOR_mean);
    jitterTimeDL = jitter(correctedTimeOD, timeOD_mean);
  
    printData(); //print data
  } 
  

  workingTime = millis() - start_time; //calculate working-time
}


void readData(){
  
  //next value not until next ramp
  if (!digitalRead(pinDORR)){
    alreadyReadDOR = false;
  }
  
  if (!digitalRead(pinDODR)){
    alreadyReadDOD = false;
  }
  
  if (!digitalRead(pinDIRR)){
    alreadyReadDIR = false;
  }
  
  if (!digitalRead(pinDIDR)){
    alreadyReadDID = false;
  }
  
  //loop until every counter has been read
  while (!(alreadyReadDOR && alreadyReadDOD &&
           alreadyReadDIR && alreadyReadDID)){

    //wait until a counter can deliver data
    while (!(digitalRead(pinDORR) || digitalRead(pinDODR) ||
             digitalRead(pinDIRR) || digitalRead(pinDIDR)));
    
    //Check if DOR is ready and has not been read yet.
    //Then address register and read databits.
    if (digitalRead(pinDORR) && !alreadyReadDOR){
      digitalWrite(pinAddr[0], LOW);
      digitalWrite(pinAddr[1], LOW);
      digitalWrite(pinAddr[2], LOW);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataLowerByte[sigNumberOR][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      digitalWrite(pinAddr[0], HIGH);
      digitalWrite(pinAddr[1], LOW);
      digitalWrite(pinAddr[2], LOW);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataUpperByte[sigNumberOR][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      alreadyReadDOR = true;
    }
    
    //Check if DOD is ready and has not been read yet.
    //Then address register and read databits.
    if (digitalRead(pinDODR) && !alreadyReadDOD){
      digitalWrite(pinAddr[0], LOW);
      digitalWrite(pinAddr[1], LOW);
      digitalWrite(pinAddr[2], HIGH);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataLowerByte[sigNumberOD][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      digitalWrite(pinAddr[0], HIGH);
      digitalWrite(pinAddr[1], LOW);
      digitalWrite(pinAddr[2], HIGH);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataUpperByte[sigNumberOD][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      alreadyReadDOD = true;
    }
    
    //Check if DIR is ready and has not been read yet.
    //Then address register and read databits.
    if (digitalRead(pinDIRR) && !alreadyReadDIR){
      digitalWrite(pinAddr[0], LOW);
      digitalWrite(pinAddr[1], HIGH);
      digitalWrite(pinAddr[2], LOW);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataLowerByte[sigNumberIR][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);    
      digitalWrite(pinAddr[0], HIGH);
      digitalWrite(pinAddr[1], HIGH);
      digitalWrite(pinAddr[2], LOW);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataUpperByte[sigNumberIR][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      alreadyReadDIR = true;
    }
    
    //Check if DID is ready and has not been read yet.
    //Then address register and read databits.
    if (digitalRead(pinDIDR) && !alreadyReadDID){
      digitalWrite(pinAddr[0], LOW);
      digitalWrite(pinAddr[1], HIGH);
      digitalWrite(pinAddr[2], HIGH);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataLowerByte[sigNumberID][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);    
      digitalWrite(pinAddr[0], HIGH);
      digitalWrite(pinAddr[1], HIGH);
      digitalWrite(pinAddr[2], HIGH);
      digitalWrite(pinEnable, HIGH);
      for(int i = 0; i < 8; i++){
        dataUpperByte[sigNumberID][i] = digitalRead(pinDatabit[i]);
      }
      //very important!!! DO NOT REMOVE THE FOLLOWING LINE!!!
      //If line is removed, counter will be propably destroyed!
      digitalWrite(pinEnable, LOW);
      alreadyReadDID = true;
    }
  }
}


//generate real times from 2 x 8 Bit
long generateTime(int sigNumber){
  long time = 0;
  for(int i = 0; i < 8; i++){
    time += bit(i) * dataLowerByte[sigNumber][i];
  }
  
  for(int i = 0; i < 8; i++){
    time += bit(i + 8) * dataUpperByte[sigNumber][i];
  }
  
 return time / clock;
}


//calculate jitter time
double jitter(long* times, long mean){
  double jitter = 0;
  for (int i = 0; i < integrate; i++){
    jitter += pow(times[i] - mean, 2);
  }
  jitter /= (integrate - 1);
  return sqrt(jitter);
}


void printData(){
  Serial.print("*begin*");
  Serial.print(workingTime);
  Serial.print(" ");
  Serial.print(timeOR_mean);
  Serial.print(" ");
  Serial.print(timeOD_mean);
  Serial.print(" ");
  Serial.print(timeIR_mean);
  Serial.print(" ");
  Serial.print(timeID_mean);
  Serial.print(" ");
  Serial.print(jitterTimeRef);
  Serial.print(" ");
  Serial.print(jitterTimeDL);
  Serial.print(" ");
  Serial.print(first_FSR_number_ref);
  Serial.print(" ");
  Serial.print(first_FSR_number_DL);
  Serial.print(" ");
  Serial.print(dataOkay);
  Serial.println("*end*");
}