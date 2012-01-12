/****************************
 ** Author: Thomas Fischbach
 ** Date: 21.10.2011
 **
 ** Description:
 ** This Arduino-program works as SPI-slave for
 ** the SPI-master EDF0910Boe. It reads 4 x 8Bit from
 ** the EDF0910Boe and calculates the countrates of
 ** the 32-Bit-Counter. You can use this system e.g.
 ** for counting events in a channeltron with a discriminator.
 ** The Arduino sends a string with
 ** the countrate via RS232 (baudrate: 9600).
****************************/

#include "pins_arduino.h"

const int bytes = 5;
byte data[bytes]; //4 x 8bit = 32bit data
byte trash;
long counterValue;
long time;

void setup(){
  pinMode(SCK, INPUT); //pin 52
  pinMode(MOSI, INPUT); //pin 51
  pinMode(MISO, OUTPUT); //pin 50
  //pin 53 (always LOW, this is the only SPI-slave in the system)
  pinMode(SS, INPUT);
  SPI_SlaveInit(); //init this device as SPI-slave
  Serial.begin(9600); // init serial communication
}

void loop(){
  readData();
  generateCounterValue();
  printData();
}

//read data from SPI shift register
void readData(){
  int dt;
  time = millis();
  
  //throw trash away
  do{
    if (SPSR&(1<<SPIF)){
      trash = SPDR;
    }
  dt = millis() - time;
  } while(dt < 10);
  
  for(int i = 0; i < bytes; i++){
    while(!(SPSR&(1<<SPIF))); //wait until SPI interupt flag is set
    data[i] = SPDR; //write current byte from shift register to array
  }
}

//convert 4 x 8bit to counter value
void generateCounterValue(){
  counterValue = 0;
  for(int i = 1; i < bytes; i++){
    counterValue += long(data[i] * pow(256, bytes - 1 - i));
  }
}

//prints data to serial interface
void printData(){
  Serial.println(counterValue);
}

//init this device as SPI-slave
void SPI_SlaveInit(void)
{
  SPCR = (0<<SPIE)|(1<<SPE)|(0<<DORD)|(0<<MSTR)|
         (1<<CPOL)|(1<<CPHA)|(0<<SPR0)|(0<<SPR1);
  /* SPI interupt disabled
   * SPI enabled
   * data order: MRB first
   * device: slave
   * clock polarity: 0
   * clock phase: 1
   * clockrate: default (0,0)
   */
}