# Remote-Controlled-Robotic-Platfrom
Remote Controlled Robotic Platfrom that utlises the Parallex Propellor Board.
![proj1litekit](https://github.com/2201512/Remote-Controlled-Robotic-Platfrom/assets/114372999/b5683c5c-3878-403b-a52a-c0c13ef40866)

Completely remote controlled thorugh Wifi (Zigbee Controller)

Motor Driven Using RoboClaw.

Safety features implemented:


ToF to prevent falling.
Ultrasonic to prevent collision.
E-Stop for additional Layer of Safety.


───────────────────────────────────────

File can be formated as such

───────────────────────────────────────

    Tool :  Propeller Tool version 2.7.0 (Beta)


            MyLiteKit.spin
              │
              ├──Parallax Serial Terminal.spin
              │
              ├──MotorControl.spin
              │    │
              │    ├──Servo32v9.spin
              │    │    │
              │    │    └──Servo32_Ramp_v2.spin
              │    │
              │    └──FullDuplexSerialExt.spin
              │
              ├──SensorControl.spin
              │    │
              │    ├──ToF.spin
              │    │    │
              │    │    └──i2cDriver_v2.spin
              │    │
              │    ├──Ultrasonic_v3.spin
              │    │    │
              │    │    └──i2cDriver_v2.spin
              │    │
              │    └──Parallax Serial Terminal.spin
              │
              └──CommControl.spin
                   │
                   ├──Definitions.spin
                   │
                   ├──FullDuplexSerialExt.spin
                   │
                   └──Parallax Serial Terminal.spin


────────────────────

