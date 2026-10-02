	.syntax	unified
	.cpu	cortex-m4
	.file	"mq_cm4.s"
	.text

	.equ	Q, 12289
	.equ	Q1I, 4143984639
	.equ	R, 10952
	.equ	R2, 5664
	.equ	B_INF, 840


	.section .compare.orig_mq,"ax",%progbits
@ =======================================================================
@ void orig_mqpoly_int_to_ntt(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	orig_mqpoly_int_to_ntt
	.thumb
	.thumb_func
	.type	orig_mqpoly_int_to_ntt, %function
orig_mqpoly_int_to_ntt:
	push.w	{ r4, r5, r6, r7, r8, r10, r11, lr }

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    0
	@   r1    &d[j1]
	@   r2    t = ht*2
	@   r3    middle loop counter
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + m]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	vmov	s2, r1         @ original &d[0]
	movs	r2, #1
	lsls	r2, r0         @ r2 <- t = ht*2 (initially equal to n)
	movw	r0, #1         @ m <- 1
	vmov	s3, r0

	@ Constants.
	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q (both halves)
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ r8 <- &mq_GM[1]
	adr	r8, orig_mqpoly_int_to_ntt__gmaddr_plus1
	ldr	r8, [r8]

	@ If n = 4, then skip directly to the specialized code for the
	@ last two iterations.
	cmp	r2, #4
	beq	orig_mqpoly_int_to_ntt__L4

orig_mqpoly_int_to_ntt__L1:
	@ Middle loop has m iterations.
	vmov	r3, s3
	lsl	r6, r3, #1     @ prepare m for next iteration
	vmov	s3, r6
orig_mqpoly_int_to_ntt__L2:
	ldrh	r6, [r8], #2   @ s <- mq_GM[i + m]
	lsr	r7, r2, #1     @ r7 <- ht
orig_mqpoly_int_to_ntt__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr.w	r4, [r1, r2]   @ r4 <- x2:y2

	@ r5 <- mmul(y2, s)
	smultb	r5, r4, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r4 <- mmul(x2, s)
	smulbb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- x2:y2
	pkhbt	r5, r4, r5, lsl #16

	@ r4 <- x1:y1
	ldr.w	r4, [r1]       @ r4 <- x1:y1

	@ d[j1] <- x1+x2 : y1+y2
	@ d[j2] <- x1-x2 : y1-y2
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	str.w	r5, [r1, r2]
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	str.w	r4, [r1], #4

	@ loop ht/2 times
	subs	r7, #2
	bne	orig_mqpoly_int_to_ntt__L3

	@ ---------------------------

	@ j0 <- j0 + t
	@ j0 is implicit in r1, which has been increased for ht elements,
	@ hence we add ht here (ht*2, since elements are 2-byte values)
	add.w	r1, r1, r2
	@ We loop m times
	subs	r3, #1
	bne	orig_mqpoly_int_to_ntt__L2

	@ r1 now contains &d[n], we must reset it to &d[0] for the next
	@ iteration.
	vmov	r1, s2

	@ replace t with ht
	@ Loop until t reaches 2
	lsr	r2, r2, #1
	cmp	r2, #4
	bne	orig_mqpoly_int_to_ntt__L1

orig_mqpoly_int_to_ntt__L4:
	@ Last two outer iterations use specialized code.
	@   m = n/4
	@   t = 4
	@ We do n/4 inner iterations, each processing four consecutive values.

	@ Loop counter (m = n/4).
	vmov	r3, s3

	@ We need two pointers to read s values; we use r8 and r7.
	@ At this point, r8 is correct (&mq_GM[m]) and we set r7 to
	@ &mq_GM[2*m] by adding 2*m (in bytes) to r8.
	add	r7, r8, r3, lsl #1

	@ r2 is free, since we know it contains 4.

orig_mqpoly_int_to_ntt__L5:
	@ Next-to-last outer iteration: the four values are, in RAM order:
	@   x1 y1 x2 y2
	@ We load x2:y2 (into r5) and s (into r6)
	ldr.w	r5, [r1, #4]
	ldrh	r6, [r8], #2

	@ r4 <- mmul(x2, s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y2, s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	@ r5 <- mmul(x2, s) : mmul(y2, s)
	pkhbt	r5, r4, r5, lsl #16

	@ Load x1:y1 (into r4)
	ldr.w	r4, [r1]

	@ r4 <- (x1+mmul(x2,s)):(y1+mmul(y2,s))
	@ r5 <- (x1-mmul(x2,s)):(y1-mmul(y2,s))
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12

	@ Last iteration: the four values are, in RAM order: x1 x2 y1 y2
	@ The values have not been really written to RAM, though; they
	@ are in r4 (x1:x2) and r5 (y1:y2).
	@ Get the two relevant s values into r6.
	ldr	r6, [r7], #4

	@ r2 <- x1:y1
	pkhbt	r2, r4, r5, lsl #16
	@ r5 <- mmul(x2,s):mmul(y2,s)
	smultb	r4, r4, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ r4 <- (x1+mmul(x2,s):(y1+mmul(y2,s))
	sadd16	r4, r2, r5
	ssub16	r12, r4, r11
	sel	r4, r12, r4
	@ r5 <- (x1-mmul(x2,s):(y1-mmul(y2,s))
	ssub16	r5, r2, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12

	@ We write the four final values in x1 x2 y1 y2 order.
	pkhbt	r12, r4, r5, lsl #16
	str.w	r12, [r1], #4
	pkhtb	r12, r5, r4, asr #16
	str.w	r12, [r1], #4

	subs	r3, #1
	bne	orig_mqpoly_int_to_ntt__L5

orig_mqpoly_int_to_ntt__Lend:
	pop	{ r4, r5, r6, r7, r8, r10, r11, pc }
	.align	2
orig_mqpoly_int_to_ntt__gmaddr_plus1:
	.word	orig_mq_GM + 2
	.size	orig_mqpoly_int_to_ntt,.-orig_mqpoly_int_to_ntt

@ =======================================================================
@ void orig_mqpoly_ntt_to_int(unsigned logn, uint16_t *d)
@ =======================================================================

	.align	2
	.global	orig_mqpoly_ntt_to_int
	.thumb
	.thumb_func
	.type	orig_mqpoly_ntt_to_int, %function
orig_mqpoly_ntt_to_int:
	push.w	{ r4, r5, r6, r7, r8, r10, r11, lr }

	@ ASSUMPTION: logn >= 2

	@ State:
	@   r0    scratch
	@   r1    &d[j1]
	@   r2    dt = 2*t
	@   r3    middle loop counter
	@   r4    x1
	@   r5    x2
	@   r6    s
	@   r7    innermost loop counter
	@   r8    &mq_GM[i + hm]
	@   r10   q
	@   r11   q:q
	@   r12   scratch
	@   r14   -1/q mod 2^32
	@
	@   s2    d
	@   s3    m

	@ We save the original d in s2.
	vmov	s2, r1
	@ m = n initially; we save m/2 to s3, and set r8 to &mq_iGM[m/2]
	adr	r8, orig_mqpoly_ntt_to_int__igmaddr
	ldr	r8, [r8]
	movs	r3, #1
	subs	r0, #1
	lsl	r0, r3, r0     @ r0 <- n/2 = 2^(logn-1)
	add.w	r8, r8, r0     @ r8 <- &mq_iGM[n/4]
	lsr	r3, r0, #1
	vmov	s3, r3         @ s3 <- n/4

	@ r0 <- 0
	movw	r0, #0
	@ r10 <- q
	movw	r10, #Q
	@ r11 <- q:q
	orr	r11, r10, r10, lsl #16
	@ r14 <- -1/q mod 2^32
	movw	r14, #(Q1I & 0xFFFF)
	movt	r14, #(Q1I >> 16)

	@ r8 is the pointer into mq_GM[] for the second outer iteration.
	@ r7 is the pointer into mq_GM[] for the first outer iteration.
	add	r7, r8, r3, lsl #1

	@ r3 is the loop counter. r10, r11 and r14 are constants used for
	@ modular reduction. r2, r4, r5 and r12 are scratch.

	@ First two iterations are specialized.
orig_mqpoly_ntt_to_int__L0:
	@ First iteration: values are in x1 x2 y1 y2 order.
	ldr	r2, [r1]        @ r2 <- x1:x2
	ldr	r5, [r1, #4]    @ r5 <- y1:y2
	ldr.w	r6, [r7], #4    @ r6 <- s1:s2

	@ r4 <- x1:y1
	pkhbt	r4, r2, r5, lsl #16
	@ r5 <- x2:y2
	pkhtb	r5, r5, r2, asr #16
	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultt	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Second iteration. Normally we get x1 y1 x2 y2 from RAM; here,
	@ we have x1:x2 in r2, y1 in r4 and y2 in r5.
	@ Reorganize the values:
	pkhbt	r4, r2, r4, lsl #16   @ r4 <- x1:y1
	lsl.w	r5, r5, #16
	orr	r5, r5, r2, lsr #16   @ r5 <- x2:y2
	@ Read s for the second iteration.
	ldrh	r6, [r8], #2

	@ r2 <- (x1+x2)/2:(y1+y2)/2
	sadd16	r2, r4, r5
	ssub16	r12, r2, r11
	sel	r2, r12, r2
	and	r12, r2, #0x00010001
	umlal	r2, r12, r12, r10
	lsr.w	r2, r2, #1
	@ r5 <- (x1-x2):(y1-y2)
	ssub16	r5, r4, r5
	sel	r12, r0, r11
	sadd16	r5, r5, r12
	@ r4 <- mmul(x1-x2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	@ r5 <- mmul(y1-y2,s)
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10

	@ Repack values, to write them in x1 y1 x2 y2 order.
	str.w	r2, [r1], #4
	pkhbt	r4, r4, r5, lsl #16
	str.w	r4, [r1], #4

	@ Loop n/4 times.
	subs	r3, #1
	bne	orig_mqpoly_ntt_to_int__L0

	@ Prepare for remaining iterations.
	@ r2 <- -2*t = -8
	movs	r2, #8
	rsbs	r2, #0
	@ r3 <- m (for next iteration)
	vmov	r3, s3

	@ If logn=2 then m=1 and we are finished.
	cmp	r3, #1
	beq	orig_mqpoly_ntt_to_int__Lend

orig_mqpoly_ntt_to_int__L1:
	@ Rewind r1 to start of array.
	vmov	r1, s2

	@ m is in r3. r8 was left at &mq_iGM[2*m]; we need to adjust it
	@ to &mq_iGM[m/2], by subtracting 3*m (each element is two bytes).
	sub	r8, r8, r3, lsl #1
	sub.w	r8, r8, r3

	@ Middle loop has m/2 iterations (r3 is used as counter).
orig_mqpoly_ntt_to_int__L2:
	ldrh	r6, [r8], #2   @ s <- mq_iGM[i + m/2]

	asrs	r7, r2, #1     @ r7 <- -t
	@ We use r1 to point to the second pair (x2:y2); r2 is negative.
	@ The inner loop will inherently adjust r1 to point to the start
	@ of the next chunk for the next middle loop iteration.
	subs	r1, r1, r2

orig_mqpoly_ntt_to_int__L3:
	@ Each inner loop iteration processes two pairs (x1,x2) and (y1,y2).
	ldr	r4, [r1, r2]   @ r4 <- x1:y1
	ldr	r5, [r1]       @ r5 <- x2:y2

	@ r4 <- (x1+x2):(y1+y2)
	@ r5 <- (x1-x2):(y1-x2)
	sadd16	r12, r4, r5
	ssub16	r5, r4, r5
	sel	r4, r0, r11
	sadd16	r5, r5, r4
	ssub16	r4, r12, r11
	sel	r4, r4, r12
	@ r4 <- (x1+x2)/2:(y1+y2)/2
	and	r12, r4, #0x00010001
	umlal	r4, r12, r12, r10
	lsr.w	r4, r4, #1
	@ Write first output word
	str.w	r4, [r1, r2]

	@ r5 <- mmul(x1-x2,s):mmul(y1-y2,s)
	smulbb	r4, r5, r6
	mul	r12, r4, r14
	umaal	r14, r4, r12, r10
	smultb	r5, r5, r6
	mul	r12, r5, r14
	umaal	r14, r5, r12, r10
	pkhbt	r5, r4, r5, lsl #16
	@ Write second output word
	str.w	r5, [r1], #4

	@ We should do t iterations, but since we process a pair of elements
	@ each time, we only do t/2 iterations. Take care that the r7 counter
	@ is negative.
	adds	r7, #2
	bne	orig_mqpoly_ntt_to_int__L3

	@ We loop m/2 times
	subs	r3, #2
	bne	orig_mqpoly_ntt_to_int__L2

	@ Replace -t with -dt = 2*(-t)
	lsl.w	r2, r2, #1

	@ Replace m with m/2. We are finished when m becomes 1.
	vmov	r3, s3
	lsr.w	r3, r3, #1
	vmov	s3, r3
	cmp	r3, #1
	bne	orig_mqpoly_ntt_to_int__L1

orig_mqpoly_ntt_to_int__Lend:
	pop	{ r4, r5, r6, r7, r8, r10, r11, pc }
	.align	2
orig_mqpoly_ntt_to_int__igmaddr:
	.word	orig_mq_iGM
	.size	orig_mqpoly_ntt_to_int,.-orig_mqpoly_ntt_to_int
