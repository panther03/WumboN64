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