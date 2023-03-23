; Target assembler: 64tass v1.56.2625 [--ascii --case-sensitive -Wall]
; 6502bench SourceGen v1.8.3
        .cpu    "6502"
Adr_MapLow =    $11
Adr_MapHigh =   $12
Adr_ColorRam = $d800
Adr_Voice2 = $d40b
;Adr_HighScore = $8422
Var_KeyboardInput = $c5    ;This is for the keyboard player inputs
Low_tempvar = $fb
High_tempvar = $fc
Var_SpriteCollision = $fd
IRQVectorLow =  $0314
IRQVectorHigh = $0315
Adr_MagicCrossNumLeft = $041c
Adr_MagicCrossNumRight = $041d
Adr_SID = $d400
Scr_HealthBar = $042e
SpritePointer0 = $07f8
SpritePointer1 = $07f9
SpritePointers = $07fa
Sprite0XPosition = $d000
Sprite0YPos =   $d001
Sprite1XPositionRegister = $d002
Sprite1YPosition = $d003
Adr_EnemyXPosition = $d004
Adr_EnemyYPosition = $d005
SpriteXMSBRegister = $d010
ScreenControlRegister = $d011
CurrentRasterLine = $d012
SpriteEnableRegister = $d015
Adr_ScreenControl = $d016
Adr_MemorySetupRegister = $d018
Adr_SprMulticolorMode = $d01c
Adr_SprDoubleWidth = $d01d
Adr_SpriteCollision = $d01e
Adr_SprBGColl = $d01f
Adr_BorderColor = $d020
Adr_BackgroundColor = $d021
ExtraBackgroundColor1 = $d022
ExtraBackgroundColor2 = $d023
Adr_SprExtraCol1 = $d025
Adr_SprExtraCol2 = $d026
Adr_Voice3Control = $d412
Adr_Voice3AttackDecay = $d413
FilterCutoffFrequencyLow = $d415
FilterCutoffFrequencyHigh = $d416
FilterResonanceRouting = $d417
FilterModeVolume = $d418
InputPortA =    $dc00
BSOUT   =       $ffd2      ;($0326/ichrout) output vector, chrout
PLOT    =       $fff0      ;read/set cursor X/Y position


*       =       $0818
        ldx     #$00
-   	lda     L0900,x
        sta     LCE00,x
        lda     L0A00,x
        sta     Var_CurrentEnemyIndex+1,x
        inx
        bne     -
-       lda     L08D0,x
        sta     Sprite0XPosition,x
        inx
        cpx     #$30
        bne     -
        jmp     L2DFA

        .include "Data/X_0837.asm"
        .include "Data/L08D0.asm"
        .include "Data/L0900.asm"
        .include "Data/L0A00.asm"
        .include "Data/X_0B00.asm"
        .include "Sprites/enemysprites.asm"

L2A00   lsr     a
        clc                			; Clear carry
        bcc     L2A29

Sub_PlayerPosition
        sta     Var_PlayerDirection 		; Set Var_PlayerDirection - default is down (00 = up / 01 = down / 02 = left / 03 = right).
        lda     Sprite0YPos 			; A = Sprite0YPos
        sec                			; Set carry
L2A0B   sbc     #$2c       			; Subtract with carry. Removing top border height.
        lsr     a          			; Divide by 2
        lsr     a          			; Divide by 2
        lsr     a          			; Divide by 2. This is to devide by 8 to work out number of characters from the top of the screen.
        tay                			; Transfer A to Y.
        lda     Sprite0XPosition 		; A = Sprite0XPosition
        sec                			; Set carry
        sbc     #$0c       			; Subtract with carry #0c (12)
        bcc     L2A00      			; Branch if carry clear
        lsr     a          			; Divide by 2
        sta     Var_CharacterXPosLow 		; Update Var_CharacterXPosLow
        lda     SpriteXMSBRegister 		; A = SpriteXMSBRegister
        and     #$01       			; Isolate the first bit
        beq     + 				; Branch something something
        lda     #$80 				; A = #80
+	ora     Var_CharacterXPosLow 	        ; 
L2A29 	lsr     a          			; Divide by 2
        lsr     a          			; Divide by 2
        tax                			; Transfer A to X
        tya                			; Transfer Y to A. Y = (Y Pos - #2c) / 8 
        asl     a          			; Multiply by 2. This is to get the 
        tay                			; Transfer A to Y
        ; *******************************************************************************
        ; * $5100 is the top left character. Y is the number of characters from $5100   *
        ; * from left to right. $fc is the high byte / $fb is the low byte.             *
        ; *******************************************************************************
        lda     Low_ScreenMap,y
        sta     Low_tempvar 			; Player position
        lda     High_ScreenMap,y
        sta     High_tempvar 			; Player position
        txa
        clc
        adc     Low_tempvar
        sta     Low_tempvar
        bcc     +
        inc     High_tempvar
+ 	lda     High_tempvar
        clc
        adc     #$04       			; Add #04 to the current value of $fc. This equates to the screen high byte.
        sta     High_tempvar 			; Set player position high byte
        ldx     Var_PlayerDirection 		; X = Var_PlayerDirection (00 = up / 01 = down / 02 = left / 03 = right)
		
        ;*******************************************************************************
        ;* This is getting the codes to find what character is next.                   *
        ;* The player position ($fb/$fc) is considered a row above the platform.       *
        ;* $5145 = #00 (00) characters from current position. Checking above.          *
        ;* $5146 = #50 (80) characters from current position. Checking below.          *
        ;* $5147 = #27 (39) characters from current position. Checking left.           *
        ;* $5148 = #29 (41) characters from current position. Checking right.          *
        ;*******************************************************************************
        
	lda     L5145,x    		        ; A = $5145,x (Up = $5415 / Down = $5416 / Left = $5417 / Right = $5418)
        tay                			; Transfer A to Y
        lda     (Low_tempvar),y 		; ($fb),y = Get character based on direction.
        cmp     #$a0       			; Check if current character is blank
        bne     Sub_WhatIsPlayerTouching 	; Branch if not a blank space
		
PlayerMidAir
        ldx     #$00                       	; Set X register to #00, representing the Up direction.
        lda     Var_PlayerDirection        	; Load the value of Var_PlayerDirection (player's current direction) into the accumulator (A).
        jsr     Sub_UpdateSpritePositions  	; Call the subroutine Sub_UpdateSpritePositions with X representing the sprite and A holding the direction (00 = up / 01 = down / 02 = left / 03 = right).
        rts                               	; Return from the subroutine.


Sub_WhatIsPlayerTouching
        cmp     #$2a                    	; Compare the value in the accumulator (A) with #$2a (check if the current character is a platform).
        bpl     If_NotPlatform         		; Branch to If_NotPlatform if the comparison result is positive or zero (the character is not a platform).
        jmp     PlayerMidAir       	        ; Jump to the label PlayerMidAir if the comparison result is negative (the character is a platform, and the player is mid-air).


If_NotPlatform
        cmp     #$54                    	; Compare the value in the accumulator (A) with #$54 (check if the current character is a mushroom).
        bpl     If_TouchingMushroom     	; Branch to If_TouchingMushroom if the comparison result is positive or zero (the player is touching a mushroom).
        jmp     L5A9A                   	; Jump to the label L5A9A if the comparison result is negative (the player is not touching a mushroom).


If_TouchingMushroom
        jmp     Sub_GetMushroom         	; Jump to the subroutine Sub_GetMushroom if the player is touching a mushroom.

        .byte   $60

L2A72   sta     Var_FallingStanding             ; Set Var_FallingStanding to #00 (Jumping).
        lda     L544A                           ; Load #05
        sta     Var_JumpAscDescTimer            ; Update Var_JumpAscDescTimer to #05
        jmp     Sub_5880

Var_JumpAscDesc   
        .byte   $07

Var_JumpAscDescTimer                            ; $2a7f
        .byte   $09

Sub_2A80
        stx     Low_tempvar 			;X = $fb (From $2a80. Passed with X = #bf)
        sty     High_tempvar 			;Y = $fc (From $2a80. Passed with Y = #5b)
        ldy     #$00       			;Y = #00
        lda     (Low_tempvar),y 		;A = 5bbf,00. Start of the index set.
        sta     Sub_C29D+1 			;$C29E = #00
        iny                			;Increase Y
        lda     (Low_tempvar),y 		;A = #b2
        sta     LC2A1+1    			;$C2A2 = #b2
        iny                			;Increase Y
        lda     (Low_tempvar),y 		;A = #ff
        sta     LC2AD+1    			;$C2AE = #ff
        iny                			;Increase Y
        lda     (Low_tempvar),y 		;A = #b5
        sta     LC2B2+1    			;$C2B3 = #b5
        iny                			;Increase Y
        lda     (Low_tempvar),y 		;A = 00
        sta     LC2A5+1    			;$C2A6 = #00
        iny                			;Increase Y
        lda     (Low_tempvar),y 		;A = #30
        sta     LC2A9+1    			;C2AA = #30
        jsr     Sub_C29D
        rts                			;Return from subroutine

        .byte   $dc,$9d,$bd,$a0,$2a,$20,$80,$2a,$a2,$c3,$a0,$2a,$20,$80,$2a,$60
        .byte   $28,$04,$ff,$07,$28,$41,$28,$d8,$ff,$db,$28,$46,$ea,$ea,$ea,$a8
        .byte   $c8,$98,$8d,$fd,$2a,$c9,$2a,$d0,$07,$18,$a5,$fb,$69,$28,$85,$fb
        .byte   $c9,$54,$d0,$07,$18,$a5,$fb,$69,$28,$85,$fb,$ad,$fd,$2a,$60,$8d
        .byte   $9c,$c1,$a9,$00,$8d,$4e,$53,$60,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
        .byte   $7e
Var_PlayerDirection
        .byte   $01
Var_CharacterXPosLow
        .byte   $58,$a9,$00,$85,$fb,$a9,$d8,$85,$fc,$a9,$00,$8d,$84,$03,$a9,$00
        .byte   $8d,$86,$03,$a9,$00,$8d,$85,$03,$a9,$00,$8d,$87,$03,$a0,$00,$ae
        .byte   $86,$03,$bd,$c0,$39,$8d,$88,$03,$ae,$87,$03,$bd,$88,$2b,$2d,$88
        .byte   $03,$c9,$00,$f0,$11,$c9,$01,$f0,$0d,$c9,$02,$f0,$09,$c9,$03,$f0
        .byte   $05,$4a,$4a,$4c,$30,$2b,$aa,$bd,$8c,$2b,$91,$fb,$ee,$87,$03,$e6
        .byte   $fb,$d0,$02,$e6,$fc,$91,$fb,$e6,$fb,$d0,$02,$e6,$fc,$ad,$87,$03
        .byte   $c9,$04,$d0,$b9,$ee,$86,$03,$ee,$85,$03,$ad,$85,$03,$c9,$03,$d0
        .byte   $a7,$a9,$10,$e6,$fb,$d0,$02,$e6,$fc,$18,$e9,$00,$d0,$f5,$ee,$84
        .byte   $03,$ad,$84,$03,$c9,$15,$d0,$8b,$60,$c0,$30,$0c,$03,$f0,$f9,$fb
        .byte   $f1,$ad,$25,$d0,$8d,$8d,$2b,$ad,$26,$d0,$8d,$8f,$2b,$ad,$2a,$d0
        .byte   $8d,$8e,$2b,$ad,$0f,$45,$8d,$8c,$2b,$4c,$00,$2b,$a2,$08,$a9,$01
        .byte   $a0,$01,$20,$ba,$ff,$ad,$84,$03,$a2,$85,$a0,$03,$20,$bd,$ff,$60
        .byte   $20,$ab,$2b,$a9,$00,$85,$fb,$a9,$30,$85,$fc,$a9,$fb,$a2,$00,$a0
        .byte   $4e,$20,$d8,$ff,$60,$20,$ab,$2b,$a9,$00,$a2,$00,$a0,$30,$20,$d5
        .byte   $ff,$60,$a9,$00,$8d,$12,$d4,$a9,$00,$ea,$ea,$ea,$ea,$ea,$ea,$4c
        .byte   $ec,$2a,$60

Sub_SetScreenControl
        sta     SpriteEnableRegister
        lda     Adr_ScreenControl
        ora     #$08
        sta     Adr_ScreenControl
        rts

        .byte   $ea,$1d

L2C00
        ; Initialize X register as index
        ldx     #$00                    ; Load #$00 into X register to use as an index

        ; Loop 5 times through values stored at L4542 (indexed by X) and call subroutine L56B2
-   	lda     L4542,x                 ; Load value from L4542 indexed by X into A register. This seems to be used for the frequency the sprite performs its path.	
        jsr     L56B2                   ; Call subroutine L56B2 with the loaded value
        inx                             ; Increment X register to move to the next index
        cpx     #$05                    ; Compare X register (index) with #$05
        bne     -                       ; Loop if X (index) not equal to #$05 (continue looping 5 times)

        ; Call subroutine L2E62 and return
        jsr     L2E62                   ; Call subroutine L2E62
        rts                             ; Return from subroutine



        .fill   8,$ea

L2C19   ldx     #$03
- 	inc     LCFA6,x
        lda     LCFA6,x
        cmp     #$ba
        bne     +
        lda     #$b0
        sta     LCFA6,x
        dex				; Decrease X
        cpx     #$00
        bne     -
+ 	jsr     L5681
        jmp     Jump_2C44

        .byte   $a9,$60,$8d,$fc,$ca,$20,$86,$ca,$a9,$4c,$8d,$fc,$ca,$60,$ea

Jump_2C44
        lda     #$01
        sta     SpriteEnableRegister
        ldx     #$00
- 	lda     $05ef,x
        sta     $0345,x
        lda     $d9ef,x
        sta     $034e,x
        lda     LCFA1,x
        sta     $05ef,x
        lda     $d81a
        sta     $d9ef,x
        inx
        cpx     #$09
        bne     -
        lda     #$00						; A = #00
        sta     LCF73
        lda     #$03
        sta     L2E00+7
        lda     #$04
        sta     L2E00+33
        sta     $a1
- 	lda     $a1
        cmp     #$06
        bne     -
        lda     #$05
        sta     L2E00+7
        lda     #$07
        sta     L2E00+33
        lda     #$00						; A = #00
        sta     LCF74
        ldx     #$00
+ 	lda     $0345,x
        sta     $05ef,x
        lda     $034e,x
        sta     $d9ef,x
        inx
        cpx     #$09
        bne     +
        jmp     LC694

Sub_SetRandomVariables
        ; Set initial values for LCFA7 and LCFA8
        lda     #$b0                    ; Load #$b0 into A register
        sta     LCFA7                   ; Store A into LCFA7
        sta     LCFA8                   ; Store A into LCFA8

        ; Set initial value for LCFA9
        lda     #$b1                    ; Load #$b1 into A register
        sta     LCFA9                   ; Store A into LCFA9

        ; Jump to another subroutine
        jmp     L2C00                   ; Jump to subroutine L2C00


Sub_SetInterruptsAndMem
        sei                					; Set interrupt flags
        lda     #$31       					; A = #31
        sta     IRQVectorLow 				; IRQVectorLow = #31
        lda     #$ea       					; A = #ea
        sta     IRQVectorHigh 				; IRQVectorHigh = #ea
        cli                					; Clear interrupt flag
        lda     #$00						; A = #00
        sta     LCF7F      					; $cf7f = #00
        lda     #$05       					; A = #05
        sta     Adr_BorderColor 			; BorderColor = #05 (Green)
        lda     #$0f       					; A = #0f
        sta     Adr_BackgroundColor 		; BackgroundColor = #0f (Light grey)
        lda     #$15       					; A = #15
        sta     Adr_MemorySetupRegister 	; Adr_MemorySetupRegister
        lda     #$93
        jsr     BSOUT
        lda     #$00						; A = #00
        sta     $c6
        sta     $ffff
        jmp     Sub_SetScreenControl

        .byte   $ea

L2CE4   lda     L45FC
        sta     LCA18+1 					; Value will be used with a CMP function. 80 will be moving slowly.
        lda     L45FD
        sta     LCA06+1
        jmp     L2EE3

L2CF3   sta     L2E87                   ; Store A register value (from previous $45ee load) at memory address L2E87
        beq     +                       ; Branch to the next '+' label if the value in A register (from previous load) is zero
        lda     #$00                    ; Load A register with the value #00 (clear A register)
        sta     $ffff                   ; Store the cleared A register value (0) at memory address $ffff
+       rts                             ; Return from subroutine (go back to where it was called)


        .fill   2,$ea

L2D00
		ldx     #$00

; The loop copies 5 bytes of data from the L45E7 address to the LCF76 address.
-       lda     L45E7,x        			; Load data from the L45E7 address indexed by X into the accumulator (A).
        sta     LCF76,x        			; Store the data in the accumulator (A) to the LCF76 address indexed by X.
        inx                    			; Increment loop index X.
        cpx     #$05           			; Compare loop index X with the value 5.
        bne     -              			; If X is not equal to 5, branch back to the beginning of the loop.

; Configure sprite extra colors and multicolor mode.
        lda     Const_SprExtraCol1      ; Load value from the Const_SprExtraCol1 address into the accumulator (A).
        sta     Adr_SprExtraCol1        ; Store the value in the accumulator (A) into the Adr_SprExtraCol1 register (Sprite Extra Color #1).
        lda     Const_SprExtraCol2      ; Load value from the Const_SprExtraCol2 address into the accumulator (A).
        sta     Adr_SprExtraCol2        ; Store the value in the accumulator (A) into the Adr_SprExtraCol2 register (Sprite Extra Color #2).
        lda     Const_SprMulticolorMode ; Load value from the Const_SprMulticolorMode address into the accumulator (A).
        sta     Adr_SprMulticolorMode   ; Store the value in the accumulator (A) into the Adr_SprMulticolorMode register (Sprite Multicolor Mode).

; Configure sprite double width mode.
        lda     Const_SprDoubleWidth    ; Load value from the Const_SprDoubleWidth address into the accumulator (A).
        sta     Adr_SprDoubleWidth      ; Store the value in the accumulator (A) into the Adr_SprDoubleWidth register (Sprite Double Width).

; Perform three no-operation instructions (NOP) for possible timing or code alignment purposes.
        nop                             ; No operation.
        nop                             ; No operation.
        nop                             ; No operation.

        jmp     LCA00



        .byte   $a0,$e4,$a2,$00,$98,$9d,$f8,$07,$18,$69,$04,$a8,$bd,$ad,$45,$9d
        .byte   $27,$d0,$e8,$e0,$05,$d0,$ed,$ad,$f4,$45,$4a,$4a,$8d,$1c,$d0,$60

L2D4B   ldx     #$00       				; Load the value #$00 into the X register.
L2D4D   lda     LCF76,x    				; Load the value at address LCF76+x into the accumulator. Addresses include c2,c5,12,00,c5.
        beq     +          				; If the value is equal to #$00, branch to the next code block. Only Loop 3 will be true.
L2D52   lda     L45F7,x    				; Load the value at address L45F7+x into the accumulator. Addresses include 00,01,00,00,00.
        beq     ++         				; If the value is equal to #$00, branch to ++.
        jmp     Jump_2D60  				; Otherwise, jump to a label called Jump_2D60. Only executed on 
+       jmp     L2EB7      				; Jump to a label called L2EB7. 
+       jmp     L2EC4      				; Jump to a label called L2EC4. This will perform a loop 5 times. On the fifth time, it will jump.


Jump_2D60
        lda     Adr_SprBGColl 			;Load the value of a memory address called Adr_SprBGColl into the accumulator.
        sta     _L2D7A      			;Store it in a variable called _L2D7A.
        and     #$02         			;Perform a bitwise AND operation with the value #$02.
        cmp     #$00         			;Compare the result to the value #$00.
        beq     +            			;If it's equal to #$00, branch to the next line.
        lda     L45FE        			;Load the value at address L45FE into the accumulator.
        beq     +            			;If it's equal to #$00, branch to the next line.
        jsr     LC4FB        			;Call a subroutine at a label called LC4FB.
        jmp     +            			;Jump to the next line.
        .byte   $ea          			;Undocumented instruction.
        .byte   $7b          			;Undocumented instruction.
        .byte   $2d          			;Undocumented instruction.
_L2D7A  .byte   $00          			;Initialize a variable called _L2D7A with the value #$00.

+       lda     Var_GameOverFlag        ;Load the value at address Var_GameOverFlag into the accumulator.
        cmp     #$01         			;Compare it to the value #$01.
        beq     +            			;If it's equal to #$01, branch to the next line.
        jmp     L2EB3        			;Otherwise, jump to a label called L2EB3.

+       jsr     Sub_5D98     			; Call a subroutine at a label called Sub_5D98.
        jmp     Jump_5DA9    			; Jump to a label called Jump_5DA9.

        .byte   $ea          			; Undocumented instruction.
        .byte   $ea          			; Undocumented instruction.

L2D8D   sta     SpritePointer1 			;Store the accumulator value into a variable called SpritePointer1.
        lda     #$00           			;Load the value #$00 into the accumulator.
        sta     LC53C+8        			;Store it in a memory address called LC53C+8.
        rts                    			;Return from the subroutine.


        .byte   $ea

                                                ;*****************************
                                                ;*      Main menu loop       *
                                                ;*****************************
MainMenuLoop
        lda     InputPortA                      ; Load Joystick input into the accumulator (A). At the start screen, the value will be 7A.
        and     #$10                            ; Isolate the 4th bit, which checks if the fire button is pressed.
        bne     Menu_FireNotPressed             ; Branch to Menu_FireNotPressed if the fire button is not pressed.
        beq     Menu_FirePressed                ; Branch to Menu_FirePressed if the fire button is pressed.

ThisRunsAfterDeath
        lda     #$00                            ; Set the accumulator (A) to #00.
        sta     SpriteEnableRegister            ; Disable all sprites by storing #00 to the SpriteEnableRegister.
        lda     L45EE                           ; Load A with the value at address L45EE, which is #01.
        jsr     L2CF3                           ; Call subroutine at L2CF3. It appears to be abandoned code.
        lda     #$ff                            ; Set the accumulator (A) to #ff.
        sta     LCF65                           ; Store #ff at address LCF65.
        sta     LCF66                           ; Store #ff at address LCF66.
        jsr     TimeWastingLoop                 ; Call a subroutine that performs a time-wasting loop.

Menu_FireNotPressed
        lda     LCF7F                           ; Load A with the value at address LCF7F.
        cmp     #$00                            ; Compare the value in the accumulator (A) with #00.
        beq     ResetToMenuScreen               ; If the value at LCF7F is equal to #00, branch to ResetToMenuScreen.
        jmp     Sub_SetInterruptsAndMem         ; Jump to the Sub_SetInterruptsAndMem subroutine, though it's unlikely to be triggered.

ResetToMenuScreen
        jsr     Sub_ResetToMenu                 ; Call the subroutine to reset the menu screen.
        lda     Var_KeyboardInput               ; Load A with the value of Var_KeyboardInput, which checks for keyboard input received.
        cmp     #$40                            ; Compare the value in the accumulator (A) with #40 (No keyboard input).
        beq     MainMenuLoop                    ; If there's no joystick or keyboard input received, loop back to the main menu.

Menu_FirePressed
        lda     Adr_BorderColor                 ; Load A with the current border color value (At menu screen, the value is #f0).
        and     #$0f                            ; Perform an AND operation on the accumulator (A) with #0f. This will result in #00 for the menu screen border color.
        beq     +                               ; If the result is #00, jump to address $2dd3.
        jsr     CheckSetHighScore               ; Call the subroutine to check and set the high score.
+       jmp     JUMP_c646                       ; Jump to address JUMP_c646.


                                                ;*****************************
                                                ;* Main menu loop end        *
                                                ;*****************************
        .fill   33,$00
		.fill 	3,$ea

L2DFA   jsr     L75A7
        jmp     L2CE4

L2E00   .byte   $60
		.fill 	97, $ea

L2E62
; Load value from memory address L45ED into accumulator A, and store it in memory address LCF7C
        lda     L45ED       			; Load value from memory address L45ED into accumulator A
        sta     LCF7C       			; Store accumulator A into memory address LCF7C

; Load value #00 into accumulator A, and store it in memory address Var_GameOverFlag
        lda     #$00      				; Load value #00 into accumulator A
        sta     Var_GameOverFlag       	; Store accumulator A into memory address Var_GameOverFlag

; Load value from memory address L450E into accumulator A, and jump to subroutine L2E8B
        lda     L450E       			; Load value from memory address L450E into accumulator A
        jmp     L2E8B       			; Jump to subroutine L2E8B



        .byte   $ea,$ad,$8d,$02,$29,$04,$f0,$05,$a9,$ff,$8d,$7f,$cf,$4c
L2E81   .byte   $01
        .byte   $60,$03,$4c,$00,$2e
L2E87   .byte   $4c
        .byte   $31,$ea,$ea

L2E8B
        lda     L45EF                           ; Load value from memory address L45EF into accumulator A
        jsr     L2CF3                           ; Jump to subroutine L2CF3
        jsr     L2F4D                           ; Jump to subroutine L2F4D

; Load value from memory address Const_SprDoubleWidth into accumulator A, and store it in memory address $d01b
        lda     Const_SprDoubleWidth            ; Load value from memory address Const_SprDoubleWidth into accumulator A
        sta     $d01b                           ; Store accumulator A into memory address $d01b

; Load value from memory address L450E into accumulator A, and return from subroutine
        lda     L450E                           ; Load value from memory address L450E into accumulator A
        rts                                     ; Return from subroutine


        .byte   $ea,$ea,$ad,$01,$d0,$c9,$b0,$d0,$0c,$ad,$15,$d0,$ee,$01,$d0,$ea
        .byte   $ea,$ea,$8d,$15,$d0

L2EB3   jmp     LCA27

        .byte   $ea

L2EB7   lda     Var_BinaryEnemyNum,x 		; Load the value at address Var_BinaryEnemyNum+x into the accumulator.
        and     SpriteEnableRegister 		; Perform a bitwise AND operation with the value of a variable called SpriteEnableRegister.
        cmp     #$00       			; Compare the result to the value #$00.
        beq     L2EC4      			; If it's equal to #$00, branch to a label called L2EC4.
        jmp     L2D52      			; Otherwise, jump to a label called L2D52.


L2EC4   inx          				; Increment the value in the X register.
        cpx     #$05 				; Compare it to the value #$05.
        beq     _L2ECC 				; If it's equal to #$05, branch to a label called _L2ECC.
        jmp     L2D4D 				; Otherwise, jump to a label called L2D4D.


_L2ECC  jmp     L2C19

        .byte   $ea,$a9,$00,$8d,$84,$03,$a9,$01,$8d,$81,$cf,$60,$a9,$00,$8d,$15
        .byte   $d0,$4c,$94,$c6

L2EE3   lda     L45FE
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        jmp     JUMP_c646

        .byte   $a9,$60,$8d,$94,$c6,$20,$cd,$c4,$a9,$ad,$8d,$94,$c6,$a9,$1c,$8d
        .byte   $18,$d0,$60,$ea

Sub_2F00
        sta     SpriteXMSBRegister
        lda     #$00				; A = #00
        sta     Adr_Voice3Control
        ldx     #$00
If_2F0A lda     L45B3,x
        sta     $d40e,x
        inx
        cpx     #$07
        bne     If_2F0A
        rts

        .byte   $9d,$fa,$07,$a9,$00,$8d,$ff,$ff,$8a,$48,$bd,$6d,$cf,$85,$fb,$a9
        .byte   $45,$85,$fc,$a0,$00,$b1,$fb,$99,$ff,$ff,$c8,$c0,$07,$d0,$f6,$68
        .byte   $aa,$60

L2F38   sta     $d029,x
        lda     L574A+20,x
        sta     Low_tempvar
        lda     LCF24,x
        sta     High_tempvar
        ldy     #$00
Sub_2F47
        lda     (Low_tempvar),y
        sta     LCF15,x
        rts

L2F4D   jsr     Sub_SIDSetup
        rts

        .fill   32,$ea
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$60,$a9,$00,$8d,$ff,$ff,$bd
        .byte   $6d,$cf,$85,$fb,$a9,$45,$85,$fc,$a0,$00,$b1,$fb,$99,$ff,$ff,$c8
        .byte   $c0,$07,$d0,$f6,$ad,$5e,$cf,$49,$ff,$2d,$15,$d0,$8d,$15,$d0,$ae
        .byte   $5f,$cf,$20,$6e,$ce,$60,$a9,$00,$8d,$ff,$ff,$20,$80,$ca,$4c,$d0
        .byte   $2e

Sub_StartEnemyUpdate
        inc     LCF75      			; Increment $cfb2
        lda     LCF75      			; A = $cfb2
        cmp     #$ff       			; Check if $cfb2 is up to 255 loops
        beq     Sub_EnemyPositionLoop 		; Branch if looped through 254 times
        rts                			; Return from subroutine (Back to $ca57)

                                                ;***************************************
                                                ;*        Enemy positioning loop       *
                                                ;***************************************
Sub_EnemyPositionLoop
        lda     #$00                            ; Clear A register
        sta     LCF75                      	; Initialize LCF75 to 0
        ldx     #$00                            ; Initialize loop index X to 0 (Enemy index)
Loop_NextEnemy
                                                ; Check if the enemy is visible. If so, skip to next enemy.
	lda     Var_BinaryEnemyNum,x            ; Load binary enemy number at index X
        and     SpriteEnableRegister            ; AND with SpriteEnableRegister to check if the enemy is visible
        cmp     #$00                            ; Compare the result to 0
        bne     NextEnemy                  	; If enemy is visible, skip to NextEnemy
		
		                                ; Load the value at LCF76+the loop index. If the value is zero, skip to next enemy.
        lda     LCF76,x                         ; Load LCF76 value at index X
        cmp     #$00                            ; Compare the value to 0
        beq     NextEnemy                  	; If equal to 0, skip to NextEnemy

        txa                                     ; Transfer X (Current index) to A
        pha                                     ; Push accumulator to the stack
        jsr     LC9F1                           ; Call subroutine LC9F1
        pla                                     ; Pull accumulator from the stack
        tax                                     ; Transfer A back to X

        tya                                     ; Transfer Y to A
        and     #$7f                            ; AND A with $7F (masking upper bit)
        cmp     L45E2,x                         ; Compare A to the value at L45E2 indexed by X
        bpl     NextEnemy                  	; If result is positive, skip to NextEnemy

        txa                                     ; Transfer X (Enemy index) to A
        jsr     Sub_UpdateEnemySprites          ; Call subroutine to update enemy sprites using A as the enemy index
        dec     LCF76,x                         ; Decrement the value at LCF76 indexed by X

        lda     #$01                            ; Load 1 into A
        sta     LCF29,x                         ; Store A (1) at LCF29 indexed by X
        lda     #$00                            ; Clear A register
        sta     LCF1A,x                         ; Initialize LCF1A at index X to 0
NextEnemy
        inx                                     ; Increment loop index X
        cpx     #$05                            ; Check if X reached the maximum enemy index (5)
        bne     Loop_NextEnemy                  ; If not at the end of the enemy index, continue the loop
        rts                                     ; Return from subroutine


        .include "Charsets/charactersets.asm"
        .include "Sprites/sprites.asm"
        .include "Data/data.asm"
		
InputNotJumping
        lda     L45FF      			; A = $45ff (Always seems to be #01)
        beq     _rts   				; Branch if equal zero
        dec     Temp_534c  			; Decrease #534c
        beq     If_535D    			; Branch if equal zero
_rts	rts

        .fill   2,$ea

If_535D lda     Temp_0c   		        ; A = $534b (Always seems to be #0c)
        sta     Temp_534c  		        ; $534c = $53cb
        lda     Sprite0YPos 		        ; A = SpriteMSBYPosition
        sta     Temp_SpriteMSBYPosition 	; Temp_SpriteMSBYPosition = SpriteMSBYPosition
        lda     #$01       			; 01 (Down) is passed to Sub_PlayerPosition as direction of player.
        ldx     #$00       			; X = #00
        jsr     Sub_PlayerPosition              ; This will work out player position and suitable actions (E.g. mushroom, etc)
        lda     Sprite0YPos
        cmp     Temp_SpriteMSBYPosition
        bne     If_537E
        jmp     L54A0

        .fill   3,$ea

If_537E jsr     L54AC
        inc     Var_Falling                     ; Counts up when falling. Can be short when on a rope.
        lda     #$00			        ; A = #00
        sta     Var_RopeFall                    
        sta     Var_SlidingOnRope
        rts

        .byte   $ea

L538E   inc     Var_SomethingRandom             ; Increment Var_SomethingRandom by 1
        lda     Var_Jumping                     ; Load the value of Var_Jumping into the accumulator (A). This variable holds the jump input state (#01 for jumping, #00 for not jumping).
        beq     InputNotJumping                 ; If the value in the accumulator (A) is zero (not jumping), branch to InputNotJumping.
        dec     Var_JumpAscDescTimer            ; Decrement the value at memory address Var_JumpAscDescTimer by 1.
        beq     If_539E                         ; If Var_JumpAscDescTimer = #00, begin to calculate direction of player and update position.
        rts                                     ; Return from the subroutine.

        .fill   2,$ea

If_539E jsr     Sub_SetTempSprite0YPos          ; Set Temp_Sprite0YPos to the Sprite 0 Y Position and load A with Var_FallingStanding (#01 Falling or Standing / #00 Jumping).
        bne     BeginFall 		        ; Branch if Var_FallingStanding not #00 (Beginning to fall).
        lda     #$00			        ; 00 (Up) is passed to Sub_PlayerPosition as direction of player.
        jsr     Sub_PlayerPosition              ; This will work out player position and suitable actions (E.g. mushroom, etc)
        jsr     Sub_UpdateYPosJumping
        ldx     Var_JumpAscDesc                 ; Load the value Var_JumpAscDesc. This counts up to the maximum of #18.
        cpx     #$18       		        ; Maximum jump height. Default is #18.
        bne     If_53B5                         ; Branch if Var_JumpAscDesc != #18.
        jmp     Jump_53BE

If_53B5 lda     L544A,x
        sta     Var_JumpAscDescTimer
        jmp     L54FC

Jump_53BE
        lda     #$01
        sta     Var_FallingStanding             ; (#01 Falling or Standing / #00 Jumping)
        rts

        .fill   2,$ea

BeginFall
        lda     #$01                            ; Load accumulator with value 1
        jsr     L5467                           ; Call subroutine at address L5467
        dec     Var_JumpAscDesc                 ; Decrement memory location Var_JumpAscDesc
        ldx     Var_JumpAscDesc                 ; Load X register with value in Var_JumpAscDesc
        cpx     #$00                            ; Compare X register to 0
        bne     If_53D8                         ; Branch to If_53D8 if not equal (branch if BeginFall flag is set)
        jmp     Jump_53E2                       ; Otherwise, jump to address Jump_53E2 (branch if BeginFall flag is not set)


If_53D8 lda     L544A,x
        sta     Var_JumpAscDescTimer
        jmp     L5518

        .byte   $ea

Jump_53E2
        lda     #$00				; A = #00
        sta     Var_Jumping 			; Reset Var_Jumping to #00 (#01 jumping / #00 not jumping)
        lda     #$18                            ; Reset Var_Falling to #18
        sta     Var_Falling
        rts

        .fill   2,$ea

L53EF   lda     #$01
        sta     Var_RopeFall
        sta     Var_SlidingOnRope
        lda     Var_Falling
        cmp     L457A
        bpl     +
+       nop
        nop									; No operation.
        nop									; No operation.
        nop									; No operation.
        nop									; No operation.
        nop									; No operation.
        nop									; No operation.
        lda     #$00						; A = #00
        sta     Var_Falling
        rts

        .byte   $ea,$a9,$00,$8d,$4e,$53,$20,$a7,$2f,$60,$ea,$ea

L5418   lda     Var_Falling			; Counts up when falling. Can be short when on a rope.
        bne     +    				; Branch if above is not #00
        lda     #$01       			; A = #01
        sta     Var_Jumping 			; Var_Jumping = #01 (#01 jumping / #00 not jumping)
        jmp     LC1B4
+ 	jmp     CheckLeftRightInput

        .fill   2,$ea

Temp_Sprite0YPos
        .byte   $e3

Sub_SetTempSprite0YPos                  ; Set Temp_Sprite0YPos to the Sprite 0 Y Position and load A with Var_FallingStanding (#01 Falling or Standing / #00 Jumping)
        lda     Sprite0YPos
        sta     Temp_Sprite0YPos
        lda     Var_FallingStanding 	; #01 Not jumping / #00 Jumping
        rts

        .fill   2,$ea

Sub_UpdateYPosJumping   
        lda     Sprite0YPos          	; Load the Y position of Sprite0 into the accumulator (A)
        cmp     Temp_Sprite0YPos     	; Compare the current Y position with the temporary Y position of Sprite0
        bne     +              		; Branch if the positions are not equal (i.e., Sprite0 has moved vertically)
        lda     #$01                 	; Load the value #01 into the accumulator (A)
        sta     Var_FallingStanding     ; Store the value #01 into Var_FallingStanding, indicating that the sprite is now falling.
+ 	inc     Var_JumpAscDesc         ; Increment the value at memory location Var_JumpAscDesc by 1
        rts                          	; Return from subroutine


        .fill   2, $ea        
L544A   .byte   $05
        .byte   $05,$06,$06,$07,$08,$09,$09,$0a,$0b,$0c,$0e,$0f,$10,$12,$14,$16
        .byte   $18,$1a,$1c,$1f,$22,$25,$29,$2d,$ea,$ea,$ea
L5466   .byte   $e3

L5467   lda     Sprite0YPos                     ; Load accumulator with value in Sprite0YPos
        sta     L5466                           ; Store accumulator in memory location L5466
        lda     #$01                            ; 01 (Down) is passed to Sub_PlayerPosition as direction of player.
        jsr     Sub_PlayerPosition              ; This will work out player position and suitable actions (E.g. mushroom, etc)
        lda     L5466                           ; Load accumulator with value in L5466
        cmp     Sprite0YPos                     ; Compare accumulator to value in Sprite0YPos
        beq     +                               ; If they are equal, branch to the next line
        rts                                     ; Return from the subroutine


+		lda     #$00
        sta     Var_Jumping 				;#01 jumping / #00 not jumping
        rts

        .fill   2,$ea

Jump_JumpSound
        lda     #$00						; A = #00
        sta     Adr_Voice3Control
        lda     #$0d
        sta     Adr_Voice3AttackDecay
        lda     #$00						; A = #00
        sta     FilterCutoffFrequencyLow-1
        lda     L45B7
        sta     Adr_Voice3Control
        lda     #$00						; A = #00
        nop									; No operation.	
        nop									; No operation.	
        jmp     L54EA

L549F   .byte   $00

L54A0   lda     #$00
        sta     Adr_Voice3Control
        sta     L549F
        jmp     L53EF

        .byte   $ea

L54AC   lda     L549F
        beq     +
        .byte   $4c
+		cmp     ($54,x)
        lda     #$01
        sta     L549F
        jsr     Jump_JumpSound
        jmp     L54DC

L54BF   .byte   $73,$80

L54C1   lda     L54BF+1
        sec
        sbc     #$80
        sta     L54BF+1
        sta     $d40e
        bcs     If_54D2
        dec     L54BF
If_54D2 lda     L54BF
        sta     $d40f
        rts

        .fill   3,$ea

L54DC   lda     #$80
        sta     L54BF
        sta     L54BF+1
        rts

L54E5   .byte   $04,$05,$04,$08,$08

L54EA   lda     #$00
        sta     L54F7+2
        lda     #$08
        sta     L54F7+3
        jmp     CheckLeftRightInput

L54F7   .byte   $ea,$ea,$00,$08,$ea

L54FC   lda     L54F7+2
        sec
        sbc     #$05
        sta     L54F7+2
        sta     $d40e
        bcc     If_550D
        inc     L54F7+3
If_550D lda     L54F7+3
        sta     $d40f
        rts

        .fill   4,$ea

L5518   lda     L54F7+2
        clc
        adc     #$05
        sta     L54F7+2
        sta     $d40e
        bcs     If_5526
If_5526 dec     L54F7+3
        lda     L54F7+3
        sta     $d40f
        rts

        .byte   $ea,$ea,$ad,$16,$45,$8d,$00,$d0,$ad,$17,$45,$8d,$01,$d0,$a9,$03
        .byte   $8d,$15,$d0,$ad,$18,$45,$8d,$10,$d0,$ad,$f4,$45,$29,$01,$8d,$1c
        .byte   $d0,$ad,$10,$45,$8d,$27,$d0,$ea,$23,$c0,$c1,$a2,$00,$ad,$ed,$c1
        .byte   $c9,$01,$d0,$05,$a9,$03,$20,$cf,$55,$ad,$ed,$c1,$c9,$ff,$d0,$05
        .byte   $a9,$02,$20,$cf,$55,$ad,$ec,$c1,$c9,$01,$d0,$05,$a9,$01,$20,$cf
        .byte   $55,$ad,$ec,$c1,$c9,$ff,$d0,$05,$a9,$00,$20,$cf,$55,$ad,$ee,$c1
        .byte   $d0,$0e,$a9,$20,$8d,$65,$cf,$8d,$66,$cf,$20,$e7,$c6,$4c,$58,$55
        .byte   $ad,$00,$d0,$8d,$16,$45,$ad,$01,$d0,$8d,$17,$45,$ad,$10,$d0,$29
        .byte   $01,$8d,$18,$45,$ad,$f8,$07,$8d,$ec,$45,$8d,$47,$08,$a9,$00,$8d
        .byte   $15,$d0,$a9,$15,$8d,$18,$d0,$a9,$00,$85,$c6,$60,$ea,$ea,$02,$8d
        .byte   $ce,$55,$20,$00,$c9,$ad,$ce,$55,$0a,$18,$69,$d8,$8d,$f8,$07,$60
        .byte   $00,$00,$ea,$a9,$93,$20,$d2,$ff,$a2,$88,$a0,$c1,$20,$80,$2a,$a2
        .byte   $8e,$a0,$c1,$20,$80,$2a,$a2,$94,$a0,$c1,$20,$80,$2a,$60,$ea,$ea
        .byte   $a2,$00,$a9,$ff,$9d,$80,$03,$e8,$e0,$40,$d0,$f6,$a9,$0e,$8d,$f8
        .byte   $07,$8d,$f9,$07,$a9,$2c,$8d,$00,$d0,$8d,$02,$d0,$a9,$70,$8d,$01
        .byte   $d0,$a9,$9a,$8d,$03,$d0,$a9,$0f,$8d,$27,$d0,$8d,$28,$d0,$a9,$0b
        .byte   $8d,$15,$d0,$8d,$10,$d0,$a9,$03,$8d,$1b,$d0,$a2,$00,$a9,$1e,$8d
        .byte   $65,$cf,$8d,$66,$cf,$20,$e7,$c6,$ee,$07,$d0,$e8,$e0,$15,$d0,$ed
        .byte   $69

L5651   lda     L45FF
        beq     If_565E
        lda     #$00						; A = #00
        sta     Var_4500
        jmp     L570A

If_565E jmp     Jump_5716

        .byte   $60

Sub_VerticalMovingEnemies
        sta     Var_CurrentEnemy
        tax                					;Transfer A to X (Current enemy)
        lda     #$01      					;A = #01
        sta     LCF33,x    					;$cf33,x = #01 ($cf33, current enemy)
        txa                					;Transfer X to A
        rts

L566D   ldx     #$00
- 		lda     L45E7,x
        sta     LCF76,x
        inx
        cpx     #$05
        bne     -
        lda     L45EC
        sta     SpritePointer0
        rts

L5681   ldx     #$00
L5683   lda     L3408+224,x
        cmp     Var_Sprite3Speed,x
        beq     If_56AC
        clc
        lda     Var_Sprite3Speed,x
        lsr     a
        sta     Var_Sprite3Speed,x
        bcc     If_569C
        lda     #$01
        sta     Var_Sprite3Speed,x
        bcs     If_56AC

If_569C lda     L54E5,x
        lsr     a
        sta     L54E5,x
        cmp     #$01
        bne     If_56AC
        lda     #$02
        sta     L54E5,x
If_56AC inx
        cpx     #$05
        bne     L5683
        rts

L56B2
    ; Store value from A register to Var_Sprite3Speed indexed by X
    sta     Var_Sprite3Speed,x    ; Store A register value into Var_Sprite3Speed indexed by X

    ; Load value from L4548 indexed by X and store to L54E5 indexed by X
    lda     L4548,x               ; Load value from L4548 indexed by X into A register
    sta     L54E5,x               ; Store A register value into L54E5 indexed by X

    ; Return from subroutine
    rts                            ; Return from subroutine


Sub_56BC
        jsr     L566D
        rts

        .byte   $00,$84,$50,$84,$00,$04,$60,$60,$60,$60,$60,$60,$60,$60,$28,$46
        .byte   $f0,$49,$28,$d8,$28,$41,$f0,$44,$28,$04,$a2,$d9,$b5,$00,$09,$80
        .byte   $95,$00,$e8,$e0,$f2,$d0,$f5,$60,$a2,$00,$bd,$0d,$cf,$aa,$bd,$19
        .byte   $45,$8d,$00,$d0,$bd,$1a,$45,$8d,$01,$d0,$a9,$00,$8d,$10,$d0,$bd
        .byte   $1b,$45,$f0,$05,$a9,$01,$8d,$10,$d0,$60

L570A   sta     Var_4501
        lda     #$2c
        sta     L2A0B+1
        jsr     Sub_2F47
        rts

Jump_5716
        jsr     Sub_2F47
        lda     #$30
        sta     L2A0B+1
        rts

        .byte   $a2,$00,$a9,$00,$9d,$00,$30,$9d,$00,$31,$9d,$00,$32,$9d,$00,$33
        .byte   $e8,$d0,$f1,$60

Sub_5733
        nop									; No operation.
        nop									; No operation.
        nop									; No operation.
        ldx     #$00						; A = #00
- 		lda     L574A,x 					; Pointless code
        lda     $07ca,x 					; Pointless code
        lda     $d805 						; Pointless code
        lda     $dbca,x 					; Pointless code
        inx									; Increase X for loop
        cpx     #$13						; Check if loop is up to #13
        bne     - 							; Continue if loop not complete.
        rts									; Return from subroutine.

L574A   .byte   $90,$92,$85,$93,$93,$a0,$83,$94,$92,$8c,$a0,$86,$8f,$92,$a0,$8d
        .byte   $85,$8e,$95,$ea,$1e,$20,$1e,$1e,$22,$ea,$ea,$ea,$ea,$ea

L5768   jmp     L7280

L576B   jsr     Sub_WaitForCurrentRaster 	; JSR from $5d65
        nop									; No operation.
        nop									; No operation.
        jsr     SetupSpritePositions
        lda     SpriteEnableRegister
        ora     #$03
        sta     SpriteEnableRegister
        lda     Var_BorderColour
        beq     If_5783    					; Have not seen this executed yet.
        jmp     Jump_57BD

If_5783 lda     #$01
        sta     Var_BorderColour
        lda     #$e8
        sta     L582C+1
        lda     #$ec
        sta     L5831+1
        lda     #$f0
        sta     Jump_58A8+1
        lda     #$f1
        sta     L5847+1
        lda     #$f6
        sta     L584B+1
        lda     #$f2
        sta     L5875+1
        lda     #$f6
        sta     If_587A+1
        lda     #$f1
        sta     If_58a3+1
        lda     #$f0
        sta     L589A+1
        lda     #$0a
        sta     Adr_BorderColor
        jmp     Jump_5844

Jump_57BD
        lda     #$00						; A = #00
        sta     Var_BorderColour
        lda     #$d8
        sta     L582C+1
        lda     #$dc
        sta     L5831+1
        lda     #$e0
        sta     Jump_58A8+1
        lda     #$e1
        sta     L5847+1
        lda     #$e6
        sta     L584B+1
        lda     #$e2
        sta     L5875+1
        lda     #$e6
        sta     If_587A+1
        lda     #$e1
        sta     If_58a3+1
        lda     #$e0
        sta     L589A+1
        lda     #$06
        sta     Adr_BorderColor
        jmp     Jump_5844

        .fill   9,$ea

L5800   inc     Var_SomethingRandom 		; Increase Var_SomethingRandom
        jsr     Sub_RedHealthBarZone
        jsr     Sub_HealthBarUpdates
        nop									; No operation.
        nop									; No operation.	
        lda     Var_5a00
        cmp     #$00
        beq     +
        lda     Var_JumpDirection 			; Never taken (Left = #ff / Right = #01 / Up = #00)
        sta     Var_LeftRightInput 			; Never taken
+ 		lda     Var_Jumping 				; #01 jumping / #00 not jumping
        cmp     #$00       					; Compare Var_Jumping
        bne     If_5836    					; Branch if jumping
        lda     #$a9
        sta     Sub_GetInputs
        lda     #$ad
        sta     Jump_5980
        jsr     Sub_CheckSlidingOnRope
L582C   lda     #$e8
        sta     LC79B+1
L5831   lda     #$ec
        sta     LC7C5+1
If_5836 jmp     L59E6

        .fill   11,$ea

Jump_5844
        lda     SpritePointer0               ; Load the value at memory location SpritePointer0 into the accumulator.
L5847   cmp     #$f1                         ; Compare the value in the accumulator with the value #$f1.
        bne     Sub_CheckXMovement           ; If they are not equal, branch to Sub_CheckXMovement.
L584B   lda     #$f6                         ; Load the value #$f6 into the accumulator.
        sta     SpritePointer0               ; Store the value in the accumulator into memory location SpritePointer0.
Sub_CheckXMovement
        ldx     Sprite0XPosition             ; Load the value at memory location Sprite0XPosition into the X register.
        lda     Var_JumpDirection+1           ; Load the value at memory location Var_JumpDirection+1 into the accumulator.
        stx     Var_JumpDirection+1           ; Store the value in the X register into memory location Var_JumpDirection+1.
        cmp     Var_JumpDirection+1           ; Compare the value in the accumulator with the value in memory location Var_JumpDirection+1.
        beq     If_5864                      ; If they are equal, branch to If_5864.
        lda     #$00                         ; Load the value #$00 into the accumulator.
        sta     Var_JumpDirection+2           ; Store the value in the accumulator into memory location Var_JumpDirection+2.
RTS_5863
        rts

If_5864 inc     Var_JumpDirection+2           ; Increment the value at memory location Var_JumpDirection+2.
        lda     Var_JumpDirection+2           ; Load the value at memory location Var_JumpDirection+2 into the accumulator.
        cmp     #$90                         ; Compare the value in the accumulator with the value #$90.
        bne     RTS_5863                     ; If they are not equal, return from the subroutine with RTS.
        lda     SpritePointer0               ; Load the value at memory location SpritePointer0 into the accumulator.
        and     #$04                         ; AND the value in the accumulator with the value #$04.
        bne     If_587A                      ; If the result is nonzero, branch to If_587A.
L5875   lda     #$f2                         ; Load the value #$f2 into the accumulator.
        jmp     JMP_UpdateLRSprite
If_587A lda     #$f6                         ; Load the value #$f6 into the accumulator.
JMP_UpdateLRSprite
        sta     SpritePointer0               ; Store the value in the accumulator into memory location SpritePointer0.
        rts


Sub_5880
        lda     #$00				; A = #00
        sta     Var_5a00   			; Var_5a00 = #00
        lda     Var_LeftRightInput 		; Left = #ff / Right = #01
        sta     Var_JumpDirection 		; Left = #ff / Right = #01 / Up = #00
        lda     #$60       			; A = #60
        sta     Sub_GetInputs 			; $c84d = #60
        sta     Jump_5980  			; $5980 = #60
        lda     SpritePointer0 			; Load SpritePointer0
        and     #$04       			; Isolate 4th bit
        bne     If_58a3    			; Branch if facing left
L589A   lda     #$f0       			; A = #f0
        nop					; No operation.
        sta     SpritePointer0 			; SprintPointer0 = #f0
        jmp     Jump_58A8

If_58a3 lda     #$f1       			; A = #f1
        sta     SpritePointer0 			; SpritePointer0 = #f1
Jump_58A8
        lda     #$f0       			; A = #f0
        sta     LC79B+1   			; #c79b = #f0
        sta     LC7C5+1   			; #c7c5 = #f0
        jmp     Jump_JumpSound

Sub_CheckSlidingOnRope
        lda     Var_SlidingOnRope
        bne     If_58bb   			; Branch if not sliding down rope
        rts

        .fill   2,$ea

If_58bb ldx     #$00       			; X = #00
        lda     InputPortA 			; A = $dc00
        and     #$10       			; Isolate 5th bit. (Port 2 joystick fire pressed)
        bne     +   				; Branch if fire not received
        nop					; No operation.
        ldx     #$01       			; X = 01
+ 		lda     Var_KeyboardInput 	; A = $c5
        cmp     #$37     			; Compare to #37 (Keyboard fire pressed).
        bne     +    				; Branch if fire not received
        ldx     #$01      			; X = 01
+ 		cpx     #$00       		; Compare X to X = #01
        bne     Sub_FireButtonEvent 		; Branch if fire received
        lda     #$00				; A = #00
        sta     Var_StartGame 			; Reset Var_StartGame
        jmp     Jump_5844

Sub_FireButtonEvent
        lda     Var_StartGame   		; Load the value at memory location Var_StartGame into the accumulator.
        beq     +              			; If the value in the accumulator is equal to zero, skip the next instruction (i.e., fall through to the following instruction).
        jmp     Jump_5844      			; Otherwise, jump to the address indicated by the label Jump_5844.
+       jmp     L5768          			; If the previous instruction was skipped (i.e., the value in Var_StartGame was zero), jump to the address indicated by the label L5768.


SetupSpritePositions
        lda     #$01       			;JSR from $5770
        sta     Var_StartGame 			;Store #01 to $5A06
        ldx     Sprite0XPosition 		;Load X with Sprite0_X_Position
        lda     Sprite1XPositionRegister 	;Load A with Sprite1_X_Position
        sta     Sprite0XPosition 		;Update Sprite0_X_Position with Sprite1_X_Position
        stx     Sprite1XPositionRegister 	;Update Sprite1_X_Position with Sprite0_X_Position
        ldx     Sprite0YPos 			;Load A with Sprite0_Y_Position
        jmp     ContSetupSpritePositions

        .byte   $8d,$f8,$07

ResetGirl
        jsr     Sub_SetRandomVariables
        lda     #$e0
        sta     Sprite1XPositionRegister 	;Set girl sprite position
        sta     Sprite1YPosition 		;Set girl sprite position
        lda     #$06       			;Value will be used to set border to blue
        nop					; No operation.
        sta     Adr_BorderColor 		;Set border colour to blue
        lda     #$ee
        sta     SpritePointer1 			;Update sprite pointer for girl
        rts                			;Return from subroutine

        .fill   2,$ea

ContSetupSpritePositions
        lda     Sprite1YPosition 		;Load A with Sprite1_Y_Position
        sta     Sprite0YPos 			;Update Sprite0_Y_Position with Sprite1_Y_Position
        stx     Sprite1YPosition 		;Update Sprite1_Y_Position with Sprite0_Y_Position
        lda     SpriteXMSBRegister
        and     #$01       			;Isolate first bit in SpriteXMSBRegister
        tax                			;Store boy X-MSB flag in X
        lda     SpriteXMSBRegister
        and     #$02       			;Isolate second bit in SpriteXMSBRegister
        tay                			;Store girl X-MSB flag in Y
        lda     SpriteXMSBRegister
        and     #$fc       			;Get remaining bits (Exlcuding 1 and 2)
        sta     Temp_SpiteXMSBReg 		;Store enemy X-MSB values
        cpy     #$00       			;Compare girl X-MSB values to #00
        beq     + 				;Branch if girl X-MSB flag not set
        lda     #$01       			;Load A with #01
        ora     Temp_SpiteXMSBReg 		;Turn on first byte for MSB-X register
        sta     Temp_SpiteXMSBReg 		;Store girl into SpriteXMSBReg
+       cpx     #$00       			;Branch if girl X-MSB flag not set
        beq     +
        lda     #$02       			;Load A with #01
        ora     Temp_SpiteXMSBReg 		;Turn on second byte for MSB-X register
        sta     Temp_SpiteXMSBReg 		;Store bpy into SpriteXMSBReg
+ 	lda     Temp_SpiteXMSBReg
        sta     SpriteXMSBRegister 		;Update SpriteXMSBRegister
        ldx     SpritePointer0 			;Set X with SpritePointer0 (Boy)
        lda     SpritePointer1 			;Set A with SpritePointer1 (Girl)
        sta     SpritePointer0 			;Store SpritePointer1 (Girl) to SpritePointer0 (Boy)
        stx     SpritePointer1 			;Store SpritePointer0 (Boy) to SpritePointer1 (Girl)
        rts                				;Return from subroutine ($5770)

Sub_RedHealthBarZone
        lda     $0430      			; Load top red health block
        cmp     #$a9       			; Check if no red health bar consumed
        beq     +    				; Branch if no red health bar consumed
        lda     #$80       			; A = #80
        sta     LCA18+1    			; $ca19 = #80. This is the value passed to an operation.
        lda     #$04       			; A = #04
        sta     Var_GoSlowRedZone 		; Var_GoSlowRedZone = #04. #02 Not slow / #04 Slow.
        rts					; Return from subroutine
+ 		lda     Var_GoSlowRedZone 	; Load Var_GoSlowRedZone
        cmp     #$04       			; Check if in Go-Slow mode (Red zone)
        beq     +				; Branch if in red zone.
        rts 					; Return from subroutine
+       jmp     Jump_5A88

        .fill   2,$ea

Jump_5980
        lda     SpritePointer0 			;A = SpritePointer0
        and     #$03       			;Isolate third bit
        cmp     #$03
        beq     +
        inc     SpritePointer0
        jmp     _rts
+ 		lda     SpritePointer0
        and     #$fc
        sta     SpritePointer0
_rts    rts

Sub_GetCurrentHealthBar
        ldx     #$ff       			;X = #ff
-   	inx                			;Increase X
        lda     Scr_HealthBar,x 		;A = $042e, x
        cmp     #$a9       			;Check if health bar is populated. Get the position where it ends.
        beq     -     				;Loop if equal zero
        rts

Sub_ReduceHealthBar
        jsr     Sub_GetCurrentHealthBar 	; Get the number position from $042e where the bar is blank
        lda     Scr_HealthBar,x 		; Get the number value of the bar block
        cmp     #$a1       			; Check if currently at empty position (Goes from #a9 to #a1)
        beq     Sub_UpdateHealthBar 		; Branch if at empty health bar position
        dec     Scr_HealthBar,x 		; Decrease current health bar block (Goes from #a9 to #a1)
        rts

        .fill   2,$ea

Sub_UpdateHealthBar
        cpx     #$00       			;Check if at the last health block
        beq     Jump_NoHealthLeft 		;Branch if at last healthbar block
        dex                			;Decrease X
        lda     #$a8       			;A = #a8
        sta     Scr_HealthBar,x 		;Store #a8 to current health bar position
        rts	

        .fill   2,$ea

Jump_NoHealthLeft
        jmp     Sub_NoHealthLeft

Sub_IncreaseHealthBlock
        jsr     Sub_GetCurrentHealthBar 	;Get current health bar block
        cpx     #$21       			;Check if at maximum health block
        beq     +	    			;Branch if already full health
        inc     Scr_HealthBar,x 		;Increase health bar block (a1 - a9)
        rts

        .fill   2,$ea

+		lda     #$0a       		; A = #0a
        sta     Counter_ScoreUpdate1 		; $cf5a = #0a
        lda     #$00				; A = #00
        sta     Counter_ScoreUpdate2 		; $cf5b = #00
        lda     #$11       			; A = #11
        sta     Counter_ScoreUpdate3 		; $cf5c = #11
        jsr     LCE42
        rts

        .fill   3,$ea

L59E6   lda     Var_Jumping 			; #01 jumping / #00 not jumping
        beq     +    				; Branch if not jumping
        dec     Var_JumpSkipDamage 		; Var_JumpSkipDamage will be set to #00 in the loop
        bne     _rts				; Branch if not equal zero
        lda     #$00				; A = #00
        sta     Var_JumpSkipDamage 		; Var_JumpSomething = #00
        jsr     Sub_ReduceHealthBar 		; Reduce health while jumping
_rts	rts

+ 		jmp     MoveHealthDec

        .fill   4,$ea
Var_5a00
        .byte   $00
Var_JumpDirection
        .byte   $01,$70,$c1,$ff,$00 		; Left = #ff / Right = #01 / Up = #00
Var_StartGame
        .fill   1,$00
Temp_SpiteXMSBReg
        .byte   $20
Var_BorderColour
        .byte   $01
Var_JumpSkipDamage
        .byte   $64
Var_MoveCounter1
        .byte   $96
Var_MoveCounter2
        .byte   $02,$12
Counter_HealthIncLoop2
        .byte   $00
        .byte   $10
        .byte   $01
Counter_HealthIncLoop
        .byte   $00
Var_DamageOccuring
        .fill   1,$00
        .byte   $12
Var_DamageCounter 
		.byte   $00
        .byte   $01
Var_MagicCrossesLeft
        .byte   $0a
Var_5a16
        .byte   $09,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

MoveHealthDec
        lda     Var_LeftRightInput 		; Left = #ff / Right = #01
        beq     _rts   				; Branch to RTS if no input
        dec     Var_MoveCounter1 		; Decrease first move counter. Uses 1023 loops before initiates Sub_ReduceHealthBar
        bne     _rts				; RTS if not #00
        lda     #$ff 				; A = #ff
        sta     Var_MoveCounter1		; Since Var_MoveCounter1 = #00, set to #ff
        dec     Var_MoveCounter2 		; Decrease Var_MoveCounter2
        bne     _rts 				; RTS if not #00
        lda     #$03 				; A = #03
        sta     Var_MoveCounter2 		; Since Var_MoveCounter2 = #00, set to #03
        jsr     Sub_ReduceHealthBar 		; Reduce health since 1023 loops have been done.
_rts    rts

        .byte   $ff,$ff,$ff,$f6

L5A41   jsr     L7659
        lda     Var_BorderColour
        bne     If_5A4F
        lda     #$06
        sta     Adr_BorderColor
        rts

If_5A4F lda     #$0a
        sta     Adr_BorderColor
        rts

        .fill   11,$00

L5A60   lda     #$02
        sta     Var_GoSlowRedZone
        lda     #$00				; A = #00
        sta     Var_RegMovingLeftRight
        jmp     Jump_ScreenSetup

        .fill   3,$00

Sub_NoHealthLeft 				; $5a70
        lda     #$01      			; A = #01
        sta     Var_GameOverFlag      		; Store #01 to Var_GameOverFlag
        lda     #$02       			; A = #02
        sta     Var_GoSlowRedZone 		; Store #02 to Var_GoSlowRedZone. #02 (Not slow).
        lda     #$00				; A = #00
        sta     Var_RegMovingLeftRight 		; Store #00 to $cf07
        lda     #$20       			; A = #20
        sta     LCA18+1    			; Store #20 to $ca19
        rts                			; Return from subroutine ($72bd)

        .fill   3,$ff

Jump_5A88
        lda     #$02       			;A = #02
        sta     Var_GoSlowRedZone 		;Var_GoSlowRedZone = #02 (Not slow)
        lda     #$00				; A = #00
        sta     Var_RegMovingLeftRight
        lda     #$20
        sta     LCA18+1
        rts

        .fill   2,$ea

L5A9A   cmp     #$4d       			;Check if current character is complete bridge
        bmi     _rts
        cpy     #$50
        beq     +
        jmp     PlayerMidAir
+ 		dec     Counter_HealthIncLoop2+2
        beq     If_UpdateBridge
_rts    rts

        .fill   2,$ea

If_UpdateBridge
        ldx     #$08
        stx     Counter_HealthIncLoop2+2
        nop					; No operation.
        cmp     #$53       			;Check if bridge block is #53
        bne     If_ErrodeBridge 		;Branch if not #53 (Gap)
        lda     #$a0       			;If bridge block is #53 then set to blank space
        sta     (Low_tempvar),y 		;Update bridge block
        rts

        .byte   $ea,$ea,$60

If_ErrodeBridge
        lda     (Low_tempvar),y 		;Load current value of bridge
        tax                			;Transfer A to X
        inx                			;Increase X
        txa                			;Transfer X to A
        sta     (Low_tempvar),y 		;Store updated value of bridge
        rts                			;Return

Sub_GetMushroom
        cmp     #$54                            ; Compare the value in the accumulator (A) with #$54 (check if the character is a health mushroom).
        bne     If_GetRedFlower                 ; Branch to If_GetRedFlower if the values are not equal (if the character is not a health mushroom).

        ldx     #$18                            ; X = #$18
        jsr     Sub_IncHealthIdx                ; Call the subroutine Sub_IncHealthIdx to handle increasing the health index when a health mushroom is collected.

        lda     #$a0                            ; A = #$a0 (Blank sprite)
        sta     (Low_tempvar),y                 ; Store the value of A (blank sprite) into the address pointed by (Low_tempvar),y to remove the mushroom.

        rts                                     ; Return from the subroutine.


If_GetRedFlower
        cmp     #$55                            ; Compare the value in the accumulator (A) with #$55 (check if the character is a poison red flower).
        bne     Sub_GetBasket                   ; Branch to subroutine Sub_GetBasket if the values are not equal (if the character is not a poison red flower).

        ldx     #$19                            ; X = #$19
        jsr     Update_DamageOccuring           ; Call the subroutine Update_DamageOccuring to handle damage from the poison red flower.

        lda     #$a0                            ; A = #$a0 (Blank sprite)
        sta     (Low_tempvar),y                 ; Store the value of A (blank sprite) into the address pointed by (Low_tempvar),y to remove the flower.

        rts                                     ; Return from the subroutine.


Sub_GetBasket
        cmp     #$56                            ; Compare the value in the accumulator (A) with #$56 (check if the character is a basket).
        bne     L5B57                  	        ; Branch to label L5B57 if the values are not equal (if the character is not a basket).

        lda     #$64                            ; A = #$64
        sta     Counter_ScoreUpdate1            ; Store the value of A into Counter_ScoreUpdate1.

        lda     #$00                            ; A = #00
        sta     Counter_ScoreUpdate2            ; Store the value of A into Counter_ScoreUpdate2.

        lda     #$11                            ; A = #$11
        sta     Counter_ScoreUpdate3            ; Store the value of A into Counter_ScoreUpdate3.

        jsr     LCE42                  	        ; Call the subroutine at label LCE42.

        lda     #$a0                            ; A = #$a0 (Blank sprite)
        sta     (Low_tempvar),y                 ; Store the value of A (blank sprite) into the address pointed by (Low_tempvar),y to remove the basket.

        rts                                     ; Return from the subroutine.


        .fill   2,$ea

Sub_HealthBarUpdates
        lda     Counter_HealthIncLoop2          ; Load A with the value of Counter_HealthIncLoop2, which is incremented when regaining health.
        beq     +                               ; Branch to '+' if the player is not regaining health.

        dec     Counter_HealthIncLoop2+1        ; Decrement the value at address Counter_HealthIncLoop2+1.
        bne     +                               ; Branch to '+' if the value at Counter_HealthIncLoop2+1 is not zero.

        lda     #$10                            ; Load A with the value #10.
        sta     Counter_HealthIncLoop2+1        ; Store A (#10) to the address Counter_HealthIncLoop2+1.
        dec     Counter_HealthIncLoop2          ; Decrement the value of Counter_HealthIncLoop2.

        jsr     Sub_IncreaseHealthBlock         ; Call subroutine Sub_IncreaseHealthBlock to update the health bar by increasing the health block.

+       jmp     If_CheckForDamage               ; Jump to the If_CheckForDamage label to check if the player has taken damage.


Sub_IncHealthIdx
        stx     Counter_HealthIncLoop 		; Counter_HealthIncLoop = #18
-       dec     Counter_HealthIncLoop 		; Decrease Counter_HealthIncLoop
        beq     _rts 				; Branch if Counter_HealthIncLoop = #00
        inc     Counter_HealthIncLoop2
        beq     _rts
        jmp     -
_rts    rts

        .fill   3,$ea

If_CheckForDamage
        lda     Var_DamageOccuring
        beq     _rts				; RTS if damage is not occuring
        dec     Var_DamageOccuring+1 		; Decrease value of Var_DamageOccuringLoop
        bne     _rts				; RTS if DamageOccuring is not zero
        lda     #$12       			; A = #12
        sta     Var_DamageOccuring+1 		; Var_DamageOccuringLoop = #12
        dec     Var_DamageOccuring 		; Decrease DamageOccuring
        jsr     Sub_DamageRoutine
_rts    rts

        .fill   2,$ea

Update_DamageOccuring
        stx     Var_DamageCounter    		; Var_DamageCounter = 2
-       dec     Var_DamageCounter   		; Decrease Var_DamageCounter
        beq     _rts 				; Return from subroutine
        inc     Var_DamageOccuring 		; Increase Var_DamageOccuring
        beq     _rts 				; Return from subroutine
        jmp     -
_rts    rts

        .fill   2,$ea

L5B57   cmp     #$57       			; Check if character is cross
        bne     If_5B89    			; Branch if character is not cross
        jmp     L7F50

IncMagicCrossNumRight
        nop									; No operation.
        lda     Adr_MagicCrossNumRight		; A = Adr_MagicCrossNum1 (Score number)
        cmp     #$b9      			; Check if Adr_MagicCrossNumRight is 9
        beq     + 				; Branch if Adr_MagicCrossNumRight is 9
        inc     Adr_MagicCrossNumRight 		; Increase Adr_MagicCrossNumRight
        jmp     _jump
+       lda     Adr_MagicCrossNumLeft 		; A = Adr_MagicCrossNumLeft (Score number)
        cmp     #$b9       			; Check if Adr_MagicCrossNumLeft is 9
        bne     + 				; Branch if Adr_MagicCrossNumLeft not 9
        lda     #$b0       			; A = #b0
        sta     Adr_MagicCrossNumRight 		; Adr_MagicCrossNumRight = 0
        sta     Adr_MagicCrossNumLeft 		; Adr_MagicCrossNumLeft = 0
        jmp     _jump
+       lda     #$b0       			; A = #b0
        sta     Adr_MagicCrossNumRight 		; Adr_MagicCrossNumRight = #b0 (Zero)
        inc     Adr_MagicCrossNumLeft 		; Increase Adr_MagicCrossNumLeft
_jump   jmp     L7F00

If_5B89 cmp     #$62
        bpl     If_5B95
L5B8D   cpy     #$50
        beq     If_5B94
        jmp     PlayerMidAir

If_5B94 rts

If_5B95 cmp     #$66
        bpl     If_5BAD
        cpy     #$50
        beq     If_5BA0
        jmp     PlayerMidAir

If_5BA0 dec     Var_DamageCounter+1
        bne     If_5B94
        lda     #$03
        sta     Var_DamageCounter+1
        jmp     PlayerMidAir

If_5BAD jmp     L7673

Sub_WaitForCurrentRaster
        lda     CurrentRasterLine 			;JSR from $576b
        cmp     #$10       					;Check if rasterline is #10
        bne     Sub_WaitForCurrentRaster 	;Loop back two instructions if raster not #10
        lda     ScreenControlRegister 		;Would be #1b (0001 1011)
        and     #$80       					;(1000 0000)
        bne     Sub_WaitForCurrentRaster
        rts                					;Return from subroutine

        .byte   $00,$b2,$ff,$b5,$00,$30,$ea,$ea

L5BC7   ldx     #$bf
        ldy     #$5b
        jsr     Sub_2A80   					;JSR $2a80 with Y = #5b / X = #bf
        lda     #$00						; A = #00       ;A = #00
        sta     SpriteEnableRegister 		;Disable all sprites
        lda     #$00						; A = #00       ;A = #00
        sta     ExtraBackgroundColor1 		;Extra Background Color 1 = Black
        sta     ExtraBackgroundColor2 		;Extra Background Color 2 = Black
        ldy     #$74       					;Y = #74
        lda     (Adr_MapLow),y 				;A = 00
        tax                					;Transfer A to X
        iny                					;Increase Y
        lda     (Adr_MapLow),y 				;A = #41
        tay                					;Transfer A to Y
        jsr     L5C4F
        sei                					;Set interrupts
        lda     #$18
        sta     $b7
        lda     #$6a
        sta     $b8
        cli                					;Clear interrupts
        jmp     L7610

L5BF4   .byte   $f0,$fb,$60,$ea,$ea,$ea,$ea,$6a,$00,$01,$00,$15

L5C00   lda     #$e7
        sta     L5BF4+11
        jsr     L5CC5
        tax
        lda     #$45
        sta     Low_tempvar
        lda     #$05
        sta     High_tempvar
        lda     #$45
        sta     Var_SpriteCollision
        lda     #$d9
        sta     $fe
        ldy     #$00
Jump_5C1B
        jsr     Sub_5C87
        jmp     L5CAA

L5C21   sta     (Low_tempvar),y
        lda     #$0a
        sta     (Var_SpriteCollision),y
        inx
        cpx     #$05
        beq     _L5C34
        tya
        clc
        adc     #$28
        tay
        jmp     Jump_5C1B

_L5C34  tya
        sec
        sbc     #$9f
        tay
        ldx     #$00
        inc     L5BF4+10
        lda     L5BF4+10
        cmp     #$03
        bne     +
        lda     #$00					; A = #00
        sta     L5BF4+10
        iny
+  		jmp     Jump_5C1B

        .byte   $60

L5C4F   jsr     Sub_5CD8
        nop					; No operation.
        nop					; No operation.
        lda     #$00					; A = #00
        sta     Adr_BorderColor
        sta     Adr_BackgroundColor
        sta     L5BF4+9
        jsr     L5C00
        lda     Adr_ScreenControl
        ora     #$10
        sta     Adr_ScreenControl
        lda     #$1c
        sta     Adr_MemorySetupRegister
        ldx     #$00
-		lda     RTS_5CFD+3,x
        sta     $04d6,x
        lda     #$02
        sta     $d8d6,x
        inx
        cpx     #$0e
        bne     -
        jsr     SetMastertronicApostrophe		; This will update the "Masteronic" text to include an apostrophe and also set top row. 						
        rts										; Return from subroutine

        .byte   $ea
        .byte   $ea

Sub_5C87
        inc     L5BF4+9
        lda     L5BF4+9
        cmp     #$06
        bne     +
        lda     #$01
        sta     L5BF4+9
        lda     L5BF4+11
        sec
        sbc     #$63
        sta     L5BF4+11
        rts
+ 		lda     L5BF4+11
        clc
        adc     #$19
        sta     L5BF4+11
        rts

L5CAA   inc     L5BF4+7
        lda     L5BF4+7
        cmp     #$6a
        beq     If_5CBA
        lda     L5BF4+11
        jmp     L5C21

If_5CBA ldy     #$31
        lda     #$32
        sta     (Low_tempvar),y
        lda     #$0a
        sta     (Var_SpriteCollision),y
        rts

L5CC5   lda     #$00
        sta     L5BF4+10
        sta     L5BF4+7
        sta     L5BF4+8
        sta     L5BF4+9
        rts

        .fill   4,$00

Sub_5CD8
        lda     #$93
        jsr     BSOUT
        stx     Low_tempvar
        sty     High_tempvar
        ldy     #$00
        lda     (Low_tempvar),y
        tax
        iny
        lda     (Low_tempvar),y
        tay
        clc
        jsr     PLOT
        ldy     #$02
-       lda     (Low_tempvar),y
        cmp     #$01
        beq     RTS_5CFD
        iny
        jsr     BSOUT
        jmp     -

RTS_5CFD
        rts

        .byte   $ea,$ea,$8d,$81,$93,$94,$85,$92,$94,$92,$8f,$8e,$89,$83,$a0,$93
        .byte   $0f,$12,$1c,$8e,$08,$54,$48,$45,$20,$46,$4f,$52,$45,$53,$54,$01
        .byte   $00,$00

Sub_5D20
        ldx     #$00
L5D22   ldy     #$b0
        stx     Low_tempvar
        sty     High_tempvar
        lda     #$00					; A = #00
        sta     Var_SpriteCollision
        lda     #$d8
        sta     $fe
-		ldy     #$00
        lda     (Low_tempvar),y
        sta     (Var_SpriteCollision),y
        iny
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     (Var_SpriteCollision),y
        inc     Low_tempvar
        bne     +
        inc     High_tempvar
+		inc     Var_SpriteCollision
        bne     +
        inc     $fe
+		inc     Var_SpriteCollision
        bne     +
        inc     $fe
+		lda     $fe
        cmp     #$db
        bne     -
        lda     Var_SpriteCollision
        cmp     #$f0
        bne     -
        rts

        .fill   4,$00

Sub_SetupSpritesEtc
        lda     #$01       ;JSR from $c649
        sta     Var_BorderColour ;This variable changes between boy (Blue) and girl (Red)
        jsr     L576B      ;Setup sprites etc.
        rts

        .byte   $ea,$ea,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00

Jump_ScreenSetup
        lda     Adr_ScreenControl
        ora     #$10
        sta     Adr_ScreenControl
        lda     #$0b
        sta     ExtraBackgroundColor2
        lda     #$01
        sta     $d024
        jsr     If_5E0A
        jmp     L5651

Sub_5D98
        jsr     Sub_GameOverText
        lda     #$10
        sta     $b7
        sta     $b9
        lda     #$6b
        sta     $b8
        sta     $ba
        rts

        .byte   $00

Jump_5DA9 
		lda     $02ff 					; Increased by $617c which is most likely an interrupt
        beq     Jump_5DA9				; Loop until $02ff is not #00
        jsr     Sub_DisableMusic		; Go to subroutine to disable music and update IRQ address
        lda     #$00					; A = #00
        sta     Counter_HealthIncLoop2
        sta     Var_DamageOccuring		; Var_DamageOccuring = #00
        jmp     ThisRunsAfterDeath

        .byte   $00,$00,$00,$00,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd
        .byte   $dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd,$dd
        .byte   $dd,$dd,$dd,$dd,$dd,$85,$fb,$a9,$80,$85,$fc,$a9,$fb,$a2,$00,$a0
        .byte   $c0,$20,$d8,$ff,$60,$00,$00,$00,$00,$01,$45,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$a2,$0d,$a0,$5d,$20,$4f,$5c,$60,$00,$00

If_5E0A lda     $01
        and     #$fe					; 
        sta     $01
        lda     $01
        and     #$01
        bne     If_5E0A
        rts

        .byte   $00
        .byte   $00

Sub_SetupScreen
        lda     Adr_7290,x
        sta     Adr_MapLow 					; Low byte address for map to load
        lda     Adr_7290+1,x
        sta     Adr_MapHigh 				; High byte address for map to load
        nop									; No operation.
        nop									; No operation.
        jsr     L5A41
        nop									; No operation.
        nop									; No operation.
        ldx     Adr_MapLow
        ldy     Adr_MapHigh
        jsr     L72A4
        lda     Adr_MapLow
        clc
        adc     #$06
        tax
        ldy     Adr_MapHigh
        jsr     Sub_2A80
        ldy     #$0c
        lda     (Adr_MapLow),y
        sta     Sub_5D20+1
        iny
        tya
        pha
        lda     (Adr_MapLow),y
        sta     L5D22+1
        jsr     Sub_5D20
        pla
        tay
        iny
        lda     (Adr_MapLow),y
        sta     ExtraBackgroundColor1
        iny
        lda     (Adr_MapLow),y
        sta     ExtraBackgroundColor2
        iny
        lda     (Adr_MapLow),y
        jsr     L7F20
        iny
        lda     (Adr_MapLow),y
        jsr     L7F27
        iny
        lda     (Adr_MapLow),y
        jsr     L7F2E
        iny
        lda     (Adr_MapLow),y
        sta     SpritePointer0
        iny
        lda     (Adr_MapLow),y
        sta     Sprite1XPositionRegister
        iny
        lda     (Adr_MapLow),y
        sta     Sprite1YPosition
        iny
        lda     Var_EnemyXPosition-1
        and     #$fd
        ora     (Adr_MapLow),y
        sta     SpriteXMSBRegister
        iny
        lda     (Adr_MapLow),y
        sta     SpritePointer1
        iny
        lda     (Adr_MapLow),y
        sta     LCF68
        iny
        lda     (Adr_MapLow),y
        sta     LCF69
        iny
        lda     (Adr_MapLow),y
        sta     LCF6A
        iny
        lda     (Adr_MapLow),y
        sta     LCF6B
        iny
        lda     (Adr_MapLow),y
        sta     LCF6C
        iny
        lda     (Adr_MapLow),y
        sta     LCF3D
        iny
        lda     (Adr_MapLow),y
        sta     LCF3E
        iny
        lda     (Adr_MapLow),y
        sta     LCF3F
        iny
        lda     (Adr_MapLow),y
        sta     LCF40
        iny
        lda     (Adr_MapLow),y
        sta     LCF41
        iny
        lda     (Adr_MapLow),y
        sta     LCF38
        iny
        lda     (Adr_MapLow),y
        sta     LCF39
        iny
        lda     (Adr_MapLow),y
        sta     LCF3A
        iny
        lda     (Adr_MapLow),y
        sta     LCF3B
        iny
        lda     (Adr_MapLow),y
        sta     LCF3C
        iny
        lda     (Adr_MapLow),y
        sta     Var_Num01+2
        iny
        lda     (Adr_MapLow),y
        sta     Var_Num01+3
        iny
        lda     (Adr_MapLow),y
        sta     L45AF
        iny
        lda     (Adr_MapLow),y
        sta     L45B0
        iny
        lda     (Adr_MapLow),y
        sta     L45B1
        iny
        lda     (Adr_MapLow),y
        sta     Var_Sprite3Speed
        iny
        lda     (Adr_MapLow),y
        sta     Var_Sprite3Speed+1
        iny
        lda     (Adr_MapLow),y
        sta     Var_Sprite3Speed+2
        iny
        lda     (Adr_MapLow),y
        sta     Var_Sprite3Speed+3
        iny
        lda     (Adr_MapLow),y
        sta     LCFA0
        iny
        lda     (Adr_MapLow),y
        sta     L54E5
        iny
        lda     (Adr_MapLow),y
        sta     L54E5+1
        iny
        lda     (Adr_MapLow),y
        sta     L54E5+2
        iny
        lda     (Adr_MapLow),y
        sta     L54E5+3
        iny
        lda     (Adr_MapLow),y
        sta     L54E5+4
        iny
        lda     (Adr_MapLow),y
        sta     L45E2
        iny
        lda     (Adr_MapLow),y
        sta     L45E3
        iny
        lda     (Adr_MapLow),y
        sta     L45E4
        iny
        lda     (Adr_MapLow),y
        sta     L45E5
        iny
        lda     (Adr_MapLow),y
        sta     L45E6
        iny
        lda     (Adr_MapLow),y
        sta     L574A+20
        iny
        lda     (Adr_MapLow),y
        sta     L574A+21
        iny
        lda     (Adr_MapLow),y
        sta     L574A+22
        iny
        lda     (Adr_MapLow),y
        sta     L574A+23
        iny
        lda     (Adr_MapLow),y
        sta     L574A+24
        iny
        lda     (Adr_MapLow),y
        sta     LCF24
        iny
        lda     (Adr_MapLow),y
        sta     LCF25
        iny
        lda     (Adr_MapLow),y
        sta     LCF26
        iny
        lda     (Adr_MapLow),y
        sta     LCF27
        iny
        lda     (Adr_MapLow),y
        sta     LCF28
        ldx     #$00
-  		iny
        lda     (Adr_MapLow),y
        sta     Var_EnemyXPosition,x
        inx
        cpx     #$19
        bne     -
        lda     #$0e
        sta     SelfMod_5FDB+1
        jsr     Sub_5FC0
        lda     #$0a
        sta     SelfMod_5FDB+1
        jsr     Sub_5FC0
        jmp     L7600

        .byte   $ea

Sub_5FC0
        ldx     #$00
- 		iny
        lda     (Adr_MapLow),y
        sta     Low_tempvar
        iny
        lda     (Adr_MapLow),y
        sta     High_tempvar
        tya
        pha
        ldy     #$00
        lda     #$57
        sta     (Low_tempvar),y
        lda     High_tempvar
        clc
        adc     #$d4
        sta     High_tempvar
SelfMod_5FDB
        lda     #$0a
        sta     (Low_tempvar),y
        pla
        tay
        inx
        cpx     #$05
        bne     -
        rts

        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$00,$70,$80,$70,$00,$71,$80
        .byte   $71,$00,$72,$ea,$ea,$ea,$ea,$ea,$ea,$40,$03,$d3,$5b,$00,$ff,$ff
        .byte   $ff,$f5,$45,$ff,$ff,$ff,$f7,$ff,$90,$f7,$50,$ff,$dc,$4b,$00,$00
        .byte   $d0,$ff,$ff,$00,$ff,$d7,$ff,$ff,$ff,$ff,$fd,$00,$50,$dc,$ff,$ff
        .byte   $ff,$ff,$ff,$00,$ff,$54,$ff,$f7,$ef,$ff,$ff,$00,$00,$f5,$00,$df
        .byte   $dd,$ff,$f5,$ff,$ff,$00,$be,$ff,$ef,$df,$f7,$ff,$9f,$ff,$df,$ff
        .byte   $00,$ff,$ef,$ff,$d0,$ff,$ff,$f5,$bf,$04,$7f,$11,$b2,$91,$00,$ff
        .byte   $7f,$00,$ff,$00,$ff,$00,$ff,$ca,$50,$ff,$f7,$00,$ff,$ff,$00,$ff
        .byte   $00,$fe,$ff,$00,$f1,$ff,$a0,$00,$b7,$fa,$46,$ff,$b5,$00,$00,$ff
        .byte   $00,$be,$ff,$00,$ff,$db,$08,$ff,$ff,$c2,$00,$ab,$0a,$45,$00,$cb
        .byte   $00,$ff,$ff,$84,$ba,$84,$10,$8f,$00,$ff,$00,$00,$90,$81,$ff,$ff
        .byte   $e5,$6d,$00,$ff,$ff,$c0,$14,$00,$15

L60A0  lda     #$05       ;A = 05
        sta     FilterCutoffFrequencyLow ;$d415 = 05
        lda     #$45       ;A = 45
        sta     FilterCutoffFrequencyHigh ;$d416 = 45
        lda     #$f1       ;A = f1
        sta     FilterResonanceRouting ;$d417 = f1
        lda     #$3f       ;A = 3f
        sta     FilterModeVolume ;$d418 = 3f
        rts


		.include "Music/v1music.asm"


L7280   .byte   $a0,$73,$b1,$11,$c9,$0a,$30,$03,$4c,$6b,$57,$60,$00,$00,$00,$00

Adr_7290
        .byte   $00,$70,$80,$70,$00,$71,$80,$71,$00,$72,$00,$73,$80,$73,$00,$74
        .byte   $80,$74,$00,$75

L72A4   .byte   $78,$a5,$00,$09,$02,$85,$00,$a9,$34,$85,$01,$20,$80,$2a,$a9,$36
        .byte   $85,$01,$58,$60,$ea

Var_DamageLoopCounter
        .byte   $04
		
Sub_DamageRoutine
        jsr     Sub_ReduceHealthBar 	;Subroutine to reduce health bar
        dec     Var_DamageLoopCounter 	;Counter to time when border should flash
        bne     +     					;RTS if not #00. If #00 will flash border.
        lda     #$04       				;A = #04
        sta     Var_DamageLoopCounter 	;72b9 = #04
-		lda     CurrentRasterLine 		;Get current raster line position
        cmp     #$10       				;Compare raster line to #10
        bne     -      					;Loop if raster line is not #10
        lda     ScreenControlRegister 	;Load screen control register
        and     #$80
        bne     -
        lda     Adr_BorderColor 		;Load border colour
        eor     #$08       				;Alternate colour between #f6 (Blue) and #fe (Light blue)
        sta     Adr_BorderColor 		;Store updated colour to background colour.
+		rts

        .byte   $00
        .byte   $00
		
SetMastertronicApostrophe
		lda     #$ac 					; Load value for apostrophe in "Mastertronic's".
        sta     $04ba 					; Store value for apostrophe in "Mastertronic's" on the screen.
        lda     #$02 					; Load value for color for apostrophe in "Mastertronic's"
        sta     $d8ba 					; Store value for color for apostrophe in "Mastertronic's"
        jmp     SetTitleScreenTopRow

JMP_SetTopChars							; Used to set the top row of the scren to say "Programmed by David and Richard Darling".
		ldx     #$00					; X = #00 (Used for looping).		
-		lda     L77C0,x 				; Load value from 77C6 for 40 characters.
        sta     $0400,x 				; Store value from A to screen mem.
        lda     #$04 					; A = #04.
        sta     Adr_ColorRam,x			; Store value to $Adr_ColorRam.
        inx								; Increase X
        cpx     #$28 					; Check if X is #28 (40).
        bne     - 						; If not #28 (40), loop again.
        rts								; Return from subroutine.

        .byte   $28,$ec,$f0,$ef,$50,$04,$00,$a8,$ff,$ab,$00,$30,$00,$b0,$01,$09
        .byte   $80,$e0,$00,$e2,$70,$c8,$00,$f2,$a0,$a4,$94,$90,$38,$a0,$a4,$94
        .byte   $90,$38,$a3,$a7,$97,$93,$3b,$00,$0b,$01,$08,$0b,$1f,$28,$10,$08
        .byte   $20,$04,$06,$04,$04,$04,$09,$09,$09,$09,$09,$1e,$20,$1e,$1e,$22
        .byte   $4a,$4a,$4a,$4a,$4a,$00,$d0,$00,$00,$20,$20,$f0,$00,$00,$00,$00
        .byte   $d0,$00,$00,$20,$00,$30,$00,$00,$70,$50,$d0,$40,$00,$80,$19,$05
        .byte   $7d,$04,$45,$06,$c8,$06,$55,$06,$ca,$04,$6e,$05,$d6,$06,$52,$06
        .byte   $6c,$07,$0a,$0a,$18,$43,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $28,$e8,$f0,$eb,$50,$04,$00,$9e,$ff,$a1,$00,$30,$00,$a6,$01,$0c
        .byte   $f0,$d0,$00,$e2,$e0,$d0,$00,$f2,$98,$a0,$2c,$94,$8c,$98,$a0,$2c
        .byte   $94,$8c,$9b,$a3,$33,$97,$8f,$02,$03,$0e,$01,$09,$23,$26,$06,$20
        .byte   $08,$04,$04,$04,$04,$04,$20,$20,$20,$20,$20,$1e,$1e,$22,$22,$22
        .byte   $4a,$4a,$4a,$4a,$4a,$00,$80,$00,$00,$60,$00,$80,$00,$00,$60,$50
        .byte   $40,$10,$00,$60,$41,$de,$20,$00,$00,$50,$80,$40,$00,$80,$c2,$04
        .byte   $ce,$06,$3b,$07,$9a,$07,$ff,$06,$33,$06,$45,$05,$43,$06,$4c,$06
        .byte   $41,$07,$0a,$0c,$88,$43,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $28,$e4,$f0,$e7,$50,$04,$00,$94,$ff,$97,$00,$30,$00,$9c,$0c,$07
        .byte   $80,$a0,$00,$e2,$70,$a3,$00,$f2,$a0,$84,$90,$3c,$2c,$a0,$84,$90
        .byte   $3c,$2c,$a3,$87,$93,$3f,$33,$0b,$0b,$0b,$05,$01,$23,$33,$08,$1f
        .byte   $08,$04,$04,$04,$04,$04,$10,$10,$20,$10,$10,$1e,$22,$1e,$22,$22
        .byte   $4a,$4a,$4a,$4a,$4a,$00,$e3,$00,$00,$00,$50,$e0,$08,$00,$10,$00
        .byte   $30,$00,$00,$b0,$41,$e1,$20,$00,$00,$50,$40,$40,$00,$60,$71,$05
        .byte   $b1,$06,$1b,$06,$c5,$07,$b4,$05,$ed,$04,$ab,$05,$9c,$05,$6d,$05
        .byte   $2c,$07,$0a,$0e,$f0,$43,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $28,$e0,$f0,$e3,$50,$04,$00,$8a,$ff,$8d,$00,$30,$00,$92,$0b,$02
        .byte   $80,$60,$00,$e2,$a0,$70,$00,$f2,$80,$36,$37,$35,$34,$80,$36,$37
        .byte   $35,$34,$83,$36,$37,$35,$34,$06,$07,$07,$07,$07,$10,$03,$04,$05
        .byte   $06,$04,$04,$04,$04,$04,$10,$30,$20,$20,$20,$1e,$24,$6b,$70,$73
        .byte   $4a,$4a,$4a,$4a,$4a,$00,$e0,$00,$00,$00,$30,$00,$00,$ff,$00,$50
        .byte   $00,$00,$d0,$00,$70,$00,$00,$70,$00,$80,$00,$00,$50,$00,$52,$05
        .byte   $ce,$05,$35,$07,$1e,$07,$cc,$07,$84,$07,$1c,$06,$04,$05,$3b,$06
        .byte   $d1,$06,$0a,$10,$58,$44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $28,$78,$f0,$7b,$50,$04,$00,$80,$ff,$83,$00,$30,$00,$88,$01,$07
        .byte   $f0,$e0,$00,$e2,$e0,$e0,$00,$f2,$88,$88,$88,$2c,$a4,$88,$88,$88
        .byte   $2c,$a4,$8b
		
L7523   .byte   $f2,$8b,$33,$a7,$02,$03,$04,$0b,$00,$23,$26,$19,$08,$40,$04,$04
        .byte   $04,$04,$04,$10,$10,$10,$0d,$0d,$00,$26,$46,$22,$20,$4a,$4a,$4a
        .byte   $4a,$4a,$30,$10,$00,$00,$00,$d7,$10,$00,$00,$00,$3f,$10,$10,$00
        .byte   $00,$50,$40,$20,$00,$a0,$c0,$ff,$00,$00,$00,$73,$05,$de,$06,$4f
        .byte   $07,$5b,$06,$6e,$04,$20,$05,$d4,$06,$85,$06,$5f,$04,$96,$04,$0a
        .byte   $12,$b0,$44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		
TwitchTitleText   
    ; Call LC9F1 subroutine and perform a series of comparisons and updates
    jsr     LC9F1                   ; Call subroutine LC9F1 (sent from $776D)
    cpy     #$00                    ; Compare Y register with #$00
    bne     _rts                    ; If Y not equal to 00, branch to _rts (return from subroutine)

    ; Repeat LC9F1 call, compare Y, and update memory locations based on conditions
    jsr     LC9F1                   ; Call subroutine LC9F1 again
    cpy     #$40                    ; Compare Y register with #$40
    bpl     +                       ; If Y is positive (>= 0), branch to label +

    ; Update ExtraBackgroundColor1 and return from subroutine
    lda     ExtraBackgroundColor1  	; Load value from ExtraBackgroundColor1 into the accumulator
    eor     #$02                    ; Perform XOR operation with #$02
    sta     ExtraBackgroundColor1  	; Store the result back into ExtraBackgroundColor1
    jmp     _rts                    ; Jump to _rts (return from subroutine)

+   ; Update ExtraBackgroundColor2 and L7523, and return from subroutine
    lda     ExtraBackgroundColor2  	; Load value from ExtraBackgroundColor2 into the accumulator
    eor     #$02                    ; Perform XOR operation with #$02
    sta     L7523                   ; Store the result into memory location L7523
    jmp     _rts                    ; Jump to _rts (return from subroutine)

_rts
    rts                             ; Return from subroutine


        .fill   2,$00

L75A7   lda     #$ea
        sta     $0328
        jmp     L5A60

        .byte   $00

Branch_DamageBorderColour
        lda     Var_DamageOccuring         	; Load the value of Var_DamageOccuring (#00 No damage / #01 Damage) into the accumulator (A).
        bne     Branch_Damage            	; Branch if damage has been received (not equal to #00).
        lda     Var_BorderColour           	; Load the value of Var_BorderColour into the accumulator (A).
        bne     +                          	; Branch if the background color is not #00 (to the code block marked as '+').
        lda     #$06                       	; Set the accumulator (A) to #$06 (blue).
        sta     Adr_BorderColor            	; Store the value in the accumulator (A) into Adr_BorderColor (set background color to blue).
        jmp     L7FAE                      	; Jump to the label L7FAE.

+       lda     #$0a                       	; Set the accumulator (A) to #$0a (pink).
        sta     Adr_BorderColor            	; Store the value in the accumulator (A) into Adr_BorderColor (set background color to pink).
Branch_Damage
        jmp     L7FAE                      	; Jump to the label L7FAE.


        .fill   22,$00

SetTitleScreenTopRow
		lda     $da5c					; Check part of colour memory
        and     #$0f					; Isolate the four bits
        cmp     #$01					; Check if the first bit is 1
        bne     + 						; Branch if not equal to 1
        jmp     JMP_SetTopChars			; Jump to code that sets the top line of the title screen
+		rts								; Return from subroutine

        .fill   19,$00

L7600   iny
        lda     (Adr_MapLow),y
        sta     Var_MagicCrossesLeft
        lda     #$03
        sta     SpriteEnableRegister
        rts

        .fill   4,$00

L7610   lda     $02ff                          ; Load the value at memory address $02ff into the accumulator
        bne     _L7639                         ; Branch to label _L7639 if the value in the accumulator is not equal to 0
        jsr     LC9F1                          ; Call subroutine at address LC9F1
        cpy     #$00                           ; Compare the value in the Y register with 0
        bne     L7610                          ; Branch to label L7610 if the value in the Y register is not equal to 0
        jsr     LC9F1                          ; Call subroutine at address LC9F1
        cpy     #$40                           ; Compare the value in the Y register with 64 ($40 in hex)
        bpl     _L762E                         ; Branch to label _L762E if the value in the Y register is positive (>= 0)
        lda     ExtraBackgroundColor1          ; Load the value of ExtraBackgroundColor1 into the accumulator
        eor     #$02                           ; Perform an exclusive OR operation on the accumulator value with 2 ($02 in hex)
        sta     ExtraBackgroundColor1          ; Store the result of the exclusive OR operation back into ExtraBackgroundColor1
        jmp     L7610                          ; Jump to label L7610 unconditionally


_L762E  lda     ExtraBackgroundColor2
        eor     #$02
        sta     ExtraBackgroundColor2
        jmp     L7610

_L7639  jsr     Sub_SIDSetup
        rts

        .fill   2,$00

Sub_CopyTopRowStartScreen
        lda     #$00						; A = #00
        sta     Low_tempvar 				; $fb = #00
        lda     #$04       					; A = #04
        sta     High_tempvar 				; $fc = #04
        ldy     #$00       					; Y = #00
-       lda     (Low_tempvar),y 			; A = $0400,00
        sta     $0200,y    					; Store $0400,00 to $0200,00
        iny                					; Increase Y
        cpy     #$50       					; Compare Y to #50
        bne     - 							; Loop to copy first two rows of start screen
        jmp     L5BC7

        .fill   3,$ea

L7659   jsr     Sub_CopyTopRowStartScreen
        lda     #$00						; A = #00
        sta     Low_tempvar
        lda     #$02
        sta     High_tempvar
        ldy     #$00
- 		lda     (Low_tempvar),y
        sta     $0400,y
        iny
        cpy     #$50
        bne     -
        rts

        .fill   2,$00

L7673   cmp     #$70
        bmi     _rts
        jmp     L5B8D
_rts    rts

L767B   .byte   $00,$00,$00,$00,$08

L7680   stx     L767B+4
        cpx     #$0a
        bpl     +
        lda     L7FE8,x
        sta     L7FE4
        lda     L7FE9,x
        sta     L7FE5
        ldx     #$e0
        ldy     #$7f
        jsr     Sub_2A80
+ 		ldx     L767B+4
        inx
        inx
        jsr     Sub_SetupScreen
        lda     Var_BorderColour
        beq     +
        lda     SpritePointer0
        ldx     SpritePointer1
        sta     SpritePointer1
        stx     SpritePointer0
        lda     #$0a
        sta     Adr_BorderColor
        jmp     Jump_76C0
+ 	lda     #$06
        sta     Adr_BorderColor

Jump_76C0
        ldy     #$73
        lda     #$01                            ; Set A to #01
        sta     Var_FallingStanding             ; Set Var_FallingStanding to #01 (Falling or Standing).
        lda     (Adr_MapLow),y
        cmp     #$0a
        bmi     +
        lda     #$03
        sta     SpriteEnableRegister
        rts
        .fill   2,$ea
+ 	lda     #$01
        sta     SpriteEnableRegister
        rts

Var_76DB
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
L771C   .byte   $ff
L771D   .byte   $ff
L771E   .byte   $0a

L771F   rts                ;Exits to $2dc3

Sub_ResetToMenu
        ; Load border color and apply a bitwise AND operation with #$0f
        lda     Adr_BorderColor       	        ; Load border color into the accumulator
	and     #$0f                   	        ; Perform bitwise AND operation with #$0f

	; Check if result is zero and branch to _TwitchTitleText if true. This will animate the title then return from subroutine.
	beq     _TwitchTitleText                 
		
	; Decrement L771C, and if it reaches zero, reset it to #$ff; otherwise, perform RTS
	dec     L771C                  	        ; Decrement L771C
	bne     L771F                  	        ; Branch if not equal to zero (RTS will be performed subsequently)
	lda     #$ff                   	        ; Load #$ff into the accumulator
	sta     L771C                  	        ; Store accumulator value into L771C
		
	; Decrement L771D, and if it reaches zero, reset it to #$ff; otherwise, perform RTS
	dec     L771D                 	        ; Decrement L771D
	bne     L771F                  	        ; Branch if not equal to zero (RTS will be performed subsequently)
	lda     #$ff                  	        ; Load #$ff into the accumulator
	sta     L771D                 	        ; Store accumulator value into L771D
		
        ; Decrement L771E, and if it reaches zero, reset it to #$ff; otherwise, perform RTS
        dec     L771E                           ; Decrement L771E
        bne     L771F                           ; Branch if not equal to zero (RTS will be performed subsequently)
        lda     #$0a                            ; Load #$0a into the accumulator
        sta     L771E                           ; Store accumulator value into L771E

        ; Check and set high score
        jsr     CheckSetHighScore               ; Call subroutine CheckSetHighScore

        ; Load specific values into X and Y registers and call Sub_2A80
        ldx     #$bf                            ; Load #$bf into the X register
        ldy     #$5b                            ; Load #$5b into the Y register
        jsr     Sub_2A80                        ; Call subroutine Sub_2A80

        ; Load default value into accumulator and initialize specific memory locations
        lda     #$00                            ; Load #$00 into the accumulator
        sta     SpriteEnableRegister            ; Store accumulator value into SpriteEnableRegister
        sta     ExtraBackgroundColor1           ; Store accumulator value into ExtraBackgroundColor1
        sta     ExtraBackgroundColor2           ; Store accumulator value into ExtraBackgroundColor2
        sta     Adr_BorderColor                 ; Store accumulator value into Adr_BorderColor
        sta     Adr_BackgroundColor             ; Store accumulator value into Adr_BackgroundColor

        ; Load specific values into X and Y registers and call subroutine L5C4F
        ldx     #$00                            ; Load #$00 into the X register
        ldy     #$7c                            ; Load #$7c into the Y register
        jsr     L5C4F                           ; Call subroutine L5C4F

        ; Set up SID (Sound Interface Device) and return from subroutine
        jsr     Sub_SIDSetup                    ; Call subroutine Sub_SIDSetup
        rts                                     ; Return from subroutine


        .fill   2,$00

_TwitchTitleText  
		jsr     TwitchTitleText
        rts

        .fill   15,$00

CheckSetHighScore
    ; Compare on-screen score with the stored high score
    lda     $0406,x               ; Load on-screen score into A register
    cmp     Adr_HighScore,x       ; Compare A with stored high score
    bmi     _jump                 ; If score is less than high score, jump to ending operations
    beq     +                     ; If score is equal to high score, continue to the next line
    jmp     ++                    ; If score is greater than high score, jump to update high score

    ; Loop control for comparing scores
+   inx                            ; Increment X
    cpx     #$06                  ; Check if on the 6th loop
    bne     CheckSetHighScore     ; Loop if loop not complete

_jump
	jmp     ++                  ; Jump to ending operations

    ; Update high score with the current on-screen score
+   ldx     #$00                  ; Initialize X to 0
-   lda     $0406,x               ; Load on-screen score into A register
    sta     Adr_HighScore,x       ; Store the score to the high score address
    inx                            ; Increment X
    cpx     #$06                  ; Check if loop complete
    bne     -                     ; Continue loop if not complete
    jmp     _jump                 ; Jump and start ending operations

    ; Set up memory locations L771E, L771D, and L771C
+   lda     #$0a                  ; Load #$0a into A register
    sta     L771E                 ; Store A into L771E
    lda     #$ff                  ; Load #$ff into A register
    sta     L771D                 ; Store A into L771D
    sta     L771C                 ; Store A into L771C

    ; Return from subroutine
    rts                            ; Return from subroutine


        .fill   13,$00
L77C0	.include "TitleScreen/toprowoftitle.asm"
		.include "Data/77e8.asm"		
L7EF0   .byte   $00

L7EF1   sta     L7EF0
        lda     SpriteXMSBRegister
        and     #$fe
        ora     L7EF0
        sta     SpriteXMSBRegister
        rts

L7F00   dec     Var_MagicCrossesLeft
        beq     AllCrossesCollected
        rts

AllCrossesCollected
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        lda     #$03       			; A = #03
        sta     SpriteEnableRegister 	        ; Turn off all sprites other than boy and girl
        ldy     #$73       			; Y = #73
        lda     (Adr_MapLow),y 			; A = ($11),y - which is ($11),73
        tax
        cpx     #$12
        bne     +
        ldx     #$fe
+  		jmp     L7680

        .byte   $70,$57,$60,$00

L7F20   sta     L4516
        sta     Sprite0XPosition
        rts

L7F27   sta     L4517
        sta     Sprite0YPos
        rts

L7F2E   sta     Var_EnemyXPosition-1
        jsr     L7EF1
        rts

        .fill   27,$00

L7F50   lda     High_tempvar 			; A = #fc
        nop					; No operation.
        clc                			; Clear carry
        adc     #$d4       			; Add 
        sta     High_tempvar
        lda     (Low_tempvar),y
        and     #$04
        tax
        lda     Var_BorderColour
        beq     _L7F67
        cpx     #$00
        beq     _L7F6C
        rts

_L7F67  cpx     #$04
        beq     _L7F6C
        rts

_L7F6C  lda     High_tempvar 			; A = $fc (Low byte of screen address)
        sec
        sbc     #$d4
        sta     High_tempvar
        lda     #$a0       				; A = #a0 (Blank sprite)
        sta     (Low_tempvar),y 		; Remove cross from ($fb),y which is screen address
        jmp     IncMagicCrossNumRight

        .fill   6,$ea

L7F80   dec     Var_5a16               	; Decrease the value at memory location $5a16
        bne     +                       ; Branch to the '+' label and perform an RTS if the value at $5a16 is not zero
        lda     #$28                    ; Load the value #28 into the accumulator (A)
        sta     Var_5a16                ; Store the value #28 into memory location Var_5a16
        ldy     #$5d                    ; Load the value #5d into the Y register
        ldx     #$00                    ; Load the value #00 into the X register

-       iny                             ; Increase the Y register
        lda     (Adr_MapLow),y          ; Load the value from the address (Adr_MapLow + Y) into the accumulator (A)
        sta     Low_tempvar             ; Store the value from the accumulator (A) into Low_tempvar
        iny                             ; Increase the Y register
        lda     (Adr_MapLow),y          ; Load the value from the address (Adr_MapLow + Y) into the accumulator (A)
        clc                             ; Clear the carry flag
        adc     #$d4                    ; Add the value #d4 to the accumulator (A)
        sta     High_tempvar            ; Store the value from the accumulator (A) into High_tempvar
        tya                             ; Transfer the value from the Y register to the accumulator (A)
        pha                             ; Push the value in the accumulator (A) onto the stack
        ldy     #$00                    ; Load the value #00 into the Y register
        lda     (Low_tempvar),y         ; Load the value from the address (Low_tempvar + Y) into the accumulator (A)
        sec                             ; Set the carry flag
        sbc     #$08                    ; Subtract the value #08 from the accumulator (A)
        sta     (Low_tempvar),y         ; Store the value from the accumulator (A) into the address (Low_tempvar + Y)
        pla                             ; Pull the value from the stack into the accumulator (A)
        tay                             ; Transfer the value from the accumulator (A) to the Y register
        inx                             ; Increase the X register
        cpx     #$0a                    ; Compare the value in the X register with #0a
        bne     -                       ; Branch to the '-' label if the values are not equal

+       rts                             ; Return from subroutine


L7FAE   jsr     L538E                     ; Call the subroutine at the label L538E.
        jsr     L7F80                     ; Call the subroutine at the label L7F80.
        rts                               ; Return from the current subroutine.


        .fill 32,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$04,$f0,$07
L7FE4   .byte   $00
L7FE5   .byte   $ec,$00,$00
L7FE8   .byte   $00
L7FE9   .byte   $78,$00,$e0,$00,$e4,$00,$e8,$00,$ec,$00,$00,$00,$00,$00,$00,$4e
        .byte   $3a,$41,$49,$50,$2c,$44,$24
                                                ;***************************************
                                                ;* Start Levels, charsets, and colors  *
                                                ;***************************************
        .include "Level1/level1charset.asm"
        .include "Level1/level1map.asm"
        .fill 	16,$a0
		.include "Level1/level1color.asm"
		.byte   $bb,$00,$00,$00,$00,$00,$00,$00
        .include "Level2/level2charset.asm"
        .include "Level2/level2map.asm"
        .fill 	16,$a0
		.include "Level2/level2color.asm"
		.byte	$bb,$00,$00,$00,$00,$00,$00,$00
        .include "Level3/level3charset.asm"
        .include "Level3/level3map.asm"
        .fill 	16,$a0
		.include "Level3/level3color.asm"        
		.byte	$bb,$00,$00,$00,$00,$00,$00,$00
        .include "Level4/level4charset.asm"
        .include "Level4/level4map.asm"
        .fill 	16,$a0
 		.include "Level4/level4color.asm"        
		.byte	$bb,$00,$00,$00,$00,$00,$00,$00
        .include "Level5/level5charset.asm"
        .include "Level5/level5map.asm"
        .fill 	16,$a0
 		.include "Level5/level5color.asm"        
		.byte	$bb,$00,$00,$00,$00,$00,$00,$00		
        .include "TitleScreen/titlecharset.asm"
                                                ;***************************************
                                                ;* End Levels, charsets, and colors    *
                                                ;***************************************
		.include "Data/b5ff.asm"	; Basic junk data

LC000   lda     LCF46,x				;
        and     SpriteEnableRegister	        ;
        beq     _LC00E
        nop					; No operation.								;
        nop					; No operation.
        nop					; No operation.
        jmp     LCA70

_LC00E  jmp     If_CD55

LC011   lda     L4555      			; Load the value at memory address $4555 into the accumulator (A)
        cmp     #$ff       			; Compare A with #ff
        beq     _rts     			; Branch if A is equal to #ff (255)
        dec     LCF43      			; Decrement the value at memory address $CF43
        jsr     LC525      			; Jump to subroutine LC525
        bne     _rts     			; Branch if the zero flag is not set (result of comparison in LC525 is not equal)
        lda     L4555      			; Load the value at memory address $4555 into the accumulator (A)
        sta     LCF43      			; Store the value in the accumulator (A) into memory address $CF43
        lda     Adr_ScreenControl 		; Load the value at Adr_ScreenControl into the accumulator (A)
        and     #$f7       			; Perform a bitwise AND operation with #$f7 to clear the 4th bit
        sta     Adr_ScreenControl 		; Store the value in the accumulator (A) into Adr_ScreenControl
        jsr     If_C46B    			; Jump to subroutine If_C46B
_rts  	rts                			; Return from the subroutine


LC032   lda     L4517
        jmp     LC144

        .byte   $a9,$90,$85,$fb,$a9,$04,$85,$fc,$a9,$00,$a0,$00,$a2,$00,$20,$d4
        .byte   $51,$20,$cc,$2a,$a0,$00,$e6,$fb,$d0,$02,$e6,$fc,$e0,$07,$d0,$ee
        .byte   $e6,$fb,$d0,$02,$e6,$fc,$e8,$e0,$28,$d0,$f5,$c9,$7e,$d0,$dd,$60
        .byte   $20,$08,$c1,$a0,$00,$a9,$78,$85,$fb,$a9,$04,$85,$fc,$a2,$00,$b9
        .byte   $00,$c1,$3d,$a0,$30,$d0,$04,$a9,$a0,$91,$fb,$c8,$c0,$08,$d0,$ef
        .byte   $a0,$00,$e8,$a9,$28,$e6,$fb,$d0,$02,$e6,$fc,$18,$e9,$00,$c9,$00
        .byte   $d0,$f3,$e0,$08,$d0,$d9,$60,$ea,$ea,$ea,$a9,$00,$85,$fb,$a9,$04
        .byte   $85,$fc,$a0,$00,$a9,$a0,$91,$fb,$e6,$fb,$d0,$02,$e6,$fc,$a5,$fb
        .byte   $c9,$e8,$d0,$f0,$a5,$fc,$c9,$07,$d0,$ea,$a9,$00,$85,$fb,$a9,$d8
        .byte   $85,$fc,$a0,$00,$a9,$0b,$91,$fb,$e6,$fb,$d0,$02,$e6,$fc,$a5,$fb
        .byte   $c9,$e8,$d0,$f0,$a5,$fc,$c9,$db,$d0,$ea,$60
Var_CurrentEnemy
        .byte   $01

Sub_UpdateEnemySprites
        jsr     Sub_VerticalMovingEnemies 	;A = Active enemy index
        jsr     Sub_EnemyMSB 			;A = Active enemy index
        lda     Var_CurrentEnemy 		;A = C0e3 (Alternates between #00-04)
        tax                			;Transfer A to X
        lda     LCF46,x    			;Load value to select sprite to enable/disable (#04,#08,#10,#20,#40)
        ora     SpriteEnableRegister 		;Enable/disable sprite in $d015
        sta     SpriteEnableRegister 		;Update sprite register
        lda     LCF68,x
        sta     SpritePointers,x
        jmp     LC6E0

        .byte   $80,$40,$20,$10,$08,$04,$02,$01,$a0,$00,$a9,$78,$85,$fb,$a9,$04
        .byte   $85,$fc,$a2,$00,$a9,$80,$91,$fb,$c8,$c0,$08,$d0,$f7,$a0,$00,$e8
        .byte   $a9,$28,$e6,$fb,$d0,$02,$e6,$fc,$18,$e9,$00,$c9,$00,$d0,$f3,$e0
        .byte   $08,$d0,$e1,$60,$00,$00,$00,$60,$00,$a9,$00,$9d,$00,$d4,$e8,$e0
        .byte   $18,$d0,$f8,$60

LC144   sta     Sprite0YPos
        lda     L4516
        sta     Sprite0XPosition
        jmp     LC1E1

        .byte   $a2,$00,$bd,$40,$3c,$8d,$be,$c1,$29,$55,$0a,$8d,$bd,$c1,$ad,$be
        .byte   $c1,$29,$aa,$4a,$0d,$bd,$c1,$9d,$40,$3c,$e8,$e0,$40,$d0,$e3,$60
        .byte   $a2,$00,$a9,$20,$9d,$ee,$05,$9d,$ee,$06,$9d,$3c,$05,$e8,$e0,$00
        .byte   $d0,$f2,$60,$ea,$ea,$4c,$4a,$54,$00,$30,$00,$34,$e8,$03,$00,$4e
        .byte   $00,$52,$00,$30,$e8,$03,$e8,$07,$00,$4e,$ea

Var_FallingStanding                             ; $C19B
        .byte   $01                             ; #01 Falling or Standing / #00 Jumping

Var_Jumping                                     ; $C19C
        .fill   1,$00      		        ; #01 jumping / #00 not jumping

Jump_C19D
        lda     L45FF                           ; Load the value at memory address $45FF into the accumulator (A)
        bne     +                               ; Branch if A is not equal to #00. Seems like $45ff is always #01.
        lda     SpriteEnableRegister            ; Load the value at SpriteEnableRegister into the accumulator (A)
        jmp     LC7D4                           ; Jump to the label LC7D4

+       lda     Var_Jumping                     ; Load the value at Var_Jumping into the accumulator (A) (#01 jumping / #00 not jumping)
        beq     +                               ; Branch if A is equal to #00 (not jumping)
        jmp     CheckLeftRightInput             ; Jump to the label CheckLeftRightInput if jumping
+       jmp     L5418                           ; Jump to the label L5418


        .byte   $ea

LC1B4   nop									
        lda     #$00			        ; A = #00
        sta     Var_JumpAscDesc                 ; Reset Var_JumpAscDesc to #00
        jmp     L2A72                           ; Begin jump routine.

        .byte   $00,$00,$00,$ad,$00,$dc,$a0,$00,$a2,$00,$4a,$b0,$01,$88,$4a,$b0
        .byte   $01,$c8,$4a,$b0,$01,$ca,$4a,$b0,$01,$e8,$4a,$8e,$ed,$c1,$8c,$ec
        .byte   $c1,$4c,$30,$c2

LC1E1   lda     SpriteXMSBRegister
        and     #$fe
        ora     Var_EnemyXPosition-1
        jmp     LC407

Var_DownInput
        .fill   1,$00
Var_LeftRightInput
        .fill   1,$00
Var_UpInput
        .byte   $00
        .byte   $ae,$8d,$02,$a5,$c5,$ac,$45,$32,$c9,$40,$f0,$1a,$c9,$07,$f0,$17
        .byte   $c9,$02,$f0,$03,$4c,$26,$c2,$e0,$00,$f0,$06,$a9,$ff,$8d,$ed,$c1
        .byte   $60,$a9,$01,$8d,$ed,$c1,$60,$e0,$00,$f0,$06,$a9,$ff,$8d,$ec,$c1
        .byte   $60,$a9,$01,$8d,$ec,$c1,$60,$c9,$3c,$d0,$fb,$a9,$01,$8d,$ee,$c1
        .byte   $60,$b0,$08,$a9,$01,$8d,$ee,$c1,$4c,$ef,$c1,$a9,$00,$8d,$ee,$c1
        .byte   $4c,$ef,$c1,$a0,$38,$ee,$00,$d0,$ad,$00,$d0,$c9,$00,$d0,$08,$ad
        .byte   $10,$d0,$09,$01,$8d,$10,$d0,$88,$c0,$00,$a9,$00,$a2,$00,$e8,$e0
        .byte   $00,$d0,$fb,$aa,$e8,$8a,$c9,$06,$d0,$f2,$c0,$00,$d0,$d7,$60,$a0
        .byte   $28,$ce,$00,$d0,$ad,$00,$d0,$c9,$ff,$d0,$08,$ad,$10,$d0,$29,$fe
        .byte   $8d,$10,$d0,$88,$c0,$00,$a9,$00,$a2,$00,$e8,$e0,$00,$d0,$fb,$aa
        .byte   $e8,$8a,$c9,$06,$d0,$f2,$c0,$00,$d0,$d7,$60,$ea,$ea,$ea

Sub_C29D
        lda     #$00					; A = #00
        sta     Low_tempvar
LC2A1   lda     #$a8
        sta     High_tempvar
LC2A5   lda     #$00
        sta     Var_SpriteCollision
LC2A9   lda     #$30
        sta     $fe
LC2AD   lda     #$ff
        sta     $0390
LC2B2   lda     #$ab
        sta     $0391
        ldy     #$00
If_C2B9 lda     (Low_tempvar),y
        sta     (Var_SpriteCollision),y
        inc     Low_tempvar
        bne     If_C2C3
        inc     High_tempvar
If_C2C3 inc     Var_SpriteCollision
        bne     If_C2C9
        inc     $fe
If_C2C9 lda     $0391
        cmp     High_tempvar
        bne     If_C2B9
        lda     $0390
        cmp     Low_tempvar
        bne     If_C2B9
        rts

        .byte   $a2,$00,$a9,$0b,$9d,$00,$d8,$9d,$00,$d9,$9d,$00,$da,$9d,$00,$db
        .byte   $a9,$a0,$9d,$00,$04,$9d,$00,$05,$9d,$00,$06,$9d,$00,$07,$e8,$e0
        .byte   $00,$d0,$df,$60,$ea,$ea,$ea,$ea,$0c,$2d,$51,$66,$91,$c3,$fa,$18
        .byte   $5a,$a3,$cc,$23,$86,$f4,$30,$b4,$47,$98,$47,$0c,$e9,$61,$68,$8f
        .byte   $30,$8f,$18,$d2,$c3,$d1,$1f,$60,$1e,$31,$a5,$87,$a2,$3e,$c1,$3c
        .byte   $63,$4b,$0f,$45,$7d,$83,$79,$c7,$97,$1e,$8b,$fa,$06,$f3,$8f,$2e
        .byte   $10,$c3,$12,$d1,$15,$1f,$16,$60,$01,$01,$01,$01,$01,$01,$01,$02
        .byte   $02,$02,$02,$03,$03,$03,$04,$04,$05,$05,$06,$07,$07,$08,$09,$0a
        .byte   $0b,$0c,$0e,$0f,$10,$12,$15,$16,$19,$1c,$1f,$21,$25,$2a,$2c,$32
        .byte   $38,$3f,$43,$4b,$54,$59,$64,$70,$7e,$86,$96,$a8,$b3,$c8,$e1,$fd
        .byte   $fd,$fd

LC37A   tya
        jsr     Sub_UpdateSpritePositions ;A = Sprite / X = Direction (00 = up / 01 = down / 02 = left / 03 = right)
        rts

        .byte   $ea,$ae,$80,$03,$ee,$80,$03,$bd,$00,$40,$c9,$00,$f0,$18,$c9,$ff
        .byte   $f0,$0c,$c9,$fe,$f0,$08,$c9,$fd,$f0,$04,$c9,$fc,$d0,$0c,$a9,$00
        .byte   $8d,$ff,$ff,$8d,$ff,$ff,$60,$21,$ea,$ea,$a8,$a9,$fe,$2d,$ff,$ff
        .byte   $8d,$ff,$ff,$98,$ea,$aa,$bd,$00,$c3,$8d,$ff,$ff,$bd,$40,$c3,$8d
        .byte   $ff,$ff,$ad,$a6,$c3,$8d,$ff,$ff,$60,$ea,$ea,$ea,$ae,$80,$03,$bd
        .byte   $00,$40,$f0,$09,$30,$07,$ac,$a6,$c3,$88,$8c,$ff,$ff,$60,$ce,$01
        .byte   $d0,$ce,$03,$d0,$ce,$05,$d0,$ce,$07,$d0,$ce,$09,$d0,$ce,$0b,$d0
        .byte   $ce,$0d,$d0,$ce,$0f,$d0,$60,$a9,$00,$8d,$ff,$ce,$20,$24,$cb,$ee
        .byte   $ff,$ce,$ad,$ff,$ce,$d0,$f5,$60

LC407   sta     SpriteXMSBRegister
        lda     L4510
        jmp     LCEF6

LC410   .byte   $bb,$a0

LC412   lda     $d828
        sta     LC410
        lda     $0428
        sta     LC410+1
        ldx     #$00
If_C420 lda     $0429,x
        sta     $0428,x
        lda     $d829,x
        sta     $d828,x
        inx
        cpx     #$d2
        bne     If_C420
        ldx     #$00
If_C433 lda     $04fa,x
        sta     $04f9,x
        lda     $d8fa,x
        sta     $d8f9,x
        inx
        cpx     #$fa
        bne     If_C433
        ldx     #$00
If_C446 lda     $05f4,x
        sta     $05f3,x
        lda     $d9f4,x
        sta     $d9f3,x
        inx
        cpx     #$fa
        bne     If_C446
        ldx     #$00
If_C459 lda     $06ee,x
        sta     $06ed,x
        lda     $daee,x
        sta     $daed,x
        inx
        cpx     #$fa
        bne     If_C459
        rts

If_C46B lda     CurrentRasterLine
        cmp     #$4b
        bne     If_C46B
        jsr     LC412
        jmp     Jump_C47F

        .byte   $ea,$ad,$76,$c4,$ea,$ea,$ea

Jump_C47F
        lda     #$bf
        sta     Low_tempvar
        lda     #$07
        sta     High_tempvar
        lda     #$bf
        sta     Var_SpriteCollision
        lda     #$db
        sta     $fe
If_C48F ldy     #$00
        lda     (Low_tempvar),y
        tax
        lda     (Var_SpriteCollision),y
        ldy     #$28
        sta     (Var_SpriteCollision),y
        txa
        sta     (Low_tempvar),y
        lda     Low_tempvar
        clc
        sbc     #$27
        bcs     If_C4A8
        dec     High_tempvar
        dec     $fe
If_C4A8 sta     Low_tempvar
        sta     Var_SpriteCollision
        lda     High_tempvar
        cmp     #$03
        beq     If_C4BE
        lda     Low_tempvar
        cmp     #$27
        bne     If_C48F
        lda     High_tempvar
        cmp     #$04
        bne     If_C48F
If_C4BE lda     LC410
        sta     $d84f
        lda     LC410+1
        sta     $044f
        rts

        .byte   $ea,$ea,$ad,$0e,$45,$20,$49,$c6,$60,$ad,$2a,$d0,$8d,$24,$d8,$8d
        .byte   $25,$d8,$ad,$25,$d0,$8d,$f5,$45,$8d,$4d,$d8,$8d,$4c,$d8,$ad,$26
        .byte   $d0,$8d,$75,$d8,$8d,$74,$d8,$8d,$f6,$45,$60,$f8,$60,$ea,$ea,$ea

LC4FB   cmp     #$01
        bne     If_C508
Jump_C4FF
        lda     SpriteEnableRegister
        and     #$fd
        sta     SpriteEnableRegister
        rts

If_C508 lda     SpritePointer1
        eor     #$ff
        eor     #$fe
        sta     SpritePointer1
        inc     LC53C+8
        lda     LC53C+8
        cmp     #$05
        bne     RTS_C524
        lda     #$00					; A = #00
        sta     LC53C+8
        jmp     Jump_C4FF

RTS_C524
        rts

LC525   lda     LCF43      ;A = $cf43
        and     #$07
        bne     If_C538
        ldx     #$01
        lda     #$03                            ; 03 (Right) is passed to Sub_PlayerPosition as direction of player.
        jsr     Sub_PlayerPosition              ; This will work out player position and suitable actions (E.g. mushroom, etc)
        lda     #$02                            ; 02 (Left) is passed to Sub_PlayerPosition as direction of player.
        jsr     Sub_PlayerPosition              ; This will work out player position and suitable actions (E.g. mushroom, etc)
If_C538 lda     LCF43
        rts

LC53C   .byte   $ea,$ea,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$80,$a2,$00,$bd
        .byte   $40,$3c,$a8,$29,$80,$8d,$3e,$c5,$98,$29,$40,$8d,$3f,$c5,$98,$29
        .byte   $20,$8d,$40,$c5,$98,$29,$10,$8d,$41,$c5,$98,$29,$08,$8d,$42,$c5
        .byte   $98,$29,$04,$8d,$43,$c5,$98,$29,$02,$8d,$44,$c5,$98,$29,$01,$8d
        .byte   $45,$c5,$ea,$a9,$00,$8d,$46,$c5,$ad,$45,$c5,$c9,$00,$f0,$02,$a9
        .byte   $80,$0d,$46,$c5,$8d,$46,$c5,$ad,$44,$c5,$c9,$00,$f0,$02,$a9,$40
        .byte   $0d,$46,$c5,$8d,$46,$c5,$ad,$43,$c5,$c9,$00,$f0,$02,$a9,$20,$0d
        .byte   $46,$c5,$8d,$46,$c5,$ad,$42,$c5,$c9,$00,$f0,$02,$a9,$10,$0d,$46
        .byte   $c5,$8d,$46,$c5,$ad,$41,$c5,$c9,$00,$f0,$02,$a9,$08,$0d,$46,$c5
        .byte   $8d,$46,$c5,$ad,$40,$c5,$c9,$00,$f0,$02,$a9,$04,$0d,$46,$c5,$8d
        .byte   $46,$c5,$ad,$3f,$c5,$c9,$00,$f0,$02,$a9,$02,$0d,$46,$c5,$8d,$46
        .byte   $c5,$ad,$3e,$c5,$c9,$00,$f0,$02,$a9,$01,$0d,$46,$c5,$9d,$40,$3c
        .byte   $e8,$e0,$40,$f0,$03,$4c,$4b,$c5,$60,$8f,$00

LC607   dec     LCF82,x
        lda     LCF82,x
        cmp     #$00
        bne     RTS_C645
        lda     #$0a
        sta     LCF82,x
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        dec     LCF54,x
        lda     LCF54,x
        cmp     #$00
        bne     RTS_C645
        inc     SpritePointers,x
        lda     SpritePointers,x
        cmp     #$fc
        bne     If_C63F
        lda     LCF46,x
        eor     #$ff
        and     SpriteEnableRegister
        sta     SpriteEnableRegister
        lda     #$00				; A = #00
        sta     LCF4F,x
If_C63F lda     L455B,x
        sta     LCF54,x
RTS_C645
        rts

JUMP_c646
        jsr     ResetGirl
        jsr     Sub_SetupSpritesEtc
        lda     L450F 				;Value is usually #f0 (Light grey)
        sta     Adr_BackgroundColor             ;Set the background colour to light grey
        lda     #$08
        jsr     BSOUT                           ;Not sure why this exists
        nop					; No operation.
        lda     #$00				; A = #00
        sta     SpriteEnableRegister            ;Disable all sprites
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        ldx     #$00       ;X = #00
        jsr     Sub_SetupScreen
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        ldx     #$c0
        ldy     #$56
        jsr     Sub_2A80
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
        nop					; No operation.
		
LC694   lda     Var_Num01               ; Load the value at Var_Num01 into the accumulator (A).
        bne     If_C6AC                 ; Branch to label If_C6AC if A is not equal to 0 (if Var_Num01 is not 0).

        lda     #$00                    ; A = #00
        sta     Var_CurrentEnemyIndex   ; Set Var_CurrentEnemyIndex to 0 (initialize enemy index to the first enemy).

- 		jsr     Sub_UpdateEnemySprites	; Call the subroutine Sub_UpdateEnemySprites to update the enemy sprites.
        inc     Var_CurrentEnemyIndex   ; Increment the enemy index.
        lda     Var_CurrentEnemyIndex   ; Load the value of Var_CurrentEnemyIndex into the accumulator (A).
        cmp     Var_Num01+1             ; Compare the value in A with the value at Var_Num01+1.
        bne     -                  		; If the values are not equal, branch back to label - to continue updating enemy sprites.

If_C6AC jsr     LC032                    ; Call the subroutine at label LC032.
        lda     #$1c                     ; A = #$1c
        sta     Adr_MemorySetupRegister  ; Store the value of A into the address specified by Adr_MemorySetupRegister.
        lda     #$0f                     ; A = #$0f
        sta     $ffff                    ; Store the value of A into the address $ffff.
        lda     #$f8                     ; A = #$f8
        sta     $07ff                    ; Store the value of A into the address $07ff.
        lda     L45B2                    ; Load the value at L45B2 into the accumulator (A).
        sta     $d028                    ; Store the value of A into the address $d028.
        ldx     #$00                     ; X = #00 (initialize X to 0).

        nop                              ; No operation (do nothing).

        lda     #$00                     ; A = #00

If_C6C9 sta     LCF1A,x                  ; Store the value of A into the address LCF1A+x.
        sta     LCF29,x                  ; Store the value of A into the address LCF29+x.
        sta     LCF2E,x                  ; Store the value of A into the address LCF2E+x.
        sta     LCF4F,x                  ; Store the value of A into the address LCF4F+x.
        inx                              ; Increment the value of X.
        cpx     #$05                     ; Compare the value of X with #$05.
        bne     If_C6C9                  ; If the values are not equal, branch back to label If_C6C9 to continue storing values.

        lda     Adr_SpriteCollision      ; Load the value at Adr_SpriteCollision into the accumulator (A).
        jmp     L2D00                    ; Jump to the label L2D00.

LC6E0   lda     Var_Num01+2,x            ; Load the value at Var_Num01+2+x into the accumulator (A).
        jmp     L2F38                    ; Jump to the label L2F38.


        .byte   $60

TimeWastingLoop
        tya
        pha
        txa
        pha
If_C6EB lda     LCF65
        sta     LCF67
If_C6F1 dec     LCF67
        bne     If_C6F1
        dec     LCF66
        bne     If_C6EB
        pla
        tax
        pla
        tay
        rts

LC700   lda     SpritePointer1            	; Load the value of SpritePointer1 into the accumulator (A)
        clc                              	; Clear the carry flag
        sbc     #$df                      	; Subtract the value #$df from the accumulator (A), with borrow
        ldx     #$01                      	; Load the X register with #$01, representing the direction (01 = down)
        jsr     Sub_UpdateSpritePositions 	; Call the subroutine Sub_UpdateSpritePositions with A holding the sprite data and X holding the direction
        cpy     #$00                      	; Compare the value in the Y register with #$00
        beq     If_C717                   	; Branch to If_C717 if Y is equal to #$00 (i.e., if the comparison is true)
        rts                              	; Return from subroutine if Y is not equal to #$00


        .fill   7,$ea

If_C717 nop
        rts

        .fill   2,$ea

LC71B   lda     #$00                		; A = #00
        sta     Var_MovingLeftRight 		; Reset Var_MovingLeftRight (#01 moving left or right / #00 not moving left or right).
        jsr     Sub_GetInputs 			; Call subroutine to get inputs
        lda     Var_DownInput       		; A = Var_DownInput. 01 = Down pressed / 00 = No input
        cmp     #$ff                		; Compare with #ff (unknown significance, possibly unused)
        bne     +   				; Branch if Var_DownInput not equal #$ff
        lda     Var_4500            		; Load A with value at Var_4500
        cmp     #$00                		; Compare A with #00
        beq     +   				; Branch if A is equal to #00
        lda     #$00                		; 00 (Up) is passed to Sub_PlayerPosition as direction of player.
        tax                         		; Transfer A to X (X = #00)
        jsr     Sub_PlayerPosition  		; This will work out player position and suitable actions (E.g. mushroom, etc)
        inc     Var_MovingLeftRight 		; Increment Var_MovingLeftRight (#01 moving left or right / #00 not moving left or right).
        lda     Var_SlidingOnRope+1 		; Load A with value at Var_SlidingOnRope+1
        cmp     #$00                		; Compare A with #00
        beq     +   				; Branch if A is equal to #00
        lda     SpritePointer0      		; Load A with value at SpritePointer0
        and     #$01                		; Perform bitwise AND with #01
        clc                         		; Clear carry flag
        adc     #$d8                		; Add #d8 to A with carry
        sta     SpritePointer0      		; Store updated value in SpritePointer0
+       lda     Var_DownInput 			; Load the value of the Down input variable into the accumulator.
        cmp     #$01       			; Compare it to the value #$01, which means "Down pressed".
        bne     +          			; If it's not equal to #$01, branch to the next code block (i.e. skip the code that follows).
        lda     Var_4501   			; Load the value of a variable called Var_4501 into the accumulator.
        cmp     #$00       			;Compare it to the value #$00.
        beq     +          			;If it's equal to #$00, branch to the next line.
        lda     #$01       			; 01 (Down) is passed to Sub_PlayerPosition as direction of player.
        ldx     #$00       			;Load the value #$00 into the X register.
        jsr     Sub_PlayerPosition 		; This will work out player position and suitable actions (E.g. mushroom, etc)
        inc     Var_MovingLeftRight 		;Increment a variable called Var_MovingLeftRight (#01 moving left or right / #00 not moving left or right).
        lda     Var_SlidingOnRope+2 		;Load the value of a variable called Var_SlidingOnRope+2 into the accumulator.
        cmp     #$00       			;Compare it to the value #$00.
        beq     +          			;If it's equal to #$00, branch to the next line.
        lda     SpritePointer0 			;Load the value of a variable called SpritePointer0 into the accumulator.
        and     #$01       			;Perform a bitwise AND operation with the value #$01.
        clc                 			;Clear the carry flag.
        adc     #$da       			;Add the value #$da to the accumulator with carry.
        sta     SpritePointer0 			;Store the result in the variable called SpritePointer0.
+       lda     Var_LeftRightInput 		; Load the value of a variable called Var_LeftRightInput into the accumulator.
        cmp     #$ff       			; Compare it to the value #$ff, which means "Left input received".
        bne     +          			; If it's not equal to #$ff, branch to the next line.
        lda     Var_RopeFall 			; Load the value of a variable called Var_RopeFall into the accumulator.
        cmp     #$00       			; Compare it to the value #$00.
        beq     +          			; If it's equal to #$00, branch to the next code block.
        lda     #$02       			; 02 (Left) is passed to Sub_PlayerPosition as direction of player.
        ldx     #$00       			; Load the value #$00 into the X register.
        jsr     Sub_PlayerPosition 		; This will work out player position and suitable actions (E.g. mushroom, etc)
        inc     Var_MovingLeftRight 		;Increment a variable called Var_MovingLeftRight (#01 moving left or right / #00 not moving left or right).
        lda     Var_SlidingOnRope+3 		;Load the value of a variable called Var_SlidingOnRope+3 into the accumulator.
        cmp     #$00       			;Compare it to the value #$00.
        beq     +          			;If it's equal to #$00, branch to the next line.
        lda     SpritePointer0 			;Load the value of a variable called SpritePointer0 into the accumulator.
        and     #$03       			;Perform a bitwise AND operation with the value #$03.
        clc                 			;Clear the carry flag.

LC79B   adc     #$e8       			;Add the value #$e8 to the accumulator (which contains a sprite pointer) with carry.
        sta     SpritePointer0 			;Store the result in the variable called SpritePointer0.
+       lda     Var_LeftRightInput 		; Load the value of a variable called Var_LeftRightInput into the accumulator.
        cmp     #$01       			; Compare it to the value #$01, which means "going right".
        bne     +          			; If it's not equal to #$01, branch to the next code block (i.e. skip the code that follows).
        lda     Var_SlidingOnRope 		; Load the value of a variable called Var_SlidingOnRope into the accumulator.
        cmp     #$00       			; Compare it to the value #$00.
        beq     +          			; If it's equal to #$00, branch to the next line.
        lda     #$03       			; 03 (Right) is passed to Sub_PlayerPosition as direction of player.
        ldx     #$00       			; Load the value #$00 into the X register.
        jsr     Sub_PlayerPosition 		; This will work out player position and suitable actions (E.g. mushroom, etc)
        inc     Var_MovingLeftRight 		; Increment a variable called Var_MovingLeftRight (#01 moving left or right / #00 not moving left or right).
        lda     L4507      			; Load the value of a variable called L4507 into the accumulator.
        cmp     #$00       			; Compare it to the value #$00.
        beq     +          			; If it's equal to #$00, branch to the next line.
        lda     SpritePointer0 			; Load the value of a variable called SpritePointer0 into the accumulator.
        and     #$03       			; Perform a bitwise AND operation with the value #$03.
        clc                 			; Clear the carry flag.

LC7C5   adc     #$ec       			;Add the value #$ec to the accumulator (which contains a sprite pointer) with carry.
        sta     SpritePointer0 			;Store the result in the variable called SpritePointer0.
+       lda     Var_UpInput 			;Load the value of a variable called Var_UpInput into the accumulator.
        cmp     #$00       			;Compare it to the value #$00.
        beq     CheckLeftRightInput 		;If it's equal to #$00, branch to a label called CheckLeftRightInput.
        jmp     Jump_C19D  			;Otherwise, jump to a label called Jump_C19D.
LC7D4   and     #$02       			;Perform a bitwise AND operation with the value #$02 on the accumulator.
        cmp     #$00       			;Compare the result to the value #$00.
        bne     CheckLeftRightInput 		;If it's not equal to #$00, branch to a label called CheckLeftRightInput.
        lda     SpritePointer0 			;Load the value of a variable called SpritePointer0 into the accumulator.
        clc                 			;Clear the carry flag.
        sbc     #$d7       			;Subtract the value #$d7 from the accumulator with borrow.
        lsr     a          			;Shift the result one bit to the right.
        tax                 			;Transfer the value in the accumulator to the X register.
        lda     L4508,x    			;Load the value at address L4508+x into the accumulator.
        cmp     #$ff       			;Compare the result to the value #$ff.
        beq     CheckLeftRightInput 		;If it's equal to #$ff, branch to a label called CheckLeftRightInput.
        clc                 			;Clear the carry flag.
        adc     #$e0       			;Add the value #$e0 to the accumulator with carry.
        jsr     L2D8D      			;Jump to a subroutine called L2D8D.
        lda     #$02       			;Load the value #$02 into the accumulator.
        ora     SpriteEnableRegister 		;Perform a bitwise OR operation with the value of a variable called SpriteEnableRegister.
        sta     SpriteEnableRegister 		;Store the result in the variable called SpriteEnableRegister.
        lda     Sprite0XPosition 		;Load the value of a variable called Sprite0XPosition into the accumulator.
        sta     Sprite1XPositionRegister 	;Store the result in a variable called Sprite1XPositionRegister.
        lda     Sprite0YPos 			;Load the value of a variable called Sprite0YPos into the accumulator.
        sta     Sprite1YPosition 		;Store the result in a variable called Sprite1YPosition.
        lda     SpriteXMSBRegister 		;Load the value of a variable called SpriteXMSBRegister into the accumulator.
        and     #$01       			;Perform a bitwise AND operation with the value #$01.
        tay                 			;Transfer the result to the Y register.
        lda     SpriteXMSBRegister 		;Load the value of a variable called SpriteXMSBRegister into the accumulator.
        and     #$fd       			;Perform a bitwise AND operation with the value #$fd.
        sta     SpriteXMSBRegister 		;Store the result in the variable called SpriteXMSBRegister.
        tya                			;Transfer the value in the Y register to the accumulator.
        asl     a          			;Shift the result one bit to the left.
        ora     SpriteXMSBRegister 		;Perform a bitwise OR operation with the value of the variable called SpriteXMSBRegister.
        jsr     Sub_2F00   			;Jump to a subroutine called Sub_2F00.

CheckLeftRightInput				; $c819
        lda     L450d   			; Load the value at address $450d into the accumulator.
        cmp     #$01       			; Compare it to the value #$01. Seems to always be #00.
        beq     +    				; If it's equal to #$01, branch to a label called +.
        lda     Var_MovingLeftRight 		; Load the value of a variable called Var_MovingLeftRight into the accumulator.
        cmp     #$00       			; Compare it to the value #$00 (#01 moving left or right / #00 not moving left or right).
        beq     _rts 			        ; If no left/right input, return from the subroutine.
+  	inc     Var_RegMovingLeftRight 	        ; Increment the value of a variable called Var_RegMovingLeftRight.
        lda     Var_RegMovingLeftRight 		; Load the value of a variable called Var_RegMovingLeftRight into the accumulator.
        cmp     Var_GoSlowRedZone 		; Compare it to the value of a variable called Var_GoSlowRedZone.
        bne     _rts 			        ; If it's not equal, return from the subroutine.
        lda     #$00       			; Load the value #$00 into the accumulator.
        sta     Var_RegMovingLeftRight 		; Store it in a variable called Var_RegMovingLeftRight.
        jmp     Jump_5980  			; Jump to a label called Jump_5980.
        .byte   $29,$03,$aa,$e8,$8a 		; Undocumented instructions.
_rts    rts               			; Return from the subroutine.

        .byte   $ea,$ea,$ea,$ad,$3c,$03,$ae,$3d,$03,$20,$00,$c9,$60 ;Undocumented instructions.


;*****************************
;* Get Inputs                *
;*****************************
Sub_GetInputs
        lda     #$00                    	; A = #00
        sta     Var_UpInput             	; Set Var_UpInput to #00
        lda     L4511                   	; Load the value at memory address $4511 into the accumulator (A)
        cmp     #$01                    	; Compare A with #01
        beq     If_C861                 	; Branch if A is equal to #01
        lda     #$00                    	; A = #00
        sta     Var_DownInput           	; Set Var_DownInput to #00
        sta     Var_LeftRightInput      	; Set Var_LeftRightInput to #00
If_C861 lda     Var_KeyboardInput      		; Load Var_KeyboardInput into the accumulator (A)
        cmp     #$40                    	; Compare A with #40
        beq     If_C8AB                 	; Branch if no keyboard input
        lda     #$00                    	; A = #00
        sta     Var_DownInput           	; Set Var_DownInput to #00
        sta     Var_LeftRightInput      	; Set Var_LeftRightInput to #00
        lda     Var_KeyboardInput       	; Load Var_KeyboardInput into the accumulator (A)
        cmp     L4512                   	; Compare A with the value at memory address $4512
        bne     If_C87B                 	; Branch if not equal
        lda     #$ff                    	; A = #ff
        sta     Var_DownInput           	; Set Var_DownInput to #ff
If_C87B lda     Var_KeyboardInput      		; Load Var_KeyboardInput into the accumulator (A)
        cmp     L4512                   	; Compare A with the value at memory address $4512
        bne     If_C887                 	; Branch if not equal
        lda     #$ff                    	; A = #ff
        sta     Var_DownInput           	; Set Var_DownInput to #ff
If_C887 lda     Var_KeyboardInput      		; Load Var_KeyboardInput into the accumulator (A)
        cmp     L4513                   	; Compare A with the value at memory address $4513
        bne     If_C893                 	; Branch if not equal
        lda     #$01                    	; A = #01
        sta     Var_DownInput           	; Store #01 to Var_DownInput
If_C893 lda     Var_KeyboardInput      		; Load Var_KeyboardInput into the accumulator (A)
        cmp     L4514                   	; Compare A with the value at memory address $4514
        bne     If_C89F                 	; Branch if not equal
        lda     #$ff                    	; A = #ff
        sta     Var_LeftRightInput      	; Store #ff (Left) to Var_LeftRightInput
If_C89F lda     Var_KeyboardInput      		; Load Var_KeyboardInput into the accumulator (A)
        cmp     L4515                   	; Compare A with the value at memory address $4515
        bne     If_C8AB                 	; Branch if not equal
        lda     #$01                    	; A = #01
        sta     Var_LeftRightInput      	; Store #01 (Right) to Var_LeftRightInput
If_C8AB lda     $028d                  		; Load the value at memory address $028D into the accumulator (A)
        cmp     #$00                    	; Compare A with #00
        beq     CheckJoyUp   				; Branch if equal, go to CheckJoyUp
        lda     #$01                    	; A = #01
        sta     Var_UpInput             	; Set Var_UpInput to #01

CheckJoyUp
        jsr     Sub_ResetMovementVars   	; Reset movement variables and get port A input (Left = 7b / Right = 77 / Up = 7e / Down = 7d / No input = 7f)
        and     #$01                    	; Isolate first bit
        cmp     #$01                    	; Compare to see if the bit is true
        beq     CheckJoyDown                    ; Branch if up is not pressed
        lda     #$01                    	; A = #01
        sta     Var_UpInput             	; Store #01 to Var_UpInput
CheckJoyDown 
	lda     InputPortA             	        ; Get Port A inputs
        and     #$02                    	; Isolate second bit
        cmp     #$02                    	; Check if second bit is set
        beq     CheckJoyLeft                    ; Branch if down is not pressed
        lda     #$01                    	; A = #01
        sta     Var_DownInput           	; Store #01 to Var_DownInput
CheckJoyLeft 
		lda     InputPortA             	; Get Port A inputs
        and     #$04                    	; Isolate third bit
        cmp     #$04                    	; Check if third bit is set
        beq     CheckJoyRight                   ; Branch if left is not pressed
        lda     #$ff                    	; A = #ff
        sta     Var_LeftRightInput      	; Store #ff (Left) to Var_LeftRightInput
CheckJoyRight 
		lda     InputPortA             	; Get Port A inputs
        and     #$08                    	; Isolate fourth bit
        cmp     #$08                    	; Check if fourth bit is set
        beq     _rts                		; Branch to RTS if right is not pressed
        lda     #$01                    	; A = #01
        sta     Var_LeftRightInput      	; Store #01 (Right) to Var_LeftRightInput
_rts
        rts                             	; Return from subroutine


;*****************************
;* End Get Inputs            *
;*****************************
        .byte   $00
        .byte   $dc
        .byte   $29
        .byte   $10
        .byte   $c9
        .byte   $10
        .byte   $f0
        .byte   $05
        .byte   $a9
        .byte   $01
        .byte   $8d
        .byte   $05
        .byte   $5a
        .byte   $60
Var_SpriteDirection
        .byte   $03
Var_SpriteNumber
        .byte   $05

Sub_UpdateSpritePositions
        ldy     #$ff       		        ; Y = #ff. X = Sprite Number / A = Direction (00 = up / 01 = down / 02 = left / 03 = right)
        sta     Var_SpriteDirection 	        ; Store sprite movement direction to Var_SpriteDirection
        stx     Var_SpriteNumber 	        ; Store sprite number to Var_SpriteNumber
        txa                		        ; Transfer sprite number (X) to A
        clc                		        ; Clear carry
        asl     a          		        ; Multiply by 2
        tax                		        ; Transfer sprite number (A) to X
        lda     Var_SpriteDirection 	        ; Load A with sprite direction
        cmp     #$00       		        ; Check if movement is up
        beq     DecreaseYposition 	        ; Branch if sprite should move up
        cmp     #$01       		        ; Check if movement is down
        beq     IncreaseYposition 	        ; Branch if sprite should move down
        cmp     #$02       		        ; Check if movement is left
        beq     DecreaseXPosition 	        ; Branch if sprite should move left
        cmp     #$03       		        ; Check if movement is right
        beq     IncreaseXPosition 	        ; Branch if sprite should move right
        rts                		        ; Return from subroutine

DecreaseYposition
        lda     Sprite0YPos,x 	                ; Load Sprite Y position
        cmp     #$32       		        ; Sets when to stop updating sprite (Top of screen / score)
        beq     _rts 			        ; Branch if near top of screen
        dec     Sprite0YPos,x 		        ; Increase vertical position on screen
        ldy     #$00       		        ; Y = #00
_rts    rts                		        ; Return from subroutine

IncreaseYposition
        lda     Sprite0YPos,x 		        ;Load Sprite Y position
        cmp     #$e3       		        ;Lowest point a sprite can go down the screen
        beq     _rts 			        ;Branch if at lowest point
        inc     Sprite0YPos,x 		        ;Deccrease vertical position on screen
        ldy     #$00       		        ;Y = #00
_rts	rts                		        ;Return from subroutine

DecreaseXPosition
        lda     Sprite0XPosition,x 	        ;Load Sprite X position
        cmp     #$08       		        ;Compare sprite position to #08 (Left hand boundary).
        bne     IF_DecreaseXMSBPosition         ;Branch if not on left hand boundary
        ldy     Var_SpriteNumber
        lda     Var_SpriteMSBOn,y 	        ;Load MSB enable check
        and     SpriteXMSBRegister 	        ;Check if sprite is on right hand side of MSB
        cmp     #$00       		        ;Check the outcome of the check
        bne     IF_DecreaseXMSBPosition         ;Branch as sprite is on right hand side of MSB
        ldy     #$ff       		        ;Y = #ff
        rts                		        ;Return from subroutine

IF_DecreaseXMSBPosition
        dec     Sprite0XPosition,x 	        ;Move sprite left on screen
        lda     Sprite0XPosition,x 	        ;Load X position
        cmp     #$ff       		        ;Compare X position to #ff
        bne     _rts 			        ;Branch if not going over the MSB line
        ldy     Var_SpriteNumber 	        ;Load sprite number
        lda     Var_SpriteMSBOff,y 	        ;Load the binary for setting the MSB value
        and     SpriteXMSBRegister 	        ;Toggle the X Position MSB value
        sta     SpriteXMSBRegister 	        ;Update the X position MSB value
_rts    ldy     #$00       		        ;Y = #00
        rts                		        ;Return from subroutine

IncreaseXPosition
        lda     Sprite0XPosition,x 	        ;Load Sprite X position
        cmp     #$4f       		        ;Compare sprite position to #4f (Right hand boundary).
        bne     IF_IncreaseXMSBPosition
        ldy     Var_SpriteNumber 	        ;Load sprite number
        lda     Var_SpriteMSBOn,y 	        ;Load MSB enable check
        and     SpriteXMSBRegister 	        ;Check if sprite is on right hand side of MSB
        cmp     #$00       		        ;Check the outcome of the check
        beq     IF_IncreaseXMSBPosition         ;Branch if sprite is on left hand side of MSB
        ldy     #$ff       		        ;Y = #ff
        rts                		        ;Return from subroutine

IF_IncreaseXMSBPosition
        inc     Sprite0XPosition,x 	        ;Move sprite right on screen
        lda     Sprite0XPosition,x 	        ;Load X position
        cmp     #$00       		        ;Compare X position to #00
        bne     _rts 			        ;Branch if not over the MSB line
        ldy     Var_SpriteNumber 	        ;Load sprite number
        lda     Var_SpriteMSBOn,y 	        ;Load the binary for setting the MSB value
        ora     SpriteXMSBRegister 	        ;Toggle the X Position MSB value
        sta     SpriteXMSBRegister 	        ;Update the X position MSB value
_rts    ldy     #$00       		        ;Y = #00
        rts               		        ;Return from subroutine

        .byte   $ea,$ea,$ea,$ee,$14,$d0,$ae,$14,$a9,$00,$8d,$04,$cf,$a9,$00,$8d
        .byte   $05,$cf,$ee,$05,$cf,$ad,$05,$cf,$c9,$ff,$d0,$f6,$ee,$04,$cf,$ad
        .byte   $04,$cf,$c9,$01,$d0,$e7,$60,$ea,$ea,$ea

Sub_ResetMovementVars
        lda     InputPortA 			;Load joystick input (Left = 7b / Right = 77 / Up = 7e / Down = 7d / No input = 7f)
        and     #$0f       			;AND on input recieved
        cmp     #$0f       			;Check if no input received
        beq     +    				;Branch if no input received
        lda     Var_KeyboardInput 		;Not sure what $c5 is used for
        cmp     #$40
        bne     +
        lda     #$00				; A = #00
        sta     Var_DownInput 			;Reset down input
        sta     Var_LeftRightInput 		;Reset left/right input
+ 		lda     InputPortA 		;Load port A inputs
        rts

        .byte   $ea
        .byte   $ea
Var_SpriteMSBOff
        .byte   $fe
        .byte   $fd
        .byte   $fb
        .byte   $f7
        .byte   $ef
        .byte   $df
        .byte   $bf
        .byte   $7f
Var_SpriteMSBOn
        .byte   $01
        .byte   $02
        .byte   $04
        .byte   $08
        .byte   $10
        .byte   $20
        .byte   $40
        .byte   $80

; SUBROUTINE: LC9F1 - Perform a custom XOR operation using an index address based on the value at LCF14 and memory location $a2
; This subroutine increments the value at LCF14, then performs an XOR operation between the value
; at LC000+X (where X is the value from LCF14) and the value at memory location $a2. The result
; of this operation is transferred to the Y register, and the X register is set to #$20 before
; returning from the subroutine.
LC9F1   
    ; Increment LCF14 and load its value into X register
    inc     LCF14                               ; Increment the value stored at LCF14
    ldx     LCF14                               ; Load the value stored at LCF14 into X register

    ; Perform EOR operation between the value at LC000+X and the value at $a2
    lda     LC000,x                             ; Load the value stored at LC000+X into A register
    eor     $a2                                 ; Perform an XOR operation between the value in A and the value in $a2

    ; Transfer the result to Y register and set X register to #$20
    tay                                         ; Transfer the result from A register to Y register
    ldx     #$20                                ; Load the value #$20 into X register

    ; Return from subroutine
    rts                                         ; Return from subroutine




LCA00   jsr     Branch_DamageBorderColour
        jsr     L5800
LCA06   cmp     #$08
        bne     If_CA12
        lda     #$00			        ; A = #00
        sta     Var_SomethingRandom 		;Var_SomethingRandom = #00
        jsr     LC700
If_CA12 inc     Var_SomethingElseRandom
        lda     Var_SomethingElseRandom
LCA18   cmp     #$20       			;Value ($ca19) get modified by code
        bne     If_CA24
        lda     #$00				; A = #00
        sta     Var_SomethingElseRandom
        jsr     LC71B
If_CA24 jmp     L2D4B

LCA27   lda     #$00                            ; Load the value #$00 into the accumulator (A).
        sta     Var_CurrentEnemyIndex           ; Initialize Var_CurrentEnemyIndex with the value in the accumulator (0).

_LCA2C  lda     Var_CurrentEnemyIndex           ; Load the value of Var_CurrentEnemyIndex into the accumulator (A).
        jsr     LCDE9                           ; Call subroutine at LCDE9, which might perform some operation on the current enemy.

        inc     Var_CurrentEnemyIndex           ; Increment Var_CurrentEnemyIndex to move on to the next enemy.

        lda     Var_CurrentEnemyIndex           ; Load the updated value of Var_CurrentEnemyIndex into the accumulator (A).
        cmp     #$05                            ; Compare the accumulator value with #$05 (5 in decimal).
        bne     _LCA2C                          ; If the value in the accumulator is not equal to 5, branch to _LCA2C to process the next enemy.

        jsr     LCCF5                           ; Call subroutine at LCCF5, which might perform operations after all enemies have been processed.

        jsr     LCE87                           ; Call subroutine at LCE87, which might perform additional operations related to enemies or game state.

        lda     LCF81                           ; Load the value stored at LCF81 into the accumulator (A). It might be a flag or variable.

        cmp     #$01                            ; Compare the value in the accumulator with #$01 (1 in decimal).
        bne     If_CA51                         ; If the value in the accumulator is not equal to 1, branch to If_CA51.

        lda     #$00                            ; Load the value #$00 into the accumulator (A).
        sta     LCF81                           ; Set the value at LCF81 to 0, possibly resetting the flag or variable.

        jmp     LC694                           ; Jump to the label LC694 to continue with the next set of operations.


If_CA51 jsr     LC011                           ;Not sure what this does as it never goes into subroutine
        jsr     Sub_StartEnemyUpdate
        lda     LCF7F
        cmp     #$ff
        bne     If_CA61
        jmp     Sub_SetInterruptsAndMem         ;Never seems to go into here

If_CA61 jmp     LCA00

LCA64   lda     Var_MovingLeftRight,x
        and     SpriteEnableRegister
        beq     RTS_CA6F
        jsr     LC37A
RTS_CA6F
        rts

LCA70   lda     LCF4F,x
        cmp     #$01
        beq     If_CA7D
        lda     L454E,x
        jmp     LCD17

If_CA7D jmp     If_CD55

        .byte   $20,$e1,$2b,$ea,$ea,$ea,$a9,$fc,$8d,$f8,$07,$ad,$88,$45,$8d,$ff
        .byte   $ff,$ad,$89,$45,$8d,$ff,$ff,$ad,$8a,$45,$8d,$ff,$ff,$a9,$00,$8d
        .byte   $60,$cf,$a9,$00,$8d,$63,$cf,$ad,$60,$cf,$a8,$b9,$8b,$45,$a8,$b9
        .byte   $00,$c3,$8d,$ff,$ff,$b9,$40,$c3,$8d,$ff,$ff,$a9,$20,$8d,$65,$cf
        .byte   $a9,$40,$8d,$66,$cf,$20,$e7,$c6,$ee,$63,$cf,$ad,$63,$cf,$c9,$08
        .byte   $f0,$06,$ee,$60,$cf,$4c,$a7,$ca,$ad,$f8,$07,$c9,$ff,$f0,$06,$ee
        .byte   $f8,$07,$4c,$a2,$ca,$ac,$88,$45,$88,$4c,$f9,$ca,$60

Jump_CAED
        dec     LCF7C
        lda     #$01
        sta     SpriteEnableRegister
        jsr     Sub_56BC
        rts

        .byte   $8c,$ff,$ff,$4c,$da,$ce,$ea,$60,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
        .byte   $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$60
Counter_Enemy
        .byte   $01

Sub_EnemyMSB
        sta     Counter_Enemy                   ;Rotates between #00-04
                                                ;*****************************
                                                ;* Level 1                   *
                                                ;* Spider 1 = 1              *
                                                ;* Spider 2 = 2              *
                                                ;* Spider 3 = 3              *
                                                ;* Skeleton = 4              *
                                                ;* Climber  = 5              *
                                                ;*****************************
        tax                                     ;Transfer A to X (Enemy counter)
        asl     a                               ;Multiply A by 2 (Allows for offset for X/Y sets)
        tay                                     ;Transfer A to Y (Enemy counter X2)
                                                ;*****************************
                                                ;* Level 1                   *
                                                ;* Enemy 00 (Spider)   = #00 *
                                                ;* Enemy 01 (Spider)   = #05 *
                                                ;* Enemy 02 (Spider)   = #0a *
                                                ;* Enemy 03 (Skeleton) = #0f *
                                                ;* Enemy 00 (Climber)  = #14 *
                                                ;*****************************
        lda     LCF0D,x                         ;A = cf0d,x (X is the enemy counter)
        tax                                     ;Transfer A to X (A reference to the data)
        lda     Var_EnemyXPosition,x            ;Get X starting position
        sta     Adr_EnemyXPosition,y            ;Set X starting position
        lda     Var_EnemyYPosition,x            ;Get Y starting position
        sta     Adr_EnemyYPosition,y            ;Set Y starting position
        ldy     Counter_Enemy                   ;Y = Enemy counter
        lda     Var_BinaryEnemyNum,y            ;Load the binary for setting the MSB value
        eor     #$ff                            ;Reverse selection
        and     SpriteXMSBRegister              ;Keep MSB sprites enabled and disable active sprite
        sta     SpriteXMSBRegister              ;Update SpriteXMSBRegister
        lda     Adr_EnemyMSBXPosition,x
        ora     SpriteXMSBRegister
        sta     SpriteXMSBRegister              ;Update SpriteXMSB
        nop					; No operation.
        lda     Adr_EnemyMSBXPosition+1,x
        cmp     #$00
        beq     LCBBB                           ;This is branched on all enemies except climbing guy
        jsr     LC9F1
LCB5C   lda     #$00                            ;A = #00
        sta     LCF12                           ;$cf12 = 00
Jump_CB61
        ldx     Counter_Enemy                   ;X = Active enemy
        lda     LCF0D,x
        tax
        lda     LCF12
        cmp     Adr_EnemyMSBXPosition+1,x
        beq     If_CB8B
        dey
        cpy     #$00
        beq     LCBBB
        inc     LCF12
        lda     #$03                            ;Set direction as right
        sty     LCF13
        ldx     Counter_Enemy                   ;Load enemy number
        inx                                     ;Increase X (Jump to next enemy)
        inx                                     ;Increase X (Jump to next enemy)
        jsr     Sub_UpdateSpritePositions       ;A = Sprite / X = Direction (00 = up / 01 = down / 02 = left / 03 = right)
        ldy     LCF13
        jmp     Jump_CB61

If_CB8B lda     Counter_Enemy
        tax
        asl     a
        sty     LCF13
        tay
        lda     LCF0D,x
        tax
        lda     Var_EnemyXPosition,x
        sta     Adr_EnemyXPosition,y
        ldy     Counter_Enemy
        lda     Var_BinaryEnemyNum,y
        eor     #$ff
        and     SpriteXMSBRegister
        sta     SpriteXMSBRegister
        lda     Adr_EnemyMSBXPosition,x
        ora     SpriteXMSBRegister
        sta     SpriteXMSBRegister
        ldy     LCF13
        jmp     LCB5C

; Level 1
; Enemy 00 (Spider)   = #00
; Enemy 01 (Spider)   = #05
; Enemy 02 (Spider)   = #0a
; Enemy 03 (Skeleton) = #0f
; Enemy 00 (Climber)  = #14
LCBBB   lda     Adr_EnemyMSBXPosition+2,x
        cmp     #$00
        beq     RTS_CC0D
        jsr     LC9F1                           ;Doesnt seem to be executed
LCBC5   lda     #$00
        sta     LCF12
Jump_CBCA
        ldx     Counter_Enemy
        lda     LCF0D,x
        tax
        lda     LCF12
        cmp     Adr_EnemyMSBXPosition+2,x
        beq     If_CBF4
        dey
        cpy     #$00
        beq     RTS_CC0D
        inc     LCF12
        lda     #$01
        sty     LCF13
        ldx     Counter_Enemy
        inx
        inx
        jsr     Sub_UpdateSpritePositions       ;A = Sprite / X = Direction (00 = up / 01 = down / 02 = left / 03 = right)
        ldy     LCF13
        jmp     Jump_CBCA

If_CBF4 lda     Counter_Enemy
        tax
        asl     a
        sty     LCF13
        tay
        lda     LCF0D,x
        tax
        lda     Var_EnemyYPosition,x
        sta     Adr_EnemyYPosition,y
        ldy     LCF13
        jmp     LCBC5

RTS_CC0D
        rts

        .byte   $ea
        .byte   $ea
        .byte   $ea
Temp_CurrentEnemy
        .byte   $03

Sub_CC12
        sta     Temp_CurrentEnemy               ;A = Enemy index
        tax                                     ;Transfer A to X
        lda     LCF15,x                         ;A = $cf15,x (Not sure what A is loaded with)
        ldx     Temp_CurrentEnemy               ;X = Temp_CurrentEnemy
        jmp     Jump_CC81

LCC1F   ldx     Temp_CurrentEnemy
        inc     LCF1A,x
        lda     LCF1A,x
        cmp     #$08
        beq     If_CC2D
        rts

If_CC2D lda     #$00
        sta     LCF1A,x
        lda     L453D,x
        cmp     #$00
        beq     If_CC3C
        jmp     Jump_CC65

If_CC3C lda     L574A+20,x
        sta     Low_tempvar
        lda     LCF24,x
        sta     High_tempvar
        lda     LCF29,x
        tay
        inc     LCF29,x
        lda     (Low_tempvar),y
        nop					; No operation.
        nop					; No operation.
        cmp     #$ff
        bne     If_CC61
        lda     #$01
        ldx     Temp_CurrentEnemy
        sta     LCF29,x
        ldy     #$00
        lda     (Low_tempvar),y
If_CC61 sta     LCF15,x
        rts

Jump_CC65
        jsr     LC9F1
        tya
        and     #$3f
        tay
        ldx     Temp_CurrentEnemy
        lda     L574A+20,x
        sta     Low_tempvar
        lda     LCF24,x
        sta     High_tempvar
        lda     (Low_tempvar),y
        sta     LCF15,x
        rts

        .fill   2,$ea

Jump_CC81
        tay                                     ;Transfer A to Y
        ldx     Temp_CurrentEnemy               ;X = Temp_CurrentEnemy
        inx                                     ;Increase X
        inx                                     ;Increase X
        jsr     LCA64
        cpy     #$ff
        bne     If_CCA4
        ldx     Temp_CurrentEnemy
        lda     L4538,x
        cmp     #$00
        bne     If_CCA4
        jsr     LCEEE
        eor     #$ff
        and     SpriteEnableRegister
        sta     SpriteEnableRegister
        rts

If_CCA4 jmp     LCC1F

        .byte   $ea,$ea,$ea,$aa

LCCAB   inc     LCF2E,x        			; Increment the value at address LCF2E+x. The index ranges from #00 to #04 (possibly iterating through enemy indices).
        lda     LCF2E,x        			; Load the value at address LCF2E+x into the accumulator (A).
        cmp     Var_Sprite3Speed,x  	        ; Compare the value in the accumulator with the value in Var_Sprite3Speed indexed by X.
        bne     If_CCBF        			; Branch to label If_CCBF if the values are not equal ($cf2e,x != Var_Sprite3Speed).
        lda     #$00           			; Load the value #$00 into the accumulator (A).
        sta     LCF2E,x        			; Store the value in the accumulator (0) at address LCF2E+x, effectively resetting it.
        txa                    			; Transfer the value in the X register (enemy index) to the accumulator (A).
        jsr     Sub_CC12       			; Call the subroutine at Sub_CC12, which might perform some operation related to the enemy or object.

If_CCBF inc     LCF97,x        			; Increment the value at address LCF97+x.
        lda     LCF97,x        			; Load the value at address LCF97+x into the accumulator (A).
        cmp     #$10           			; Compare the value in the accumulator with #$10 (16 in decimal).
        bne     RTS_CCF2       			; Branch to label RTS_CCF2 if the values are not equal.
        lda     #$00           			; Load the value #$00 into the accumulator (A).
        sta     LCF97,x        			; Store the value in the accumulator (0) at address LCF97+x, effectively resetting it.
        ldx     Var_CurrentEnemyIndex           ; Load the value of Var_CurrentEnemyIndex into the X register.
        inc     LCF33,x        			; Increment the value at address LCF33+x.
        lda     LCF33,x        			; Load the value at address LCF33+x into the accumulator (A).
        cmp     L54E5,x        			; Compare the value in the accumulator with the value at address L54E5 indexed by X.
        bne     RTS_CCF2       			; Branch to label RTS_CCF2 if the values are not equal.
        lda     #$00           			; Load the value #$00 into the accumulator (A).
        sta     LCF33,x        			; Store the value in the accumulator (0) at address LCF33+x, effectively resetting it.
        lda     SpritePointers,x   		; Load the value at address SpritePointers indexed by X into the accumulator (A).
        inc     SpritePointers,x   		; Increment the value at address SpritePointers indexed by X.
        cmp     LCF38,x        			; Compare the value in the accumulator with the value at address LCF38 indexed by X.
        bne     RTS_CCF2       			; Branch to label RTS_CCF2 if the values are not equal.
        lda     LCF3D,x        			; Load the value at address LCF3D+x into the accumulator (A).
        sta     SpritePointers,x   		; Store the value in the accumulator (A) at address SpritePointers indexed by X.

RTS_CCF2
        rts                    			; Return from the subroutine.


        .fill   2,$ea

LCCF5   lda     SpriteEnableRegister            ;A = SpriteEnableRegister
        and     #$80                            ;Isolate girl
        cmp     #$00                            ;Check if girl is visible
        beq     If_CD01                         ;Branch if girl not visible
        jmp     If_CD55

If_CD01 jsr     LCD7B
        cpy     L4553
        bpl     If_CD55
If_CD09 jsr     LC9F1
        tya
        and     #$07
        cmp     #$05
        bpl     If_CD09
        tax
        jmp     LC000

LCD17   cmp     #$04
        beq     If_CD55
        sta     LCF44
        lda     SpriteEnableRegister
        ora     #$80
        sta     SpriteEnableRegister
        lda     L454D
        sta     $d02e
        txa
        asl     a
        tax
        lda     Adr_EnemyXPosition,x
        sta     $d00e
        lda     Adr_EnemyYPosition,x
        sta     SpriteXMSBRegister-1
        txa
        lsr     a
        tax
        lda     #$7f
        and     SpriteXMSBRegister
        sta     SpriteXMSBRegister
        and     LCF46,x
        cmp     #$00
        beq     If_CD55
        lda     #$80
        ora     SpriteXMSBRegister
        sta     SpriteXMSBRegister
If_CD55 inc     LCF45
        lda     LCF45
        cmp     L4554
        bne     RTS_CD79
        lda     #$00				; A = #00
        sta     LCF45
        lda     LCF44
        ldx     #$07
        jsr     Sub_UpdateSpritePositions       ;A = Sprite / X = Direction (00 = up / 01 = down / 02 = left / 03 = right)
        cpy     #$ff
        bne     RTS_CD79
        lda     SpriteEnableRegister
        and     #$7f
        sta     SpriteEnableRegister
RTS_CD79
        rts

        .byte   $ea

LCD7B   jsr     LC9F1
        tya
        and     #$7f
        sta     LCF4C
        jsr     LC9F1
        tya
        and     #$7f
        cmp     #$78
        bpl     If_CD93
        ldy     #$7f
        jmp     RTS_CD96

If_CD93 ldy     LCF4C
RTS_CD96
        rts

        .byte   $ea,$ea,$ea,$4c,$87,$ce

LCD9D   lda     Var_SpriteCollision 	        ; Load the value at Var_SpriteCollision into the accumulator (A).
        and     #$02       			; Perform a bitwise AND operation with #$02 to isolate the second bit, which might represent the girl's collision information.
        bne     If_CDA6    			; Branch to label If_CDA6 if the collision is related to the second bit (Girl's collision).
        jmp     RTS_CD96   			; Jump to the label RTS_CD96 and return from the subroutine if the collision is not related to the second bit.


If_CDA6 ldx     #$00                            ;X = #00
        ldy     #$00                            ;Y = #00
IF_CDAA lda     LCF46,x
        and     Var_SpriteCollision
        beq     If_CDB2
        iny
If_CDB2 inx
        cpx     #$05
        bne     IF_CDAA
        cpy     #$00
        bne     If_CDBE
        jmp     RTS_CD96

If_CDBE ldx     #$02
        jsr     Update_DamageOccuring
        rts

        .byte   $da,$da,$da,$ad,$4d,$cf,$c9,$04,$f0,$05,$e8,$4a,$4c,$ca,$cd,$8e
        .byte   $4e,$cf,$bd,$56,$45,$f0,$0d,$4c,$fa,$cd,$a2,$02,$20,$44,$5b,$60
        .byte   $01,$4c,$02,$ce,$60

LCDE9   tax                                     ; Transfer the value in the accumulator (A) to the X register. This will rotate between #00-#04 (possibly iterating through enemy indices).
        lda     LCF4F,x                         ; Load the value at address LCF4F+x into the accumulator (A). This might represent a property or status of the enemy indexed by X.
        cmp     #$01                            ; Compare the value in the accumulator with #$01 (1 in decimal).
        beq     +                               ; If the value in the accumulator is equal to 1, branch to the next code block (marked as '+'). However, this branch is never taken as the values are always #00.
        jmp     LCCAB                           ; If the value in the accumulator is not equal to 1, jump to the label LCCAB, which could represent an alternative set of operations.
+       jmp     LC607                           ; '+' - Jump to the label LC607. This part of the code is never executed, as the branch condition is never met (values are always #00).


        .byte   $ea,$ea,$ea,$bd,$4f,$cf,$c9,$01,$d0
LCE00   .byte   $dd,$60,$9d,$4f,$cf,$a9,$fd,$2d,$15,$d0,$8d,$15,$d0,$4c,$6b,$ce
        .byte   $60

Sub_UpdateScore
        ldx     #$06                            ;X = #06
-       inc     $0405,x    			;Update score character
        lda     $0405,x    			;A = updated score character value
        cmp     #$ba       			;Check if character is over 9
        bne     + 				;Exit if not over 9
        lda     #$b0       			;A = #b0
        sta     $0405,x    			;Update character to 0
        dex                			;Decrease X (Go to next character in score)
        cpx     #$00       			;Check if character is 0
        bne     - 				;Branch if not equal 0
+       rts

        .byte   $a2,$06,$de,$05,$04,$bd,$05,$04,$c9,$af,$d0,$0d,$a9,$b9,$9d,$05
        .byte   $04,$ca,$e0,$00,$d0,$ec,$20,$11,$ce,$60

LCE42   lda     Counter_ScoreUpdate3            ;A = $cf5c
        sta     Temp_Something1+1               ;$ce53 = $cf5c (#11)
-       lda     Counter_ScoreUpdate1            ;A = $cf5a
        cmp     #$00
        beq     +
        dec     Counter_ScoreUpdate1
Temp_Something1
        jsr     Sub_UpdateScore
        jmp     -
+ 		lda     Counter_ScoreUpdate2
        cmp     #$00
        beq     +
        dec     Counter_ScoreUpdate2
        lda     #$ff
        sta     Counter_ScoreUpdate1
        jmp     Temp_Something1
+       rts

        .byte   $ae,$4e,$cf,$bd,$60,$45,$8d,$5a,$cf,$bd,$65,$45,$8d,$5b,$cf,$bd
        .byte   $6a,$45,$8d,$5c,$cf,$20,$42,$ce,$60,$ea,$ea,$ea

LCE87   lda     Adr_SpriteCollision   	        ; Load the value at Adr_SpriteCollision into the accumulator (A).
        sta     Var_SpriteCollision             ; Store the value in the accumulator (A) into Var_SpriteCollision.

        and     #$01                            ; Perform a bitwise AND operation with #$01 to isolate the boy's collision information.
        bne     +                               ; Branch as the boy has had a collision.

        jmp     LCD9D                           ; Jump to check if the girl has a collision.

+       lda     Var_SpriteCollision             ; Load the value at Var_SpriteCollision into the accumulator (A).

        and     #$02                            ; Perform a bitwise AND operation with #$02 to isolate the girl's collision information.
        beq     +                               ; Branch to the next code block (marked as '+') since the girl does not have a collision.

        rts                                     ; Return from the subroutine if the girl has a collision.

+       ldx     #$00                            ; Set the X register to #00, initializing it.
        ldy     #$00                            ; Set the Y register to #00, initializing it.

-       lda     LCF46,x                         ; Load the value at address LCF46+x into the accumulator (A). This will increase through each enemy (#04, #08, #10, #20, #40).
        and     Var_SpriteCollision             ; Perform a bitwise AND operation with Var_SpriteCollision to check if the selected sprite caused a collision.
        beq     +                               ; Branch to the next code block (marked as '+') if the selected enemy caused a collision.

        iny                                     ; Increment the Y register. This is used to confirm that an enemy was found.

+       inx                                     ; Increment the X register.
        cpx     #$06					; Compare the value in the X register to #$06 (6 in decimal), since there are only 5 enemies.
        bne     -                               ; Loop back to '-' if not at the final enemy.

        cpy     #$01                            ; Compare the value in the Y register to #$01 (1 in decimal) to check if an enemy was found.
        beq     +                               ; Branch to the next code block (marked as '+') if an enemy was found.

        rts                                     ; Return from the subroutine if no enemy was found.

+       lda     Var_SpriteCollision             ; Load the value at Var_SpriteCollision into the accumulator (A).
        and     #$fc                            ; Perform a bitwise AND operation with #$fc to isolate enemy sprites only.
        sta     Temp_EnemyCollidedBin           ; Store the value in the accumulator (A) into Temp_EnemyCollidedBin.

        ldx     #$00                            ; Set the X register to #00, initializing it.

-       cmp     #$04                            ; Compare the value in the accumulator (A) to #$04 (4 in decimal) to check the enemy number.
        beq     +                               ; Branch to the next code block (marked as '+') if the selected enemy is found.

        inx                                     ; Increment the X register (enemy number).
        lsr     a                               ; Perform a logical shift right operation on the accumulator (A), effectively dividing the value by 2.
        jmp     -                               ; Loop back to '-'.

+       stx     Temp_EnemyCollidedInt           ; Store the value in the X register into Temp_EnemyCollidedInt.
        ldx     #$02                            ; Set the X register to #02.
        jsr     Update_DamageOccuring           ; Perform damage routine.

        jmp     LCD9D

        .byte   $6f,$45,$29,$01,$d0,$04,$60,$4c,$7b,$2f,$4c,$a7,$2f,$20,$ed,$ca
        .byte   $ce,$1a,$04,$ad,$1a,$04,$c9,$b0,$f0,$01,$60,$a9,$01,$8d,$7d,$cf
        .byte   $60

LCEEE   inc     LCF76,x
        lda     Var_BinaryEnemyNum,x
        rts

        .byte   $ea

LCEF6   sta     $d027 		                ; Sprite #0 color
        lda     L45EC
        jmp     Jump_CAED

Var_CurrentEnemyIndex
        .byte   $05
        .byte   $00
        .byte   $ea
Var_SomethingRandom
        .byte   $7f
Var_SomethingElseRandom
        .byte   $06,$00,$06
Var_MovingLeftRight                             ; $cf06 (#01 moving left or right / #00 not moving left or right).
        .byte   $00
Var_RegMovingLeftRight
        .byte   $00
Var_BinaryEnemyNum
        .byte   $04
        .byte   $08
        .byte   $10
        .byte   $20
        .byte   $40
LCF0D   .byte   $00
        .byte   $05
        .byte   $0a
        .byte   $0f
        .byte   $14
LCF12   .byte   $0f
LCF13   .byte   $01
LCF14   .byte   $a9
LCF15   .byte   $03
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $02
LCF1A   .byte   $07
        .byte   $02
        .byte   $04
        .byte   $00
        .byte   $06
        .byte   $ea
        .byte   $ea
        .byte   $ea
        .byte   $20
        .byte   $11
LCF24   .byte   $4a
LCF25   .byte   $4a
LCF26   .byte   $4a
LCF27   .byte   $4a
LCF28   .byte   $4a
LCF29   .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
LCF2E   .byte   $1c
        .byte   $01
        .byte   $09
        .byte   $01
        .byte   $09
LCF33   .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $00
LCF38   .byte   $a3
LCF39   .byte   $a7
LCF3A   .byte   $97
LCF3B   .byte   $93
LCF3C   .byte   $3b
LCF3D   .byte   $a0
LCF3E   .byte   $a4
LCF3F   .byte   $94
LCF40   .byte   $90
LCF41   .byte   $38
        .byte   $0d
LCF43   .byte   $3c
LCF44   .byte   $02
LCF45   .byte   $2f
LCF46   .byte   $04,$08,$10,$20,$40,$80
LCF4C   .byte   $49,$10,$02
LCF4F   .fill   5,$00
LCF54   .byte   $40,$08,$04,$08,$04,$0a
Counter_ScoreUpdate1
        .byte   $00
Counter_ScoreUpdate2
        .byte   $00
Counter_ScoreUpdate3
        .byte   $11
        .byte   $48
Temp_EnemyCollidedBin
        .byte   $20
Temp_EnemyCollidedInt
        .byte   $03
        .byte   $0b,$00,$ea,$04,$ea
LCF65   .byte   $ff
LCF66   .byte   $00
LCF67   .byte   $00
LCF68   .byte   $a0
LCF69   .byte   $a4
LCF6A   .byte   $94
LCF6B   .byte   $90
LCF6C   .byte   $38,$ba,$c1,$c8,$cf,$d6,$ea
LCF73   .byte   $00
LCF74   .byte   $00
LCF75   .byte   $c1
LCF76   .byte   $c6,$c6,$14,$00,$c6,$40
LCF7C   .byte   $b3
Var_GameOverFlag   .byte   $00
        .byte   $02
LCF7F   .byte   $00
        .byte   $ea
LCF81   .byte   $00
LCF82   .byte   $0a
        .byte   $0a,$0a,$0a,$0a,$0f,$00,$01,$00,$00,$00,$01,$00,$00,$01,$00,$01
        .byte   $00,$00,$00,$00
LCF97   .byte   $02
        .byte   $01,$05,$04,$08
Var_Sprite3Speed
        .byte   $20
        .fill   3,$20
LCFA0   .byte   $20
LCFA1   .byte   $8c
        .byte   $85,$96,$85,$8c
LCFA6   .byte   $a0
LCFA7   .byte   $b0
LCFA8   .byte   $b0
LCFA9   .byte   $b1
Txt_GameOver
		.byte   $87,$81,$8d,$85,$a0,$8f,$96,$85,$92
		.byte	$ec,$ec,$ec,$ed,$ec,$ec,$ec,$ed,$ec,$ed,$ed,$ed,$ed

Sub_GameOverText 				; Run when game over
        jsr     Sub_5733
        ldx     #$00
- 		lda     LCFA1,x			; Pointless code.
        lda     $0617,x				; Pointless code.
        lda     $d81a				; Pointless code.
        lda     #$01 				; A = #01 (Will be used to change character to white).
        nop					; No operation.								; No operation.
        sta     $d838,x				; Change color of character to white.
        lda     Txt_GameOver,x 			; Load text for "Game Over" text.
        sta     $0438,x				; Store "Game Over" text to screen.
        inx					; Increase X for loop.
        cpx     #$09				; Check if up to ninth character
        bne     -				; Continue loop if not completed.
        rts					; Return from subroutine.

        .byte   $33,$57,$00,$00,$ee,$ec,$ed,$ee,$ed,$ed,$ed,$ed,$ed,$ed,$ed,$ed
        .byte   $ee,$f2,$f2,$f2,$32,$f1,$f1,$f1,$20,$f1,$f1,$f0,$f1,$ef,$ef,$01
