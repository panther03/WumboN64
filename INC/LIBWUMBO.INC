macro STACK_PUSH(register) {
	addiu sp, sp, -4
	sw {register}, 0(sp)
}

macro STACK_POP(register) {
	lw {register}, 0(sp)
	addiu sp, sp, 4
}


macro PrintInt(vram, xpos, ypos, fontfile, int) {
  //li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  //la a1,{fontfile} // A1 = Font Address
//
  //  ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    //ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter
   // 
    //move t3,{int} // T3 = Next Text Character
    //addiu t3,t3,48
//
  //  sll t3,7 // T3 *= 128 (Shift to Correct Position in Font)
    //addu t3,a1 // T3 += Font Address
//
  //  {#}DrawCharX:
    //  lh t4,0(t3) // Load Font Text Character Pixel
      //addiu t3,BYTES_PER_PIXEL
     // sh t4,0(a0) // Store Font Text Character Pixel into Frame Buffer
      //addiu a0,BYTES_PER_PIXEL

//      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
  //    subiu t1,1 // Decrement Character X Pixel Counter (Delay Slot)

    //  addiu a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      //ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      //bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      //subiu t2,1 // Decrement Character Y Pixel Counter (Delay Slot)

  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Font Address
  //ori t0,r0,{length} // T0 = Number of Text Characters to Print
  li a2, 10 // Divide by 10
  li a3, 0 // Digit counter
  move t4, {int}

  {#}PushDigits:
      div t4, a2 // T3 = Next text character
      mflo t4
      mfhi t3
      addiu t3, t3, 0x30
      STACK_PUSH(t3)
      addiu a3, 1  
      bne t4,r0,{#}PushDigits // Continue to Print Characters
  nop
  subiu a3, 1

  {#}DrawChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter

    STACK_POP(t3)

    sll t3,7 // T3 *= 128 (Shift to Correct Position in Font)
    addu t3,a1 // T3 += Font Address

    {#}DrawCharX:
      lh t5,0(t3) // Load Font Text Character Pixel
      addiu t3,BYTES_PER_PIXEL
      sh t5,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addiu a0,BYTES_PER_PIXEL

      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subiu t1,1 // Decrement Character X Pixel Counter (Delay Slot)

      addiu a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subiu t2,1 // Decrement Character Y Pixel Counter (Delay Slot)

    subiu a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char
    bnez a3,{#}DrawChars // Continue to Print Characters
    subiu a3,1 // Subtract Number of Text Characters to Print (Delay Slot)
  STACK_POP(t3)
}

macro PrintString(vram, xpos, ypos, fontfile) { // Print Text String To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Font Address
  //la a2,{string} // A2 = Text Address (Assumed to be set before calling macro)
  //ori t0,r0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter
    
    lbu t3,0(a2) // T3 = Next Text Character
    move t0, t3
    addiu a2,1 // Text Address++

    sll t3,7 // T3 *= 128 (Shift to Correct Position in Font)
    addu t3,a1 // T3 += Font Address

    {#}DrawCharX:
      lh t4,0(t3) // Load Font Text Character Pixel
      addiu t3,BYTES_PER_PIXEL
      sh t4,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addiu a0,BYTES_PER_PIXEL

      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subiu t1,1 // Decrement Character X Pixel Counter (Delay Slot)

      addiu a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subiu t2,1 // Decrement Character Y Pixel Counter (Delay Slot)

    subiu a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char
    bne t0, r0, {#}DrawChars // Continue to Print Characters if t0 is not 0
    nop
}

macro PrintStringOG(vram, xpos, ypos, fontfile, string, length) { // Print Text String To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Font Address
  la a2,{string} // A2 = Text Address
  ori t0,r0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter
    
    lbu t3,0(a2) // T3 = Next Text Character
    addiu a2,1 // Text Address++

    sll t3,7 // T3 *= 128 (Shift to Correct Position in Font)
    addu t3,a1 // T3 += Font Address

    {#}DrawCharX:
      lh t4,0(t3) // Load Font Text Character Pixel
      addiu t3,BYTES_PER_PIXEL
      sh t4,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addiu a0,BYTES_PER_PIXEL

      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subiu t1,1 // Decrement Character X Pixel Counter (Delay Slot)

      addiu a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subiu t2,1 // Decrement Character Y Pixel Counter (Delay Slot)

    subiu a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char
    bnez t0,{#}DrawChars // Continue to Print Characters
    subiu t0,1 // Subtract Number of Text Characters to Print (Delay Slot)
}