L60B5 	lda     #$03
        cmp     $02
        bne     _L60C7
        ldx     $02ac
        dex
        stx     $d404
        lda     #$50
        sta     $d40b
_L60C7  jmp     $ea31

Sub_SIDSetup 
		lda     #$00
        sta     $02
        sta     $02ff
        ldx     #$20
_L60D3  sta     $d400,x
        dex
        bne     _L60D3
        lda     #$f8
        sta     $b7
        sta     $b9
        lda     #$61
        sta     $b8
        sta     $ba
        jsr     L60A0
        sei
        lda     #$f5
        sta     $0314
        lda     #$60
        sta     $0315
        cli
        rts

        ldy     #$00
        cmp     $02
        beq     _L6100
        dec     $02
        jmp     L60B5

_L6100  inc     $b7
        bne     _L6106
        inc     $b8
_L6106  lda     ($b7),y
        sta     _L610B+1
_L610B  jmp     _L6174

        jsr     L61E9
        sta     $d401
        jsr     L61E9
        sta     $d400
        lda     $02ac
        sty     $d404
        sta     $d404
        jmp     _L6100

        jsr     L61E9
        sta     $d408
        jsr     L61E9
        sta     $d407
        lda     $02ad
        sty     $d40b
        sta     $d40b
        jmp     _L6100

        jsr     L61E9
        sta     $d401
        jsr     L61E9
        sta     $d400
        jsr     L61E9
        sta     $d408
        jsr     L61E9
        sta     $d407
        sty     $d404
        sty     $d40b
        lda     $02ac
        sta     $d404
        lda     $02ad
        sta     $d40b
        jmp     _L6100

        jsr     L61E9
        sta     $02aa
        jmp     $ea31

_L6174  lda     $02aa
        sta     $02
        jmp     $ea31

        inc     $02ff
        jmp     $ea31

        jsr     L61E9
        sta     $02ac
        jsr     L61E9
        sta     $02ad
        jmp     _L6100

        jsr     L61E9
        sta     $d405
        jsr     L61E9
        sta     $d40c
        jsr     L61E9
        sta     $d406
        jsr     L61E9
        sta     $d40d
        jmp     _L6100

        jsr     L61E9
        sta     $d402
        jsr     L61E9
        sta     $d403
        jsr     L61E9
        sta     $d409
        jsr     L61E9
        sta     $d40a
        jmp     _L6100

        lda     $b9
        sta     $b7
        lda     $ba
        sta     $b8
        jmp     $ea31

Sub_DisableMusic
		lda     #$00
        ldx     #$20
_L61D6  sta     $d400,x
        dex
        bne     _L61D6
        sei
        lda     #$31
        sta     $0314
        lda     #$ea
        sta     $0315
        cli
        rts

L61E9  	inc     $b7
        bne     _L61EF
        inc     $b8
_L61EF  lda     ($b7),y
        rts

        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $dd
        .byte   $91
        .byte   $07
        .byte   $07
        .byte   $58
        .byte   $7a
        .byte   $6b
        .byte   $06
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $02
        .byte   $82
        .byte   $41
        .byte   $21
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
				   
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $43
        .byte   $0f
        .byte   $74
				   
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $43
        .byte   $0f
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $26
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
        .byte   $74
        .byte   $82
        .byte   $41
        .byte   $41
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $54
        .byte   $7d
        .byte   $74
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $74
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $43
        .byte   $0f
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $26
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $26
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
				   
				   
        .byte   $74
        .byte   $26
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
				   
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $08
        .byte   $91
        .byte   $07
        .byte   $03
        .byte   $58
        .byte   $38
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $0e
        .byte   $03
        .byte   $bb
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $25
        .byte   $a2
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $03
        .byte   $bb
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
				   
				   
				   
				   
				   
				   
				   
        .byte   $2a
				   
        .byte   $3e
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $00
        .byte   $91
        .byte   $07
        .byte   $05
        .byte   $58
        .byte   $58
        .byte   $0e
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $2c
        .byte   $c1
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $03
        .byte   $bb
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $03
				   
        .byte   $23
        .byte   $2c
        .byte   $c1
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $3b
        .byte   $be
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $91
        .byte   $07
        .byte   $08
        .byte   $58
        .byte   $aa
        .byte   $00
        .byte   $00
				   
				   
				   
				   
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $3b
        .byte   $be
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $38
        .byte   $63
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
				   
				   
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $86
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $02
        .byte   $91
        .byte   $07
        .byte   $03
        .byte   $58
        .byte   $38
        .byte   $0e
        .byte   $03
        .byte   $bb
				   
				   
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $03
        .byte   $bb
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $03
        .byte   $91
        .byte   $07
        .byte   $05
        .byte   $58
        .byte   $68
        .byte   $0e
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $03
        .byte   $bb
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $03
        .byte   $23
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $3b
        .byte   $be
        .byte   $74
        .byte   $74
        .byte   $ac
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $04
        .byte   $91
        .byte   $07
        .byte   $07
        .byte   $78
        .byte   $7a
        .byte   $3e
        .byte   $04
        .byte   $30
        .byte   $3b
        .byte   $be
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $26
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $0b
        .byte   $30
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $30
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $82
        .byte   $11
        .byte   $21
        .byte   $91
        .byte   $07
        .byte   $07
        .byte   $78
        .byte   $78
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $3e
        .byte   $02
        .byte   $5f
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
				   
				   
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
				   
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $26
        .byte   $05
        .byte   $50
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $91
        .byte   $05
        .byte   $07
        .byte   $58
        .byte   $78
        .byte   $82
        .byte   $41
        .byte   $21
        .byte   $26
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $54
        .byte   $7d
        .byte   $02
        .byte   $5a
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $43
        .byte   $0f
        .byte   $74
        .byte   $3e
        .byte   $38
        .byte   $63
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $3e
        .byte   $3f
        .byte   $4b
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $3e
        .byte   $43
        .byte   $0f
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
				   
        .byte   $74
        .byte   $0e
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
				   
				   
				   
				   
        .byte   $74
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $3e
        .byte   $2c
        .byte   $c1
        .byte   $02
        .byte   $5a
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $3e
        .byte   $21
        .byte   $87
        .byte   $03
        .byte   $23
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
				   
				   
				   
				   
				   
				   
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $0e
        .byte   $21
        .byte   $87
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $0e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $0e
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $91
        .byte   $07
        .byte   $07
        .byte   $78
        .byte   $78
        .byte   $82
        .byte   $11
        .byte   $21
        .byte   $3e
        .byte   $1c
				   
				   
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
				   
        .byte   $23
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $26
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $74
				   
        .byte   $74
        .byte   $3e
        .byte   $1c
				   
				   
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $91
        .byte   $05
        .byte   $07
        .byte   $58
        .byte   $78
        .byte   $82
        .byte   $41
        .byte   $21
        .byte   $26
				   
        .byte   $02
				   
				   
        .byte   $18
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $54
        .byte   $7d
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
				   
        .byte   $43
        .byte   $0f
        .byte   $74
        .byte   $3e
        .byte   $3f
        .byte   $4b
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
				   
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $3e
        .byte   $3f
        .byte   $4b
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
				   
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $3e
        .byte   $43
				   
        .byte   $0f
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $0e
        .byte   $2a
				   
				   
        .byte   $3e
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $3e
				   
				   
        .byte   $2c
        .byte   $c1
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $3e
        .byte   $21
        .byte   $87
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $0e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $21
        .byte   $87
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $0e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $0e
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $82
        .byte   $11
        .byte   $21
				   
				   
				   
				   
				   
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
				   
				   
				   
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $26
        .byte   $05
        .byte   $98
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
				   
				   
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
				   
				   
				   
        .byte   $74
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $04
        .byte   $b4
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $82
        .byte   $41
        .byte   $21
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $26
        .byte   $03
        .byte   $bb
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $16
        .byte   $60
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
				   
				   
				   
				   
        .byte   $25
        .byte   $a2
        .byte   $07
        .byte   $77
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $38
        .byte   $63
        .byte   $03
        .byte   $bb
        .byte   $74
        .byte   $0e
        .byte   $4b
        .byte   $45
        .byte   $74
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $3e
        .byte   $59
        .byte   $83
        .byte   $04
        .byte   $30
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $0e
				   
				   
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $0e
				   
				   
				   
				   
				   
				   
        .byte   $1c
        .byte   $31
        .byte   $74
				   
				   
        .byte   $3e
        .byte   $16
        .byte   $60
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $26
        .byte   $03
        .byte   $23
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $0e
        .byte   $ef
        .byte   $74
        .byte   $0e
        .byte   $10
        .byte   $c3
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $3e
        .byte   $15
        .byte   $1f
        .byte   $06
        .byte   $47
        .byte   $74
        .byte   $0e
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
        .byte   $1c
        .byte   $31
        .byte   $74
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $3e
        .byte   $1d
        .byte   $df
        .byte   $04
        .byte   $30
				   
				   
				   
				   
        .byte   $74
        .byte   $0e
        .byte   $21
        .byte   $87
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
				   
				   
				   
				   
				   
				   
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $3e
        .byte   $2c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $0e
        .byte   $1d
        .byte   $df
        .byte   $74
        .byte   $82
        .byte   $11
        .byte   $21
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $26
				   
        .byte   $05
        .byte   $50
				   
				   
				   
				   
				   
				   
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $c1
        .byte   $02
        .byte   $18
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $02
        .byte   $5a
        .byte   $74
        .byte   $74
				   
				   
				   
        .byte   $74
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $04
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
				   
        .byte   $b4
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $82
        .byte   $41
        .byte   $21
        .byte   $00
        .byte   $26
        .byte   $03
        .byte   $f4
        .byte   $74
        .byte   $0e
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $0e
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $07
        .byte   $e9
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $25
        .byte   $a2
        .byte   $03
        .byte   $f4
        .byte   $74
        .byte   $0e
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $1a
        .byte   $9c
        .byte   $05
        .byte   $47
        .byte   $74
        .byte   $0e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $0e
        .byte   $21
        .byte   $87
        .byte   $74
        .byte   $0e
        .byte   $1a
        .byte   $9c
        .byte   $74
        .byte   $3e
        .byte   $15
        .byte   $1f
        .byte   $02
        .byte   $a3
        .byte   $74
        .byte   $0e
        .byte   $10
        .byte   $c3
        .byte   $74
        .byte   $3e
        .byte   $0d
        .byte   $4e
        .byte   $02
        .byte   $a3
        .byte   $74
        .byte   $0e
        .byte   $10
        .byte   $c3
        .byte   $74
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $15
        .byte   $1f
        .byte   $74
        .byte   $0e
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $0e
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $3e
        .byte   $21
        .byte   $87
        .byte   $02
        .byte   $cc
        .byte   $74
        .byte   $0e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $3e
        .byte   $2a
        .byte   $3e
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
        .byte   $2c
        .byte   $c1
        .byte   $74
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $03
        .byte   $23
        .byte   $74
        .byte   $0e
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $3e
        .byte   $3f
        .byte   $4b
        .byte   $03
        .byte   $86
        .byte   $74
        .byte   $0e
        .byte   $47
        .byte   $0c
        .byte   $74
        .byte   $3e
        .byte   $4b
        .byte   $45
        .byte   $03
        .byte   $86
        .byte   $74
        .byte   $0e
        .byte   $54
        .byte   $7d
        .byte   $74
        .byte   $91
        .byte   $99
        .byte   $99
        .byte   $a9
        .byte   $a9
        .byte   $82
        .byte   $41
        .byte   $41
        .byte   $ac
        .byte   $00
        .byte   $08
        .byte   $00
        .byte   $08
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $06
        .byte   $47
        .byte   $07
        .byte   $77
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $0c
        .byte   $08
        .byte   $61
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $77
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $3e
        .byte   $08
        .byte   $61
        .byte   $0a
        .byte   $8f
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $0b
        .byte   $30
        .byte   $74
        .byte   $3e
        .byte   $0a
        .byte   $8f
        .byte   $0c
        .byte   $8f
        .byte   $74
        .byte   $3e
        .byte   $0b
        .byte   $30
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $3e
        .byte   $0c
        .byte   $8f
        .byte   $0e
        .byte   $ef
        .byte   $74
        .byte   $3e
        .byte   $0e
        .byte   $18
        .byte   $10
        .byte   $c3
        .byte   $74
        .byte   $3e
        .byte   $0e
        .byte   $ef
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $3e
        .byte   $10
        .byte   $c3
        .byte   $15
        .byte   $1f
        .byte   $74
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $3e
        .byte   $15
        .byte   $1f
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $3e
        .byte   $16
        .byte   $60
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $23
        .byte   $86
        .byte   $91
        .byte   $55
        .byte   $55
        .byte   $57
        .byte   $57
        .byte   $74
        .byte   $c7
        .byte   $dd
        .byte   $dd
        .byte   $dd
        .byte   $91
        .byte   $0a
        .byte   $0a
        .byte   $aa
        .byte   $aa
        .byte   $6b
        .byte   $07
        .byte   $ac
        .byte   $00
        .byte   $08
        .byte   $00
        .byte   $08
        .byte   $82
        .byte   $21
        .byte   $21
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $3e
        .byte   $0f
        .byte   $d2
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $0f
        .byte   $d2
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $0f
        .byte   $d2
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $3e
        .byte   $15
        .byte   $1f
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $17
        .byte   $b5
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $15
        .byte   $1f
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $0f
        .byte   $d2
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $0e
        .byte   $18
        .byte   $23
        .byte   $86
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $3e
        .byte   $17
        .byte   $b5
        .byte   $23
        .byte   $86
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $17
        .byte   $b5
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $23
        .byte   $86
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $19
        .byte   $1e
        .byte   $1f
        .byte   $a5
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $1c
        .byte   $31
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $3e
        .byte   $0e
        .byte   $18
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $0e
        .byte   $18
        .byte   $2a
        .byte   $3e
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $12
        .byte   $d1
        .byte   $2f
        .byte   $6b
        .byte   $74
        .byte   $74
        .byte   $00
        .byte   $6b
        .byte   $04
        .byte   $3e
        .byte   $2a
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $74
        .byte   $3e
        .byte   $2f
        .byte   $6b
        .byte   $38
        .byte   $63
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $32
        .byte   $3c
        .byte   $3f
        .byte   $4b
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $38
        .byte   $63
        .byte   $47
        .byte   $0c
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $3f
        .byte   $4b
        .byte   $4b
        .byte   $45
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $47
        .byte   $0c
        .byte   $54
        .byte   $7d
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $4b
        .byte   $45
        .byte   $5e
        .byte   $d6
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $7c
        .byte   $74
        .byte   $d2
        .byte   $dd
        .byte   $dd
        .byte   $91
        .byte   $09
        .byte   $09
        .byte   $9a
        .byte   $9a
        .byte   $6b
        .byte   $09
        .byte   $ac
        .byte   $00
        .byte   $08
        .byte   $00
        .byte   $08
        .byte   $82
        .byte   $41
        .byte   $41
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $98
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $3e
        .byte   $06
        .byte   $47
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $11
        .byte   $c3
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $0c
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $15
        .byte   $1f
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $77
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $0e
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $3e
        .byte   $08
        .byte   $61
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $09
        .byte   $68
        .byte   $1d
        .byte   $df
        .byte   $74
        .byte   $3e
        .byte   $0a
        .byte   $8f
        .byte   $21
        .byte   $87
        .byte   $74
        .byte   $3e
        .byte   $0b
        .byte   $30
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $47
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $09
        .byte   $68
        .byte   $74
        .byte   $3e
        .byte   $05
        .byte   $98
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $0e
        .byte   $0e
        .byte   $18
        .byte   $74
        .byte   $3e
        .byte   $06
        .byte   $47
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $11
        .byte   $c3
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $0c
        .byte   $12
        .byte   $d1
        .byte   $74
        .byte   $0e
        .byte   $15
        .byte   $1f
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $77
        .byte   $16
        .byte   $60
        .byte   $74
        .byte   $0e
        .byte   $19
        .byte   $1e
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $0c
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $07
        .byte   $0c
        .byte   $1c
        .byte   $31
        .byte   $74
        .byte   $3e
        .byte   $04
        .byte   $b4
        .byte   $25
        .byte   $a2
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $74
        .byte   $7c
        .byte   $74
        .byte   $d2
        .byte   $dd
        .byte   $10
        .byte   $0c
        .byte   $00
        .byte   $3c
        .byte   $ff
        .byte   $f5
        .byte   $9e
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $ff
        .byte   $f1
        .byte   $fe
        .byte   $db
        .byte   $10
        .byte   $06
        .byte   $00
        .byte   $00
        .byte   $90
        .byte   $20
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $0a
        .byte   $fb
        .byte   $1f
        .byte   $ff
        .byte   $ff
        .byte   $fb
        .byte   $ff
        .byte   $a0
        .byte   $ff
        .byte   $f0
        .byte   $0f
        .byte   $df
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $b0
        .byte   $8f
        .byte   $df
        .byte   $ff
        .byte   $f7
        .byte   $00
        .byte   $df
        .byte   $8f
        .byte   $ff
        .byte   $ff
        .byte   $04
        .byte   $02
        .byte   $0f
        .byte   $5b
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $74
        .byte   $05
        .byte   $ff
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $10
        .byte   $f7
        .byte   $58
        .byte   $ff
        .byte   $9c
        .byte   $4b
        .byte   $00
        .byte   $00
        .byte   $24
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $d7
        .byte   $ff
        .byte   $ff
        .byte   $7f
        .byte   $ff
        .byte   $fd
        .byte   $00
        .byte   $00
        .byte   $8c
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $df
        .byte   $04
        .byte   $ff
        .byte   $75
        .byte   $eb
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $b5
        .byte   $00
        .byte   $ff
        .byte   $dd
        .byte   $ff
        .byte   $24
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $ff
        .byte   $db
        .byte   $f7
        .byte   $ff
        .byte   $9f
        .byte   $ff
        .byte   $df
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $10
        .byte   $ff
        .byte   $ff
        .byte   $f5
        .byte   $bf
        .byte   $04
        .byte   $7f
        .byte   $01
        .byte   $b2
        .byte   $80
        .byte   $00
        .byte   $f7
        .byte   $7f
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $4a
        .byte   $34
        .byte   $ff
        .byte   $fe
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $00
        .byte   $75
        .byte   $ff
        .byte   $a0
        .byte   $00
        .byte   $b4
        .byte   $da
        .byte   $4e
        .byte   $ff
        .byte   $b5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $be
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $08
        .byte   $ff
        .byte   $ff
        .byte   $82
        .byte   $00
        .byte   $ab
        .byte   $0a
        .byte   $45
        .byte   $00
        .byte   $8b
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $90
        .byte   $ba
        .byte   $84
        .byte   $00
        .byte   $8b
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $80
        .byte   $ff
        .byte   $ff
        .byte   $e5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $40
        .byte   $34
        .byte   $00
        .byte   $05
        .byte   $5f
        .byte   $80
        .byte   $ff
        .byte   $8f
        .byte   $00
        .byte   $ff
        .byte   $c5
        .byte   $00
        .byte   $0b
        .byte   $31
        .byte   $30
        .byte   $ff
        .byte   $df
        .byte   $d7
        .byte   $76
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $43
        .byte   $9f
        .byte   $06
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $24
        .byte   $ff
        .byte   $b1
        .byte   $90
        .byte   $20
        .byte   $00
        .byte   $20
        .byte   $ff
        .byte   $02
        .byte   $02
        .byte   $00
        .byte   $ff
        .byte   $80
        .byte   $b9
        .byte   $df
        .byte   $80
        .byte   $ff
        .byte   $90
        .byte   $0c
        .byte   $00
        .byte   $3c
        .byte   $ff
        .byte   $ef
        .byte   $df
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $ff
        .byte   $fd
        .byte   $ff
        .byte   $db
        .byte   $00
        .byte   $06
        .byte   $20
        .byte   $00
        .byte   $b0
        .byte   $30
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $6a
        .byte   $fb
        .byte   $0f
        .byte   $ff
        .byte   $ff
        .byte   $fb
        .byte   $ff
        .byte   $a0
        .byte   $ff
        .byte   $f0
        .byte   $0f
        .byte   $df
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $b4
        .byte   $8f
        .byte   $ff
        .byte   $ff
        .byte   $f7
        .byte   $00
        .byte   $df
        .byte   $cf
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $02
        .byte   $85
        .byte   $5b
        .byte   $00
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $e4
        .byte   $05
        .byte   $f5
        .byte   $ff
        .byte   $ef
        .byte   $bf
        .byte   $ff
        .byte   $10
        .byte   $f7
        .byte   $50
        .byte   $ff
        .byte   $94
        .byte   $6b
        .byte   $00
        .byte   $00
        .byte   $a4
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $87
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $f5
        .byte   $00
        .byte   $00
        .byte   $84
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $df
        .byte   $04
        .byte   $ff
        .byte   $f0
        .byte   $eb
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $b5
        .byte   $00
        .byte   $df
        .byte   $dd
        .byte   $ff
        .byte   $a4
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $ff
        .byte   $db
        .byte   $f7
        .byte   $ff
        .byte   $95
        .byte   $ff
        .byte   $df
        .byte   $ff
        .byte   $00
        .byte   $f7
        .byte   $ef
        .byte   $fb
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $e4
        .byte   $bf
        .byte   $00
        .byte   $7f
        .byte   $01
        .byte   $b0
        .byte   $80
        .byte   $00
        .byte   $ff
        .byte   $7f
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $0a
        .byte   $00
        .byte   $ff
        .byte   $fe
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $00
        .byte   $f1
        .byte   $ff
        .byte   $a0
        .byte   $00
        .byte   $b4
        .byte   $d8
        .byte   $44
        .byte   $ff
        .byte   $a5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $be
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $08
        .byte   $ff
        .byte   $ff
        .byte   $83
        .byte   $00
        .byte   $ab
        .byte   $0a
        .byte   $45
        .byte   $00
        .byte   $cb
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $90
        .byte   $ba
        .byte   $84
        .byte   $10
        .byte   $8b
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $80
        .byte   $ff
        .byte   $ff
        .byte   $e5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $c0
        .byte   $00
        .byte   $00
        .byte   $05
        .byte   $df
        .byte   $80
        .byte   $ff
        .byte   $8f
        .byte   $00
        .byte   $ff
        .byte   $c7
        .byte   $00
        .byte   $0b
        .byte   $31
        .byte   $30
        .byte   $ff
        .byte   $df
        .byte   $84
        .byte   $74
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $c0
        .byte   $9f
        .byte   $06
        .byte   $00
        .byte   $fd
        .byte   $ff
        .byte   $24
        .byte   $f7
        .byte   $a0
        .byte   $80
        .byte   $20
        .byte   $00
        .byte   $20
        .byte   $ff
        .byte   $02
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $80
        .byte   $b1
        .byte   $df
        .byte   $80
        .byte   $ff
        .byte   $90
        .byte   $0c
        .byte   $00
        .byte   $3c
        .byte   $ff
        .byte   $f5
        .byte   $de
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $ff
        .byte   $f1
        .byte   $fc
        .byte   $db
        .byte   $00
        .byte   $06
        .byte   $20
        .byte   $00
        .byte   $90
        .byte   $20
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $2a
        .byte   $fb
        .byte   $0f
        .byte   $ff
        .byte   $ff
        .byte   $fb
        .byte   $ff
        .byte   $a0
        .byte   $ff
        .byte   $f2
        .byte   $0f
        .byte   $df
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $b0
        .byte   $8f
        .byte   $ff
        .byte   $ff
        .byte   $f6
        .byte   $80
        .byte   $df
        .byte   $8f
        .byte   $ff
        .byte   $ff
        .byte   $44
        .byte   $00
        .byte   $4d
        .byte   $5f
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $f5
        .byte   $45
        .byte   $fd
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $10
        .byte   $f7
        .byte   $50
        .byte   $ff
        .byte   $dc
        .byte   $4b
        .byte   $00
        .byte   $00
        .byte   $54
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $d7
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $fd
        .byte   $00
        .byte   $40
        .byte   $cc
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $df
        .byte   $54
        .byte   $ff
        .byte   $fd
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $f5
        .byte   $00
        .byte   $df
        .byte   $dd
        .byte   $ff
        .byte   $f5
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $ff
        .byte   $db
        .byte   $f7
        .byte   $ff
        .byte   $9d
        .byte   $ff
        .byte   $df
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $50
        .byte   $ff
        .byte   $ff
        .byte   $f5
        .byte   $bf
        .byte   $04
        .byte   $7f
        .byte   $01
        .byte   $b0
        .byte   $91
        .byte   $00
        .byte   $ff
        .byte   $7f
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $4a
        .byte   $14
        .byte   $ff
        .byte   $fc
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $f5
        .byte   $ff
        .byte   $a0
        .byte   $00
        .byte   $b4
        .byte   $da
        .byte   $4c
        .byte   $ff
        .byte   $b5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $be
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $08
        .byte   $ff
        .byte   $ff
        .byte   $c2
        .byte   $00
        .byte   $ab
        .byte   $0a
        .byte   $45
        .byte   $00
        .byte   $8f
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $90
        .byte   $ba
        .byte   $84
        .byte   $10
        .byte   $8f
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $80
        .byte   $ff
        .byte   $ff
        .byte   $e5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $50
        .byte   $54
        .byte   $00
        .byte   $05
        .byte   $5f
        .byte   $80
        .byte   $ff
        .byte   $cf
        .byte   $00
        .byte   $ff
        .byte   $c5
        .byte   $00
        .byte   $0b
        .byte   $31
        .byte   $30
        .byte   $ff
        .byte   $df
        .byte   $d5
        .byte   $7c
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $10
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $51
        .byte   $df
        .byte   $06
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $04
        .byte   $ff
        .byte   $b1
        .byte   $90
        .byte   $20
        .byte   $00
        .byte   $20
        .byte   $ff
        .byte   $02
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $80
        .byte   $f9
        .byte   $df
        .byte   $80
        .byte   $ff
        .byte   $10
        .byte   $0c
        .byte   $00
        .byte   $3c
        .byte   $ff
        .byte   $ff
        .byte   $5f
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $ff
        .byte   $fd
        .byte   $fe
        .byte   $db
        .byte   $10
        .byte   $14
        .byte   $00
        .byte   $00
        .byte   $90
        .byte   $34
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $4a
        .byte   $fb
        .byte   $5f
        .byte   $ff
        .byte   $ff
        .byte   $fb
        .byte   $ff
        .byte   $a0
        .byte   $ff
        .byte   $f0
        .byte   $0f
        .byte   $df
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $fc
        .byte   $8f
        .byte   $df
        .byte   $ff
        .byte   $f7
        .byte   $40
        .byte   $df
        .byte   $df
        .byte   $ff
        .byte   $ff
        .byte   $40
        .byte   $00
        .byte   $4d
        .byte   $5b
        .byte   $00
        .byte   $cf
        .byte   $ff
        .byte   $ff
        .byte   $6c
        .byte   $45
        .byte   $f5
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $10
        .byte   $f7
        .byte   $58
        .byte   $ff
        .byte   $dc
        .byte   $4b
        .byte   $00
        .byte   $00
        .byte   $44
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $47
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $fd
        .byte   $00
        .byte   $40
        .byte   $cc
        .byte   $ff
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $df
        .byte   $44
        .byte   $ff
        .byte   $fb
        .byte   $ef
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $b5
        .byte   $00
        .byte   $df
        .byte   $dd
        .byte   $ff
        .byte   $64
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $ff
        .byte   $db
        .byte   $f7
        .byte   $ff
        .byte   $95
        .byte   $ff
        .byte   $df
        .byte   $ff
        .byte   $00
        .byte   $fb
        .byte   $ef
        .byte   $db
        .byte   $50
        .byte   $ff
        .byte   $ff
        .byte   $e4
        .byte   $bf
        .byte   $00
        .byte   $7f
        .byte   $01
        .byte   $f0
        .byte   $80
        .byte   $00
        .byte   $ff
        .byte   $7f
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $4a
        .byte   $40
        .byte   $ff
        .byte   $fc
        .byte   $00
        .byte   $fd
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $fe
        .byte   $ff
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $a0
        .byte   $00
        .byte   $3c
        .byte   $d8
        .byte   $4c
        .byte   $ff
        .byte   $a5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $be
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $08
        .byte   $ff
        .byte   $ff
        .byte   $c3
        .byte   $00
        .byte   $ab
        .byte   $0a
        .byte   $45
        .byte   $00
        .byte   $cb
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $90
        .byte   $ba
        .byte   $84
        .byte   $50
        .byte   $df
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $80
        .byte   $ff
        .byte   $ff
        .byte   $e5
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $ff
        .byte   $41
        .byte   $40
        .byte   $00
        .byte   $05
        .byte   $5f
        .byte   $80
        .byte   $ff
        .byte   $cf
        .byte   $00
        .byte   $ff
        .byte   $c5
        .byte   $00
        .byte   $0b
        .byte   $31
        .byte   $30
        .byte   $ff
        .byte   $df
        .byte   $84
        .byte   $7c
        .byte   $ff
        .byte   $ff
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $51
        .byte   $df
        .byte   $06
        .byte   $00
        .byte   $fd
        .byte   $ff
        .byte   $04
        .byte   $ff
        .byte   $a1
        .byte   $90
        .byte   $00
        .byte   $00
        .byte   $20
        .byte   $ff
        .byte   $02
        .byte   $02
        .byte   $00
        .byte   $ff
        .byte   $80
        .byte   $b1
        .byte   $df
        .byte   $80
        .byte   $ff
        .byte   $10
        .byte   $0c
        .byte   $00
        .byte   $3c
        .byte   $ff
        .byte   $fd
        .byte   $5f
        .byte   $00
        .byte   $ff
        .byte   $db
        .byte   $ff
        .byte   $f1
        .byte   $fc
        .byte   $db
        .byte   $00
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $90
        .byte   $64
        .byte   $ff
        .byte   $00
        .byte   $00
        .byte   $4a
        .byte   $fb
        .byte   $4f
        .byte   $ff
        .byte   $ff
        .byte   $fb
        .byte   $ff
        .byte   $a0
        .byte   $ff
        .byte   $f0
        .byte   $0f
        .byte   $df
        .byte   $00
        .byte   $71
        .byte   $ff
        .byte   $7c
        .byte   $8f
        .byte   $df
        .byte   $ff
        .byte   $f7
        .byte   $40
        .byte   $df
        .byte   $cf
        .byte   $ff
        .byte   $ff
        .byte   $50
        .byte   $84
        .byte   $f0
        .byte   $87
        .byte   $50
        .byte   $04
        .byte   $00
        .byte   $80
        .byte   $ff
        .byte   $83
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $88
        .byte   $01
        .byte   $07
        .byte   $80
        .byte   $e0
        .byte   $00
        .byte   $e2
        .byte   $e0
        .byte   $e0
        .byte   $00
        .byte   $f2
        .byte   $88
        .byte   $88
        .byte   $88
        .byte   $98
        .byte   $a4
        .byte   $88
        .byte   $88
        .byte   $88
        .byte   $98
        .byte   $a4
        .byte   $8b
        .byte   $8b
        .byte   $8b
        .byte   $9b
        .byte   $a7
        .byte   $02
        .byte   $03
        .byte   $04
        .byte   $05
        .byte   $06
        .byte   $23
        .byte   $26
        .byte   $19
        .byte   $20
        .byte   $80
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $08
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $0d
        .byte   $0d
        .byte   $00
        .byte   $26
        .byte   $46
        .byte   $1e
        .byte   $20
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $30
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $d7
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3f
        .byte   $10
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $11
        .byte   $de
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $b5
        .byte   $de
        .byte   $00
        .byte   $20
        .byte   $00
        .byte   $87
        .byte   $04
        .byte   $97
        .byte   $04
        .byte   $04
        .byte   $07
        .byte   $95
        .byte   $05
        .byte   $a4
        .byte   $06
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $05
        .byte   $00
        .byte   $00
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $8e
        .byte   $f0
        .byte   $91
        .byte   $50
        .byte   $04
        .byte   $00
        .byte   $8a
        .byte   $ff
        .byte   $8d
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $92
        .byte   $0b
        .byte   $02
        .byte   $e0
        .byte   $b0
        .byte   $00
        .byte   $e2
        .byte   $a0
        .byte   $70
        .byte   $00
        .byte   $f2
        .byte   $80
        .byte   $36
        .byte   $37
        .byte   $35
        .byte   $34
        .byte   $80
        .byte   $36
        .byte   $37
        .byte   $35
        .byte   $34
        .byte   $83
        .byte   $36
        .byte   $37
        .byte   $35
        .byte   $34
        .byte   $06
        .byte   $07
        .byte   $07
        .byte   $07
        .byte   $07
        .byte   $18
        .byte   $03
        .byte   $04
        .byte   $05
        .byte   $06
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $10
        .byte   $30
        .byte   $20
        .byte   $20
        .byte   $20
        .byte   $1e
        .byte   $24
        .byte   $6b
        .byte   $70
        .byte   $73
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $00
        .byte   $e0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $ff
        .byte   $00
        .byte   $50
        .byte   $00
        .byte   $00
        .byte   $d0
        .byte   $00
        .byte   $70
        .byte   $00
        .byte   $00
        .byte   $70
        .byte   $00
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $00
        .byte   $56
        .byte   $05
        .byte   $d1
        .byte   $05
        .byte   $f9
        .byte   $06
        .byte   $34
        .byte   $07
        .byte   $f6
        .byte   $06
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $05
        .byte   $02
        .byte   $78
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $98
        .byte   $f0
        .byte   $9b
        .byte   $50
        .byte   $04
        .byte   $00
        .byte   $94
        .byte   $ff
        .byte   $97
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $9c
        .byte   $0c
        .byte   $07
        .byte   $80
        .byte   $a0
        .byte   $00
        .byte   $e2
        .byte   $70
        .byte   $a3
        .byte   $00
        .byte   $f2
        .byte   $a0
        .byte   $84
        .byte   $90
        .byte   $3c
        .byte   $2c
        .byte   $a0
        .byte   $84
        .byte   $90
        .byte   $3c
        .byte   $2c
        .byte   $a3
        .byte   $87
        .byte   $93
        .byte   $3f
        .byte   $33
        .byte   $0b
        .byte   $0b
        .byte   $0b
        .byte   $05
        .byte   $0c
        .byte   $23
        .byte   $33
        .byte   $08
        .byte   $1f
        .byte   $08
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $10
        .byte   $10
        .byte   $20
        .byte   $10
        .byte   $10
        .byte   $1e
        .byte   $22
        .byte   $1e
        .byte   $22
        .byte   $22
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $00
        .byte   $e3
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $e0
        .byte   $08
        .byte   $00
        .byte   $10
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $b0
        .byte   $41
        .byte   $e1
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $80
        .byte   $51
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $a7
        .byte   $05
        .byte   $de
        .byte   $05
        .byte   $6d
        .byte   $05
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $05
        .byte   $04
        .byte   $b8
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $a2
        .byte   $f0
        .byte   $a5
        .byte   $50
        .byte   $04
        .byte   $00
        .byte   $9e
        .byte   $ff
        .byte   $a1
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $a6
        .byte   $01
        .byte   $0c
        .byte   $80
        .byte   $d0
        .byte   $00
        .byte   $e2
        .byte   $50
        .byte   $d0
        .byte   $00
        .byte   $f2
        .byte   $98
        .byte   $a0
        .byte   $9c
        .byte   $94
        .byte   $8c
        .byte   $98
        .byte   $a0
        .byte   $9c
        .byte   $94
        .byte   $8c
        .byte   $9b
        .byte   $a3
        .byte   $9f
        .byte   $97
        .byte   $8f
        .byte   $02
        .byte   $03
        .byte   $04
        .byte   $01
        .byte   $09
        .byte   $23
        .byte   $26
        .byte   $19
        .byte   $20
        .byte   $08
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $20
        .byte   $20
        .byte   $20
        .byte   $20
        .byte   $20
        .byte   $1e
        .byte   $1e
        .byte   $1e
        .byte   $22
        .byte   $22
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $00
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $60
        .byte   $00
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $60
        .byte   $00
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $60
        .byte   $41
        .byte   $80
        .byte   $20
        .byte   $00
        .byte   $60
        .byte   $50
        .byte   $80
        .byte   $40
        .byte   $00
        .byte   $60
        .byte   $e8
        .byte   $04
        .byte   $cb
        .byte   $06
        .byte   $e6
        .byte   $06
        .byte   $51
        .byte   $07
        .byte   $1e
        .byte   $05
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $05
        .byte   $06
        .byte   $08
        .byte   $42
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $ac
        .byte   $f0
        .byte   $af
        .byte   $50
        .byte   $04
        .byte   $00
        .byte   $a8
        .byte   $ff
        .byte   $ab
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $b0
        .byte   $01
        .byte   $09
        .byte   $80
        .byte   $e0
        .byte   $00
        .byte   $e2
        .byte   $90
        .byte   $e0
        .byte   $00
        .byte   $f2
        .byte   $9c
        .byte   $a4
        .byte   $98
        .byte   $90
        .byte   $8c
        .byte   $9c
        .byte   $a4
        .byte   $98
        .byte   $90
        .byte   $8c
        .byte   $9f
        .byte   $a7
        .byte   $9b
        .byte   $93
        .byte   $8f
        .byte   $00
        .byte   $03
        .byte   $04
        .byte   $08
        .byte   $06
        .byte   $1f
        .byte   $28
        .byte   $10
        .byte   $08
        .byte   $08
        .byte   $04
        .byte   $06
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $09
        .byte   $09
        .byte   $09
        .byte   $09
        .byte   $09
        .byte   $1e
        .byte   $20
        .byte   $1e
        .byte   $1e
        .byte   $22
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $4a
        .byte   $00
        .byte   $d0
        .byte   $00
        .byte   $00
        .byte   $20
        .byte   $20
        .byte   $f0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $d0
        .byte   $00
        .byte   $00
        .byte   $20
        .byte   $00
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $70
        .byte   $50
        .byte   $d0
        .byte   $40
        .byte   $00
        .byte   $80
        .byte   $a5
        .byte   $06
        .byte   $4f
        .byte   $05
        .byte   $86
        .byte   $06
        .byte   $ca
        .byte   $04
        .byte   $ce
        .byte   $04
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $e8
        .byte   $07
        .byte   $05
        .byte   $08
        .byte   $88
        .byte   $42
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
		 