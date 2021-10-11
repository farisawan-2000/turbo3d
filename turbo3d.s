.rsp

.create DATA_FILE, 0
.area 0x1000
; two vectors with helpful constants
dmem_00:
.dh    0, 1, 2, -1, 0x4000, 4, 0xFFFC, 512
dmem_constvector_00 equ lo(dmem_00)
dmem_10:
.dh    32767, -8, 8, 0xFD, 0x20, 0x8000, 0x01CC, 0xCCCC
dmem_constvector_10 equ lo(dmem_10)

dmem_20:
.dh    1, -1, 1, 1, 1, -1, 1, 1
opengl_correction_scale_vec equ lo(dmem_20)

; newtons iteration (el 3 and 7 must be 2)
dmem_30:
.dh    2, 2, 2, 2, 2, 2, 2, 2
newton_iterator_vec equ lo(dmem_30)

dmem_40:
.dh  4090, -4090, 0x7FFF, 0
dmem_screenclamp_vec equ lo(dmem_40)

dmem_48:
.word  0x00ffffff
dmem_segment_mask equ lo(dmem_48)

dmem_4C:
.dh lo(dl_dma_wait)
.align 4
dmem_dma_wait equ lo(dmem_4C)

dmem_50: ; some sort of OSTask reference
.word  0x00000000, 0x00000000, 0x00000000, 0x00000000
.word  0x00000000, 0x00000000
output_buff_ptr equ 0x18
.word  0x00000000
output_buff_size equ 0x1C
.word  0x00000000

dmem_70:
.word  0x00000000
.align 8
dmem_returnaddr equ lo(dmem_70)

dmem_78:
.dh 0xffff
.align 8
dmem_gtGlobState equ lo(dmem_78)
dmem_perspnorm equ lo(dmem_78)

dmem_80:
.fill 8,0
dmem_globStateOtherMode equ lo(dmem_80)

; dmem_88

.area 0xA8 - ., 0
    ; the rest of dmem_rsp_state
.endarea
dmem_rsp_state equ lo(dmem_50)

.area 0xE0 - ., 0

.endarea

dmem_E0:
    .word 0, 0
dmem_E8:
    .byte 0, 0, 0, 0
dmem_EC:
    .word 0,0,0
dmem_gtStateL equ lo(dmem_E0)
dmem_gtStateL_renderState equ lo(dmem_E0 - dmem_50)
dmem_gtStateL_vtxCount equ lo(dmem_E8 - dmem_50)
dmem_gtStateL_vtxV0 equ lo(dmem_E8 + 1 - dmem_50)
dmem_gtStateL_triCount equ lo(dmem_E8 + 2 - dmem_50)
dmem_gtStateL_flag equ lo(dmem_E8 + 3 - dmem_50)
dmem_gtStateL_rdpCmds equ lo(dmem_E8 + 4 - dmem_50)
dmem_gtStateL_rdpOtherMode equ lo(dmem_E8 + 8 - dmem_50)

dmem_F8:
.area 0x40, 0
    ; gtlistp->transform
.endarea
dmem_gtStateMtx equ lo(dmem_F8)

.area 0x140 - ., 0

.endarea

dmem_140:
    .fill 1024, 0
dmem_vertexbuffer equ lo(dmem_140)

.area 0x640 - ., 0
    ; fil
.endarea

dmem_640:
.area 0xF0
    ; turbo3d_04001260 dma's to here
.endarea

.area 0xBC0 - ., 0
    ; scratch space?
.endarea

.endarea
.close

.create CODE_FILE, 0x04001080

; DEFINES (move to new file?)
TRUE equ 1
FALSE equ 0
OSTask equ r1
rsp_state equ r29
DMA_TYPE equ r17
DMA_ISWRITE equ r17
    dma_READ equ 0
    dma_WRITE equ 1
DMA_LEN equ r18
DMA_SRC equ r19
DMA_DEST equ r20

GT_ZBUFFER equ 0x1
GT_TEXTURE equ 0x2
GT_SHADING_SMOOTH equ 0x200
GT_CULL_BACK equ 0x2000
GT_FLAG_NOMTX equ 0x01 ; don't load the matrix
GT_FLAG_NO_XFM equ 0x02 ; load vtx, use verbatim
GT_FLAG_XFM_ONLY equ 0x04 ; xform vtx, write to *TriN

vtx_xyz equ 0
vtx_flag equ 0x6

; vreg names
v_matrix0_i equ $v0
v_matrix0_f equ $v4

v_matrix1_i equ $v1
v_matrix1_f equ $v5

v_matrix2_i equ $v2
v_matrix2_f equ $v6

v_matrix3_i equ $v3
v_matrix3_f equ $v7

v_w_scale equ $v8
v_viewport_scale equ $v9
v_viewport_translation equ $v10

entry:
/* [000] */ addi rsp_state, r0, dmem_rsp_state
/* [004] */ ori r2, r0, 0x2800
/* [008] */ mtc0 r2, sp_status
/* [00c] */ lw r2, 0x28(OSTask) ; task.t.output_buff
/* [010] */ lw r3, 0x2c(OSTask) ; task.t.output_buff_size
/* [014] */ sw r0, 0x4 (rsp_state)
/* [018] */ sw r3, 0x10(rsp_state)
/* [01c] */ lqv $v31[0], dmem_constvector_00(r0)
/* [020] */ lqv $v30[0], dmem_constvector_10(r0)
/* [024] */ lw r23, 0x28(OSTask) ; task.t.output_buff
/* [028] */ lw  r3, 0x2c(OSTask) ; task.t.output_buff_size
/* [02c] */ sw r23, 0x18(rsp_state)
/* [030] */ sw  r3, 0x1c(rsp_state)
/* [034] */ mfc0 r4, dpc_status
/* [038] */ andi r4, r4, 0x1
/* [03c] */ bnez r4, @@f
/* [040] */ mfc0 r4, dpc_end
/* [044] */ sub r23, r23, r4
/* [048] */ bgtz r23, @@f
/* [04c] */ mfc0 r5, dpc_current
/* [050] */ beqz r5, @@f
/* [054] */ nop
/* [058] */ beq r5, r4, @@f
/* [05c] */ nop
/* [060] */ j @@f2
/* [064] */ ori r3, r4, 0x0
@@f:
@@b:
/* [068] */ mfc0 r4, dpc_status
/* [06c] */ andi r4, r4, 0x400
/* [070] */ bnez r4, @@b
/* [074] */ addi r4, r0, 0x1
/* [078] */ mtc0 r4, dpc_status
/* [07c] */ mtc0 r3, dpc_start
/* [080] */ mtc0 r3, dpc_end
@@f2:
/* [084] */ sw r3, 0x4(rsp_state)
/* [088] */ addi r23, r0, 0x7b0
/* [08c] */ jal turbo3d_04001260
/* [090] */ lw r26, 0x30(OSTask) ; data_ptr

dl_dma_wait:
/* [094] */ jal wait_for_dma_finish
/* [098] */ nop
/* [09c] */ addi r27, r0, 0x640
decode_dl:
/* [0a0] */ lw r3, 0x0(r27)
/* [0a4] */ lw r25, 0x4(r27)
/* [0a8] */ lw r24, 0x8(r27)
/* [0ac] */ lw r30, 0xc(r27)
/* [0b0] */ addi r26, r26, 16
/* [0b4] */ addi r27, r27, 16
/* [0b8] */ addi r28, r28, -16
/* [0bc] */ beqz r3, @@f3
/* [0c0] */ add r19, r0, r3
/* [0c4] */ jal turbo3d_04001284
/* [0c8] */ addi r20, r0, dmem_gtGlobState
/* [0cc] */ addi r18, r0, 0x63
/* [0d0] */ jal dma_read_write
/* [0d4] */ addi r17, r0, 0x0
/* [0d8] */ jal wait_for_dma_finish
/* [0dc] */ nop
/* [0e0] */ jal turbo3d_040013c4
/* [0e4] */ nop
@@f3:
/* [0e8] */ beqz r25, @lab_04001244
/* [0ec] */ add r19, r0, r25
/* [0f0] */ jal turbo3d_04001284
; read in the Lite part of the current gtState
/* [0f4] */ addi DMA_DEST, r0, dmem_gtStateL
/* [0f8] */ addi DMA_LEN, r0, 0x18 - 1
/* [0fc] */ jal dma_read_write
/* [100] */ addi DMA_ISWRITE, r0, FALSE
/* [104] */ jal wait_for_dma_finish
/* [108] */ nop
/* [10c] */ beqz r24, @@f4
/* [110] */ add r19, r0, r24
/* [114] */ lb r5, dmem_gtStateL_vtxCount(rsp_state)
/* [118] */ lb r6, dmem_gtStateL_vtxV0(rsp_state)
/* [11c] */ jal turbo3d_04001284
/* [120] */ addi r20, r0, dmem_vertexbuffer
/* [124] */ sll r6, r6, 4
/* [128] */ add r20, r20, r6
/* [12c] */ sll r5, r5, 4
/* [130] */ addi r18, r5, -1
/* [134] */ jal dma_read_write
/* [138] */ addi r17, r0, 0x0
@@f4:
/* [13c] */ jal dma_transform_mtx
/* [140] */ nop
/* [144] */ jal wait_for_dma_finish
/* [148] */ nop
/* [14c] */ lb r5, dmem_gtStateL_flag(rsp_state)
/* [150] */ andi r6, r5, 0x4
/* [154] */ bgtz r6, @@f5
/* [158] */ lb r5, dmem_gtStateL_triCount(rsp_state)
/* [15c] */ beqz r5, @@f5
/* [160] */ add r19, r0, r30
/* [164] */     jal turbo3d_04001284
/* [168] */     addi DMA_DEST, r0, 0x540
/* [16c] */     sll r5, r5, 2
/* [170] */     addi DMA_LEN, r5, -1
/* [174] */     lb r5, dmem_gtStateL_flag(rsp_state)
/* [178] */     jal dma_read_write
/* [17c] */     addi DMA_ISWRITE, r0, FALSE
@@f5:
/* [180] */ andi r5, r5, 0x2
/* [184] */ bgtz r5, @@f6
/* [188] */ nop
/* [18c] */ jal transform_vtx_handler
/* [190] */ nop
@@f6:
/* [194] */ jal wait_for_dma_finish
/* [198] */ nop
/* [19c] */ jal triangle_draw_handler
/* [1a0] */ nop

@lab_04001224:
/* [1a4] */ mfc0 r2, sp_status
/* [1a8] */ andi r2, r2, 0x80
/* [1ac] */ bnez r2, @lab_040012f4
/* [1b0] */ nop
/* [1b4] */ bgtz r28, decode_dl
/* [1b8] */ nop
/* [1bc] */ j turbo3d_04001260
/* [1c0] */ lh ra, 0x4c(r0)

@lab_04001244:
/* [1c4] */ nop
/* [1c8] */ jal wait_for_dma_finish
/* [1cc] */ ori r2, r0, 0x4000
/* [1d0] */ mtc0 r2, sp_status
/* [1d4] */ break 0
/* [1d8] */ nop
/* [1dc] */ addiu r0, r0, 0xbeef

turbo3d_04001260:
/* [1e0] */ addi r28, r0, 0xf0
/* [1e4] */ add r21, r0, ra
/* [1e8] */ addi DMA_DEST, r0, dmem_640
/* [1ec] */ add DMA_SRC, r0, r26
/* [1f0] */ addi DMA_LEN, r0, 0xF0 - 1
/* [1f4] */ jal dma_read_write
/* [1f8] */ addi DMA_ISWRITE, r0, FALSE
/* [1fc] */ jr r21
/* [200] */ addi r27, r0, 0x640

turbo3d_04001284:
mask equ r11
/* [204] */ lw mask, dmem_segment_mask(r0)
/* [208] */ srl r12, r19, 22
/* [20c] */ andi r12, r12, 0x3c
/* [210] */ and r19, r19, mask
/* [214] */ add r13, r0, r12
/* [218] */ lw r12, 0x88(r13)
/* [21c] */ jr ra
/* [220] */ add r19, r19, r12

; args:
;  r17: 0 if read, 1 if write
;  r18: len
;  r19: src
;  r20: dest
dma_read_write:
@@b: ; wait for semaphore to be freed
/* [224] */ mfc0 r11, sp_semaphore
/* [228] */ bnez r11, @@b
@@b2:
/* [22c] */  mfc0 r11, sp_dma_full
/* [230] */ bnez r11, @@b2
/* [234] */  nop
/* [238] */ mtc0 DMA_DEST, sp_mem_addr
/* [23c] */ bgtz DMA_TYPE, @@writeIt
/* [240] */  mtc0 DMA_SRC, sp_dram_addr
/* [244] */ j @@f2
/* [248] */  mtc0 DMA_LEN, sp_rd_len
@@writeIt:
/* [24c] */ mtc0 DMA_LEN, sp_wr_len
@@f2:
/* [250] */ jr ra
/* [254] */  mtc0 r0, sp_semaphore ; release the semaphore

wait_for_dma_finish:
/* [258] */ mfc0 r11, sp_semaphore
/* [25c] */ bnez r11, wait_for_dma_finish
@@b:
/* [260] */ mfc0 r11, sp_dma_busy
/* [264] */ bnez r11, @@b
/* [268] */ nop
/* [26c] */ jr ra
/* [270] */ mtc0 r0, sp_semaphore
@lab_040012f4:
/* [274] */ ori r2, r0, 0x1000
/* [278] */ sw r28, 0x734(r0)
/* [27c] */ sw r27, 0x738(r0)
/* [280] */ sw r26, 0x73c(r0)
/* [284] */ sw r23, 0x740(r0)
/* [288] */ lw  DMA_SRC, 0x50(r0)
/* [28c] */ ori DMA_DEST, r0, 0x0
/* [290] */ ori DMA_LEN, r0, 0x65f
/* [294] */ jal dma_read_write
/* [298] */ ori DMA_ISWRITE, r0, TRUE
/* [29c] */ jal wait_for_dma_finish
/* [2a0] */ nop
/* [2a4] */ j @lab_04001244
/* [2a8] */ mtc0 r2, sp_status
/* [2ac] */ lw r23, 0x740(r0)
/* [2b0] */ lw r28, 0x734(r0)
/* [2b4] */ lw r27, 0x738(r0)
/* [2b8] */ j @lab_04001224
/* [2bc] */ lw r26, 0x73c(r0)

setup_rdp:
/* [2c0] */ add r21, r0, ra
/* [2c4] */ lw r19, 0x4(rsp_state)
/* [2c8] */ addi r18, r23, 0xf850
/* [2cc] */ lw r23, 0x1c(rsp_state)
/* [2d0] */ blez r18, @@f3
/* [2d4] */ add r20, r19, r18
/* [2d8] */ sub r20, r23, r20
/* [2dc] */ bgez r20, @@f
@@b:
/* [2e0] */ mfc0 r20, dpc_status
/* [2e4] */ andi r20, r20, 0x400
/* [2e8] */ bnez r20, @@b
@@b2:
/* [2ec] */ mfc0 r23, dpc_current
/* [2f0] */ lw DMA_SRC, 0x18(rsp_state)
/* [2f4] */ beq r23, DMA_SRC, @@b2
/* [2f8] */ nop
/* [2fc] */ mtc0 DMA_SRC, dpc_start
@@f:
@@b3:
/* [300] */ mfc0 r23, dpc_current
/* [304] */ sub r20, DMA_SRC, r23
/* [308] */ bgez r20, @@f2
/* [30c] */ add r20, DMA_SRC, r18
/* [310] */ sub r20, r20, r23
/* [314] */ bgez r20, @@b3
/* [318] */ nop
@@f2:
/* [31c] */ add r23, DMA_SRC, r18
/* [320] */ addi DMA_LEN, -1
/* [324] */ addi DMA_DEST, r0, 0x7B0
/* [328] */ jal dma_read_write
/* [32c] */ addi DMA_ISWRITE, r0, TRUE
/* [330] */ jal wait_for_dma_finish
/* [334] */ sw r23, 0x4(rsp_state)
/* [338] */ mtc0 r23, dpc_end
@@f3:
/* [33c] */ jr r21
/* [340] */ addi r23, r0, 0x7b0

turbo3d_040013c4:
/* [344] */ add r5, r0, ra
/* [348] */ lw r19, 0xd8(r0)
/* [34c] */ ldv v_matrix0_i[0], 0x30(rsp_state)
/* [350] */ sdv v_matrix0_i[0], 0x0(r23)
/* [354] */ addi r23, r23, 0x8
/* [358] */ beqz r19, @lab_04001490
/* [35c] */ nop
/* [360] */ jal turbo3d_04001284
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
/* [3b0] */     jal turbo3d_04001284
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
/* [434] */ jal turbo3d_04001284
/* [438] */  addi DMA_SRC, 0x18
/* [43c] */ addi DMA_DEST, r0, dmem_gtStateMtx
/* [440] */ addi DMA_LEN, r0, 0x40 - 1
/* [444] */ jal dma_read_write
/* [448] */ addi DMA_ISWRITE, r0, FALSE
/* [44c] */ jal wait_for_dma_finish
/* [450] */ nop
@@skipMtx:
/* [454] */ ldv v_matrix0_i[0], dmem_gtStateL_rdpOtherMode(rsp_state)
/* [458] */ sdv v_matrix0_i[0], 0x0(r23)
/* [45c] */ addi r23, r23, 0x8
/* [460] */ lw r19, dmem_gtStateL_rdpCmds(rsp_state)
/* [464] */ beqz r19, @lab_04001490
/* [468] */ nop
/* [46c] */ jal turbo3d_04001284
/* [470] */ nop
/* [474] */ addi r6, r19, 0x0
/* [478] */ j @lab_040013ec
/* [47c] */ nop

transform_vtx_handler:
vtxPtr equ r22
transformedVtxPtr equ r3 ; idk if this is true
numVerticesLeft equ r5  ;  idk if this is true
/* [480] */ lb r1, dmem_gtStateL_vtxCount(rsp_state)
/* [484] */ lb r2, dmem_gtStateL_vtxV0(rsp_state)
/* [488] */ addi vtxPtr, r0, dmem_vertexbuffer
/* [48c] */ beqz r1, @@f2
/* [490] */ sw ra, 0x70(r0)
/* [494] */ addi numVerticesLeft, r1, 0x0
/* [498] */ addi transformedVtxPtr, r0, dmem_vertexbuffer
/* [49c] */ sll r4, r2, 4
/* [4a0] */ add transformedVtxPtr, r4
/* [4a4] */ add vtxPtr, r4
/* [4a8] */ ldv $v11[0], 0x0(vtxPtr)
/* [4ac] */ ldv $v11[8], 0x10(vtxPtr)
/* [4b0] */ ldv $v20[0], 0x20(vtxPtr)
/* [4b4] */ ldv $v20[8], 0x30(vtxPtr)
/* [4b8] */ addi r4, r0, dmem_gtStateMtx
/* [4bc] */ ldv v_matrix0_i[0], 0x0(r4)
/* [4c0] */ ldv $v1[0], 0x8(r4)
/* [4c4] */ ldv $v2[0], 0x10(r4)
/* [4c8] */ ldv $v3[0], 0x18(r4)
/* [4cc] */ ldv v_matrix0_f[0], 0x20(r4)
/* [4d0] */ ldv $v5[0], 0x28(r4)
/* [4d4] */ ldv $v6[0], 0x30(r4)
/* [4d8] */ ldv $v7[0], 0x38(r4)
/* [4dc] */ ldv v_matrix0_i[8], 0x0(r4)
/* [4e0] */ ldv $v1[8], 0x8(r4)
/* [4e4] */ ldv $v2[8], 0x10(r4)
/* [4e8] */ ldv $v3[8], 0x18(r4)
/* [4ec] */ ldv v_matrix0_f[8], 0x20(r4)
/* [4f0] */ ldv $v5[8], 0x28(r4)
/* [4f4] */ ldv $v6[8], 0x30(r4)
/* [4f8] */ ldv $v7[8], 0x38(r4)
/* [4fc] */ lqv $v29[0], opengl_correction_scale_vec(r0)
/* [500] */ addi r4, r0, 0xc8
/* [504] */ ldv $v9[0], 0x0(r4)
/* [508] */ ldv $v10[0], 0x8(r4)
/* [50c] */ ldv $v9[8], 0x0(r4)
/* [510] */ ldv $v10[8], 0x8(r4)
/* [514] */ lsv $v8[0], 0x28(rsp_state)
/* [518] */ vmudh $v9, $v9, $v29

@@b:
/* [51c] */ vmudn $v13, v_matrix0_f, $v11[0h]
/* [520] */ vmadh $v13, v_matrix0_i, $v11[0h]
/* [524] */ vmadn $v13, $v5, $v11[1h]
/* [528] */ vmadh $v13, $v1, $v11[1h]
/* [52c] */ vmadn $v13, $v6, $v11[2h]
/* [530] */ vmadh $v13, $v2, $v11[2h]
/* [534] */ vmadn $v13, $v7, $v31[1]
/* [538] */ vmadh $v12, $v3, $v31[1]
/* [53c] */ vmudn $v22, v_matrix0_f, $v20[0h]
/* [540] */ vmadh $v22, v_matrix0_i, $v20[0h]
/* [544] */ vmadn $v22, $v5, $v20[1h]
/* [548] */ vmadh $v22, $v1, $v20[1h]
/* [54c] */ vmadn $v22, $v6, $v20[2h]
/* [550] */ vmadh $v22, $v2, $v20[2h]
/* [554] */ vmadn $v22, $v7, $v31[1]
/* [558] */ vmadh $v21, $v3, $v31[1]
/* [55c] */ addi r22, r22, 0x40
/* [560] */ vmudl $v15, $v13, $v8[0]
/* [564] */ vmadm $v14, $v12, $v8[0]
/* [568] */ vmadn $v15, $v31, $v31[0]
/* [56c] */ vmudl $v24, $v22, $v8[0]
/* [570] */ vmadm $v23, $v21, $v8[0]
/* [574] */ vmadn $v24, $v31, $v31[0]
/* [578] */ vrcph $v16[3], $v14[3]
/* [57c] */ vrcpl $v17[3], $v15[3]
/* [580] */ vrcph $v16[3], $v14[7]
/* [584] */ vrcpl $v17[7], $v15[7]
/* [588] */ vrcph $v16[7], $v31[0]
/* [58c] */ vrcph $v25[3], $v23[3]
/* [590] */ vrcpl $v26[3], $v24[3]
/* [594] */ vrcph $v25[3], $v23[7]
/* [598] */ vrcpl $v26[7], $v24[7]
/* [59c] */ vrcph $v25[7], $v31[0]
/* [5a0] */ vmudn $v17, $v17, $v31[2]
/* [5a4] */ vmadh $v16, $v16, $v31[2]
/* [5a8] */ vmadn $v17, $v31, $v31[0]
/* [5ac] */ vmudn $v26, $v26, $v31[2]
/* [5b0] */ vmadh $v25, $v25, $v31[2]
/* [5b4] */ vmadn $v26, $v31, $v31[0]
/* [5b8] */ vmudl $v15, $v13, $v17[3h]
/* [5bc] */ vmadm $v15, $v12, $v17[3h]
/* [5c0] */ vmadn $v15, $v13, $v16[3h]
/* [5c4] */ vmadh $v14, $v12, $v16[3h]
/* [5c8] */ vmudl $v24, $v22, $v26[3h]
/* [5cc] */ vmadm $v24, $v21, $v26[3h]
/* [5d0] */ vmadn $v24, $v22, $v25[3h]
/* [5d4] */ vmadh $v23, $v21, $v25[3h]
/* [5d8] */ vmudl $v15, $v15, $v8[0]
/* [5dc] */ ldv $v12[0], dmem_screenclamp_vec(r0)
/* [5e0] */ vmadm $v14, $v14, $v8[0]
/* [5e4] */ ldv $v12[8], dmem_screenclamp_vec(r0)
/* [5e8] */ vmadn $v15, $v31, $v31[0]
/* [5ec] */ vmudl $v24, $v24, $v8[0]
/* [5f0] */ vmadm $v23, $v23, $v8[0]
/* [5f4] */ vmadn $v24, $v31, $v31[0]
/* [5f8] */ vmudh $v19, $v10, $v31[1]
/* [5fc] */ vmadn $v19, $v15, $v9
/* [600] */ ldv $v11[0], 0x0(r22)
/* [604] */ vmadh $v18, $v14, $v9
/* [608] */ ldv $v11[8], 0x10(r22)
/* [60c] */ vmadn $v19, $v31, $v31[0]
/* [610] */ vmudh $v28, $v10, $v31[1]
/* [614] */ vmadn $v28, $v24, $v9
/* [618] */ ldv $v20[0], 0x20(r22)
/* [61c] */ vmadh $v27, $v23, $v9
/* [620] */ ldv $v20[8], 0x30(r22)
/* [624] */ vmadn $v28, $v31, $v31[0]
/* [628] */ vlt $v18, $v18, $v12[0q]
/* [62c] */ addi numVerticesLeft, -1
/* [630] */ vlt $v27, $v27, $v12[0q]
/* [634] */ vadd $v18, $v18, $v31[2]
/* [638] */ vadd $v27, $v27, $v31[2]
/* [63c] */ vand $v18, $v18, $v31[6]
/* [640] */ vand $v27, $v27, $v31[6]
/* [644] */ sdv $v18[0], (vtx_xyz)(transformedVtxPtr)
/* [648] */ ssv $v19[4], (vtx_flag)(transformedVtxPtr)
/* [64c] */ blez numVerticesLeft, @@f
/* [650] */ addi numVerticesLeft, numVerticesLeft, -1
/* [654] */ sdv $v18[8], (0x10 + vtx_xyz)(transformedVtxPtr)
/* [658] */ ssv $v19[12], (0x10 + vtx_flag)(transformedVtxPtr)
/* [65c] */ blez numVerticesLeft, @@f
/* [660] */ addi numVerticesLeft, numVerticesLeft, -1
/* [664] */ sdv $v27[0], (0x20 + vtx_xyz)(transformedVtxPtr)
/* [668] */ ssv $v28[4], (0x20 + vtx_flag)(transformedVtxPtr)
/* [66c] */ blez numVerticesLeft, @@f
/* [670] */ addi numVerticesLeft, numVerticesLeft, -1
/* [674] */ sdv $v27[8], (0x30 + vtx_xyz)(transformedVtxPtr)
/* [678] */ ssv $v28[12], (0x30 + vtx_flag)(transformedVtxPtr)
/* [67c] */ bgtz numVerticesLeft, @@b
/* [680] */ addi transformedVtxPtr, 0x40

@@f:
/* [684] */ lb r5, dmem_gtStateL_flag(rsp_state)
/* [688] */ lb r1, dmem_gtStateL_vtxCount(rsp_state)
/* [68c] */ lb r2, dmem_gtStateL_vtxV0(rsp_state)
/* [690] */ andi r5, r5, GT_FLAG_XFM_ONLY
/* [694] */ addi r22, r0, dmem_vertexbuffer
/* [698] */ beqz r5, @@f2
/* [69c] */ sll r4, r2, 4
/* [6a0] */ add r22, r22, r4
/* [6a4] */ add r19, r0, r30
/* [6a8] */ jal turbo3d_04001284
/* [6ac] */ addi r20, r0, 0x16
/* [6b0] */ sll r1, r1, 4
/* [6b4] */ addi DMA_LEN, r1, -1
/* [6b8] */ jal dma_read_write
/* [6bc] */ addi DMA_ISWRITE, r0, TRUE

@@f2:
/* [6c0] */ lw ra, 0x70(r0)
/* [6c4] */ jr ra
/* [6c8] */ nop

triangle_draw_handler:
/* [6cc] */ lb r10, dmem_gtStateL_flag(rsp_state)
/* [6d0] */ andi r10, r10, GT_FLAG_XFM_ONLY
/* [6d4] */ bgtz r10, @lab_04001224
/* [6d8] */ sw ra, 0x70(r0)
/* [6dc] */ addi r1, r0, 0x540
/* [6e0] */ lb r2, dmem_gtStateL_triCount(rsp_state)
/* [6e4] */ sll r2, r2, 2
/* [6e8] */ beqz r2, @noTris
/* [6ec] */ add r2, r2, r1
/* [6f0] */ lw r11, dmem_gtStateL_renderState(rsp_state)

@bigman_loop:
/* [6f4] */ beq r1, r2, @lab_040017b0
/* [6f8] */ lb r4, 0x0(r1)
/* [6fc] */ lb r5, 0x1(r1)
/* [700] */ lb r6, 0x2(r1)
/* [704] */ sll r4, r4, 4
/* [708] */ sll r5, r5, 4
/* [70c] */ sll r6, r6, 4
/* [710] */ addi r4, r4, dmem_vertexbuffer
/* [714] */ addi r5, r5, dmem_vertexbuffer
/* [718] */ addi r6, r6, dmem_vertexbuffer
/* [71c] */ andi r10, r11, GT_SHADING_SMOOTH
/* [720] */ beqz r10, @lab_040017cc
@lab_040017a4:
/* [724] */ nop
/* [728] */ j @lab_040017e8
/* [72c] */ addi r1, r1, 0x4
@lab_040017b0:
/* [730] */ lui r1, 0xe700
/* [734] */ sw r1, 0x0(r23)
/* [738] */ sw r0, 0x4(r23)
/* [73c] */ jal setup_rdp
/* [740] */ addi r23, r23, 0x8
@noTris:
/* [744] */ lw ra, 0x70(r0)
/* [748] */ jr ra
@lab_040017cc:
/* [74c] */ lb r7, 0x3(r1)
/* [750] */ sll r7, r7, 2
/* [754] */ sw r4, 0xbb0(r0)
/* [758] */ sw r5, 0xbb4(r0)
/* [75c] */ sw r6, 0xbb8(r0)
/* [760] */ j @lab_040017a4
/* [764] */ lw r7, 0xbb0(r7)
@lab_040017e8:
/* [768] */ llv $v9[0], 0x0(r4)
/* [76c] */ llv $v10[0], 0x0(r5)
/* [770] */ llv $v11[0], 0x0(r6)
/* [774] */ lw r11, dmem_gtStateL_renderState(rsp_state)
/* [778] */ vsub $v6, $v10, $v9
/* [77c] */ vsub $v5, $v11, $v9
/* [780] */ vsub $v8, $v9, $v10
/* [784] */ addi r18, r0, 0x0
/* [788] */ vmudh $v12, $v5, $v6[1]
/* [78c] */ lh r12, 0x2(r4)
/* [790] */ vsar $v14, $v14, $v14[1]
/* [794] */ lh r13, 0x2(r5)
/* [798] */ vsar $v13, $v13, $v13[0]
/* [79c] */ lh r14, 0x2(r6)
/* [7a0] */ vmudh $v12, $v8, $v5[1]
/* [7a4] */ vsar $v16, $v16, $v16[1]
/* [7a8] */ andi r15, r11, GT_CULL_BACK
/* [7ac] */ vsar $v15, $v15, $v15[0]
@@b:
/* [7b0] */ slt r10, r13, r12
/* [7b4] */ blez r10, @@f
/* [7b8] */ add r10, r13, r0
/* [7bc] */ add r13, r12, r0
/* [7c0] */ add r12, r10, r0
/* [7c4] */ addu r10, r5, r0
/* [7c8] */ addu r5, r4, r0
/* [7cc] */ addu r4, r10, r0
/* [7d0] */ xori r18, r18, 0x1
/* [7d4] */ nop
@@f:
/* [7d8] */ vaddc $v28, $v14, $v16
/* [7dc] */ slt r10, r14, r13
/* [7e0] */ vadd $v29, $v13, $v15
/* [7e4] */ blez r10, @@f2
/* [7e8] */ add r10, r14, r0
/* [7ec] */ add r14, r13, r0
/* [7f0] */ add r13, r10, r0
/* [7f4] */ addu r10, r6, r0
/* [7f8] */ addu r6, r5, r0
/* [7fc] */ addu r5, r10, r0
/* [800] */ j @@b
/* [804] */ xori r18, r18, 0x1
@@f2:
/* [808] */ vlt $v27, $v29, $v31[0]
/* [80c] */ llv $v11[0], 0x0(r6)
/* [810] */ vor $v26, $v29, $v28
/* [814] */ llv $v10[0], 0x0(r5)
/* [818] */ llv $v9[0], 0x0(r4)
/* [81c] */ blez r18, @@f3
/* [820] */ vsub v_matrix0_i, $v11, $v10
/* [824] */ vmudn $v28, $v28, $v31[3]
/* [828] */ vmadh $v29, $v29, $v31[3]
/* [82c] */ vmadn $v28, $v31, $v31[0]
@@f3:
/* [830] */ vsub $v6, $v10, $v9
/* [834] */ mfc2 r17, $v27[0]
/* [838] */ vsub $v5, $v11, $v9
/* [83c] */ mfc2 r16, $v26[0]
/* [840] */ addi r10, r6, 0x4
/* [844] */ luv $v17[0], 0x8(r10)
/* [848] */ addi r10, r4, 0x4
/* [84c] */ luv $v19[0], 0x8(r10)
/* [850] */ vxor $v20, $v31, $v31
/* [854] */ addi r10, r5, 0x4
/* [858] */ luv $v18[0], 0x8(r10)
/* [85c] */ andi r10, r11, GT_SHADING_SMOOTH
/* [860] */ bgtz r10, @@f4 ; no need to load normals if shade_smooth is off
/* [864] */ addi r10, r7, 0x4 ; did they have to do this?
/* [868] */ luv $v17[0], 0x8(r10)
/* [86c] */ luv $v19[0], 0x8(r10)
/* [870] */ luv $v18[0], 0x8(r10)
@@f4:
/* [874] */ sra r17, r17, 31
/* [878] */ vmov $v29[3], $v29[0]
/* [87c] */ and r15, r15, r17
/* [880] */ vmov $v28[3], $v28[0]
/* [884] */ vmov v_matrix0_i[2], $v6[0]
/* [888] */ beqz r16, @@f8
/* [88c] */ vmudm $v17, $v17, $v31[7]
/* [890] */ vmudm $v19, $v19, $v31[7]
/* [894] */ bgtz r15, @@f8
/* [898] */ vmudm $v18, $v18, $v31[7]
/* [89c] */ vlt $v27, $v29, $v31[0]
/* [8a0] */ andi r12, r12, 0xfffc
/* [8a4] */ vmov v_matrix0_i[3], $v6[1]
/* [8a8] */ andi r13, r13, 0xfffc
/* [8ac] */ vmov v_matrix0_i[4], $v5[0]
/* [8b0] */ andi r14, r14, 0xfffc
/* [8b4] */ vmov v_matrix0_i[5], $v5[1]
/* [8b8] */ mfc2 r10, $v27[0]
/* [8bc] */ llv $v19[8], 0x8(r4)
/* [8c0] */ vrcph $v27[3], $v29[3]
/* [8c4] */ llv $v18[8], 0x8(r5)
/* [8c8] */ vrcpl $v26[3], $v28[3]
/* [8cc] */ llv $v17[8], 0x8(r6)
/* [8d0] */ vrcph $v27[3], $v31[0]
/* [8d4] */ vmov $v19[6], $v30[0]
/* [8d8] */ vmov $v18[6], $v30[0]
/* [8dc] */ lsv $v19[14], 0x4(r4)
/* [8e0] */ vmudn $v26, $v26, $v31[2]
/* [8e4] */ lsv $v18[14], 0x4(r5)
/* [8e8] */ vmadh $v27, $v27, $v31[2]
/* [8ec] */ lsv $v17[14], 0x4(r6)
/* [8f0] */ vmadn $v26, $v31, $v31[0]
/* [8f4] */ vmov $v17[6], $v30[0]
/* [8f8] */ lqv $v23[0], newton_iterator_vec(r0)
/* [8fc] */ vxor $v22, $v31, $v31
/* [900] */ vmudl $v24, $v26, $v28
/* [904] */ vmadm $v24, $v27, $v28
/* [908] */ vmadn $v24, $v26, $v29
/* [90c] */ vmadh $v25, $v27, $v29
/* [910] */ vsub $v14, $v19, $v17
/* [914] */ vsub $v15, $v19, $v18
/* [918] */ vsubc $v24, $v22, $v24
/* [91c] */ vsub $v25, $v23, $v25
/* [920] */ vsub $v21, $v18, $v19
/* [924] */ vsub $v22, $v17, $v19
/* [928] */ vmudl $v16, $v26, $v24
/* [92c] */ vmadm $v16, $v27, $v24
/* [930] */ addi r9, r0, 0x80
/* [934] */ vmadn $v26, $v26, $v25
/* [938] */ vmadh $v27, $v27, $v25
/* [93c] */ bltz r10, @@f5
/* [940] */ lb r8, 0x93(rsp_state)
/* [944] */ addi r9, r0, 0x0
@@f5:
/* [948] */ vmudm $v5, v_matrix0_i, $v31[4]
/* [94c] */ vmadn $v6, $v31, $v31[0]
/* [950] */ vrcp $v28[1], v_matrix0_i[1]
/* [954] */ lb r10, 0x97(rsp_state)
/* [958] */ vrcph $v29[1], $v31[0]
/* [95c] */ ori r8, r8, 0xcc
/* [960] */ vrcp $v28[3], v_matrix0_i[3]
/* [964] */ vrcph $v29[3], $v31[0]
/* [968] */ vrcp $v28[5], v_matrix0_i[5]
/* [96c] */ or r9, r9, r10
/* [970] */ vrcph $v29[5], $v31[0]
/* [974] */ vmudl $v28, $v28, $v30[2]
/* [978] */ sb r8, 0x0(r23)
/* [97c] */ vmadm $v29, $v29, $v30[2]
/* [980] */ sb r9, 0x1(r23)
/* [984] */ vmadn $v28, $v31, $v31[0]
/* [988] */ vmudh v_matrix0_i, v_matrix0_i, $v31[5]
/* [98c] */ lsv $v7[0], 0x0(r5)
/* [990] */ vmudl $v2, $v28, $v6[0q]
/* [994] */ lsv $v7[4], 0x0(r4)
/* [998] */ vmadm $v2, $v29, $v6[0q]
/* [99c] */ lsv $v7[8], 0x0(r4)
/* [9a0] */ vmadn $v2, $v28, $v5[0q]
/* [9a4] */ vmadh $v1, $v29, $v5[0q]
/* [9a8] */ sh r14, 0x2(r23)
/* [9ac] */ vmadn $v2, $v31, $v31[0]
/* [9b0] */ sh r12, 0x6(r23)
/* [9b4] */ vmudm $v7, $v7, $v31[4]
/* [9b8] */ vmadn $v8, $v31, $v31[0]
/* [9bc] */ sh r13, 0x4(r23)
/* [9c0] */ vcr $v1, $v1, $v30[6]
/* [9c4] */ ssv $v2[2], 0xe(r23)
/* [9c8] */ vmudm $v16, $v22, $v28[5]
/* [9cc] */ ssv $v2[10], 0x16(r23)
/* [9d0] */ vmadh $v25, $v22, $v29[5]
/* [9d4] */ ssv $v2[6], 0x1e(r23)
/* [9d8] */ vmadn $v24, $v31, $v31[0]
/* [9dc] */ ssv $v7[0], 0x8(r23)
/* [9e0] */ vmudh $v16, $v22, v_matrix0_i[3]
/* [9e4] */ ssv $v8[0], 0xa(r23)
/* [9e8] */ vmadh $v16, $v15, v_matrix0_i[5]
/* [9ec] */ ssv $v1[2], 0xc(r23)
/* [9f0] */ vsar $v22, $v22, $v22[0]
/* [9f4] */ ssv $v1[10], 0x14(r23)
/* [9f8] */ vsar $v23, $v23, $v23[1]
/* [9fc] */ ssv $v1[6], 0x1c(r23)
/* [a00] */ ssv $v7[8], 0x10(r23)
/* [a04] */ ssv $v8[8], 0x12(r23)
/* [a08] */ ssv $v7[4], 0x18(r23)
/* [a0c] */ ssv $v8[4], 0x1a(r23)
/* [a10] */ addi r23, r23, 0x20
/* [a14] */ vmudl $v16, $v23, $v26[3]
/* [a18] */ sdv $v20[0], 0x28(r23)
/* [a1c] */ vmadm $v16, $v22, $v26[3]
/* [a20] */ sdv $v20[0], 0x38(r23)
/* [a24] */ vmadn $v23, $v23, $v27[3]
/* [a28] */ sdv $v25[0], 0x20(r23)
/* [a2c] */ vmadh $v22, $v22, $v27[3]
/* [a30] */ sdv $v24[0], 0x30(r23)
/* [a34] */ sdv $v19[0], 0x0(r23)
/* [a38] */ sdv $v20[0], 0x10(r23)
/* [a3c] */ andi r10, r8, 0x2
/* [a40] */ sdv $v22[0], 0x8(r23)
/* [a44] */ sdv $v23[0], 0x18(r23)
/* [a48] */ blez r10, @@f6
/* [a4c] */ addi r23, r23, 0x40
/* [a50] */ sdv $v19[8], 0x0(r23)
/* [a54] */ sdv $v20[8], 0x10(r23)
/* [a58] */ sdv $v22[8], 0x8(r23)
/* [a5c] */ sdv $v23[8], 0x18(r23)
/* [a60] */ sdv $v20[0], 0x28(r23)
/* [a64] */ sdv $v20[0], 0x38(r23)
/* [a68] */ sdv $v25[8], 0x20(r23)
/* [a6c] */ sdv $v24[8], 0x30(r23)
/* [a70] */ addi r23, r23, 0x40
@@f6:
/* [a74] */ andi r10, r8, 0x1
/* [a78] */ blez r10, @@f7
/* [a7c] */ vmudh $v16, $v21, v_matrix0_i[4]
/* [a80] */ vmadh $v16, $v21, v_matrix0_i[2]
/* [a84] */ vsar $v21, $v21, $v21[0]
/* [a88] */ vsar $v5, $v5, $v5[1]
/* [a8c] */ vmudl $v16, $v5, $v26[3]
/* [a90] */ vmadm $v16, $v21, $v26[3]
/* [a94] */ vmadn $v5, $v5, $v27[3]
/* [a98] */ vmadh $v21, $v21, $v27[3]
/* [a9c] */ vmudn $v24, $v24, $v30[4]
/* [aa0] */ vmadh $v25, $v25, $v30[4]
/* [aa4] */ vmadn $v24, $v31, $v31[0]
/* [aa8] */ vmudn $v1, $v20, $v30[4]
/* [aac] */ vmadh $v19, $v19, $v30[4]
/* [ab0] */ vmadn $v1, $v31, $v31[0]
/* [ab4] */ ssv $v25[14], 0x8(r23)
/* [ab8] */ vmudn $v23, $v23, $v30[4]
/* [abc] */ ssv $v24[14], 0xa(r23)
/* [ac0] */ vmadh $v22, $v22, $v30[4]
/* [ac4] */ vmadn $v23, $v31, $v31[0]
/* [ac8] */ ssv $v22[14], 0x4(r23)
/* [acc] */ ssv $v23[14], 0x6(r23)
/* [ad0] */ ssv $v21[14], 0xc(r23)
/* [ad4] */ ssv $v5[14], 0xe(r23)
/* [ad8] */ addi r23, r23, 0x10
/* [adc] */ ssv $v19[14], -0x10(r23)
/* [ae0] */ ssv $v1[14], -0xe(r23)
@@f7:
/* [ae4] */ jal setup_rdp
@@f8:
/* [ae8] */ nop
/* [aec] */ j @bigman_loop
/* [af0] */ nop
.align 16
.close

