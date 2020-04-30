	.data
	.align 2
_y:	.space 4	# reserve 4 bytes
	.data
	.align 2
_x:	.space 4	# reserve 4 bytes
	.text
	.globl main
main:
__start:
	sw    $ra, 0($sp)	#PUSH
	subu  $sp, $sp, 4
	sw    $fp, 0($sp)	#PUSH
	subu  $sp, $sp, 4
	addiu $fp, $sp, 12
	addiu $sp, $sp, -8
	.data
.L1:	.asciiz "Hello World!"
	.text
	la    $t0, .L1
	sw    $t0, 0($sp)	#PUSH
	subu  $sp, $sp, 4
	lw    $a0, 4($sp)	#POP
	addu  $sp, $sp, 4
	li    $v0, 4
	syscall
.L0:
	lw    $ra, -4($fp)
	move  $t0, $fp
	lw    $ra, -8($fp)
	move  $sp, $t0
	li    $v0, 10
	syscall
