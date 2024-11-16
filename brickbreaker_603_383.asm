.model small	
.stack 100h
.data
	
;--------------------------------------BALL & PADDLE--------------------------------------
	
	screen_width dw	140h	    ;320 pixels
	screen_height dw 0C8h		;200 pixels	200/2 = 64h		0c8h
	screen_boundary dw 6		;to check collisions early
	
	time_prev db 0	;to check if time has changed
	
	ogx_ball dw 20h		;reset coordinates
	ogy_ball dw 60h
	
	x_ball dw 20h		
	y_ball dw 60h
	
	s_ball dw 8h		;size of ball
	color_ball db ?		;color of ball
	
	vx_ball dw 2h	;velocity horizontal axis		
	vy_ball dw 2h	;velocity vertical axis
	
	x_paddle dw 087h
	y_paddle dw 0BCh
	
	height_paddle dw 05h
	width_paddle dw 30h
	
	v_paddle dw 05h
	color_paddle db ?
	paddleee dw 265
	
	x_col dw ?
	y_col dw ?

;--------------------------------------BOXES--------------------------------------

	array_x dw 35, 35 ,35,  78, 78, 78, 120, 120, 120, 162,162,162, 204,204,204, 246, 246, 246
	array_y dw 40, 57, 74 , 40, 57, 74 , 40, 57, 74 ,40, 57, 74 ,40, 57, 74 ,40, 57, 74 
	color db 0
	
	x dw 0
	y dw 0
	zx dw 0 
	zy dw 0
	
;--------------------------------------HEARTS--------------------------------------
	x_heart dw 0	
	y_heart dw 0
	
	color_heart db 0
	lives_count db 3	;lives counter
	counter dw 0
	
	x_heart_col dw 0
	y_heart_col dw 0
	
;--------------------------------------SCORE--------------------------------------

	score db 0		;counter 
	scorearray byte "0", '$'
	scrorestr byte "Score: "
	
;--------------------------------------GAME MENU--------------------------------------
	
	string1 byte "BRICK BREAKER GAME","$"
	string2 byte "New Game <- Press g","$"
	string3 byte "Resume <- Press p","$"
	string4 byte "Rules <- Press r","$"
	string5 byte "High score <- Press h","$"
	string6 byte "Exit <- Press Esc","$"
	
	string1rules byte "BRICK BREAKER GAME","$"
	string2rules byte "RULES"
	string3rules byte "Move the paddle to hit the ball"
	string4rules byte "Eliminate the bricks by hitting them    with the ball"
	string5rules byte "If the ball hit the bottom,the game ends"
	
	hs1 byte "BRICK BREAKING GAME$"
	hs2 byte "High Scores "
	hs3 byte "Names		Scores "
	hs4 byte "Zaib 		21"
	hs5 byte "Hamna 		19"
	hs6 byte "Kissa 		5"
	
;--------------------------------------GAME WIN--------------------------------------

	WIN1 byte "BRICK BREAKING GAME$"
	WIN2 byte "CONGRATULATIONS"
	WIN3 byte ":D YOU WON!! :D "
	WIN4 byte "SCORE: "
	
;--------------------------------------GAME LOSE--------------------------------------

	LOSE1 byte "BRICK BREAKING GAME$"
	LOSE2 byte ":( YOU lost!! :( "
	LOSE3 byte "SCORE: "
	
;--------------------------------------USER INPUT--------------------------------------
	
	array_input db 10 DUP(0)
	stringname byte "Enter your name :)"
	
;--------------------------------------filehandling user INPUT--------------------------------------

	msg db "Score",'$'
	filehandle db "projfile.txt",0
	handle dw 0
	buffer dw 100 dup('$')	

.code
	main proc
		mov ax, @data
		mov ds, ax
		mov ax, 0
		
		gamem: 
		
			call clear_screen
			call game_menu	
			
			mov ah, 01h		;check if key pressed
			int 16h
			
			mov ah, 0
			int 16h			;check which key pressed
			
			
			cmp ah, 34		;ascii for 'g' in hexa -> NEW GAME
			je new_game
			cmp ah, 19		;ascii for 'r' in hexa -> RULES
			je r_ules
			cmp ah, 35		;ascii for 'h' in hexa -> HIGHSCORE
			je highscore
			cmp ah, 1		;ascii for 'esc' in hexa -> EXIT
			je exit_game
		
			jmp gamem
			
		r_ules:
		
			call clear_screen
			call rules
		
			mov ah, 01h
			int 16h
			
			mov ah, 0
			int 16h
			
			cmp ah, 28		;press enter to go back to game menu
			je gamem
			
			jmp gamem
		
		highscore:

			call clear_screen
			call high_scoree
			
			mov ah, 01h
			int 16h
			
			mov ah, 0
			int 16h
			
			cmp ah, 28		;press enter to go back to game menu
			je gamem
			
			jmp gamem
			
		exit_game:
			mov ah, 01h
			int 16h
			
			mov ah, 0
			int 16h
			
			cmp ah, 28		;press enter to go back to game menu
			je leavegame
			
			leavegame:
				mov ah, 4ch
				int 21h
				
			jmp gamem
		
		new_game:
		
			;-------------------USER INPUT------------------------	
			
			call clear_screen
			
			;--------------- HEADING-------------
			mov  bh, 0    ;Display page
			mov  ah, 02h  ;Set cursor position
			mov dl, 52
			mov dh, 2
			int  10h

			mov cx, lengthof string1rules
			sub cx, 1
			mov si, offset string1rules
			
			printer:	
			push cx
			mov  al, BYTE ptr[si]
			mov  bl, 55h  ;Red color
			mov  bh, 0    ;Display page
			mov  ah, 0Eh  
			int  10h
			inc si
			pop cx
			loop printer
			
			;--------------- ENTER NAME-------------
			mov  bh, 0    ;Display page
			mov  ah, 02h  ;Set cursor position
			mov dl, 52
			mov dh, 8
			int  10h

			mov cx, lengthof stringname
			sub cx, 1
			mov si, offset stringname
			
			printername:	
			push cx
			mov  al, BYTE ptr[si]
			mov  bl, 55h  ;Red color
			mov  bh, 0    ;Display page
			mov  ah, 0Eh  
			int  10h
			inc si
			pop cx
			loop printername
			
		;---------------USER NAME-------------
		
			mov dl, 18
			mov dh, 10
			mov cx, 20
			mov di, 0

			namein: 
			push cx
			mov cx,0
			mov bh,0
			mov ah, 02h
			int 10h

				mov ah, 01h
				int 21h
				cmp al,13
				JE continue_game
				mov BYTE ptr array_input[di],al
				mov ah, 09h
				int 10h
				pop cx
				inc di
				inc dl
				loop namein
			
			continue_game:
			
			;---------------------save name using file handling----------------
			
			mov dx,offset filehandle
			mov ah,3dh
		    mov al,1 
		    int 21h
		    mov handle,ax
		    mov bx,handle
		    mov cx,0
		    mov dx,0
		    mov ah,42h
		    mov al,2
		    int 21h
		   
		    ;write name

		    mov ah,40h
		    mov cx,lengthof array_input
		    mov dx,offset array_input
		    int 21h

		    ;write score
		    mov  ah, 40h  
		    mov  cx, lengthof scorearray  
		    mov  dx, offset scorearray
		    int  21h
			;-------------------GAME------------------------	
			
			call clear_screen
				
			;stuff:	
			;-------------------BANNER------------------------	
			
				call banner 		;banner 
				call scorebanner
				call namebanner
				
				;1st HEART 
				;LEFT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 10	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 13	;x coordinate
				mov y_heart, 7	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 16	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 18	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;RIGHT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 10	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 15	;x coordinate
				mov y_heart, 15	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;2ND HEART 
				;LEFT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 23	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 26	;x coordinate
				mov y_heart, 7	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 29	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 31	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;RIGHT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 23	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 28	;x coordinate
				mov y_heart, 15	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;3RD HEART 
				;LEFT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 36	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 3	;loop counter
				mov x_heart, 39	;x coordinate
				mov y_heart, 7	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 42	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartleft
				
				;RIGHT SLANTED
				mov counter, 2	;loop counter
				mov x_heart, 44	;x coordinate
				mov y_heart, 8	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;RIGHT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 36	;x coordinate
				mov y_heart, 10	;y coordinate
				mov color_heart, 4
				call drawheartright
				
				;LEFT SLANTED
				mov counter, 6	;loop counter
				mov x_heart, 41	;x coordinate
				mov y_heart, 15	;y coordinate
				mov color_heart, 4
				call drawheartleft	
				
		;-------------------BRICKSS------------------------	
		
				;-------------------------------
				;-------------1ST LINE----------
				;-------------------------------
			
				;1st
				mov y, 40 ; y axis vertical part 
				mov x, 35	; x axis horizontal part
				mov color, 1	; color
				call rectangle 
				
				;2nd
				mov y, 40 ; y axis vertical part 
				mov x, 78	; x axis horizontal part
				mov color, 14	; color
				call rectangle 
				
				;3rd
				mov y, 40 ; y axis vertical part 
				mov x, 120	; x axis horizontal part
				mov color, 1	; color
				call rectangle 
				
				;4th
				mov y, 40 ; y axis vertical part 
				mov x, 162	; x axis horizontal part
				mov color, 4	; color
				call rectangle 
				
				;5th
				mov y, 40 ; y axis vertical part 
				mov x, 204	; x axis horizontal part
				mov color, 14	; color
				call rectangle 
				
				;6th
				mov y, 40 ; y axis vertical part 
				mov x, 246	; x axis horizontal part
				mov color, 2	; color
				call rectangle 
					;-------------------------------
					;-------------2ND LINE----------
					;-------------------------------
					
				;1st
				mov y, 57 ; y axis vertical part 
				mov x, 35		;x axis horizontal part
				mov color, 2	; color
				call rectangle 
				
				;2nd
				mov y, 57 ; y axis vertical part 
				mov x, 78	; x axis horizontal part
				mov color, 1	; color
				call rectangle 
					
				;3rd
				mov y, 57 ; y axis vertical part 
				mov x, 120	; x axis horizontal part
				mov color, 14	; color
				call rectangle 
				
				;4th
				mov y, 57 ; y axis vertical part 
				mov x, 162	; x axis horizontal part
				mov color, 2	; color
				call rectangle 
				
				;5th
				mov y, 57 ; y axis vertical part 
				mov x, 204	; x axis horizontal part
				mov color, 4	; color
				call rectangle 
				
				;6th
				mov y, 57 ; y axis vertical part 
				mov x, 246	; x axis horizontal part
				mov color, 1	; color
				call rectangle 	
					
					;-----------------------------------
					;--------------3RD LINE-------------
					;-----------------------------------
			
				;1st
				mov y, 74 ; y axis vertical part 
				mov x, 35	; x axis horizontal part
				mov color, 14	; color
				call rectangle 
				
				;2nd
				mov y, 74 ; y axis vertical part 
				mov x, 78	; x axis horizontal part
				mov color, 4	; color
				call rectangle 
					
				;3rd
				mov y, 74 ; y axis vertical part 
				mov x, 120	; x axis horizontal part
				mov color, 2	; color
				call rectangle 
				
				;4th
				mov y, 74 ; y axis vertical part 
				mov x, 162	; x axis horizontal part
				mov color, 4	; color
				call rectangle 
				
				;5th
				mov y, 74 ; y axis vertical part 
				mov x, 204	; x axis horizontal part
				mov color, 14	; color
				call rectangle 
				
				;6th
				mov y, 74 ; y axis vertical part 
				mov x, 246	; x axis horizontal part
				mov color, 4	; color
				call rectangle 
			
		;----------------INFINITE LOOP-----------------------	
			check_time:
			
				mov ah, 2Ch	    ;system time
				int 21h	   ;CH = hour CL = minute DH = second DL = 1/100 seconds

				cmp dl, time_prev	;prev time = current?
				je check_time
				
				;if diff then draw, move etc
				mov time_prev, dl	;update time
				
		
		;-----------BRICK AND BALL COLLISION-----------------
				
				mov si,0
				mov cx,lengthof array_y
				L1:
				push cx

				mov ax,array_x[si]
				mov x,ax
				mov x_col,ax
				mov ax,array_y[si]
				mov y,ax
				mov y_col,ax

				call brick_collision

				add si,2
				pop cx
				loop L1
				
				call scorecount
		
		;----------------MOVING BALL-----------------------
		
				mov color_ball, 00h		;background ball
				call draw_ball
				
				call move_ball
				
				mov color_ball, 14
				call draw_ball	
				
		;----------------MOVING PADDLE---------------------	
		
				call move_paddle	
				
				;LEVEL 2
				;.if(score == 18)
				;	call clear_screen
				;	call game_win
					
				;	call clear_screen2
				;	call level2
					
				;	jmp stuff
					
				;.endif
				
				;LEVEL 3
				;.if(score == 21)
				;	call clear_screen
				;	call game_win
					
				;	call clear_screen3
				;	call level3
					
				;	jmp stuff
					
					mov ah, 4ch 
					int 21h
					
				;.endif
		
		jmp check_time			;check time again
		
		
		mov ah, 4ch
		int 21h
	main endp

;--------------------------------------------------------
;|				      CLEAR SCREEN		   			   	|
;--------------------------------------------------------
	clear_screen proc
		;set video mode
		mov ah, 0h
		mov al, 13h ;320x200
		int 10h
		
		;background
		mov ah, 0bh
		mov bh, 00h
		mov bl, 00h	;black
		int 10h
		
		ret
	clear_screen endp
	
	clear_screen2 proc
		;set video mode
		mov ah, 0h
		mov al, 13h ;320x200
		int 10h
		
		;background
		mov ah, 0bh
		mov bh, 1
		mov bl, 00h	;black
		int 10h
	
		ret
	clear_screen2 endp
	
	clear_screen3 proc
		;set video mode
		mov ah, 0h
		mov al, 13h ;320x200
		int 10h
		
		;background
		mov ah, 0bh
		mov bh, 2
		mov bl, 00h	;black
		int 10h
	
		ret
	clear_screen3 endp
	
;--------------------------------------------------------
;|				      LEVEL 2 			   			   	|
;--------------------------------------------------------
	
	level2 proc
	
		mov vx_ball, 3
		mov vy_ball, 3
		
		mov width_paddle, 30
		mov score, 0
		mov paddleee, 280
		
		ret
	level2 endp
	
;--------------------------------------------------------
;|				      LEVEL 3 			   			   	|
;--------------------------------------------------------
	
	level3 proc
	
		mov vx_ball, 4
		mov vy_ball, 4
		
		mov score, 0
		mov paddleee, 280
		
		ret
	level3 endp	
	
;--------------------------------------------------------
;|				         BALL	   					   	|
;--------------------------------------------------------
	draw_ball proc 
		mov cx, s_ball	
		mov di, y_ball
		L6:
			push cx
			mov cx, s_ball
			mov si, x_ball
			L5:
				push cx
				mov ah, 0Ch
				mov al, color_ball
				mov bh, 0
				mov cx, si
				mov dx, di
				int 10h
				inc si
				pop cx
				Loop L5
			inc di
			pop cx
			Loop L6	
		ret
	draw_ball endp
	
	move_ball proc
	
		;x_ball += velocity
		;y_ball += velocity
		
	;---------moving in y direction------------	
		mov bx, vy_ball
		add y_ball, bx
		
		mov ax, 23					;banner
		cmp y_ball, ax				;if collides with TOP wall
		jl	y_neg_vel				;y_ball < screen_boundary 
		
	;--------------------COLLISION OF BALL AND PADDLE------------------------------		
		
		mov ax, x_paddle
		cmp x_ball, ax			;x_ball < x_paddle  -> no collision
		jl nocoll
		add ax, width_paddle	
		cmp x_ball, ax			;x_ball > x_paddle + width_paddle  -> no collision
		jg nocoll

		mov ax, y_paddle
		sub ax,5
		cmp y_ball, ax			;y_ball < y_paddle  -> no collision
		jl nocoll
		add ax, height_paddle
		cmp y_ball, ax			;y_ball > y_paddle + height_paddle  -> no collision
		jg nocoll
		
		
		jmp y_neg_vel
		
		nocoll:
			mov ax, screen_height
			sub ax, s_ball
			sub ax, screen_boundary
			cmp y_ball, ax				;if collides with BOTTOM wall		
			jg reset_pos	     	 ;y_ball > screen_height - ball size 
		
		jmp move_horizontally
		
	;---------reset position------------
		reset_pos:
		dec lives_count
		mov ax, ogx_ball
		mov x_ball, ax
		
		mov ax, ogy_ball
		mov y_ball, ax

	;----------------LIVES DEDUCTION---------------	
		
		.if(lives_count == 2)
			;3RD HEART 
			;LEFT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 36	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 39	;x coordinate
			mov y_heart, 7	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 42	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 44	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;RIGHT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 36	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 41	;x coordinate
			mov y_heart, 15	;y coordinate
			mov color_heart, 00h
			call drawheartleft
		
		.elseif(lives_count == 1)
			;2ND HEART 
			;LEFT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 23	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 26	;x coordinate
			mov y_heart, 7	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 29	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 31	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;RIGHT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 23	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 28	;x coordinate
			mov y_heart, 15	;y coordinate
			mov color_heart, 00h
			call drawheartleft
		
		.elseif(lives_count == 0)
			;1st HEART 
			;LEFT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 10	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 3	;loop counter
			mov x_heart, 13	;x coordinate
			mov y_heart, 7	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 16	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			;RIGHT SLANTED
			mov counter, 2	;loop counter
			mov x_heart, 18	;x coordinate
			mov y_heart, 8	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;RIGHT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 10	;x coordinate
			mov y_heart, 10	;y coordinate
			mov color_heart, 00h
			call drawheartright
			
			;LEFT SLANTED
			mov counter, 6	;loop counter
			mov x_heart, 15	;x coordinate
			mov y_heart, 15	;y coordinate
			mov color_heart, 00h
			call drawheartleft
			
			call clear_screen
			call game_lose
			jmp lives_end
			
			lives_end:
				mov ah, 4ch
				int 21h
		.endif
		
		ret
		
	;---------moving in x direction------------	
		move_horizontally:
		
			mov ax, vx_ball
			add x_ball, ax
		
			mov ax, screen_boundary
			cmp x_ball, ax				;if collides with LEFT wall
			jl	x_neg_vel				;x_ball < 0 + screen_boundary 
		
			mov ax, screen_width
			sub ax, s_ball
			sub ax, screen_boundary
			cmp x_ball, ax				;if collides with RIGHT wall
			jg x_neg_vel			;x_ball > screen_width - ball size 
			
		ret
			
		y_neg_vel:
			neg vy_ball
			ret
		x_neg_vel:
			neg vx_ball
			ret
		exit:
			ret
	move_ball endp
	
	reset_ball proc
		mov ax, ogx_ball
		mov x_ball, ax
		
		mov ax, ogy_ball
		mov y_ball, ax

		ret
	reset_ball endp
	
;--------------------------------------------------------
;|				         LIVES	   					   	|
;--------------------------------------------------------
	drawheartleft proc
	mov cx, counter	;loop counter
	mov si, x_heart	;x coordinate
	mov di, y_heart	;y coordinate
	
	L1a:
		push cx
		mov ah, 0Ch
		mov al, color_heart	
		mov bh, 0
		mov cx, si	
		mov dx, di
		int 10h
		inc si
		dec di
		pop cx
		Loop L1a
		ret
	drawheartleft endp
	
	drawheartright proc
	mov cx, counter		;loop counter
	mov si, x_heart	;x coordinate
	mov di, y_heart		;y coordinate
	
	L1a:
		push cx
		mov ah, 0Ch
		mov al, color_heart	
		mov bh, 0
		mov cx, si	
		mov dx, di
		int 10h
		inc si
		inc di
		pop cx
		Loop L1a
		ret
	drawheartright endp
	
;--------------------------------------------------------
;|				         PADDLE	   					   	|
;--------------------------------------------------------
	
	draw_paddle proc
		mov cx, height_paddle	
		mov di, y_paddle
		L6:
			push cx
			mov cx, width_paddle 
			mov si, x_paddle 
			L5:
				push cx
				mov ah, 0Ch
				mov al, color_paddle
				mov bh, 0
				mov cx, si
				mov dx, di
				int 10h
				inc si
				pop cx
				Loop L5
			inc di
			pop cx
			Loop L6
		ret
	draw_paddle endp	
	
	move_paddle proc
		mov ah, 01h
		int 16h
		jz L1
		
		mov ah, 00h
		int 16h
			
		cmp ah, 77	;right
		je right	
		cmp ah, 75	;left
		je left
		
		cmp ah,28		;to run game again
		je exit
		
		jmp L1
			
		left:	
			mov bx, x_paddle
			cmp x_paddle, 8
			jl L1
			
			mov color_paddle, 00h				
			call draw_paddle
			
			mov ax, v_paddle
			sub x_paddle, ax

			jmp L1
			
		right:
			mov bx, x_paddle
			cmp bx, paddleee
			jg L1
			
			mov color_paddle, 00h
			call draw_paddle

			mov ax, v_paddle
			add x_paddle, ax

			jmp L1
		L1:	
			mov color_paddle, 14
			call draw_paddle
		ret
		
		exit:
		mov ah,4ch
		int 21h
	move_paddle endp
	
	
;--------------------------------------------------------
;|				         BRICKS   					   	|
;--------------------------------------------------------

	rectangle proc 
		mov di, y		; y cordinate
		mov cx, 15 	;counter -> height
		L6:
		push cx
		mov cx, 40 ;counter ->length
		mov si, x ;1 x coordinate
			L5:
			push cx
			mov ah, 0Ch
			mov al, color		 ;color
			mov bh, 0
			mov cx, si
			mov dx, di
			int 10h
			inc si
			pop cx
			Loop L5
		inc di
		pop cx
		Loop L6
		
	ret	
	rectangle endp	
	
;--------------------------------------------------------
;|				     BRICKS COLLISION		   		    |
;--------------------------------------------------------

	brick_collision proc uses ax bx cx dx si di

		mov ax, x_col
		sub ax,8
		cmp x_ball, ax			;x_ball < x_brick  -> no collision
		jl nocollision

		add ax,8
		add ax, 42				;42 = length
		cmp x_ball, ax			;x_ball > x_brick + width  -> no collision
		jg nocollision
		
		mov ax, y_col
		sub ax,8
		cmp y_ball, ax			;y_ball < y_brick  -> no collision
		jl nocollision
		
		add ax,8
		add ax, 15				;15 = height
		cmp y_ball, ax			;y_ball > y_brick + height  -> no collision
		jg nocollision
		
		call beep_sound				;sound effect
		
		jmp collision
		
		nocollision:
			ret
		collision:
			inc score					;score == 21 game ends u win
			
			xor al, al
			mov al, score
			add al , 30h
			mov [scorearray], al
			
			mov color, 00h
			mov array_y[si],0
			mov array_x[si],0
	
			mov di,y_col
			mov si,x_col
			call rectangle
			neg vy_ball

		ret
	brick_collision endp
	
;--------------------------------------------------------
;|				     SCORE BANNER   				   	|
;--------------------------------------------------------	
	
	banner proc 	
		mov di, 20	; y cordinate
		mov cx, 1 ;counter -> width
		
		tag1:
		push cx
		mov cx, 318 ;counter ->length
		mov si, 1 ;1 x coordinate
			tag2:
			push cx
			mov ah, 0Ch
			mov al,15  ;color
			mov bh, 0
			mov cx, si
			mov dx, di
			int 10h
			inc si
			pop cx
			Loop tag2
		inc di
		pop cx
		Loop tag1
		
		ret	
	banner endp	
	
	scorebanner proc
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 30
		mov dh, 1
		int  10h

		mov cx,7
		mov si, offset scrorestr
		
		scoree:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;pink
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		
		loop scoree
	
	ret 
	scorebanner endp
	
	scorecount proc
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 37
		mov dh, 1
		int  10h

		mov cx,1
		mov si, offset scorearray
		
		scoree:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;pink
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		ret
	scorecount endp
	
	
	namebanner proc
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 15
		mov dh, 1
		int  10h

		mov cx, lengthof array_input
		mov si, offset array_input
		
		scoree:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;pink
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		
		loop scoree
	
	
		ret
	namebanner endp

;--------------------------------------------------------
;|					GAME MENU   					   	|
;--------------------------------------------------------
	game_menu proc
	
		;--------------- HEADING-------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 52
		mov dh, 2
		int  10h

		mov cx, lengthof string1
		sub cx, 1
		mov si, offset string1
		
		printer:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer
		
		;---------------NEW GAME--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 57 ;X
		mov dh, 4	;Y
		int  10h

		mov cx,19
		mov si, offset string2
		printer2:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer2
		
		;---------------RESUME--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 58  ;X
		mov dh, 8	;Y
		int  10h

		mov cx,17
		mov si, offset string3
		printer3:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer3
		;---------------Rules--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 58  ;X
		mov dh, 12	;Y
		int  10h

		mov cx,16
		mov si, offset string4
		printer4:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer4
		
		;---------------High Score--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 56  ;X
		mov dh, 16	;Y
		int  10h

		mov cx,21
		mov si, offset string5
		printer5:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer5
	
		;---------------EXIT--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 59  ;X
		mov dh, 20	;Y
		int  10h

		mov cx, lengthof string6
		sub cx, 1
		mov si, offset string6
		printer6:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer6

		;------------------- 1st box-------------------
		mov cx, 80	;counter	50
		mov si, 125	;x coordinate
		
		
		L1:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 50  ;50	
			int 10h
			inc si
			pop cx
			Loop L1
			
		mov cx, 20	;counter
		mov si, 50	;y coordinate
		L2:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 125	;10
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L2
		
		mov cx, 20	;counter
		mov si, 50	;y coordinate
		L3:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 204
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L3
		
		mov cx, 80	;counter
		mov si, 125	;x coordinate
		L4:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 30
			int 10h
			inc si
			pop cx
			Loop L4
			
		;--------------------- 2nd BOX-------------------
		mov cx, 50	;counter	50
		mov si, 140	;x coordinate

		L9:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 60  ;50	
			int 10h
			inc si
			pop cx
			Loop L9
			
		mov cx, 20	;counter
		mov si, 80	;y coordinate
		L10:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 140	;10
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L10
		
		mov cx, 20	;counter
		mov si, 80	;y coordinate
		L11:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 189
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L11
		
		mov cx, 50	;counter
		mov si, 140	;x coordinate
		L12:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 80
			int 10h
			inc si
			pop cx
			Loop L12
			
		;--------------------- 4th BOX-------------------
		mov cx, 81	;counter	50
		mov si, 124	;x coordinate
		
		
		L5:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 120  ;50	
			int 10h
			inc si
			pop cx
			Loop L5
			
		mov cx, 20	;counter
		mov si, 140	;y coordinate
		L6:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 124	;10
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L6
		
		mov cx, 20	;counter
		mov si, 140	;y coordinate
		L7:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 204
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L7
		
		mov cx, 80	;counter
		mov si, 125	;x coordinate
		L8:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 140
			int 10h
			inc si
			pop cx
			Loop L8
			
			
		;--------------------- 3rd BOX-------------------
		mov cx, 50	;counter	50
		mov si, 140	;x coordinate
		
		
		L13:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 90  ;50	
			int 10h
			inc si
			pop cx
			Loop L13
			
		mov cx, 20	;counter
		mov si, 110	;y coordinate
		L14:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 140	;10
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L14
		
		mov cx, 20	;counter
		mov si, 110	;y coordinate
		L15:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 189
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L15
		
		mov cx, 50	;counter
		mov si, 140	;x coordinate
		L16:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 110
			int 10h
			inc si
			pop cx
			Loop L16
			
		;------------------ Last box-------------------	

		mov cx, 50	;counter	50
		mov si, 140	;x coordinate
		
		
		L17:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 150  ;50	
			int 10h
			inc si
			pop cx
			Loop L17
			
		mov cx, 20	;counter
		mov si, 170	;y coordinate
		L18:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 140	;10
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L18
		
		mov cx, 20	;counter
		mov si, 170	;y coordinate
		L19:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, 189
			mov dx, si	
			int 10h
			dec si
			pop cx
			Loop L19
		
		mov cx, 50	;counter
		mov si, 140	;x coordinate
		L20:
			push cx
			mov ah, 0Ch
			mov al, 14	;yellow
			mov bh, 0
			mov cx, si	
			mov dx, 170
			int 10h
			inc si
			pop cx
			Loop L20
		ret
	game_menu endp	
	
	rules proc
	
		;--------------- HEADING-------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 52
		mov dh, 2
		int  10h

		mov cx, lengthof string1rules
		sub cx, 1
		mov si, offset string1rules
		
		printer:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer
		
		;---------------RULES--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 58 ;X
		mov dh, 4	;Y
		int  10h

		mov cx,5
		mov si, offset string2rules
		printer2:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer2
		
		;---------------STATEMENT1--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 0 ;X
		mov dh, 7	;Y
		int  10h

		mov cx,31
		mov si, offset string3rules
		printer3:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 15  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer3
		;---------------STATEMENT2----------------------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 0  ;X
		mov dh, 10	;Y
		int  10h

		mov cx,53
		mov si, offset string4rules
		printer4:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 15  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer4
		
		;---------------STATEMENT3--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 0  ;X
		mov dh, 13	;Y
		int  10h

		mov cx,40
		mov si, offset string5rules
		printer5:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 15 ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop printer5

		ret
	rules endp	
	
;--------------------------------------------------------
;|					  SOUND 	  					   	|
;--------------------------------------------------------
	
	beep_sound proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         
        out     43h, al         
        mov     ax, 400        

        out     42h, al         
        mov     al, ah         
        out     42h, al 
        in      al, 61h        
		
        or      al, 00000011b   
        out     61h, al        
        mov     bx, 2          
	pause1:
        mov     cx, 65535
	pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         
        and     al, 11111100b   
        out     61h, al         

        pop dx
        pop cx
        pop bx
        pop ax

		ret
	beep_sound endp
	
;--------------------------------------------------------
;|					  GAME OVER	  					   	|
;--------------------------------------------------------

	game_lose proc 
		
	;--------------- HEADING-------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 51
		mov dh, 5
		int  10h

		mov cx,19
		mov si, offset LOSE1
		
		LOSER:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop LOSER
		
		;---------------STATEMENT1--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 12 ;X
		mov dh, 11	;Y
		int  10h

		mov cx,17
		mov si, offset LOSE2
		LOSER3:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop LOSER3
	;---------------STATEMENT2----------------------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 17  ;X
		mov dh, 14	;Y
		int  10h

		mov cx,7
		mov si, offset LOSE3
		LOSER4:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop LOSER4
		
		;---------------SCORE NUM--------------	

		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 25
		mov dh, 14
		int  10h

		mov cx,1
		mov si, offset scorearray
		
		scoree:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;pink
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop scoree
		
		xor al, al
		mov al, score
		add al , 30h
		mov [scorearray], al
		
		ret
	game_lose endp
	
	game_win proc
	
	;--------------- HEADING-------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 51
		mov dh, 2
		int  10h

		mov cx,19
		mov si, offset WIN1
		
		WINNER:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop WINNER
	
	;---------------CONGRATULATIONS------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 53 ;X
		mov dh, 8	;Y
		int  10h

		mov cx,15
		mov si, offset WIN2
		WINNER1:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop WINNER1
	
	;---------------STATEMENT1--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 13 ;X
		mov dh, 11	;Y
		int  10h

		mov cx,16
		mov si, offset WIN3
		WINNER2:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop WINNER2
		;---------------STATEMENT2----------------------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 17  ;X
		mov dh, 14	;Y
		int  10h

		mov cx,7
		mov si, offset WIN4
		WINNER3:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop WINNER3
		
	;---------------SCORE NUM--------------	

		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 25
		mov dh, 14
		int  10h

		mov cx,1
		mov si, offset scorearray
		
		scoree:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;pink
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop scoree
		
		xor al, al
		mov al, score
		add al , 30h
		mov [scorearray], al
		
		ret
	game_win endp
	
	
;--------------------------------------------------------
;|					  HIGH SCORE	  				   	|
;--------------------------------------------------------

	high_scoree proc
			;--------------- HEADING-------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 51
		mov dh, 2
		int  10h

		mov cx,lengthof hs1
		mov si, offset hs1
		
		hss1:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 55h  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss1
		
		;---------------STATEMENT1--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 16 ;X
		mov dh, 5	;Y
		int  10h

		mov cx,lengthof hs2
		mov si, offset hs2
		hss2:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss2
		;---------------STATEMENT2----------------------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 9 ;X
		mov dh, 8	;Y
		int  10h

		mov cx, lengthof hs3
		mov si, offset hs3
		hss3:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12  ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss3
		
		;---------------STATEMENT3--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 9  ;X
		mov dh, 11	;Y
		int  10h

		mov cx,lengthof hs4
		mov si, offset hs4
		hss4:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12 ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss4
		
		;---------------STATEMENT4--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 9  ;X
		mov dh, 14	;Y
		int  10h

		mov cx,lengthof hs5
		mov si, offset hs5
		hss5:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12 ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss5
		;---------------STATEMENT4--------------
		mov  bh, 0    ;Display page
		mov  ah, 02h  ;Set cursor position
		mov dl, 9  ;X
		mov dh, 17	;Y
		int  10h

		mov cx,lengthof hs6
		mov si, offset hs6
		hss6:	
		push cx
		mov  al, BYTE ptr[si]
		mov  bl, 12 ;Red color
		mov  bh, 0    ;Display page
		mov  ah, 0Eh  
		int  10h
		inc si
		pop cx
		loop hss6
	
		ret
	high_scoree endp
end