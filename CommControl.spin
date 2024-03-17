{{

  File: RxComm.spin

  Developer: Kenichi Kato
  Copyright (c) 2021, Singapore Institute of Technology
  Platform: Parallax USB Project Board (P1)
  Date: 14 Sep 2021
  Objective:
    - Communication module on the receiver board
    - Module selected is ZigBee

}}
CON
  _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001 = _ConClkFreq / 1_000

  ' ZigBee Commands
  'cmdStart    = $7A
  cmdStop     = $40
  cmdForward  = $20 '
  cmdReverse  = $10  '
  cmdLeft     = $01
  cmdRight    = $02
  'error = -1

OBJ
  Def   : "Definitions.spin"
  Comm  : "FullDuplexSerialExt.spin"
  pst   : "Parallax Serial Terminal.spin"

VAR
  long MainHubMS
  long  cog, cogStack[64]

PUB Stop
  if(cog)
    cogstop(~cog - 1)
  return


PUB Start(MS, commMem)
  mainHubMS := MS
  Stop
  cog := cognew(commCore(commMem), @cogStack) + 1
  return cog          

PUB commCore(commMem) | i, j
{{ Core unit for all messaging with transmitter/ZigBee }}

  Comm.Start(16, 17, 0, 9600)
  'pst.Start(9600)
  'pst.Str(String("start"))
  'pst.Chars(pst#NL, 2)

  'long[commMem][1] := 0
  repeat
    'i := Comm.Rx
    'Pause(50)                     'start is not used
    'if Comm.Rx == cmdStart
      'long[commMem][1] := 1
    j := Comm.Rx' take rx value
    case j
      cmdStop:
        long[commMem][0] := 5
        'pst.Str(String("Command Stop"))
        'pst.Chars(pst#NL, 2)
      cmdForward:
        long[commMem][0] := 1
        'pst.Str(String("Command Forward"))
        'pst.Chars(pst#NL, 2)
      cmdReverse:
        long[commMem][0] := 2
        'pst.Str(String("Command Reverse"))
        'pst.Chars(pst#NL, 2)
      cmdLeft:
        long[commMem][0] := 4
        'pst.Str(String("Command Left"))
        'pst.Chars(pst#NL, 2)
      cmdRight:
        long[commMem][0] := 3
        'pst.Str(String("Command Right"))
        'pst.Chars(pst#NL, 2)


PRI Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += mainHubMS)
  return