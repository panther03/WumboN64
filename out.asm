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
include "LIB/N64_INPUT.INC" // Include N64 Definitions
include "INC/LIBWUMBO.INC" // Include Wumbo Helper Routines

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin = $A0100000
  InitController(PIF1) 

  PrintStringOG($A0100000, 0, 0, FontBlack, Greeting, 17) // Print Text String To VRAM Using Font At X,Y Position
  
  j main

	align(2)
_y:	
dw 0x00000000	// reserve 4 bytes
	align(2)
_a:	
dw 0x00000000	// reserve 4 bytes
	_f:
	sw    r31, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    r30, 0(sp)	//PUSH
	addiu sp, sp, -4
	addiu r30, sp, 12
	subiu sp, sp, 0
	lw    t0, 0(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 2
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 3
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	mult  t0, t1
	mflo  t0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	add   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    v0, 4(sp)	//POP
	addiu sp, sp, 4
	j     _L0
	nop
_L0:
	lw    r31, -4(r30)
	move  t0, r30
	lw    r30, -8(r30)
	move  sp, t0
	jr    r31
	nop
	_fac:
	sw    r31, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    r30, 0(sp)	//PUSH
	addiu sp, sp, -4
	addiu r30, sp, 12
	subiu sp, sp, 0
	
// if ((n(int) == 0))

	lw    t0, 0(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	seq   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	beq   t0, 0, ElseLab__L2
	nop
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    v0, 4(sp)	//POP
	addiu sp, sp, 4
	j     _L1
	nop
	b     DoneLab__L3
	nop
ElseLab__L2:
	lw    t0, 0(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 0(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sub   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	jal   _fac
	nop
	sw    v0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	mult  t0, t1
	mflo  t0
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    v0, 4(sp)	//POP
	addiu sp, sp, 4
	j     _L1
	nop
DoneLab__L3:
_L1:
	lw    r31, -4(r30)
	move  t0, r30
	lw    r30, -8(r30)
	move  sp, t0
	jr    r31
	nop
main:
	addiu r30, sp, 0
	addiu sp, r30, -4
	li    t0, 0x4d41494e
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	addiu r30, sp, 12
	subiu sp, sp, 4
	
// n(int) = 1;

	li    t0, 1
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
LoopLab__L5:
	lw    t0, -12(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 40
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	slt   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	beq   t0, 0, DoneLab__L6
	nop
	
// if ((n(int) > 20))

	lw    t0, -12(r30)
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	li    t0, 20
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t1, 4(sp)	//POP
	addiu sp, sp, 4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	sgt   t0, t0, t1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	beq   t0, 0, ElseLab__L7
	nop
	
// PrintLn(5);

	li    t0, 5
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, CURR_SCREEN_X, CURR_SCREEN_Y, FontBlack, 3, 10, t0)
	b     DoneLab__L8
	nop
ElseLab__L7:
	
// PrintLn(1);

	li    t0, 1
	sw    t0, 0(sp)	//PUSH
	addiu sp, sp, -4
	lw    t0, 4(sp)	//POP
	addiu sp, sp, 4
	PrintInt($A0100000, CURR_SCREEN_X, CURR_SCREEN_Y, FontBlack, 11, 5, t0)
DoneLab__L8:
	
// n(int)++;

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
	addiu t0, t0, 1
	sw    t0, 0(t1)	//INCREMENT
	b     LoopLab__L5
	nop
DoneLab__L6:
_L4:
	lw    r31, -4(r30)
	move  t0, r30
	lw    r30, -8(r30)
	move  sp, t0
	Loop:
	j Loop
	nop
Greeting:
  db "Welcome to Wumbo!",0x0
ContinueMsg:
  db "Press A to continue output.."

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

align(4)
CURR_SCREEN_X:
  dw 0x00000000
CURR_SCREEN_Y:
  dw 0x00000010

align(8)
PIF1:
  dw $FF010401,0
  dw 0,0
  dw 0,0
  dw 0,0
  dw $FE000000,0
  dw 0,0
  dw 0,0
  dw 0,1

PIF2:
  fill 64 // Generate 64 Bytes Containing $00

align(4) // Align 32-Bit
insert FontBlack, "INC/FontBlack8x8.bin"