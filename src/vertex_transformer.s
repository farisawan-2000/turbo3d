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
/* [4a8] */ ldv $v11[0], 0x0(vtxPtr)
/* [4ac] */ ldv $v11[8], 0x10(vtxPtr)
/* [4b0] */ ldv $v20[0], 0x20(vtxPtr)
/* [4b4] */ ldv $v20[8], 0x30(vtxPtr)
/* [4b8] */ addi r4, r0, dmem_gtStateMtx
/* [4bc] */ ldv v_matrix0_i[0], 0x0(r4);
/* [4c0] */ ldv v_matrix1_i[0], 0x8(r4);
/* [4c4] */ ldv v_matrix2_i[0], 0x10(r4);
/* [4c8] */ ldv v_matrix3_i[0], 0x18(r4);
/* [4cc] */ ldv v_matrix0_f[0], 0x20(r4);
/* [4d0] */ ldv v_matrix1_f[0], 0x28(r4);
/* [4d4] */ ldv v_matrix2_f[0], 0x30(r4);
/* [4d8] */ ldv v_matrix3_f[0], 0x38(r4);

/* [4dc] */ ldv v_matrix0_i[8], 0x0(r4)
/* [4e0] */ ldv v_matrix1_i[8], 0x8(r4)
/* [4e4] */ ldv v_matrix2_i[8], 0x10(r4)
/* [4e8] */ ldv v_matrix3_i[8], 0x18(r4)
/* [4ec] */ ldv v_matrix0_f[8], 0x20(r4)
/* [4f0] */ ldv v_matrix1_f[8], 0x28(r4)
/* [4f4] */ ldv v_matrix2_f[8], 0x30(r4)
/* [4f8] */ ldv v_matrix3_f[8], 0x38(r4)
/* [4fc] */ lqv $v29[0], DMEM(opengl_correction_scale_vec)
/* [500] */ addi r4, DMEM_PTR(0xC8)
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
/* [528] */ vmadh $v13, v_matrix1_i, $v11[1h]
/* [52c] */ vmadn $v13, $v6, $v11[2h]
/* [530] */ vmadh $v13, $v2, $v11[2h]
/* [534] */ vmadn $v13, $v7, $v31[1]
/* [538] */ vmadh $v12, $v3, $v31[1]
/* [53c] */ vmudn $v22, v_matrix0_f, $v20[0h]
/* [540] */ vmadh $v22, v_matrix0_i, $v20[0h]
/* [544] */ vmadn $v22, $v5, $v20[1h]
/* [548] */ vmadh $v22, v_matrix1_i, $v20[1h]
/* [54c] */ vmadn $v22, $v6, $v20[2h]
/* [550] */ vmadh $v22, $v2, $v20[2h]
/* [554] */ vmadn $v22, $v7, $v31[1]
/* [558] */ vmadh $v21, $v3, $v31[1]
/* [55c] */ addi vtxPtr, 0x40
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
/* [650] */  addi numVerticesLeft, numVerticesLeft, -1
/* [654] */ sdv $v18[8], (0x10 + vtx_xyz)(transformedVtxPtr)
/* [658] */ ssv $v19[12], (0x10 + vtx_flag)(transformedVtxPtr)
/* [65c] */ blez numVerticesLeft, @@f
/* [660] */  addi numVerticesLeft, numVerticesLeft, -1
/* [664] */ sdv $v27[0], (0x20 + vtx_xyz)(transformedVtxPtr)
/* [668] */ ssv $v28[4], (0x20 + vtx_flag)(transformedVtxPtr)
/* [66c] */ blez numVerticesLeft, @@f
/* [670] */  addi numVerticesLeft, numVerticesLeft, -1
/* [674] */ sdv $v27[8], (0x30 + vtx_xyz)(transformedVtxPtr)
/* [678] */ ssv $v28[12], (0x30 + vtx_flag)(transformedVtxPtr)
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
