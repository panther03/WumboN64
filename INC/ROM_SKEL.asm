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

