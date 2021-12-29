  #include <math.h>
#include<stdio.h>
#include<WiFiUdp.h>
#include<NTPClient.h>
#include <ctype.h>
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <DHT.h>
#define DHTTYPE 
#define dht_dpin 0
DHT dht(dht_dpin, DHT11); 
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#define LED D0
#define BUZZER D4

#define FIREBASE_HOST ""
#define FIREBASE_AUTH ""
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

float m = -0.3376; //Slope 
float b = 0.7165; //Y-Intercept 
float R0 = 11.19; //Sensor Resistance in fresh air from previous code
char updatedIAQ[15];
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");
String weekDays[7]={"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", 
                    "Friday", "Saturday"};
String months[12]={"January", "February", "March", "April", "May",
                  "June", "July", "August","September", "October", 
                  "November", "December"};
char mon[4];
char dy[4];
char aqi[5];
// Set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27, 16, 2);
void setup()
{// initialize the LCD
	lcd.begin();
  Serial.begin(9600); //baud rate like transfer rate
  dht.begin(); //begin the temp and humidity sesnor
  pinMode(LED, OUTPUT);
  pinMode(BUZZER, OUTPUT);
	// Turn on the blacklight and print a message on LCD.
  lcd.backlight();
	lcd.setCursor(0,0);
  lcd.print("IAQ:");
  lcd.setCursor(8,0);
  lcd.print("PPM");
  lcd.setCursor(0,1);
  lcd.print("TEM:");
  lcd.setCursor(8,1);
  lcd.print("HUM:");
   // connect to wifi and the firebase
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");

  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  timeClient.begin();
  timeClient.setTimeOffset(28800); 
	}





void loop()
{
   timeClient.update();
  unsigned long epochTime = timeClient.getEpochTime();
  struct tm *ptm = gmtime ((time_t *)&epochTime); 

  int monthDay = ptm->tm_mday;
  int currentMonth = ptm->tm_mon+1;
  String currentMonthName = months[currentMonth-1];
  int currentYear = ptm->tm_year+1900;

  sprintf(dy,"%02d",monthDay);
  sprintf(mon,"%02d",currentMonth);
  
  String currentDate = String(currentYear) + "-" + String(mon) + "-" + String(dy);

  Serial.print("Current date: ");
  Serial.println(currentDate);
  
 
    
  float sensor_volt; //Define variable for sensor voltage 
  float RS_gas; //Define variable for sensor resistance  
  float ratio; //Define variable for ratio

 /*********Read MQ135 sensor*********/
  float ppm = analogRead(A0);

  sensor_volt = ppm*(5.0/1023.0); //Convert analog values to voltage 
  RS_gas = ((5.0*10.0)/sensor_volt)-10.0; //Get value of RS in a gas
  ratio = RS_gas/R0;  // Get ratio RS_gas/RS_air
  
  float ppm_log = (log10(ratio)-b)/m; //Get ppm value in linear scale according to the the ratio value  
  
  float ppm_desired = pow(10, ppm_log); //Convert ppm value to log scale 
  Serial.print("Our desired PPM = ");
  Serial.println(roundf(ppm_desired * 100) / 100);
 

 /*********MQ135 sensor, display on LCD*********/
 lcd.setCursor(4,0);
 lcd.print(ppm_desired);
  
 /******Read DHT11 sensor and display on LCD*********/
 float h_backup = 0;
 float t_backup = 0;
 float h;
 float t;
 
 if(!isnan(h)){
   h = dht.readHumidity();
 } else {
   h = h_backup;
   Serial.print("Humidity in NAN");
 }

 if(!isnan(t)){
   t = dht.readTemperature();
 } else {
   t = t_backup;
   Serial.print("Temperature in NAN");
 }

 lcd.setCursor(4,1);  
 lcd.printf("%.0f" ,t);     
 lcd.setCursor(6,1);
 lcd.print("C");   
 lcd.setCursor(12,1); 
 lcd.printf("%.0f", h); 
 lcd.setCursor(14,1); 
 lcd.print("%"); 

/********Condition if AQI more than 300ppm********/
  if(ppm_desired>100){
   digitalWrite(LED, HIGH);
   digitalWrite(BUZZER, HIGH);
  }else{
   digitalWrite(LED, LOW);
   digitalWrite(BUZZER, LOW);
 }
 delay(3000);

 /******Convert all sensors's value to String*********/
h = floor(10000*h)/10000;
t = floor(10000*t)/10000;
String humidityString = String(h);
String temperatureString = String(t);
sprintf(aqi,"%06.3f",ppm_desired);
//String ppmString = String(updatedIAQ);



StaticJsonBuffer<200> buffer;
JsonObject& root = buffer.createObject();
root["value"] = String(aqi);
root["date"] = currentDate;

/*****Upload sensor's data to realtime firebase******/


   Firebase.pushString("/DHT11/Humidity", humidityString);            //setup path to send Humidity readings
   Firebase.pushString("/DHT11/Temperature", temperatureString);         //setup path to send Temperature readings  
   if(isnan(ppm_desired)){
    Serial.print("PPM in NAN");
 } else {
  Firebase.push("/MQ135/PPM", root);

 }
}





// float sensor_volt; //Define variable for sensor voltage 
//  float RS_air; //Define variable for sensor resistance
//  float R0; //Define variable for R0
//  float sensorValue1=0.0; //Define variable for analog readings 
//  Serial.print("Sensor Reading = ");
//  Serial.println(analogRead(A0));
//  
//  for(int x = 0 ; x < 500 ; x++) //Start for loop 
//  {
//    sensorValue1 = sensorValue1 + analogRead(A0); //Add analog values of sensor 500 times 
//  }
//  sensorValue1 = sensorValue1/500.0; //Take average of readings
//  sensor_volt = sensorValue1*(5.0/1023.0); //Convert average to voltage 
//  RS_air = ((5.0*10.0)/sensor_volt)-10.0; //Calculate RS in fresh air 
//  R0 = RS_air/3.7; //Calculate R0 
// 
//  float RS_gas; //Define variable for sensor resistance  
//  float ratio; //Define variable for ratio 
//  Serial.print("SENSOR RAW VALUE = ");
//  Serial.println(sensorValue);
//  sensor_volt = sensorValue*(5.0/1023.0); //Convert analog values to voltage 
//  Serial.print("Sensor value in volts = ");
//  Serial.println(sensor_volt);
//  RS_gas = ((5.0*10.0)/sensor_volt)-10.0; //Get value of RS in a gas
//  Serial.print("Rs value = ");
//  Serial.println(RS_gas);
//  ratio = RS_gas/R0;  // Get ratio RS_gas/RS_air
//  
//  Serial.print("Ratio = ");
//  Serial.println(ratio);
//  float ppm_log = (log10(ratio)-b)/m; //Get ppm value in linear scale according to the the ratio value  
//  float ppm = pow(10, ppm_log); //Convert ppm value to log scale 
//  Serial.print("Our desired PPM = ");
//  Serial.println(ppm);
//  double percentage = ppm/10000; //Convert to percentage 
//  Serial.print("Value in Percentage = "); //Load screen buffer with percentage value
//  Serial.println(percentage); 
