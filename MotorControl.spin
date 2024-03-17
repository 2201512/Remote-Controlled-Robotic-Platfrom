{
 ************************************************************************************************************
 *                                                                                                          *
 *  AUTO-RECOVER NOTICE: This file was automatically recovered from an earlier Propeller Tool session.      *
 *                                                                                                          *
 *  ORIGINAL FOLDER:     C:\solidworks\litekit\                                                             *
 *  TIME AUTO-SAVED:     6 hours, 3 minutes ago (10/11/2022 7:31:49 pm)                                     *
 *                                                                                                          *
 *  OPTIONS:             1)  RESTORE THIS FILE by deleting these comments and selecting File -> Save.       *
 *                           The existing file in the original folder will be replaced by this one.         *
 *                                                                                                          *
 *                           -- OR --                                                                       *
 *                                                                                                          *
 *                       2)  IGNORE THIS FILE by closing it without saving.                                 *
 *                           This file will be discarded and the original will be left intact.              *
 *                                                                                                          *
 ************************************************************************************************************
.}
{{

  Developer: Kenichi Kato
  Copyright (c) 2021, Singapore Institute of Technology
  Platform: Parallax USB Project Board (P1)
  Date: 30 Aug 2021
  Modified 2022-10-20 by Sum Yee Loon for RSE1101 AY2022
  Modified 2022-11-02 by Yugen
}}
CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001   = _ConClkFreq / 1_000

  '' [ Definitions ]

  '' Hardware
  ' RoboClaw 1
  S1 = 0 'red wire, back wheel left
  S2 = 1 'yellow wire, back wheel right
  S3 = 2 'green wire, front wheel left
  S4 = 3 'white wire, front wheel right

  MotorZero = 1500
  'MotorBck = 1400 ' not used for now
  'MotorFwd = 1600 ' not used for now
  'Offset  = 0     ' no offset for my motors

VAR
  long  mainHubMS, cog, cogStack[64]


OBJ

  PWM   : "Servo32v9.spin"          'For Set(Pin, Width)|S_Width
  DBG   : "FullDuplexSerialExt.spin"



PUB motorCore(Cmd, Pulse) ' | Cmd, Pulse defintions to be used later, motorCore will be using (Cmd, Pulse) when required and will
'main function for movements that uses other PUB functions to run                 'keep looping and checking for cmd.
  'DBG.Start(31, 30, 0, 115200)'start   'commented out to fix issue with it colliding with pst
  Pause(500)
  PWM.Start
  StopAllMotor
      'servo start
  repeat
    case long[Cmd]
      1: StopAllMotor

      2: Forward(long[Pulse])

      3: Backward(long[Pulse])

      4: TurnRight(1000)

      5: TurnLeft(1000)

      6:
       StopAllMotor
       Forward(long[Pulse])

      7:
        StopAllMotor
        Backward(long[Pulse])

{PUB Motion1 'fixed motion that is hardcoded  to do:    |
  StopALLMotor 'stop all motor at the start         ___|
  Forward(3000) '3 sec movement forward            |
  StopAllMotor                                    '|
  TurnRight(1205) 'fixed no set to turn 90 degree on lab floor, intended to work on that surface
  StopAllMotor
  Forward(3000)
  StopAllMotor
  TurnLeft(1205)
  StopAllMotor
  Forward(3000)
  StopAllMotor
  return
          }
PRI StopALLMotor        'no offset
  PWM.Set(S1, MotorZero)
  PWM.Set(S2, MotorZero)
  PWM.Set(S3, MotorZero)
  PWM.Set(S4, MotorZero)
  Pause(1000)
  return

PUB Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += _MS_001)
  return

PRI Forward(Pulse) | i          'no offset
'Enter your code here to move forward
i := 0
repeat while i < 100
    PWM.Set(S2, i+MotorZero)
    PWM.Set(S4, i+MotorZero)
    PWM.Set(S1, MotorZero-i)
    PWM.Set(S3, MotorZero-i)
    i+=20
Pause(Pulse)
return
PRI Backward(Pulse) | i            'no offset
'Enter your code here to move backward
i := 0
repeat while i < 100
    PWM.Set(S2, MotorZero-i)
    PWM.Set(S4, MotorZero-i)
    PWM.Set(S1, MotorZero+i)
    PWM.Set(S3, MotorZero+i)
    i+=20
Pause(Pulse)
return
PRI TurnLeft(Pulse) | i            'no offset
'Enter your code here to turn left
repeat i from 1500 to 1400 step 20
    PWM.Set(S1, i)
    PWM.Set(S2, i)
    PWM.Set(S3, i)
    PWM.Set(S4, i)
Pause(Pulse)
return
PRI TurnRight(Pulse) | i           'no offset
'Enter your code here to turn right
repeat i from 1500 to 1600 step 20
    PWM.Set(S1, i)
    PWM.Set(S2, i)
    PWM.Set(S3, i)
    PWM.Set(S4, i)
Pause(Pulse)
return
PUB Start(MS, Cmd, Pulse)                       '(Cmd, Pulse) will be added in when used in motorCore                                            'commented out as not used in this code
  mainHubMS := MS
  Stop
  cog := cognew(motorCore(Cmd, Pulse), @cogStack) + 1
  return cog
PUB Stop                                        'Start a new core commented because it is not used in the code
{{ Stop & Release Core }}                             'commented out as not used in this code
  if cog
    cogstop(cog~ - 1)
  return