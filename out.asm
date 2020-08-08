// Wumbo skeleton file
// Originally from:
// N64 'Bare Metal' 16BPP 320x240 Hello World Demo by krom (Peter Lemon)

arch n64.cpu
endian msb
output "out.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(320)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(2)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code
include "INC/LIBWUMBO.INC" // Include Wumbo Helper Routines

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin = $A0100000
  //PrintStringOG($A0100000, 128, 32, FontBlack, Text, 11) // Print Text String To VRAM Using Font At X,Y Position
  PrintStringOG($A0100000, 0, 0, FontBlack, Greeting, 17) // Print Text String To VRAM Using Font At X,Y Position
  
  j main

	align(2)
_p:	
dw 0x00000000	// reserve 4 bytes
	align(2)
_q:	
dw 0x00000000	// reserve 4 bytes
	align(2)
_c:	
dw 0x00000000	// reserve 4 bytes
	_print_c:
	sw    r31, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    r30, 0(sp)	//PUSH
	addiu sp, sp, -4
	addiu r30, sp, 8
	subiu sp, sp, 0
	
// PrintLn((c(int) + 1));

	la    a1, _c
	lw    t0, 0(a1)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	add   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 16, FontBlack, 1, 0, t0)
_L0:
	lw    r31, 0(r30)
	move  t0, r30
	lw    r30, -4(r30)
	move  sp, t0
	jr    r31
	nop
main:
	addiu r30, sp, 0
	addiu sp, r30, 0
	li    t0, 0x4d41494e
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	addiu r30, sp, 8
	subiu sp, sp, 8
	
// a(int) = 2;

	li    t0, 2
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 0
	addiu t0, r30, -8
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	
// if (true)

	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	beq   t0, 0, FalseLab__L2
	nop
	
// b(int) = 6;

	li    t0, 6
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 0
	addiu t0, r30, -12
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
LoopLab__L3:
	lw    t0, -12(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sge   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	beq   t0, 0, DoneLab__L4
	nop
	
// a(int) = (c(int) = (3 + a(int)));

	li    t0, 3
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, -8(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	add   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	la    t0, _c
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	li    t0, 0
	addiu t0, r30, -8
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	
// b(int)--;

	lw    t0, -12(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 0
	addiu t0, r30, -12
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	addiu t0, t0, -1
	sw    t0, 0(t1)	//DECREMENT
	b     LoopLab__L3
	nop
DoneLab__L4:
	
// PrintLn(b(int));

	lw    t0, -12(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 32, FontBlack, 1, 0, t0)
FalseLab__L2:
	jal   _print_c
	nop
	sw    v0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    v0, 4(sp)	//POP
	addiu sp, sp, 4
	
// PrintLn(a(int));

	lw    t0, -8(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 48, FontBlack, 1, 0, t0)
	
// p(bool) = (q(bool) = true);

	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	la    t0, _q
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	la    t0, _p
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(t1)	//ASSIGN
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	
// PrintLn((p(bool) || q(bool)));

	// OrNode start
	la    a1, _p
	lw    t0, 0(a1)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	li    t1, 0
	beq   t0, t1, FalseLab__L5
	nop
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	b     DoneLab__L6
	nop
FalseLab__L5:
	la    a1, _q
	lw    t0, 0(a1)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
DoneLab__L6:
	// OrNode end
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 64, FontBlack, 1, 0, t0)
	
// PrintLn((!(a(int) != c(int))));

	lw    t0, -8(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	la    a1, _c
	lw    t0, 0(a1)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sne   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	seq   t0, t0, 0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 80, FontBlack, 1, 0, t0)
	
// PrintLn((true && true));

	// AndNode start
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	li    t1, 1
	beq   t0, t1, TrueLab__L7
	nop
	li    t0, 0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	b     DoneLab__L8
	nop
TrueLab__L7:
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
DoneLab__L8:
	// AndNode end
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, 0, 96, FontBlack, 1, 0, t0)
	la    a1, _c
	lw    t0, 0(a1)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    v0, 4(sp)	//POP
	addiu sp, sp, 4
	j     _L1
	nop
_L1:
	lw    r31, 0(r30)
	move  t0, r30
	lw    r30, -4(r30)
	move  sp, t0
	Loop:
	j Loop
	nop
Greeting:
  db "Welcome to Wumbo!"

align(4)
FontColors:
  dh 0xFFFE
  dh 0x0000
  dh 0x0032
  dh 0x0400
  dh 0x07FF
  dh 0xF800
  dh 0xF8A4
  dh 0xFD00
  dh 0xD6B4
  dh 0x8420
  dh 0x8020
  dh 0x4820
  dh 0xFFC0
  dh 0xA14A
  dh 0x07C0
  dh 0x7B7A
  dh 0xFE32

align(4) // Align 32-Bit
insert FontBlack, "INC/FontBlack8x8.bin"