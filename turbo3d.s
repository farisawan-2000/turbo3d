#include <PR/rcp.h>
#include <PR/gbi.h>
#include <PR/gt.h>

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
    ; load_display_list dma's to here
.endarea

.area 0xBC0 - ., 0
    ; scratch space?
.endarea

.endarea
.close

.create CODE_FILE, 0x04001080
.area 0x1000
; DEFINES (move to new file?)
OSTask equ r1
rsp_state equ r29
DMA_TYPE equ r17
DMA_ISWRITE equ r17
    dma_READ equ 0
    dma_WRITE equ 1
DMA_LEN equ r18
DMA_SRC equ r19
DMA_DEST equ r20

vtx_xyz equ 0
vtx_flag equ 0x6

; vreg names
#define v_matrix0_i $v0
#define v_matrix0_f $v4

#define v_matrix1_i $v1
#define v_matrix1_f $v5

#define v_matrix2_i $v2
#define v_matrix2_f $v6

#define v_matrix3_i $v3
#define v_matrix3_f $v7

#define v_w_scale $v8
#define v_viewport_scale $v9
#define v_viewport_translation $v10

#define v_vtx_input_1_and_2 $v11
#define v_vtx_output_1_and_2_i $v12
#define v_vtx_output_1_and_2_f $v13
#define v_persp_correct_1_and_2_i $v14
#define v_persp_correct_1_and_2_f $v15
#define v_w_reciprocal_1_and_2_i $v16
#define v_w_reciprocal_1_and_2_f $v17
#define v_screen_space_vtx_1_and_2_i $v18
#define v_screen_space_vtx_1_and_2_f $v19

#define v_vtx_input_3_and_4 $v20
#define v_vtx_output_3_and_4_i $v21
#define v_vtx_output_3_and_4_f $v22
#define v_persp_correct_3_and_4_i $v23
#define v_persp_correct_3_and_4_f $v24
#define v_w_reciprocal_3_and_4_i $v25
#define v_w_reciprocal_3_and_4_f $v26
#define v_screen_space_vtx_3_and_4_i $v27
#define v_screen_space_vtx_3_and_4_f $v28

#define v_const $v31


#define DMEM(addr) addr(r0)
#define DMEM_PTR(addr) r0, addr


#include "src/entry.s"

// start of gtmain

dl_dma_wait:
/* [094] */ jal wait_for_dma_finish
/* [098] */  nop
/* [09c] */ addi r27, r0, 0x640
decode_dl:
/* [0a0] */ lw r3, 0x0(r27)
/* [0a4] */ lw r25, 0x4(r27)
/* [0a8] */ lw r24, 0x8(r27)
/* [0ac] */ lw r30, 0xc(r27)
/* [0b0] */ addi r26, r26, 16
/* [0b4] */ addi r27, r27, 16
/* [0b8] */ addi r28, r28, -16
/* [0bc] */ beqz r3, @@skipGlob
/* [0c0] */  add r19, r0, r3
/* [0c4] */ jal segmented_to_virtual
/* [0c8] */  addi r20, r0, dmem_gtGlobState
/* [0cc] */ addi r18, r0, 0x63
/* [0d0] */ jal dma_read_write
/* [0d4] */  addi r17, r0, 0x0
/* [0d8] */ jal wait_for_dma_finish
/* [0dc] */  nop
/* [0e0] */ jal gtGlobStateProcessor
/* [0e4] */  nop
@@skipGlob:
// Yield if no obj state
/* [0e8] */ beqz r25, @task_done
/* [0ec] */  add r19, r0, r25
/* [0f0] */ jal segmented_to_virtual
; read in the Lite part of the current gtState
/* [0f4] */  addi DMA_DEST, r0, dmem_gtStateL
/* [0f8] */ addi DMA_LEN, r0, 0x18 - 1
/* [0fc] */ jal dma_read_write
/* [100] */  addi DMA_ISWRITE, r0, FALSE
/* [104] */ jal wait_for_dma_finish
/* [108] */  nop
/* [10c] */ beqz r24, @@f4
/* [110] */  add r19, r0, r24
/* [114] */ lb r5, dmem_gtStateL_vtxCount(rsp_state)
/* [118] */ lb r6, dmem_gtStateL_vtxV0(rsp_state)
/* [11c] */ jal segmented_to_virtual
/* [120] */  addi r20, r0, dmem_vertexbuffer
/* [124] */ sll r6, r6, 4
/* [128] */ add r20, r20, r6
/* [12c] */ sll r5, r5, 4
/* [130] */ addi r18, r5, -1
/* [134] */ jal dma_read_write
/* [138] */  addi r17, r0, 0x0
@@f4:
/* [13c] */ jal dma_transform_mtx
/* [140] */  nop
/* [144] */ jal wait_for_dma_finish
/* [148] */  nop
/* [14c] */ lb r5, dmem_gtStateL_flag(rsp_state)
/* [150] */ andi r6, r5, 0x4
/* [154] */ bgtz r6, @@skipTriLoading
/* [158] */  lb r5, dmem_gtStateL_triCount(rsp_state)
/* [15c] */ beqz r5, @@skipTriLoading
/* [160] */  add r19, r0, r30
/* [164] */     jal segmented_to_virtual
/* [168] */     addi DMA_DEST, r0, 0x540
/* [16c] */     sll r5, r5, 2
/* [170] */     addi DMA_LEN, r5, -1
/* [174] */     lb r5, dmem_gtStateL_flag(rsp_state)
/* [178] */     jal dma_read_write
/* [17c] */     addi DMA_ISWRITE, r0, FALSE
@@skipTriLoading:
/* [180] */ andi r5, r5, 0x2
/* [184] */ bgtz r5, @@noTransform
/* [188] */  nop
/* [18c] */ jal transform_vtx_handler
/* [190] */  nop
@@noTransform:
/* [194] */ jal wait_for_dma_finish
/* [198] */  nop
/* [19c] */ jal triangle_draw_handler
/* [1a0] */  nop

gfx_done:
/* [1a4] */ mfc0 r2, sp_status
/* [1a8] */ andi r2, r2, 0x80
/* [1ac] */ bnez r2, @rsp_yield
/* [1b0] */  nop
/* [1b4] */ bgtz r28, decode_dl
/* [1b8] */  nop
/* [1bc] */ j load_display_list
/* [1c0] */  lh ra, dmem_dma_wait(r0)

@task_done:
// nop'd out if non-DRAM ucode
/* [1c4] */ nop
@task_halt:
/* [1c8] */ jal wait_for_dma_finish
/* [1cc] */  ori r2, r0, 0x4000
/* [1d0] */ mtc0 r2, sp_status
/* [1d4] */ break 0
/* [1d8] */  nop
#ifndef NON_MATCHING // free instruction save
/* [1dc] */ addiu r0, r0, 0xbeef
#endif

// continue gtmain

load_display_list:
/* [1e0] */ addi r28, r0, 0xf0
/* [1e4] */ add r21, r0, ra
/* [1e8] */ addi DMA_DEST, r0, dmem_640
/* [1ec] */ add DMA_SRC, r0, r26
/* [1f0] */ addi DMA_LEN, r0, 0xF0 - 1
/* [1f4] */ jal dma_read_write
/* [1f8] */ addi DMA_ISWRITE, r0, FALSE
/* [1fc] */ jr r21
/* [200] */ addi r27, r0, 0x640

segmented_to_virtual:
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

// start of gyield
@rsp_yield:
/* [274] */ ori r2, r0, 0x1000
/* [278] */ sw r28, 0x734(r0)
/* [27c] */ sw r27, 0x738(r0)
/* [280] */ sw r26, 0x73c(r0)
/* [284] */ sw r23, 0x740(r0)
/* [288] */ lw  DMA_SRC, 0x50(r0)
/* [28c] */ ori DMA_DEST, r0, 0x0
/* [290] */ ori DMA_LEN, r0, 0x65f
/* [294] */ jal dma_read_write
/* [298] */  ori DMA_ISWRITE, r0, TRUE
/* [29c] */ jal wait_for_dma_finish
/* [2a0] */  nop
/* [2a4] */ j @task_done
/* [2a8] */  mtc0 r2, sp_status
rsp_yield_restart:
/* [2ac] */ lw r23, 0x740(r0)
/* [2b0] */ lw r28, 0x734(r0)
/* [2b4] */ lw r27, 0x738(r0)
/* [2b8] */ j gfx_done
/* [2bc] */  lw r26, 0x73c(r0)

// start of goutfifo
// makes sure the RDP FIFO buffer is ready and dma'd
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

#include "src/gtGlobState_processor.s"
#include "src/vertex_transformer.s"
#include "src/triangle_handler.s"

.align 16

.endarea
.close


