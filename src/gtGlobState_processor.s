// start of gtstate
gtGlobStateProcessor:
/* [344] */ add r5, r0, ra
/* [348] */ lw r19, 0xd8(r0)
/* [34c] */ ldv v_mtx0_i[0], 0x30(rsp_state)
/* [350] */ sdv v_mtx0_i[0], 0x0(r23)
/* [354] */ addi r23, r23, 0x8
/* [358] */ beqz r19, @lab_04001490
/* [35c] */ nop
/* [360] */ jal segmented_to_virtual
/* [364] */ nop
/* [368] */ addi r6, r19, 0x0
@lab_040013ec:
/* [36c] */ addi r19, r6, 0x0
/* [370] */ addi r1, r0, 0x7a0
/* [374] */ addi r20, r0, 0x730
/* [378] */ addi r18, r0, 0x77
/* [37c] */ jal dma_read_write
/* [380] */ addi r17, r0, 0x0
/* [384] */ jal wait_for_dma_finish
/* [388] */ nop
@@b:
/* [38c] */ lw r2, 0x0(r20)
/* [390] */ lw r3, 0x4(r20)
/* [394] */ beqz r2, @lab_04001490
/* [398] */ addi r20, r20, 0x8
/* [39c] */ addi r6, r6, 0x8
/* [3a0] */ sra r4, r2, 24
/* [3a4] */ addi r4, r4, 0x3
/* [3a8] */ bltz r4, @@f
/* [3ac] */ nop
/* [3b0] */     jal segmented_to_virtual
/* [3b4] */     add r19, r3, r0
/* [3b8] */     add r3, r19, r0
@@f:
/* [3bc] */ srl r4, r2, 24
/* [3c0] */ andi r4, r4, 0xfe
/* [3c4] */ addi r7, r4, 0xff1c
/* [3c8] */ bnez r7, @@f2
/* [3cc] */ nop
/* [3d0] */ sw r2, 0x0(r23)
/* [3d4] */ sw r3, 0x4(r23)
/* [3d8] */ addi r23, r23, 0x8
/* [3dc] */ lw r2, 0x0(r20)
/* [3e0] */ lw r3, 0x4(r20)
/* [3e4] */ addi r20, r20, 0x8
/* [3e8] */ addi r6, r6, 0x8
@@f2:
/* [3ec] */ sw r2, 0x0(r23)
/* [3f0] */ sw r3, 0x4(r23)
/* [3f4] */ addi r23, r23, 0x8
/* [3f8] */ bne r20, r1, @@b
/* [3fc] */ nop
/* [400] */ jal setup_rdp
/* [404] */ nop
/* [408] */ j @lab_040013ec
/* [40c] */ nop
@lab_04001490:
/* [410] */ jal setup_rdp
/* [414] */ nop
/* [418] */ jr r5
/* [41c] */ nop

; args:
;   r25: gtState pointer
dma_transform_mtx:
/* [420] */ add r5, r0, ra
/* [424] */ lb r7, dmem_gtStateL_flag(rsp_state)
/* [428] */ andi r7, r7, GT_FLAG_NOMTX
/* [42c] */ bgtz r7, @@skipMtx
/* [430] */ add DMA_SRC, r0, r25
/* [434] */ jal segmented_to_virtual
/* [438] */  addi DMA_SRC, 0x18
/* [43c] */ addi DMA_DEST, r0, dmem_gtStateMtx
/* [440] */ addi DMA_LEN, r0, 0x40 - 1
/* [444] */ jal dma_read_write
/* [448] */ addi DMA_ISWRITE, r0, FALSE
/* [44c] */ jal wait_for_dma_finish
/* [450] */ nop
@@skipMtx:
/* [454] */ ldv v_mtx0_i[0], dmem_gtStateL_rdpOtherMode(rsp_state)
/* [458] */ sdv v_mtx0_i[0], 0x0(r23)
/* [45c] */ addi r23, r23, 0x8
/* [460] */ lw r19, dmem_gtStateL_rdpCmds(rsp_state)
/* [464] */ beqz r19, @lab_04001490
/* [468] */ nop
/* [46c] */ jal segmented_to_virtual
/* [470] */ nop
/* [474] */ addi r6, r19, 0x0
/* [478] */ j @lab_040013ec
/* [47c] */ nop
