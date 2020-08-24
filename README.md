# Info

This is a port of the Wumbo language used in the CS536 compilers class at UW-Madison to the N64. It compiles to a piece of an assembly file, which is then combined with a library written directly in assembly for initialization and console routines.

Credit to PeterLemon/N64 for his HelloWorld and N64Input examples, which served as the skeletons for the library files.

# Changes from SPIM Wumbo

* `WriteStmtNode` (`cout <<`) and `ReadStmtNode` (`cin >>`) have been replaced with `PrintStmtNode` (`PrintLn`) and `ScanStmtNode` (`Scan`), to make more clear that they are implemented as primitives and not in fact writing to a standard input or output file (though this isn't how SPIM Wumbo works either). 
* PrintLn also supports selecting colors for the foreground and background of the text. The syntax of this color selection is `PrintLn(<exp>,background, foreground)`, where background and foreground are one of these 17 options:
    * Black
    * White
    * Black
    * Blue
    * Green
    * Cyan
    * Red
    * Magenta
    * Orange
    * LightGray
    * Gray
    * Purple
    * Indigo
    * Yellow
    * Brown
    * Lime
    * Slate
    * Pink
* Since the N64 does not have a keyboard peripheral as standard, button presses on the controller are instead used for Scan statements. Every A press increments the counter of the scanned value by 1, and a B press saves the current value.
* A separate assembler and tool to fix the checksum of the ROM is required to build a functioning ROM, so binaries have been included in a `tools` directory. They work on my personal machine and the CS lab machines, but I haven't tried them on anything else.

## Build Changes

* Use `make` to build the compiler.
* `make cmpl` creates an out.asm file that can be assembled and then CRC-checked with `chksum64`. (basically what `test` was before)
* `make rom` runs the `cmpl` step then assembles and `chksum64`'s it into a ROM usable by an emulator. By default it uses the `bass` and `chksum64` binaries included in the repo, but you can set the `WUMBO_TOOLS` environment variable to `SYSTEM` to use the binaries in your own path, in case you have them.
* `make play` runs an N64 emulator of your choice and plays the rom file. By default it tries to launch mupen64plus, but using the `WUMBO_EMU` environment variable this can be changed to the MAME emulator (`WUMBO_EMU=MAME`) or MAME with the debugging interface active (`WUMBO_EMU=MAME_DEBUG`). Additionally, a script has been included to automatically download a mupen64plus binary and installing it with your permission; run the script with `make installemu`.

# N64-specific notes/limitations

* No `Print` function, instead printing works on a line by line basis (`PrintLn`). This means that you cannot print two things without having a newline in between. There is also no word wrapping for the console so strings are limited to a certain number of characters.
* Code that makes use of button presses is not quite sensitive enough, sometimes button presses aren't fully registered. I'm not sure why this is, I'd have to look into it more.
* Main function exit might not work right. I can't imagine this would be an issue because right now Wumbo programs are built as one rom, with nothing running "after" them but if there was an operating system it was returning to it would probably not work because an important SPIM syscall was ripped out. At the moment when a program finishes it simply enters an endless loop which is the intended functionality.
* I haven't tested it on a real console because I don't have the equipment but the creator of the original HelloWorld demo has tested it on real hardware and it did work so I have reason to believe it should work.

# Code Examples

Code examples can be found in the `tests/` directory. At the moment, there are 4 examples (including the test.wumbo found at the root of this repository.)