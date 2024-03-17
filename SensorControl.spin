'Ultrasonic and Time of Flight Testing

CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        'Time of Flight Pins
        ToF1SCL = 6
        ToF1SDA = 7
        ToF1RST = 8

        ToF2SCL = 9
        ToF2SDA = 10
        ToF2RST = 11

        'Ultrasonic Pins
        Ultra1SCL = 4
        Ultra1SDA = 5
        Ultra2SCL = 12
        Ultra2SDA = 13

VAR

long  mainHubMS, cog, cogStack[128]

OBJ
  tof[2]        : "ToF.spin"
  ultra         : "Ultrasonic_v3.spin"
  pst           : "Parallax Serial Terminal"

PUB sensorCore(Tof1, Ultra1) | ToF_Range1, ToF_Range2, UltraRange1, UltraRange2

    'pst.Start(9600)                   ' commented out to not intertwine with other code

    WAITCNT((2*(clkfreq/1000)) + cnt)

    ToF_Init

    ultra.Init(Ultra1SCL, Ultra1SDA, 0)
    ultra.Init(Ultra2SCL, Ultra2SDA, 1)


    repeat

      long[Ultra1][0]:= ultra.readSensor(0)
     ' WAITCNT((1*(clkfreq)) + cnt)
      long[Ultra1][1]:= ultra.readSensor(1)
     ' WAITCNT((1*(clkfreq)) + cnt)
      long[Tof1][0]:= tof[0].GetSingleRange($29)
      'WAITCNT((1*(clkfreq)) + cnt)
      long[Tof1][1]:= tof[1].GetSingleRange($29)


PRI ToF_Init | i

  tof[0].init(ToF1SCL,ToF1SDA,ToF1RST)
  tof[0].ChipReset(1)
  Pause(1000)
  tof[0].FreshReset($29)
  tof[0].MandatoryLoad($29)
  tof[0].RecommendedLoad($29)
  tof[0].FreshReset($29)

  tof[1].init(ToF2SCL,ToF2SDA,ToF2RST)
  tof[1].ChipReset(1)
  Pause(1000)
  tof[1].FreshReset($29)
  tof[1].MandatoryLoad($29)
  tof[1].RecommendedLoad($29)
  tof[1].FreshReset($29)

PUB Start(MS, Tof1, Ultra1)                  '(Cmd, Pulse) will be added in when used in motorCore
  mainHubMS := MS                                          'commented out as not used in this code
  Stop
  cog := cognew(sensorCore(Tof1, Ultra1), @cogStack) + 1
  return cog

PUB Stop
{{ Check & Stop/Unload Core if loaded }}
  if cog
    cogstop(~cog - 1)
  return
PRI Pause(ms) | t

  t:=cnt - 1088
  repeat (ms#>0)
    waitcnt(t += _Ms_001)
  return