{Object_Title_and_Purpose}


CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001   = _ConClkFreq / 1_000

  ToF_limit = 200
  Ultra_limit = 100

VAR
  ' Motors
  long Cmd, Pulse

  ' Sensors
  long Tof[2], Ultra[2]

  ' Wireless Communication
  long  Comm[16]

OBJ
  'Def   : "Definitions.spin"
  pst   : "Parallax Serial Terminal.spin"

  Mot   : "MotorControl.spin"
  Sen   : "SensorControl.spin"
  Com   : "CommControl.spin"


PUB Main | control

  pst.Start(9600)    'all pst are commented out as they are used for debugging only
  Pause(1000)

  Mot.Start(_Ms_001, @Cmd, @Pulse)
  Sen.Start(_Ms_001, @Tof, @Ultra)
  Com.Start(_Ms_001, @Comm)

  Pause(1000)

  'pst.Str(String("Start"))
  'pst.Chars(pst#NL, 2)


repeat
  case Comm[0] 'taking value from com control
    1:
        'pst.Str(String("Command foward"))
        'pst.Chars(pst#NL, 2)
      if (Ultra[0] < 200 OR Tof[0]>200)'too near                      'limits are 200 for each based on my own sensors
        Cmd := 1   'stop
      else
        if (Ultra[0]>200 AND Tof[0] <200) ' far enough
          Cmd :=2   'forward
          Pulse := 400

    2:
        'pst.Str(String("Command reverse"))
        'pst.Chars(pst#NL, 2)
      if (Ultra[1] < 200 OR Tof[1]>200)'too near
        Cmd := 1          'stop
      else
        if (Ultra[1]>200 AND Tof[1] <200)
          Cmd :=3   'backward
          Pulse := 400
    3:
      Cmd := 4 'right
        'pst.Str(String("Command right"))
        'pst.Chars(pst#NL, 2)

    4:
      Cmd := 5 'left
      'pst.Str(String("Command left"))
      'pst.Chars(pst#NL, 2)

    5:
      Cmd := 1 'stop
      'pst.Str(String("Command stop"))
      ' pst.Chars(pst#NL, 2)


PRI Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += _MS_001)