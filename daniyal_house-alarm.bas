symbol key_pos = b0	; number of keys pressed 
symbol key_value = b1	; value of key pressed 
symbol arm_state = b2	; variable that stores arming state 
 
init:	 
let dirsB = 255 
let key_pos = 0 
 let arm_state = 0 
 
arm: 
      if arm_state = 0 then keypad 
 
 
scan: 
if pinC.0 = 1 then alarm 
if pinC.1 = 1 then alarm 
if pinC.2 = 1 then alarm 
 
goto scan 
 
keypad: 
 
let key_value = 0 
let pinsB = %01100001 
gosub key_test 
 
let key_value = 1 
let pinsB = %01100010 
gosub key_test 
 
let key_value = 2 
let pinsB = %01100100 
gosub key_test 
 
goto keypad 
 
 
key_test: 
 
if pinA.0 = 1 then add1 
if pinA.1 = 1 then add2 
if pinA.2 = 1 then add3 
if pinA.3 = 1 then add4 
 
return 
 
 
alarm: 
let pinsB = %1110000 
goto keypad 
 
 
add4:	let key_value = key_value + 1 
add3:	let key_value = key_value + 1 
add2:	let key_value = key_value + 1 
add1:	let key_value = key_value + 1 
 
; *** Make a beep *** 
 
;sound B.6,(60,50) 
 
let key_pos = key_pos + 1 
 
if key_pos = 1 then test1 
if key_pos = 2 then test2 
if key_pos = 3 then test3 
if key_pos = 4 then test4  
 
 
; *** Key code is set to 2-0-0-7 *** 
 
 
test4: 
if key_value = 3 then disarm ;4 
goto reset1 
 
test3: 
if key_value = 5 then continue ;6 
goto reset1 
 
test2: 
if key_value = 5 then continue ;6 
goto reset1 
 
test1: 
if key_value = 2 then continue ;3 
goto reset1 
 
disarm:	 
if arm_state = 0 then alarm_on 
      let pinsB = %00100000 
      wait 1 
      let pinsB = %00000000 
      goto resetCircuit 
 
alarm_on: 
      let arm_state = 1 
      wait 20 
      goto scan 
 
reset1: 
let key_pos = 0 
 
continue: 
return 
 
resetCircuit: 
      pinsA = %00000000 
      pinsB = %00000000 
      goto init 
 

 

 
 
