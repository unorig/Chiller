
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
        sta     SpriteEnableRegister            ; Disable all sprites by storing #00 to the SpriteEnableRegister ($d015).
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
        lda     Adr_BorderColor                 ; Set A with Adr_BorderColor ($d020). At menu screen, the value is #f0.
        and     #$0f                            ; Perform an AND operation on the accumulator (A) with #0f. This will result in #00 for the menu screen border color.
        beq     +                               ; If the result is #00, jump to address $2dd3.
        jsr     CheckSetHighScore               ; Call the subroutine to check and set the high score.
+       jmp     JUMP_c646                       ; Jump to address JUMP_c646.


                                                ;*****************************
                                                ;* Main menu loop end        *
                                                ;*****************************
        .fill   33,$00
	.fill 	3,$ea