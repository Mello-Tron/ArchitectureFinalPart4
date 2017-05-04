# test_patrick.asm
# Author: Patrick Herbert
# Test MIPS instructions.

# Assembly Code					          #Machine Code #Comment
main:		addi  $t0, $0,  0x0001        #20080001     #t0 = 1
	        xori  $t1, $t0, 0x0000        #39090000     #t1 = (t0 xor 0) = 1
		slti  $t2, $t1, 0x0002            #292a0002     #(t1 is less than 2) so t2 = 1
		sll   $t3, $t2, 00001             #000a5840     #t3 = (t2 sll 1) = 2
		srl   $t2, $t3, 00001             #000b5042     #t2 = (t3 srl 1) = 1