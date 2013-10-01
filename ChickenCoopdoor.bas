' Name: Chicken Coop Door
' Description:
' Version No.: 0.1
' Date created: 01/02/12
' Date last modified
' PIC PICAXE-08M (PIC12F683)
' Pins: 
' Action	Physical - Name - Label in prog
' Read LDR	    5    - In 2 -     2
' Motor Open    6    - Out 1-     1
' Motor Close   3	   - Out 4 -    4                                                                                                                       	


symbol sleeptime = 52		'1 sleeptime = 2.3 seconds
symbol pausetime = 10000


init: let b0 = 0
	let b2 = 0	'This is the doorisclosed flag
	let b4 = 1	' This is the doorisOpenFlag
	let b10 = 15	' The light reading
	let b11 = 0
	let b12 = 0
	let b13 = 0
main:
	' This is the override switch
	output 1
	'output 2
	output 4
	
	gosub Test
	serout 0,N2400,(83, 84, 79, 80, 80, 73, 78, 71, 13, 10)
	
	goto readlight

readlight:
	
	' 255 is brightest/0 is darkest
	input 2
	readadc 2, b1

	' send the value
	serout 0,N2400,(#b1, 13,10)

	' if it's dark and door not closed
	if b1 < b10 and b2 = 0 and b11 = 3 then 
		let b11 = 0
		gosub closedoor
	elseif b1 < b10 and b2 = 0 and b11 < 3 then
		serout 0,N2400,(35, #b11, 13, 10)
		'serout 0,N2400,(13,10)
		inc b11 
	endif	

	' if it's light and door not closed
	if b1 > b10 and b4 = 0 and b12 = 3 then 
		let b12 = 0
		gosub opendoor
	elseif b1 > b10 and b4 = 0 and b12 < 3 then
		serout 0,N2400,(42, #b12, 13, 10)
		'serout 0,N2400,(13,10)
		inc b12
	endif	
		
	
	'pause pausetime
	sleep sleeptime 
	goto readlight



closedoor: ' Close the hatch, open the drive
	serout 0,N2400,(67, 76, 79, 83, 73, 78, 71, 13, 10)
	'if b2 = 1 then opendoor
	output 2
	high 2
	
	high 4
	pause 2000
	low 4
	
	low 2
	input 2

	let b2 = 1
	let b4 = 0
	'serout 0,N2400,(#b2)
	'goto readlight
	return

opendoor: 'Open the hatch, close the drive
	serout 0,N2400,(79, 80, 69, 78, 73, 78, 71, 13, 10)

	output 2
	high 2

	high 1
	pause 2000

	low 1
	
	low 2
	input 2
	
	let b2 = 0
	let b4 = 1
	'serout 0,N2400,(#b2)
	'goto readlight
	return

Test:
	pause 2000
	gosub closedoor
	pause 3000
	gosub opendoor
	serout 0,N2400,(42, #b13, 13, 10)
	inc b13
	pause 2000
	'goto Test
	return
	

