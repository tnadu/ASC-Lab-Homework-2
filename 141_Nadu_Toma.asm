.data
	formatScan: .asciz "%[^\n]s"
	formatPrintD: .asciz "%d "
	formatPrintS: .asciz "%s"
	delimitator: .asciz " "
	nline: .asciz "\n"
	sirInput: .space 1000
	n: .long 0
	m: .long 0
	x: .long 0
	c: .long 0
	aux: .long 0
	nPlus: .long 0
	nDe3: .long 0
	v: .space 400
	sol: .space 400
	
.text

.global main

input:	
	pushl $sirInput
	pushl $formatScan
	call scanf
	popl %ebx
	popl %ebx

	pushl $delimitator
	pushl $sirInput
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, n
	
	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, m
	
	movl n, %eax
	xorl %edx, %edx
	movl $3, %ebx
	mull %ebx
	movl %eax, nDe3
	movl %eax, %edx
	xorl %ecx, %ecx
	movl $v, %edi
for_input:
	cmp %edx, %ecx
	je main_cont
	
	pushl %ecx
	pushl %edx
	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	popl %edx
	popl %ecx
	
	pushl %ecx
	pushl %edx
	pushl %eax
	call atoi
	popl %ebx
	popl %edx
	popl %ecx
	
	movl %eax, (%edi, %ecx, 4)
	incl %ecx
	
	jmp for_input
	
output:
	movl nDe3, %eax
	xorl %edx, %edx
	xorl %ecx, %ecx
	movl $sol, %edi
for_output:
	cmp %ecx, %eax
	je output_cont
	
	pushl %eax
	pushl %ecx
	pushl (%edi, %ecx, 4)
	pushl $formatPrintD
	call printf
	popl %ebx
	popl %ebx
	popl %ecx
	popl %eax
	incl %ecx
	
	jmp for_output
output_cont:
	pushl $nline
	pushl $formatPrintS
	call printf
	popl %ebx
	popl %ebx

	jmp et_exit
		
punct_fix:
	
	popl %ebx
	movl (%edi, %edx, 4), %eax
	popl %edi
	popl %esi
	popl %ebp
	movl %ebx, aux
	popl %ebx 
	movl aux, %ebx
	popl %edx
	popl %ecx
	movl %eax, %ecx
	popl %eax
	jmp for_bk_true
	
punct_fix1:
	pushl %edi
	pushl %eax
	movl $v, %edi
	movl (%edi, %edx, 4), %eax
	cmp $0, %eax
	popl %eax
	popl %edi
	jne bk_exit
	jmp for_bk_cont
	
counter_false:
	movl $0, %eax
	jmp counter_exit
counter_inc:
	pushl %eax
	movl c, %eax
	incl %eax
	movl %eax, c
	popl %eax
	jmp for_counter_cont
counter:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %ecx
	movl %ecx, c
	movl 8(%ebp), %ecx
	pushl %esi
	pushl %edi
	movl $v, %edi
	movl $sol, %esi
	pushl %ebx
	xorl %ebx, %ebx
	movl nDe3, %eax
for_counter:
	cmp %eax, %ebx
	je counter_cont
	
	movl (%esi, %ebx, 4), %edx
	cmp %edx, %ecx
	je counter_inc
	movl (%edi, %ebx, 4), %edx
	cmp %edx, %ecx
	je counter_inc
for_counter_cont:
	incl %ebx
	jmp for_counter
counter_cont:
	movl c, %ebx
	cmp $3, %ebx
	je counter_false
	movl $1, %eax
counter_exit:
	popl %ebx
	popl %edi
	popl %esi
	popl %ebp
	ret	

conditie_fals:
	xorl %eax, %eax
	jmp conditie_exit
conditie_punct_fix:
	cmp %ecx, %ebx
	jne punct_fix
	jmp conditie_cont
conditie_start:
	xorl %eax, %eax
	jmp conditie_cont1
conditie_finish:
	movl %eax, %ebx
	jmp conditie_cont2
conditie_conditie:
	pushl %edx
	movl (%esi, %eax, 4), %edx
	cmp %edx, %ecx
	popl %edx
	je conditie_fals
	pushl %edx
	movl (%edi, %eax, 4), %edx
	cmp %edx, %ecx
	popl %edx
	je conditie_fals
	jmp for_conditie_cont
conditie:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %edx
	movl 12(%ebp), %ecx
	pushl %esi
	pushl %edi
	movl $v, %edi
	movl $sol, %esi
	pushl %ebx
	
	movl (%edi, %edx, 4), %ebx
	cmp $0, %ebx
	jne punct_fix
conditie_cont:
	movl %edx, %eax
	movl m, %ebx
	subl %ebx, %eax
	
	cmp $0, %eax	
	jl conditie_start
	// eax devine start
conditie_cont1:
	movl %edx, %ebx
	pushl %eax
	movl m, %eax
	addl %eax, %ebx	
	movl nDe3, %eax
	subl $1, %eax
	
	cmp %eax, %ebx
	jg conditie_finish
	// ebx devine finish
conditie_cont2:
	incl %ebx
	popl %eax
for_conditie:
	cmp %ebx, %eax
	je conditie_cont3
	
	cmp %eax, %edx
	jne conditie_conditie
for_conditie_cont:
	incl %eax
	jmp for_conditie
conditie_cont3:
	pushl %ebx
	pushl %edx
	pushl %ecx
	call counter
	popl %ecx
	popl %edx
	popl %ebx
	
conditie_exit:
	popl %ebx
	popl %edi
	popl %esi
	popl %ebp
	ret
	
bk:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %edx		
	//edx devine i
	movl nPlus, %eax
	movl $1, %ecx			
	//ecx devine x
	pushl %ebx
	pushl %edi
	pushl %esi
	movl $sol, %edi
for_bk:
	cmp %eax, %ecx
	jge bk_exit

	pushl %eax
	pushl %ecx
	pushl %edx
	call conditie
	popl %edx
	popl %ecx
	
	cmp $1, %eax
	popl %eax
	je for_bk_true
for_bk_cont:
	incl %ecx
	jmp for_bk
for_bk_true:
	movl nDe3, %ebx
	subl $1, %ebx
	cmp %ebx, %edx
	je bk_sol
	jmp bk_not_yet_sol
bk_sol:
	movl %ecx, (%edi, %edx, 4)
	jmp output
bk_not_yet_sol:
	movl %ecx, (%edi, %edx, 4)
	incl %edx
	pushl %ecx
	pushl %edx
	call bk
	popl %edx
	popl %ecx
	movl $0, (%edi, %edx, 4)
	subl $1, %edx
	jmp punct_fix1
bk_exit:
	popl %esi
	popl %edi
	popl %ebx
	popl %ebp
	ret

main:
	jmp input
main_cont:
	movl n, %eax
	incl %eax
	movl %eax, nPlus
	
	pushl $0
	call bk
	popl %ebx

	pushl $-1
	pushl $formatPrintD
	call printf
	popl %ebx
	popl %ebx
	
	pushl $nline
	pushl $formatPrintS
	call printf
	popl %ebx
	popl %ebx

et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
