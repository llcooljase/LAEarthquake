turtles-own [health speed exit]
patches-own [blocks no-more]

to setup
  set make-new? "yes"
  clear-all
  setup-grid
  import-pcolors "lasimpler.bmp"
  draw-border
end

;;;;;;; setup ;;;;;;;

to setup-grid
  import-pcolors "lasimplermap2.bmp"
  ask patches [
    ifelse pcolor = 0 [set blocks 1000][
      set blocks pcolor]]
end
  

to draw-border
  ask patches with [abs pxcor = max-pxcor]
    [ set pcolor blue ]
  ask patches with [abs pycor = max-pycor]
    [ set pcolor blue ]
end

;;;;;;; procedure ;;;;;;;

to go
  make-turtles
  move-turtles
  make-ambulances
  move-ambulances
  load-ambulances
  kill-turtles
  end-ambulances
  tick
  do-plots
  if ticks > (1000) [ if all? patches [count turtles with [color != 12] = 0] [ stop ]] ; checks for end
end

to make-turtles
  if make-new? = "no" [stop]
  ask n-of 50 (patches with [pcolor = 8]) [
    if random 100 <= ((population / time-for-everyone-to-leave) / .5) [sprout 1]]
  ask turtles [ 
    if speed > 0 [stop]
    set shape "dot"
    set exit random 28
    set speed (((random 3) + 3) / (4 ^ pace))
    let temp random 100
    ifelse temp < (injured) [
      set color pink]
    [ifelse temp > (injured) and temp < (injured + critically-injured) [set color red][set color white]
      ]
    if color = pink [set speed (speed / 2)]
    if color = red [set speed (speed / 5)]
    if who >= population [set make-new? "no"]
  ]
end

to move-turtles
  if evacuation-mode = "shortest distance out" [
  ask turtles with [color != 12] [
    ifelse [blocks] of patch-at 1 0 < [blocks] of patch-here [
      face patch-at 1 0 forward speed][
    ifelse [blocks] of patch-at 0 1 < [blocks] of patch-here [
      face patch-at 0 1 forward speed][
    ifelse [blocks] of patch-at -1 0 < [blocks] of patch-here [
      face patch-at -1 0 forward speed][
    ifelse [blocks] of patch-at 0 -1 < [blocks] of patch-here [
      face patch-at 0 -1 forward speed][oh-shit]]]]]]
  
  if evacuation-mode = "to random exit point" [
  ask turtles with [color != 12] [
    face-exit
    ifelse abs(dx) >= abs(dy) [
      if dx > 0 [ifelse [pcolor] of patch-at 1 0 = 8 or [pcolor] of patch-at 1 0 = 1 [face patch-at 1 0 forward speed][
          if dy > 0 [face patch-at 0 1 forward speed] if dy < 0 [face patch-at 0 -1 forward speed]]]
      if dx < 0 [ifelse [pcolor] of patch-at -1 0 = 8 or [pcolor] of patch-at -1 0 = 1 [face patch-at -1 0 forward speed][
          if dy > 0 [face patch-at 0 1 forward speed] if dy < 0 [face patch-at 0 -1 forward speed]]]][
    ifelse abs(dx) < abs(dy) [
      if dy > 0 [ifelse [pcolor] of patch-at 0 1 = 8 or [pcolor] of patch-at 0 1 = 1 [face patch-at 0 1 forward speed][
          if dx > 0 [face patch-at 1 0 forward speed] if dx < 0 [face patch-at -1 0 forward speed]]]
      if dy < 0 [ifelse [pcolor] of patch-at 0 -1 = 8 or [pcolor] of patch-at 0 -1 = 1 [face patch-at 0 -1 forward speed][
          if dx > 0 [face patch-at 1 0 forward speed] if dx < 0 [face patch-at -1 0 forward speed]]]][
      if dx > 0 [face patch-at 1 0 forward speed * 2]
      if dx < 0 [face patch-at -1 0 forward speed * 2]]]]
  ]
end

to oh-shit
  set color orange
end

to face-exit
  if exit = 0 [face patch 32 13]
  if exit = 1 [face patch 32 6]
  if exit = 2 [face patch 32 3]
  if exit = 3 [face patch 32 -5]
  if exit = 4 [face patch 32 -8]
  if exit = 5 [face patch 32 -13]
  if exit = 6 [face patch -32 13]
  if exit = 7 [face patch -32 6]
  if exit = 8 [face patch -32 3]
  if exit = 9 [face patch -32 -5]
  if exit = 10 [face patch -32 -8]
  if exit = 11 [face patch -32 -13]
  if exit = 12 [face patch -22 15]
  if exit = 13 [face patch -19 15]
  if exit = 14 [face patch -4 15]
  if exit = 15 [face patch -1 15]
  if exit = 16 [face patch 14 15]
  if exit = 17 [face patch 17 15]
  if exit = 18 [face patch 27 15]
  if exit = 19 [face patch 30 15]
  if exit = 20 [face patch -22 -15]
  if exit = 21 [face patch -19 -15]
  if exit = 22 [face patch -4 -15]
  if exit = 23 [face patch -1 -15]
  if exit = 24 [face patch 14 -15]
  if exit = 25 [face patch 17 -15]
  if exit = 26 [face patch 27 -15]
  if exit = 27 [face patch 30 -15]
end
    
to make-ambulances
  if random ticks-per-ambulance = 0 [
    let starting (patches with [(pxcor = min-pxcor + 1) and ((pycor = 4) or (pycor = 14) or (pycor = -7)) or ((pxcor = max-pxcor - 1) and ((pycor = -14) or (pycor = -6) or (pycor = 5))) or ((pycor) = max-pycor - 1 and ((pcolor = 0 and pxcor = -21) or (pcolor = 0 and pxcor = -3) or (pcolor = 0 and pxcor = 15) or (pcolor = 0 and pxcor = 28)) or (pycor = (- 1 * max-pycor) + 1 and ((pcolor = 0 and pxcor = -20) or (pcolor = 0 and pxcor = -2) or (pcolor = 0 and pxcor = 16) or (pcolor = 0 and pxcor = 29))))])
    ask n-of 1 starting
    [sprout 1
         ask turtles with  [shape != "dot"] [
           set color 12
           if xcor = max-pxcor - 1 [face patch-at -1 0]
           if xcor = min-pxcor + 1 [face patch-at 1 0]
           if xcor =  -21 and ycor > 0 [face patch-at 0 -1] 
           if xcor =  -20 and ycor < 0 [face patch-at 0 1]
           if xcor =  -3 and ycor > 0 [face patch-at 0 -1] 
           if xcor =  -2 and ycor < 0 [face patch-at 0 1]
           if xcor =  15 and ycor > 0 [face patch-at 0 -1] 
           if xcor =  16 and ycor < 0 [face patch-at 0 1]
           if xcor =  28 and ycor > 0 [face patch-at 0 -1] 
           if xcor =  29 and ycor < 0 [face patch-at 0 1]
]
  ]]
end

to move-ambulances
  let critical turtles with [color = red]
  let ambulances turtles with [color = 12]
  ask ambulances [
    set speed (((random 3) + 3) / 4 ^ (pace - 1))
    if count critical > 0 [
    if distance one-of critical < 2 [set color magenta]]
    forward speed]
end

to load-ambulances
  let people turtles with [color = red]
  ask people  [
    let ambulances turtles with [color = magenta]
    if any? ambulances [
    if distance one-of ambulances < 2.5 [set color magenta die]]
    ]
end
      
to kill-turtles
  ask turtles [
    if [blocks] of patch-here = 1 [die]
    if distance one-of patches with [pcolor = blue] <= 1 [die]
    if color = magenta [die]
]
end

to end-ambulances
  let critical turtles with [color = red]
  let ambulances turtles with [color = 12]
  if count critical = 0 [ask ambulances [die]]
end

to do-plots
  set-current-plot "Totals"
  set-current-plot-pen "turtles"
  plot count turtles with [color = white or color = red or color = pink]
  set-current-plot-pen "uninjured"
  plot count turtles with [color = white]
  set-current-plot-pen "injured"
  plot count turtles with [color = pink]
  set-current-plot-pen "critical"
  plot count turtles with [color = red]
end
@#$#@#$#@
GRAPHICS-WINDOW
216
19
1063
462
33
16
12.5
1
10
1
1
1
0
1
1
1
-33
33
-16
16
1
1
1
ticks

BUTTON
5
38
68
71
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
139
38
202
71
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

PLOT
1080
20
1280
290
Totals
time
Totals
0.0
10.0
0.0
10.0
true
false
PENS
"turtles" 1.0 0 -16777216 true
"critical" 1.0 0 -2674135 true
"uninjured" 1.0 0 -7500403 true
"injured" 1.0 0 -2064490 true

SLIDER
15
164
187
197
population
population
0
200
175
25
1
people
HORIZONTAL

BUTTON
72
38
135
71
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
22
471
165
504
NIL
follow one-of turtles
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

SLIDER
15
269
187
302
injured
injured
0
100
40
5
1
%
HORIZONTAL

SLIDER
15
306
187
339
critically-injured
critically-injured
0
100 - injured
60
5
1
%
HORIZONTAL

SLIDER
17
372
189
405
ticks-per-ambulance
ticks-per-ambulance
0
300
100
100
1
NIL
HORIZONTAL

SLIDER
15
203
187
236
pace
pace
1
5
3
1
1
NIL
HORIZONTAL

SLIDER
4
411
208
444
time-for-everyone-to-leave
time-for-everyone-to-leave
0
300
100
25
1
ticks
HORIZONTAL

CHOOSER
14
97
180
142
evacuation-mode
evacuation-mode
"shortest distance out" "to random exit point"
0

CHOOSER
1115
434
1253
479
make-new?
make-new?
"yes" "no"
1

TEXTBOX
1089
329
1239
347
NIL
11
0.0
1

@#$#@#$#@
WHAT IS IT?
-----------
This section could give a general understanding of what the model is trying to show or explain.


HOW IT WORKS
------------
This section could explain what rules the agents use to create the overall behavior of the model.


HOW TO USE IT
-------------
This section could explain how to use the model, including a description of each of the items in the interface tab.


THINGS TO NOTICE
----------------
This section could give some ideas of things for the user to notice while running the model.


THINGS TO TRY
-------------
This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.


EXTENDING THE MODEL
-------------------
This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.


NETLOGO FEATURES
----------------
This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.


RELATED MODELS
--------------
This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.


CREDITS AND REFERENCES
----------------------
This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 4.1.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
