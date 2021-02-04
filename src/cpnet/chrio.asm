; SNIOS plug-in for Noberto's H89 USB/SERIAL board,
; Specifically, the FT245R chip.
; http://koyado.com/Heathkit/H-89_USB_Serial.html
;
; Modified to support the Dual/SIO board for S100 
; buss.  See www.s100computers.com et.al for further
; details.
;
; NOTE:  this could be merged back into the original
; driver with conditional assembly, but I don't have a
; way to test the code on Noberto's H89 USB/SERIAL board.
;
	maclib	z80
	maclib	config

	public	sendby,check,recvby,recvbt

	cseg

; Destroys C
sendby:
	mov	c,a
sendb0:
	in	STSPORT	; read the status PIO port.
	ani	USBTXR
	jnz	sendb0	; loop forever.
	mov	a,c	; but really not that long (FIFO).
	out	USBPORT	; probably can't ever overrun?
	ret		; if not, should make this in-line

check:
	; do check for sane hardware...
;	lxi	h,0
; on my s100 machine the cpu runs at 8mhz
;	mvi	e,24	; approx 4.5 sec @18MHz
; this works on my machine, but the timout is not
; calibrated yet.
check0:
	stc
	cmc
	ret
;
	in	STSPORT	; 11
	ani	USBTXR	; 7, also NC
	rz		; 5 (11)
	dcx	h	; 6
	mov	a,h	; 4
	ora	l	; 4
	jnz	check0	; 10 = 47, * 65536 = 3080192 = 1.504 sec
	dcr	e	; 4
	jnz	check0	; 10
	stc
	ret

; When using this, each byte must be coming soon...
; Destroys C
; Returns character in A
recvby:
	push	b
	lxi	b,charTimeout
recvb0:
	in	STSPORT 	; test status bit
	ani	USBRXR		; but don't hang here
	jz	recvb1		; to long.
	dcx	b
	mov	a,b
	ora	c
	jnz	recvb0
	pop	b
	stc
	ret	; CY, timeout
recvb1:
	in	USBPORT		; get a byte (FIFO)
	pop	b
	ret

; Receive initial message bytes (e.g. "++")
; Must preserve all regs (exc. A)
; May return CY on timeout.
recvbt:
	push	b
	lxi	b,startTimeout
recvbt0:
	in	STSPORT
	ani	USBRXR
	jz	recvbt1
	dcx	b
	mov	a,b
	ora	c
	jnz	recvbt0
	pop	b
	stc
	ret	; CY, timeout
recvbt1:
	in	USBPORT
	pop	b
	ret

	end
