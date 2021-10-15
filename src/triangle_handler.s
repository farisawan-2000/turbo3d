// start of gtsetup
triangle_draw_handler:
/* [6cc] */ lb r10, dmem_gtStateL_flag(rsp_state)
/* [6d0] */ andi r10, r10, GT_FLAG_XFM_ONLY
/* [6d4] */ bgtz r10, gfx_done
/* [6d8] */ sw ra, 0x70(r0)
/* [6dc] */ addi r1, r0, 0x540
/* [6e0] */ lb r2, dmem_gtStateL_triCount(rsp_state)
/* [6e4] */ sll r2, r2, 2
/* [6e8] */ beqz r2, @noTris
/* [6ec] */ add r2, r2, r1
/* [6f0] */ lw r11, dmem_gtStateL_renderState(rsp_state)

@draw_next_triangle:
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
/* [72c] */  addi r1, r1, 0x4
@lab_040017b0:
/* [730] */ lui r1, 0xe700
/* [734] */ sw r1, 0x0(r23)
/* [738] */ sw r0, 0x4(r23)
/* [73c] */ jal setup_rdp
/* [740] */  addi r23, r23, 0x8
@noTris:
/* [744] */ lw ra, 0x70(r0)
/* [748] */ jr ra
@lab_040017cc:
/* [74c] */  lb r7, 0x3(r1)
/* [750] */ sll r7, r7, 2
/* [754] */ sw r4, 0xbb0(r0)
/* [758] */ sw r5, 0xbb4(r0)
/* [75c] */ sw r6, 0xbb8(r0)
/* [760] */ j @lab_040017a4
/* [764] */  lw r7, 0xbb0(r7)
@lab_040017e8:
// TODO: put rejection here
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
/* [7b8] */  add r10, r13, r0
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
/* [7e8] */  add r10, r14, r0
/* [7ec] */ add r14, r13, r0
/* [7f0] */ add r13, r10, r0
/* [7f4] */ addu r10, r6, r0
/* [7f8] */ addu r6, r5, r0
/* [7fc] */ addu r5, r10, r0
/* [800] */ j @@b
/* [804] */  xori r18, r18, 0x1
@@f2:
/* [808] */ vlt $v27, $v29, $v31[0]
/* [80c] */ llv $v11[0], 0x0(r6)
/* [810] */ vor $v26, $v29, $v28
/* [814] */ llv $v10[0], 0x0(r5)
/* [818] */ llv $v9[0], 0x0(r4)
/* [81c] */ blez r18, @@f3
/* [820] */  vsub v_matrix0_i, $v11, $v10
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
/* [864] */  addi r10, r7, 0x4 ; did they have to do this?
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
/* [95c] */ ori r8, r8, G_TRI_SHADE
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
/* [ae8] */  nop
/* [aec] */ j @draw_next_triangle
/* [af0] */  nop