#define LOAD_MTX(mtx, offset, reg) \
    ldv mtx##0_i[offset], 0x0(reg); \
    ldv mtx##1_i[offset], 0x8(reg); \
    ldv mtx##2_i[offset], 0x10(reg); \
    ldv mtx##3_i[offset], 0x18(reg); \
    ldv mtx##0_f[offset], 0x20(reg); \
    ldv mtx##1_f[offset], 0x28(reg); \
    ldv mtx##2_f[offset], 0x30(reg); \
    ldv mtx##3_f[offset], 0x38(reg); \


// start of gtvtx
transform_vtx_handler:
#define vtxPtr r22
#define transformedVtxPtr r3
#define numVerticesLeft r5
#define vtxCount r1
/* [480] */ lb vtxCount, dmem_gtStateL_vtxCount(rsp_state)
/* [484] */ lb r2, dmem_gtStateL_vtxV0(rsp_state)
/* [488] */ addi vtxPtr, r0, dmem_vertexbuffer
/* [48c] */ beqz vtxCount, @@f2
/* [490] */  sw ra, dmem_returnaddr(r0)
/* [494] */ addi numVerticesLeft, vtxCount, 0x0
/* [498] */ addi transformedVtxPtr, r0, dmem_vertexbuffer
/* [49c] */ sll r4, r2, 4
/* [4a0] */ add transformedVtxPtr, r4
/* [4a4] */ add vtxPtr, r4
/* [4a8] */ ldv v_invtx_1_and_2[0], 0x0(vtxPtr)
/* [4ac] */ ldv v_invtx_1_and_2[8], 0x10(vtxPtr)
/* [4b0] */ ldv v_invtx_3_and_4[0], 0x20(vtxPtr)
/* [4b4] */ ldv v_invtx_3_and_4[8], 0x30(vtxPtr)
/* [4b8] */ addi r4, r0, dmem_gtStateMtx
/* [4bc] */ ldv v_mtx0_i[0], 0x0(r4);
/* [4c0] */ ldv v_mtx1_i[0], 0x8(r4);
/* [4c4] */ ldv v_mtx2_i[0], 0x10(r4);
/* [4c8] */ ldv v_mtx3_i[0], 0x18(r4);
/* [4cc] */ ldv v_mtx0_f[0], 0x20(r4);
/* [4d0] */ ldv v_mtx1_f[0], 0x28(r4);
/* [4d4] */ ldv v_mtx2_f[0], 0x30(r4);
/* [4d8] */ ldv v_mtx3_f[0], 0x38(r4);

/* [4dc] */ ldv v_mtx0_i[8], 0x0(r4)
/* [4e0] */ ldv v_mtx1_i[8], 0x8(r4)
/* [4e4] */ ldv v_mtx2_i[8], 0x10(r4)
/* [4e8] */ ldv v_mtx3_i[8], 0x18(r4)
/* [4ec] */ ldv v_mtx0_f[8], 0x20(r4)
/* [4f0] */ ldv v_mtx1_f[8], 0x28(r4)
/* [4f4] */ ldv v_mtx2_f[8], 0x30(r4)
/* [4f8] */ ldv v_mtx3_f[8], 0x38(r4)
/* [4fc] */ lqv $v29[0], DMEM(opengl_correction_scale_vec)
/* [500] */ addi r4, DMEM_PTR(0xC8)
/* [504] */ ldv $v9[0], 0x0(r4)
/* [508] */ ldv v_viewport_translation[0], 0x8(r4)
/* [50c] */ ldv $v9[8], 0x0(r4)
/* [510] */ ldv v_viewport_translation[8], 0x8(r4)
/* [514] */ lsv v_w_scale[0], 0x28(rsp_state)
/* [518] */ vmudh $v9, $v9, $v29

@@b:
/* [51c] */ vmudn v_outvtx_1_and_2_f, v_mtx0_f, v_invtx_1_and_2[0h]
/* [520] */ vmadh v_outvtx_1_and_2_f, v_mtx0_i, v_invtx_1_and_2[0h]
/* [524] */ vmadn v_outvtx_1_and_2_f, v_mtx1_f, v_invtx_1_and_2[1h]
/* [528] */ vmadh v_outvtx_1_and_2_f, v_mtx1_i, v_invtx_1_and_2[1h]
/* [52c] */ vmadn v_outvtx_1_and_2_f, v_mtx2_f, v_invtx_1_and_2[2h]
/* [530] */ vmadh v_outvtx_1_and_2_f, v_mtx2_i, v_invtx_1_and_2[2h]
/* [534] */ vmadn v_outvtx_1_and_2_f, v_mtx3_f, v_const[1]
/* [538] */ vmadh v_outvtx_1_and_2_i, v_mtx3_i, v_const[1]
/* [53c] */ vmudn v_outvtx_3_and_4_f, v_mtx0_f, v_invtx_3_and_4[0h]
/* [540] */ vmadh v_outvtx_3_and_4_f, v_mtx0_i, v_invtx_3_and_4[0h]
/* [544] */ vmadn v_outvtx_3_and_4_f, v_mtx1_f, v_invtx_3_and_4[1h]
/* [548] */ vmadh v_outvtx_3_and_4_f, v_mtx1_i, v_invtx_3_and_4[1h]
/* [54c] */ vmadn v_outvtx_3_and_4_f, v_mtx2_f, v_invtx_3_and_4[2h]
/* [550] */ vmadh v_outvtx_3_and_4_f, v_mtx2_i, v_invtx_3_and_4[2h]
/* [554] */ vmadn v_outvtx_3_and_4_f, v_mtx3_f, v_const[1]
/* [558] */ vmadh v_outvtx_3_and_4_i, v_mtx3_i, v_const[1]
/* [55c] */ addi vtxPtr, 0x40
/* [560] */ vmudl v_persp_correct_1_and_2_f, v_outvtx_1_and_2_f, v_w_scale[0]
/* [564] */ vmadm v_persp_correct_1_and_2_i, v_outvtx_1_and_2_i, v_w_scale[0]
/* [568] */ vmadn v_persp_correct_1_and_2_f, v_const, v_const[0]
/* [56c] */ vmudl v_persp_correct_3_and_4_f, v_outvtx_3_and_4_f, v_w_scale[0]
/* [570] */ vmadm v_persp_correct_3_and_4_i, v_outvtx_3_and_4_i, v_w_scale[0]
/* [574] */ vmadn v_persp_correct_3_and_4_f, v_const, v_const[0]
/* [578] */ vrcph v_w_reciprocal_1_and_2_i[3], v_persp_correct_1_and_2_i[3]
/* [57c] */ vrcpl v_w_reciprocal_1_and_2_f[3], v_persp_correct_1_and_2_f[3]
/* [580] */ vrcph v_w_reciprocal_1_and_2_i[3], v_persp_correct_1_and_2_i[7]
/* [584] */ vrcpl v_w_reciprocal_1_and_2_f[7], v_persp_correct_1_and_2_f[7]
/* [588] */ vrcph v_w_reciprocal_1_and_2_i[7], v_const[0]
/* [58c] */ vrcph v_w_reciprocal_3_and_4_i[3], v_persp_correct_3_and_4_i[3]
/* [590] */ vrcpl v_w_reciprocal_3_and_4_f[3], v_persp_correct_3_and_4_f[3]
/* [594] */ vrcph v_w_reciprocal_3_and_4_i[3], v_persp_correct_3_and_4_i[7]
/* [598] */ vrcpl v_w_reciprocal_3_and_4_f[7], v_persp_correct_3_and_4_f[7]
/* [59c] */ vrcph v_w_reciprocal_3_and_4_i[7], v_const[0]
/* [5a0] */ vmudn v_w_reciprocal_1_and_2_f, v_w_reciprocal_1_and_2_f, v_const[2]
/* [5a4] */ vmadh v_w_reciprocal_1_and_2_i, v_w_reciprocal_1_and_2_i, v_const[2]
/* [5a8] */ vmadn v_w_reciprocal_1_and_2_f, v_const, v_const[0]
/* [5ac] */ vmudn v_w_reciprocal_3_and_4_f, v_w_reciprocal_3_and_4_f, v_const[2]
/* [5b0] */ vmadh v_w_reciprocal_3_and_4_i, v_w_reciprocal_3_and_4_i, v_const[2]
/* [5b4] */ vmadn v_w_reciprocal_3_and_4_f, v_const, v_const[0]
/* [5b8] */ vmudl v_persp_correct_1_and_2_f, v_outvtx_1_and_2_f, v_w_reciprocal_1_and_2_f[3h]
/* [5bc] */ vmadm v_persp_correct_1_and_2_f, v_outvtx_1_and_2_i, v_w_reciprocal_1_and_2_f[3h]
/* [5c0] */ vmadn v_persp_correct_1_and_2_f, v_outvtx_1_and_2_f, v_w_reciprocal_1_and_2_i[3h]
/* [5c4] */ vmadh v_persp_correct_1_and_2_i, v_outvtx_1_and_2_i, v_w_reciprocal_1_and_2_i[3h]
/* [5c8] */ vmudl v_persp_correct_3_and_4_f, v_outvtx_3_and_4_f, v_w_reciprocal_3_and_4_f[3h]
/* [5cc] */ vmadm v_persp_correct_3_and_4_f, v_outvtx_3_and_4_i, v_w_reciprocal_3_and_4_f[3h]
/* [5d0] */ vmadn v_persp_correct_3_and_4_f, v_outvtx_3_and_4_f, v_w_reciprocal_3_and_4_i[3h]
/* [5d4] */ vmadh v_persp_correct_3_and_4_i, v_outvtx_3_and_4_i, v_w_reciprocal_3_and_4_i[3h]
/* [5d8] */ vmudl v_persp_correct_1_and_2_f, v_persp_correct_1_and_2_f, v_w_scale[0]
/* [5dc] */ ldv v_outvtx_1_and_2_i[0], dmem_screenclamp_vec(r0)
/* [5e0] */ vmadm v_persp_correct_1_and_2_i, v_persp_correct_1_and_2_i, v_w_scale[0]
/* [5e4] */ ldv v_outvtx_1_and_2_i[8], dmem_screenclamp_vec(r0)
/* [5e8] */ vmadn v_persp_correct_1_and_2_f, v_const, v_const[0]
/* [5ec] */ vmudl v_persp_correct_3_and_4_f, v_persp_correct_3_and_4_f, v_w_scale[0]
/* [5f0] */ vmadm v_persp_correct_3_and_4_i, v_persp_correct_3_and_4_i, v_w_scale[0]
/* [5f4] */ vmadn v_persp_correct_3_and_4_f, v_const, v_const[0]
/* [5f8] */ vmudh v_screen_vtx_1_and_2_f, v_viewport_translation, v_const[1]
/* [5fc] */ vmadn v_screen_vtx_1_and_2_f, v_persp_correct_1_and_2_f, $v9
/* [600] */ ldv v_invtx_1_and_2[0], 0x0(r22)
/* [604] */ vmadh v_screen_vtx_1_and_2_i, v_persp_correct_1_and_2_i, $v9
/* [608] */ ldv v_invtx_1_and_2[8], 0x10(r22)
/* [60c] */ vmadn v_screen_vtx_1_and_2_f, v_const, v_const[0]
/* [610] */ vmudh v_screen_vtx_3_and_4_f, v_viewport_translation, v_const[1]
/* [614] */ vmadn v_screen_vtx_3_and_4_f, v_persp_correct_3_and_4_f, $v9
/* [618] */ ldv v_invtx_3_and_4[0], 0x20(r22)
/* [61c] */ vmadh v_screen_vtx_3_and_4_i, v_persp_correct_3_and_4_i, $v9
/* [620] */ ldv v_invtx_3_and_4[8], 0x30(r22)
/* [624] */ vmadn v_screen_vtx_3_and_4_f, v_const, v_const[0]
/* [628] */ vlt v_screen_vtx_1_and_2_i, v_screen_vtx_1_and_2_i, v_outvtx_1_and_2_i[0q]
/* [62c] */ addi numVerticesLeft, -1
/* [630] */ vlt v_screen_vtx_3_and_4_i, v_screen_vtx_3_and_4_i, v_outvtx_1_and_2_i[0q]
/* [634] */ vadd v_screen_vtx_1_and_2_i, v_screen_vtx_1_and_2_i, v_const[2]
/* [638] */ vadd v_screen_vtx_3_and_4_i, v_screen_vtx_3_and_4_i, v_const[2]
/* [63c] */ vand v_screen_vtx_1_and_2_i, v_screen_vtx_1_and_2_i, v_const[6]
/* [640] */ vand v_screen_vtx_3_and_4_i, v_screen_vtx_3_and_4_i, v_const[6]
/* [644] */ sdv v_screen_vtx_1_and_2_i[0], (vtx_xyz)(transformedVtxPtr)
/* [648] */ ssv v_screen_vtx_1_and_2_f[4], (vtx_flag)(transformedVtxPtr)
/* [64c] */ blez numVerticesLeft, @@f
/* [650] */  addi numVerticesLeft, numVerticesLeft, -1
/* [654] */ sdv v_screen_vtx_1_and_2_i[8], (0x10 + vtx_xyz)(transformedVtxPtr)
/* [658] */ ssv v_screen_vtx_1_and_2_f[12], (0x10 + vtx_flag)(transformedVtxPtr)
/* [65c] */ blez numVerticesLeft, @@f
/* [660] */  addi numVerticesLeft, numVerticesLeft, -1
/* [664] */ sdv v_screen_vtx_3_and_4_i[0], (0x20 + vtx_xyz)(transformedVtxPtr)
/* [668] */ ssv v_screen_vtx_3_and_4_f[4], (0x20 + vtx_flag)(transformedVtxPtr)
/* [66c] */ blez numVerticesLeft, @@f
/* [670] */  addi numVerticesLeft, numVerticesLeft, -1
/* [674] */ sdv v_screen_vtx_3_and_4_i[8], (0x30 + vtx_xyz)(transformedVtxPtr)
/* [678] */ ssv v_screen_vtx_3_and_4_f[12], (0x30 + vtx_flag)(transformedVtxPtr)
/* [67c] */ bgtz numVerticesLeft, @@b
/* [680] */  addi transformedVtxPtr, 0x40

@@f:
/* [684] */ lb r5, dmem_gtStateL_flag(rsp_state)
/* [688] */ lb r1, dmem_gtStateL_vtxCount(rsp_state)
/* [68c] */ lb r2, dmem_gtStateL_vtxV0(rsp_state)
/* [690] */ andi r5, r5, GT_FLAG_XFM_ONLY
/* [694] */ addi r22, r0, dmem_vertexbuffer
/* [698] */ beqz r5, @@f2
/* [69c] */  sll r4, r2, 4
/* [6a0] */ add r22, r22, r4
/* [6a4] */ add r19, r0, r30
/* [6a8] */ jal segmented_to_virtual
/* [6ac] */  addi r20, r0, 0x16
/* [6b0] */ sll r1, r1, 4
/* [6b4] */ addi DMA_LEN, r1, -1
/* [6b8] */ jal dma_read_write
/* [6bc] */  addi DMA_ISWRITE, r0, TRUE

@@f2:
/* [6c0] */ lw ra, DMEM(dmem_returnaddr)
/* [6c4] */ jr ra
/* [6c8] */  nop
