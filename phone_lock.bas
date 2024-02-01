;output 3 - reset
;output 2 - solenoid
;output 1 - clock display 1
;output 0 - up/down

;input A0 - row 1
;input A1 - row 2
;input A2 - row 3
;input A3 - row 4
;output 0 - Column3
;output 1 - Column2
;output 2 - Column1

symbol key_pos = w0	; number of keys pressed
symbol key_value = w1	; value of key pressed
symbol lock_state = w2	; variable that stores lock state
symbol countdown = w3   ; stores number to countdown from

; 0 - unlocked
; 1 - locked

init:	
	let dirsB = 255
	let key_pos = 0
	let lock_state = 0
	let countdown = 3600	;number of seconds
	
	
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
	
	if pinC.7 = 1 then lock ; debug tool
	
	if pinA.0 = 1 then add1
	if pinA.1 = 1 then add2
	if pinA.2 = 1 then add3
	if pinA.3 = 1 then add4
	
	return


display:
	
	let pinsB = %00000101
	for w5 = 0 to countdown step -1
		pinsB = %00000111
		pause 500
		pinsB = %00000101
		let countdown = countdown - 1
	next goto keypad
	

add4:	let key_value = key_value + 1
add3:	let key_value = key_value + 1
add2:	let key_value = key_value + 1
add1:	let key_value = key_value + 1
	
	let key_pos = key_pos + 1

	if key_pos = 1 then test1
	if key_pos = 2 then test2
	if key_pos = 3 then test3
	if key_pos = 4 then test4 
	

; *** Key code is set to 1-2-3-4 ***


test4:
	if key_value = 4 then lock
	goto reset1

test3:
	if key_value = 3 then continue 
	goto reset1

test2:
	if key_value = 2 then continue 
	goto reset1

test1:
	if key_value = 1 then continue 
	goto reset1
	
reset1:
	let key_pos = 0

continue:
	return

lock:
	if lock_state =  1 then unlock
	let pinsB = %00000110
	let lock_state = 1
	goto display
	
unlock:
	let pinsB = %00000000
	let lock_state = 0
	goto resetall

resetall:
	let pinsB = %00000000
	let key_pos = 0
	goto init
