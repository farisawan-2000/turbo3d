.rsp
.create CODE_FILE, 0x04001080


/* [04001080 / 000] 201d0050 */ addi r29, r0, 0x50
/* [04001084 / 004] 34022800 */ ori r2, r0, 0x2800
/* [04001088 / 008] 40822000 */ mtc0 r2, sp_status
/* [0400108c / 00c] 8c220028 */ lw r2, 0x28(r1)
/* [04001090 / 010] 8c23002c */ lw r3, 0x2c(r1)
/* [04001094 / 014] afa00004 */ sw r0, 0x4(r29)
/* [04001098 / 018] afa30010 */ sw r3, 0x10(r29)
/* [0400109c / 01c] c81f2000 */ lqv $v31[0], 0x0(r0)
/* [040010a0 / 020] c81e2001 */ lqv $v30[0], 0x10(r0)
/* [040010a4 / 024] 8c370028 */ lw r23, 0x28(r1)
/* [040010a8 / 028] 8c23002c */ lw r3, 0x2c(r1)
/* [040010ac / 02c] afb70018 */ sw r23, 0x18(r29)
/* [040010b0 / 030] afa3001c */ sw r3, 0x1c(r29)
/* [040010b4 / 034] 40045800 */ mfc0 r4, dpc_status
/* [040010b8 / 038] 30840001 */ andi r4, r4, 0x1
/* [040010bc / 03c] 1480000a */ bnez r4, @@f
/* [040010c0 / 040] 40044800 */ mfc0 r4, dpc_end
/* [040010c4 / 044] 02e4b822 */ sub r23, r23, r4
/* [040010c8 / 048] 1ee00007 */ bgtz r23, @@f
/* [040010cc / 04c] 40055000 */ mfc0 r5, dpc_current
/* [040010d0 / 050] 10a00005 */ beqz r5, @@f
/* [040010d4 / 054] 00000000 */ nop
/* [040010d8 / 058] 10a40003 */ beq r5, r4, @@f
/* [040010dc / 05c] 00000000 */ nop
/* [040010e0 / 060] 09000441 */ j @@f2
/* [040010e4 / 064] 34830000 */ ori r3, r4, 0x0
@@f:
@@b:
/* [040010e8 / 068] 40045800 */ mfc0 r4, dpc_status
/* [040010ec / 06c] 30840400 */ andi r4, r4, 0x400
/* [040010f0 / 070] 1480fffd */ bnez r4, @@b
/* [040010f4 / 074] 20040001 */ addi r4, r0, 0x1
/* [040010f8 / 078] 40845800 */ mtc0 r4, dpc_status
/* [040010fc / 07c] 40834000 */ mtc0 r3, dpc_start
/* [04001100 / 080] 40834800 */ mtc0 r3, dpc_end
@@f2:
/* [04001104 / 084] afa30004 */ sw r3, 0x4(r29)
/* [04001108 / 088] 201707b0 */ addi r23, r0, 0x7b0
/* [0400110c / 08c] 0d000498 */ jal turbo3d_04001260
/* [04001110 / 090] 8c3a0030 */ lw r26, 0x30(r1)
/* [04001114 / 094] 0d0004b6 */ jal turbo3d_040012d8
/* [04001118 / 098] 00000000 */ nop
/* [0400111c / 09c] 201b0640 */ addi r27, r0, 0x640
@lab_04001120:
/* [04001120 / 0a0] 8f630000 */ lw r3, 0x0(r27)
/* [04001124 / 0a4] 8f790004 */ lw r25, 0x4(r27)
/* [04001128 / 0a8] 8f780008 */ lw r24, 0x8(r27)
/* [0400112c / 0ac] 8f7e000c */ lw r30, 0xc(r27)
/* [04001130 / 0b0] 235a0010 */ addi r26, r26, 0x10
/* [04001134 / 0b4] 237b0010 */ addi r27, r27, 0x10
/* [04001138 / 0b8] 239cfff0 */ addi r28, r28, 0xfff0
/* [0400113c / 0bc] 1060000a */ beqz r3, @@f3
/* [04001140 / 0c0] 00039820 */ add r19, r0, r3
/* [04001144 / 0c4] 0d0004a1 */ jal turbo3d_04001284
/* [04001148 / 0c8] 20140078 */ addi r20, r0, 0x78
/* [0400114c / 0cc] 20120063 */ addi r18, r0, 0x63
/* [04001150 / 0d0] 0d0004a9 */ jal turbo3d_040012a4
/* [04001154 / 0d4] 20110000 */ addi r17, r0, 0x0
/* [04001158 / 0d8] 0d0004b6 */ jal turbo3d_040012d8
/* [0400115c / 0dc] 00000000 */ nop
/* [04001160 / 0e0] 0d0004f1 */ jal turbo3d_040013c4
/* [04001164 / 0e4] 00000000 */ nop
@@f3:
/* [04001168 / 0e8] 13200036 */ beqz r25, @lab_04001244
/* [0400116c / 0ec] 00199820 */ add r19, r0, r25
/* [04001170 / 0f0] 0d0004a1 */ jal turbo3d_04001284
/* [04001174 / 0f4] 201400e0 */ addi r20, r0, 0xe0
/* [04001178 / 0f8] 20120017 */ addi r18, r0, 0x17
/* [0400117c / 0fc] 0d0004a9 */ jal turbo3d_040012a4
/* [04001180 / 100] 20110000 */ addi r17, r0, 0x0
/* [04001184 / 104] 0d0004b6 */ jal turbo3d_040012d8
/* [04001188 / 108] 00000000 */ nop
/* [0400118c / 10c] 1300000b */ beqz r24, @@f4
/* [04001190 / 110] 00189820 */ add r19, r0, r24
/* [04001194 / 114] 83a50098 */ lb r5, 0x98(r29)
/* [04001198 / 118] 83a60099 */ lb r6, 0x99(r29)
/* [0400119c / 11c] 0d0004a1 */ jal turbo3d_04001284
/* [040011a0 / 120] 20140140 */ addi r20, r0, 0x140
/* [040011a4 / 124] 00063100 */ sll r6, r6, 4
/* [040011a8 / 128] 0286a020 */ add r20, r20, r6
/* [040011ac / 12c] 00052900 */ sll r5, r5, 4
/* [040011b0 / 130] 20b2ffff */ addi r18, r5, -1
/* [040011b4 / 134] 0d0004a9 */ jal turbo3d_040012a4
/* [040011b8 / 138] 20110000 */ addi r17, r0, 0x0
@@f4:
/* [040011bc / 13c] 0d000528 */ jal turbo3d_040014a0
/* [040011c0 / 140] 00000000 */ nop
/* [040011c4 / 144] 0d0004b6 */ jal turbo3d_040012d8
/* [040011c8 / 148] 00000000 */ nop
/* [040011cc / 14c] 83a5009b */ lb r5, 0x9b(r29)
/* [040011d0 / 150] 30a60004 */ andi r6, r5, 0x4
/* [040011d4 / 154] 1cc0000a */ bgtz r6, @@f5
/* [040011d8 / 158] 83a5009a */ lb r5, 0x9a(r29)
/* [040011dc / 15c] 10a00008 */ beqz r5, @@f5
/* [040011e0 / 160] 001e9820 */ add r19, r0, r30
/* [040011e4 / 164] 0d0004a1 */ jal turbo3d_04001284
/* [040011e8 / 168] 20140540 */ addi r20, r0, 0x540
/* [040011ec / 16c] 00052880 */ sll r5, r5, 2
/* [040011f0 / 170] 20b2ffff */ addi r18, r5, -1
/* [040011f4 / 174] 83a5009b */ lb r5, 0x9b(r29)
/* [040011f8 / 178] 0d0004a9 */ jal turbo3d_040012a4
/* [040011fc / 17c] 20110000 */ addi r17, r0, 0x0
@@f5:
/* [04001200 / 180] 30a50002 */ andi r5, r5, 0x2
/* [04001204 / 184] 1ca00003 */ bgtz r5, @@f6
/* [04001208 / 188] 00000000 */ nop
/* [0400120c / 18c] 0d000540 */ jal turbo3d_04001500
/* [04001210 / 190] 00000000 */ nop
@@f6:
/* [04001214 / 194] 0d0004b6 */ jal turbo3d_040012d8
/* [04001218 / 198] 00000000 */ nop
/* [0400121c / 19c] 0d0005d3 */ jal turbo3d_0400174c
/* [04001220 / 1a0] 00000000 */ nop

@lab_04001224:
/* [04001224 / 1a4] 40022000 */ mfc0 r2, sp_status
/* [04001228 / 1a8] 30420080 */ andi r2, r2, 0x80
/* [0400122c / 1ac] 14400031 */ bnez r2, @lab_040012f4
/* [04001230 / 1b0] 00000000 */ nop
/* [04001234 / 1b4] 1f80ffba */ bgtz r28, @lab_04001120
/* [04001238 / 1b8] 00000000 */ nop
/* [0400123c / 1bc] 09000498 */ j turbo3d_04001260
/* [04001240 / 1c0] 841f004c */ lh ra, 0x4c(r0)

@lab_04001244:
/* [04001244 / 1c4] 00000000 */ nop
/* [04001248 / 1c8] 0d0004b6 */ jal turbo3d_040012d8
/* [0400124c / 1cc] 34024000 */ ori r2, r0, 0x4000
/* [04001250 / 1d0] 40822000 */ mtc0 r2, sp_status
/* [04001254 / 1d4] 0000000d */ break 0
/* [04001258 / 1d8] 00000000 */ nop
/* [0400125c / 1dc] 2400beef */ addiu r0, r0, 0xbeef

turbo3d_04001260:
/* [04001260 / 1e0] 201c00f0 */ addi r28, r0, 0xf0
/* [04001264 / 1e4] 001fa820 */ add r21, r0, ra
/* [04001268 / 1e8] 20140640 */ addi r20, r0, 0x640
/* [0400126c / 1ec] 001a9820 */ add r19, r0, r26
/* [04001270 / 1f0] 201200ef */ addi r18, r0, 0xef
/* [04001274 / 1f4] 0d0004a9 */ jal turbo3d_040012a4
/* [04001278 / 1f8] 20110000 */ addi r17, r0, 0x0
/* [0400127c / 1fc] 02a00008 */ jr r21
/* [04001280 / 200] 201b0640 */ addi r27, r0, 0x640

turbo3d_04001284:
/* [04001284 / 204] 8c0b0048 */ lw r11, 0x48(r0)
/* [04001288 / 208] 00136582 */ srl r12, r19, 22
/* [0400128c / 20c] 318c003c */ andi r12, r12, 0x3c
/* [04001290 / 210] 026b9824 */ and r19, r19, r11
/* [04001294 / 214] 000c6820 */ add r13, r0, r12
/* [04001298 / 218] 8dac0088 */ lw r12, 0x88(r13)
/* [0400129c / 21c] 03e00008 */ jr ra
/* [040012a0 / 220] 026c9820 */ add r19, r19, r12

turbo3d_040012a4:
/* [040012a4 / 224] 400b3800 */ mfc0 r11, sp_semaphore
/* [040012a8 / 228] 1560fffe */ bnez r11, turbo3d_040012a4
@@b:
/* [040012ac / 22c] 400b2800 */ mfc0 r11, sp_dma_full
/* [040012b0 / 230] 1560fffe */ bnez r11, @@b
/* [040012b4 / 234] 00000000 */ nop
/* [040012b8 / 238] 40940000 */ mtc0 r20, sp_mem_addr
/* [040012bc / 23c] 1e200003 */ bgtz r17, @@f
/* [040012c0 / 240] 40930800 */ mtc0 r19, sp_dram_addr
/* [040012c4 / 244] 090004b4 */ j @@f2
/* [040012c8 / 248] 40921000 */ mtc0 r18, sp_rd_len
@@f:
/* [040012cc / 24c] 40921800 */ mtc0 r18, sp_wr_len
@@f2:
/* [040012d0 / 250] 03e00008 */ jr ra
/* [040012d4 / 254] 40803800 */ mtc0 r0, sp_semaphore

turbo3d_040012d8:
/* [040012d8 / 258] 400b3800 */ mfc0 r11, sp_semaphore
/* [040012dc / 25c] 1560fffe */ bnez r11, turbo3d_040012d8
@@b:
/* [040012e0 / 260] 400b3000 */ mfc0 r11, sp_dma_busy
/* [040012e4 / 264] 1560fffe */ bnez r11, @@b
/* [040012e8 / 268] 00000000 */ nop
/* [040012ec / 26c] 03e00008 */ jr ra
/* [040012f0 / 270] 40803800 */ mtc0 r0, sp_semaphore
@lab_040012f4:
/* [040012f4 / 274] 34021000 */ ori r2, r0, 0x1000
/* [040012f8 / 278] ac1c0734 */ sw r28, 0x734(r0)
/* [040012fc / 27c] ac1b0738 */ sw r27, 0x738(r0)
/* [04001300 / 280] ac1a073c */ sw r26, 0x73c(r0)
/* [04001304 / 284] ac170740 */ sw r23, 0x740(r0)
/* [04001308 / 288] 8c130050 */ lw r19, 0x50(r0)
/* [0400130c / 28c] 34140000 */ ori r20, r0, 0x0
/* [04001310 / 290] 3412065f */ ori r18, r0, 0x65f
/* [04001314 / 294] 0d0004a9 */ jal turbo3d_040012a4
/* [04001318 / 298] 34110001 */ ori r17, r0, 0x1
/* [0400131c / 29c] 0d0004b6 */ jal turbo3d_040012d8
/* [04001320 / 2a0] 00000000 */ nop
/* [04001324 / 2a4] 09000491 */ j @lab_04001244
/* [04001328 / 2a8] 40822000 */ mtc0 r2, sp_status
/* [0400132c / 2ac] 8c170740 */ lw r23, 0x740(r0)
/* [04001330 / 2b0] 8c1c0734 */ lw r28, 0x734(r0)
/* [04001334 / 2b4] 8c1b0738 */ lw r27, 0x738(r0)
/* [04001338 / 2b8] 09000489 */ j @lab_04001224
/* [0400133c / 2bc] 8c1a073c */ lw r26, 0x73c(r0)

turbo3d_04001340:
/* [04001340 / 2c0] 001fa820 */ add r21, r0, ra
/* [04001344 / 2c4] 8fb30004 */ lw r19, 0x4(r29)
/* [04001348 / 2c8] 22f2f850 */ addi r18, r23, 0xf850
/* [0400134c / 2cc] 8fb7001c */ lw r23, 0x1c(r29)
/* [04001350 / 2d0] 1a40001a */ blez r18, @@f3
/* [04001354 / 2d4] 0272a020 */ add r20, r19, r18
/* [04001358 / 2d8] 02f4a022 */ sub r20, r23, r20
/* [0400135c / 2dc] 06810008 */ bgez r20, @@f
@@b:
/* [04001360 / 2e0] 40145800 */ mfc0 r20, dpc_status
/* [04001364 / 2e4] 32940400 */ andi r20, r20, 0x400
/* [04001368 / 2e8] 1680fffd */ bnez r20, @@b
@@b2:
/* [0400136c / 2ec] 40175000 */ mfc0 r23, dpc_current
/* [04001370 / 2f0] 8fb30018 */ lw r19, 0x18(r29)
/* [04001374 / 2f4] 12f3fffd */ beq r23, r19, @@b2
/* [04001378 / 2f8] 00000000 */ nop
/* [0400137c / 2fc] 40934000 */ mtc0 r19, dpc_start
@@f:
@@b3:
/* [04001380 / 300] 40175000 */ mfc0 r23, dpc_current
/* [04001384 / 304] 0277a022 */ sub r20, r19, r23
/* [04001388 / 308] 06810004 */ bgez r20, @@f2
/* [0400138c / 30c] 0272a020 */ add r20, r19, r18
/* [04001390 / 310] 0297a022 */ sub r20, r20, r23
/* [04001394 / 314] 0681fffa */ bgez r20, @@b3
/* [04001398 / 318] 00000000 */ nop
@@f2:
/* [0400139c / 31c] 0272b820 */ add r23, r19, r18
/* [040013a0 / 320] 2252ffff */ addi r18, r18, -1
/* [040013a4 / 324] 201407b0 */ addi r20, r0, 0x7b0
/* [040013a8 / 328] 0d0004a9 */ jal turbo3d_040012a4
/* [040013ac / 32c] 20110001 */ addi r17, r0, 0x1
/* [040013b0 / 330] 0d0004b6 */ jal turbo3d_040012d8
/* [040013b4 / 334] afb70004 */ sw r23, 0x4(r29)
/* [040013b8 / 338] 40974800 */ mtc0 r23, dpc_end
@@f3:
/* [040013bc / 33c] 02a00008 */ jr r21
/* [040013c0 / 340] 201707b0 */ addi r23, r0, 0x7b0

turbo3d_040013c4:
/* [040013c4 / 344] 001f2820 */ add r5, r0, ra
/* [040013c8 / 348] 8c1300d8 */ lw r19, 0xd8(r0)
/* [040013cc / 34c] cba01806 */ ldv $v0[0], 0x30(r29)
/* [040013d0 / 350] eae01800 */ sdv $v0[0], 0x0(r23)
/* [040013d4 / 354] 22f70008 */ addi r23, r23, 0x8
/* [040013d8 / 358] 1260002d */ beqz r19, @lab_04001490
/* [040013dc / 35c] 00000000 */ nop
/* [040013e0 / 360] 0d0004a1 */ jal turbo3d_04001284
/* [040013e4 / 364] 00000000 */ nop
/* [040013e8 / 368] 22660000 */ addi r6, r19, 0x0
@lab_040013ec:
/* [040013ec / 36c] 20d30000 */ addi r19, r6, 0x0
/* [040013f0 / 370] 200107a0 */ addi r1, r0, 0x7a0
/* [040013f4 / 374] 20140730 */ addi r20, r0, 0x730
/* [040013f8 / 378] 20120077 */ addi r18, r0, 0x77
/* [040013fc / 37c] 0d0004a9 */ jal turbo3d_040012a4
/* [04001400 / 380] 20110000 */ addi r17, r0, 0x0
/* [04001404 / 384] 0d0004b6 */ jal turbo3d_040012d8
/* [04001408 / 388] 00000000 */ nop
@@b:
/* [0400140c / 38c] 8e820000 */ lw r2, 0x0(r20)
/* [04001410 / 390] 8e830004 */ lw r3, 0x4(r20)
/* [04001414 / 394] 1040001e */ beqz r2, @lab_04001490
/* [04001418 / 398] 22940008 */ addi r20, r20, 0x8
/* [0400141c / 39c] 20c60008 */ addi r6, r6, 0x8
/* [04001420 / 3a0] 00022603 */ sra r4, r2, 24
/* [04001424 / 3a4] 20840003 */ addi r4, r4, 0x3
/* [04001428 / 3a8] 04800004 */ bltz r4, @@f
/* [0400142c / 3ac] 00000000 */ nop
/* [04001430 / 3b0] 0d0004a1 */     jal turbo3d_04001284
/* [04001434 / 3b4] 00609820 */     add r19, r3, r0
/* [04001438 / 3b8] 02601820 */     add r3, r19, r0
@@f:
/* [0400143c / 3bc] 00022602 */ srl r4, r2, 24
/* [04001440 / 3c0] 308400fe */ andi r4, r4, 0xfe
/* [04001444 / 3c4] 2087ff1c */ addi r7, r4, 0xff1c
/* [04001448 / 3c8] 14e00008 */ bnez r7, @@f2
/* [0400144c / 3cc] 00000000 */ nop
/* [04001450 / 3d0] aee20000 */ sw r2, 0x0(r23)
/* [04001454 / 3d4] aee30004 */ sw r3, 0x4(r23)
/* [04001458 / 3d8] 22f70008 */ addi r23, r23, 0x8
/* [0400145c / 3dc] 8e820000 */ lw r2, 0x0(r20)
/* [04001460 / 3e0] 8e830004 */ lw r3, 0x4(r20)
/* [04001464 / 3e4] 22940008 */ addi r20, r20, 0x8
/* [04001468 / 3e8] 20c60008 */ addi r6, r6, 0x8
@@f2:
/* [0400146c / 3ec] aee20000 */ sw r2, 0x0(r23)
/* [04001470 / 3f0] aee30004 */ sw r3, 0x4(r23)
/* [04001474 / 3f4] 22f70008 */ addi r23, r23, 0x8
/* [04001478 / 3f8] 1681ffe4 */ bne r20, r1, @@b
/* [0400147c / 3fc] 00000000 */ nop
/* [04001480 / 400] 0d0004d0 */ jal turbo3d_04001340
/* [04001484 / 404] 00000000 */ nop
/* [04001488 / 408] 090004fb */ j @lab_040013ec
/* [0400148c / 40c] 00000000 */ nop
@lab_04001490:
/* [04001490 / 410] 0d0004d0 */ jal turbo3d_04001340
/* [04001494 / 414] 00000000 */ nop
/* [04001498 / 418] 00a00008 */ jr r5
/* [0400149c / 41c] 00000000 */ nop

turbo3d_040014a0:
/* [040014a0 / 420] 001f2820 */ add r5, r0, ra
/* [040014a4 / 424] 83a7009b */ lb r7, 0x9b(r29)
/* [040014a8 / 428] 30e70001 */ andi r7, r7, 0x1
/* [040014ac / 42c] 1ce00009 */ bgtz r7, @@f
/* [040014b0 / 430] 00199820 */ add r19, r0, r25
/* [040014b4 / 434] 0d0004a1 */ jal turbo3d_04001284
/* [040014b8 / 438] 22730018 */ addi r19, r19, 0x18
/* [040014bc / 43c] 201400f8 */ addi r20, r0, 0xf8
/* [040014c0 / 440] 2012003f */ addi r18, r0, 0x3f
/* [040014c4 / 444] 0d0004a9 */ jal turbo3d_040012a4
/* [040014c8 / 448] 20110000 */ addi r17, r0, 0x0
/* [040014cc / 44c] 0d0004b6 */ jal turbo3d_040012d8
/* [040014d0 / 450] 00000000 */ nop
@@f:
/* [040014d4 / 454] cba01814 */ ldv $v0[0], 0xa0(r29)
/* [040014d8 / 458] eae01800 */ sdv $v0[0], 0x0(r23)
/* [040014dc / 45c] 22f70008 */ addi r23, r23, 0x8
/* [040014e0 / 460] 8fb3009c */ lw r19, 0x9c(r29)
/* [040014e4 / 464] 1260ffea */ beqz r19, @lab_04001490
/* [040014e8 / 468] 00000000 */ nop
/* [040014ec / 46c] 0d0004a1 */ jal turbo3d_04001284
/* [040014f0 / 470] 00000000 */ nop
/* [040014f4 / 474] 22660000 */ addi r6, r19, 0x0
/* [040014f8 / 478] 090004fb */ j @lab_040013ec
/* [040014fc / 47c] 00000000 */ nop

turbo3d_04001500:
/* [04001500 / 480] 83a10098 */ lb r1, 0x98(r29)
/* [04001504 / 484] 83a20099 */ lb r2, 0x99(r29)
/* [04001508 / 488] 20160140 */ addi r22, r0, 0x140
/* [0400150c / 48c] 1020008c */ beqz r1, @@f2
/* [04001510 / 490] ac1f0070 */ sw ra, 0x70(r0)
/* [04001514 / 494] 20250000 */ addi r5, r1, 0x0
/* [04001518 / 498] 20030140 */ addi r3, r0, 0x140
/* [0400151c / 49c] 00022100 */ sll r4, r2, 4
/* [04001520 / 4a0] 00641820 */ add r3, r3, r4
/* [04001524 / 4a4] 02c4b020 */ add r22, r22, r4
/* [04001528 / 4a8] cacb1800 */ ldv $v11[0], 0x0(r22)
/* [0400152c / 4ac] cacb1c02 */ ldv $v11[8], 0x10(r22)
/* [04001530 / 4b0] cad41804 */ ldv $v20[0], 0x20(r22)
/* [04001534 / 4b4] cad41c06 */ ldv $v20[8], 0x30(r22)
/* [04001538 / 4b8] 200400f8 */ addi r4, r0, 0xf8
/* [0400153c / 4bc] c8801800 */ ldv $v0[0], 0x0(r4)
/* [04001540 / 4c0] c8811801 */ ldv $v1[0], 0x8(r4)
/* [04001544 / 4c4] c8821802 */ ldv $v2[0], 0x10(r4)
/* [04001548 / 4c8] c8831803 */ ldv $v3[0], 0x18(r4)
/* [0400154c / 4cc] c8841804 */ ldv $v4[0], 0x20(r4)
/* [04001550 / 4d0] c8851805 */ ldv $v5[0], 0x28(r4)
/* [04001554 / 4d4] c8861806 */ ldv $v6[0], 0x30(r4)
/* [04001558 / 4d8] c8871807 */ ldv $v7[0], 0x38(r4)
/* [0400155c / 4dc] c8801c00 */ ldv $v0[8], 0x0(r4)
/* [04001560 / 4e0] c8811c01 */ ldv $v1[8], 0x8(r4)
/* [04001564 / 4e4] c8821c02 */ ldv $v2[8], 0x10(r4)
/* [04001568 / 4e8] c8831c03 */ ldv $v3[8], 0x18(r4)
/* [0400156c / 4ec] c8841c04 */ ldv $v4[8], 0x20(r4)
/* [04001570 / 4f0] c8851c05 */ ldv $v5[8], 0x28(r4)
/* [04001574 / 4f4] c8861c06 */ ldv $v6[8], 0x30(r4)
/* [04001578 / 4f8] c8871c07 */ ldv $v7[8], 0x38(r4)
/* [0400157c / 4fc] c81d2002 */ lqv $v29[0], 0x20(r0)
/* [04001580 / 500] 200400c8 */ addi r4, r0, 0xc8
/* [04001584 / 504] c8891800 */ ldv $v9[0], 0x0(r4)
/* [04001588 / 508] c88a1801 */ ldv $v10[0], 0x8(r4)
/* [0400158c / 50c] c8891c00 */ ldv $v9[8], 0x0(r4)
/* [04001590 / 510] c88a1c01 */ ldv $v10[8], 0x8(r4)
/* [04001594 / 514] cba80814 */ lsv $v8[0], 0x28(r29)
/* [04001598 / 518] 4a1d4a47 */ vmudh $v9, $v9, $v29

@@b:
/* [0400159c / 51c] 4a8b2346 */ vmudn $v13, $v4, $v11[0h]
/* [040015a0 / 520] 4a8b034f */ vmadh $v13, $v0, $v11[0h]
/* [040015a4 / 524] 4aab2b4e */ vmadn $v13, $v5, $v11[1h]
/* [040015a8 / 528] 4aab0b4f */ vmadh $v13, $v1, $v11[1h]
/* [040015ac / 52c] 4acb334e */ vmadn $v13, $v6, $v11[2h]
/* [040015b0 / 530] 4acb134f */ vmadh $v13, $v2, $v11[2h]
/* [040015b4 / 534] 4b3f3b4e */ vmadn $v13, $v7, $v31[1]
/* [040015b8 / 538] 4b3f1b0f */ vmadh $v12, $v3, $v31[1]
/* [040015bc / 53c] 4a942586 */ vmudn $v22, $v4, $v20[0h]
/* [040015c0 / 540] 4a94058f */ vmadh $v22, $v0, $v20[0h]
/* [040015c4 / 544] 4ab42d8e */ vmadn $v22, $v5, $v20[1h]
/* [040015c8 / 548] 4ab40d8f */ vmadh $v22, $v1, $v20[1h]
/* [040015cc / 54c] 4ad4358e */ vmadn $v22, $v6, $v20[2h]
/* [040015d0 / 550] 4ad4158f */ vmadh $v22, $v2, $v20[2h]
/* [040015d4 / 554] 4b3f3d8e */ vmadn $v22, $v7, $v31[1]
/* [040015d8 / 558] 4b3f1d4f */ vmadh $v21, $v3, $v31[1]
/* [040015dc / 55c] 22d60040 */ addi r22, r22, 0x40
/* [040015e0 / 560] 4b086bc4 */ vmudl $v15, $v13, $v8[0]
/* [040015e4 / 564] 4b08638d */ vmadm $v14, $v12, $v8[0]
/* [040015e8 / 568] 4b1ffbce */ vmadn $v15, $v31, $v31[0]
/* [040015ec / 56c] 4b08b604 */ vmudl $v24, $v22, $v8[0]
/* [040015f0 / 570] 4b08adcd */ vmadm $v23, $v21, $v8[0]
/* [040015f4 / 574] 4b1ffe0e */ vmadn $v24, $v31, $v31[0]
/* [040015f8 / 578] 4b6e5c32 */ vrcph $v16[3], $v14[3]
/* [040015fc / 57c] 4b6f5c71 */ vrcpl $v17[3], $v15[3]
/* [04001600 / 580] 4bee5c32 */ vrcph $v16[3], $v14[7]
/* [04001604 / 584] 4bef7c71 */ vrcpl $v17[7], $v15[7]
/* [04001608 / 588] 4b1f7c32 */ vrcph $v16[7], $v31[0]
/* [0400160c / 58c] 4b775e72 */ vrcph $v25[3], $v23[3]
/* [04001610 / 590] 4b785eb1 */ vrcpl $v26[3], $v24[3]
/* [04001614 / 594] 4bf75e72 */ vrcph $v25[3], $v23[7]
/* [04001618 / 598] 4bf87eb1 */ vrcpl $v26[7], $v24[7]
/* [0400161c / 59c] 4b1f7e72 */ vrcph $v25[7], $v31[0]
/* [04001620 / 5a0] 4b5f8c46 */ vmudn $v17, $v17, $v31[2]
/* [04001624 / 5a4] 4b5f840f */ vmadh $v16, $v16, $v31[2]
/* [04001628 / 5a8] 4b1ffc4e */ vmadn $v17, $v31, $v31[0]
/* [0400162c / 5ac] 4b5fd686 */ vmudn $v26, $v26, $v31[2]
/* [04001630 / 5b0] 4b5fce4f */ vmadh $v25, $v25, $v31[2]
/* [04001634 / 5b4] 4b1ffe8e */ vmadn $v26, $v31, $v31[0]
/* [04001638 / 5b8] 4af16bc4 */ vmudl $v15, $v13, $v17[3h]
/* [0400163c / 5bc] 4af163cd */ vmadm $v15, $v12, $v17[3h]
/* [04001640 / 5c0] 4af06bce */ vmadn $v15, $v13, $v16[3h]
/* [04001644 / 5c4] 4af0638f */ vmadh $v14, $v12, $v16[3h]
/* [04001648 / 5c8] 4afab604 */ vmudl $v24, $v22, $v26[3h]
/* [0400164c / 5cc] 4afaae0d */ vmadm $v24, $v21, $v26[3h]
/* [04001650 / 5d0] 4af9b60e */ vmadn $v24, $v22, $v25[3h]
/* [04001654 / 5d4] 4af9adcf */ vmadh $v23, $v21, $v25[3h]
/* [04001658 / 5d8] 4b087bc4 */ vmudl $v15, $v15, $v8[0]
/* [0400165c / 5dc] c80c1808 */ ldv $v12[0], 0x40(r0)
/* [04001660 / 5e0] 4b08738d */ vmadm $v14, $v14, $v8[0]
/* [04001664 / 5e4] c80c1c08 */ ldv $v12[8], 0x40(r0)
/* [04001668 / 5e8] 4b1ffbce */ vmadn $v15, $v31, $v31[0]
/* [0400166c / 5ec] 4b08c604 */ vmudl $v24, $v24, $v8[0]
/* [04001670 / 5f0] 4b08bdcd */ vmadm $v23, $v23, $v8[0]
/* [04001674 / 5f4] 4b1ffe0e */ vmadn $v24, $v31, $v31[0]
/* [04001678 / 5f8] 4b3f54c7 */ vmudh $v19, $v10, $v31[1]
/* [0400167c / 5fc] 4a097cce */ vmadn $v19, $v15, $v9
/* [04001680 / 600] cacb1800 */ ldv $v11[0], 0x0(r22)
/* [04001684 / 604] 4a09748f */ vmadh $v18, $v14, $v9
/* [04001688 / 608] cacb1c02 */ ldv $v11[8], 0x10(r22)
/* [0400168c / 60c] 4b1ffcce */ vmadn $v19, $v31, $v31[0]
/* [04001690 / 610] 4b3f5707 */ vmudh $v28, $v10, $v31[1]
/* [04001694 / 614] 4a09c70e */ vmadn $v28, $v24, $v9
/* [04001698 / 618] cad41804 */ ldv $v20[0], 0x20(r22)
/* [0400169c / 61c] 4a09becf */ vmadh $v27, $v23, $v9
/* [040016a0 / 620] cad41c06 */ ldv $v20[8], 0x30(r22)
/* [040016a4 / 624] 4b1fff0e */ vmadn $v28, $v31, $v31[0]
/* [040016a8 / 628] 4a4c94a0 */ vlt $v18, $v18, $v12[0q]
/* [040016ac / 62c] 20a5ffff */ addi r5, r5, -1
/* [040016b0 / 630] 4a4cdee0 */ vlt $v27, $v27, $v12[0q]
/* [040016b4 / 634] 4b5f9490 */ vadd $v18, $v18, $v31[2]
/* [040016b8 / 638] 4b5fded0 */ vadd $v27, $v27, $v31[2]
/* [040016bc / 63c] 4bdf94a8 */ vand $v18, $v18, $v31[6]
/* [040016c0 / 640] 4bdfdee8 */ vand $v27, $v27, $v31[6]
/* [040016c4 / 644] e8721800 */ sdv $v18[0], 0x0(r3)
/* [040016c8 / 648] e8730a03 */ ssv $v19[4], 0x6(r3)
/* [040016cc / 64c] 18a0000d */ blez r5, @@f
/* [040016d0 / 650] 20a5ffff */ addi r5, r5, -1
/* [040016d4 / 654] e8721c02 */ sdv $v18[8], 0x10(r3)
/* [040016d8 / 658] e8730e0b */ ssv $v19[12], 0x16(r3)
/* [040016dc / 65c] 18a00009 */ blez r5, @@f
/* [040016e0 / 660] 20a5ffff */ addi r5, r5, -1
/* [040016e4 / 664] e87b1804 */ sdv $v27[0], 0x20(r3)
/* [040016e8 / 668] e87c0a13 */ ssv $v28[4], 0x26(r3)
/* [040016ec / 66c] 18a00005 */ blez r5, @@f
/* [040016f0 / 670] 20a5ffff */ addi r5, r5, -1
/* [040016f4 / 674] e87b1c06 */ sdv $v27[8], 0x30(r3)
/* [040016f8 / 678] e87c0e1b */ ssv $v28[12], 0x36(r3)
/* [040016fc / 67c] 1ca0ffa7 */ bgtz r5, @@b
/* [04001700 / 680] 20630040 */ addi r3, r3, 0x40

@@f:
/* [04001704 / 684] 83a5009b */ lb r5, 0x9b(r29)
/* [04001708 / 688] 83a10098 */ lb r1, 0x98(r29)
/* [0400170c / 68c] 83a20099 */ lb r2, 0x99(r29)
/* [04001710 / 690] 30a50004 */ andi r5, r5, 0x4
/* [04001714 / 694] 20160140 */ addi r22, r0, 0x140
/* [04001718 / 698] 10a00009 */ beqz r5, @@f2
/* [0400171c / 69c] 00022100 */ sll r4, r2, 4
/* [04001720 / 6a0] 02c4b020 */ add r22, r22, r4
/* [04001724 / 6a4] 001e9820 */ add r19, r0, r30
/* [04001728 / 6a8] 0d0004a1 */ jal turbo3d_04001284
/* [0400172c / 6ac] 20140016 */ addi r20, r0, 0x16
/* [04001730 / 6b0] 00010900 */ sll r1, r1, 4
/* [04001734 / 6b4] 2032ffff */ addi r18, r1, -1
/* [04001738 / 6b8] 0d0004a9 */ jal turbo3d_040012a4
/* [0400173c / 6bc] 20110001 */ addi r17, r0, 0x1

@@f2:
/* [04001740 / 6c0] 8c1f0070 */ lw ra, 0x70(r0)
/* [04001744 / 6c4] 03e00008 */ jr ra
/* [04001748 / 6c8] 00000000 */ nop

turbo3d_0400174c:
/* [0400174c / 6cc] 83aa009b */ lb r10, 0x9b(r29)
/* [04001750 / 6d0] 314a0004 */ andi r10, r10, 0x4
/* [04001754 / 6d4] 1d40feb3 */ bgtz r10, @lab_04001224
/* [04001758 / 6d8] ac1f0070 */ sw ra, 0x70(r0)
/* [0400175c / 6dc] 20010540 */ addi r1, r0, 0x540
/* [04001760 / 6e0] 83a2009a */ lb r2, 0x9a(r29)
/* [04001764 / 6e4] 00021080 */ sll r2, r2, 2
/* [04001768 / 6e8] 10400016 */ beqz r2, @early_return
/* [0400176c / 6ec] 00411020 */ add r2, r2, r1
/* [04001770 / 6f0] 8fab0090 */ lw r11, 0x90(r29)

@bigman_loop:
/* [04001774 / 6f4] 1022000e */ beq r1, r2, @lab_040017b0
/* [04001778 / 6f8] 80240000 */ lb r4, 0x0(r1)
/* [0400177c / 6fc] 80250001 */ lb r5, 0x1(r1)
/* [04001780 / 700] 80260002 */ lb r6, 0x2(r1)
/* [04001784 / 704] 00042100 */ sll r4, r4, 4
/* [04001788 / 708] 00052900 */ sll r5, r5, 4
/* [0400178c / 70c] 00063100 */ sll r6, r6, 4
/* [04001790 / 710] 20840140 */ addi r4, r4, 0x140
/* [04001794 / 714] 20a50140 */ addi r5, r5, 0x140
/* [04001798 / 718] 20c60140 */ addi r6, r6, 0x140
/* [0400179c / 71c] 316a0200 */ andi r10, r11, 0x200
/* [040017a0 / 720] 1140000a */ beqz r10, @lab_040017cc
@lab_040017a4:
/* [040017a4 / 724] 00000000 */ nop
/* [040017a8 / 728] 090005fa */ j @lab_040017e8
/* [040017ac / 72c] 20210004 */ addi r1, r1, 0x4
@lab_040017b0:
/* [040017b0 / 730] 3c01e700 */ lui r1, 0xe700
/* [040017b4 / 734] aee10000 */ sw r1, 0x0(r23)
/* [040017b8 / 738] aee00004 */ sw r0, 0x4(r23)
/* [040017bc / 73c] 0d0004d0 */ jal turbo3d_04001340
/* [040017c0 / 740] 22f70008 */ addi r23, r23, 0x8
@early_return:
/* [040017c4 / 744] 8c1f0070 */ lw ra, 0x70(r0)
/* [040017c8 / 748] 03e00008 */ jr ra
@lab_040017cc:
/* [040017cc / 74c] 80270003 */ lb r7, 0x3(r1)
/* [040017d0 / 750] 00073880 */ sll r7, r7, 2
/* [040017d4 / 754] ac040bb0 */ sw r4, 0xbb0(r0)
/* [040017d8 / 758] ac050bb4 */ sw r5, 0xbb4(r0)
/* [040017dc / 75c] ac060bb8 */ sw r6, 0xbb8(r0)
/* [040017e0 / 760] 090005e9 */ j @lab_040017a4
/* [040017e4 / 764] 8ce70bb0 */ lw r7, 0xbb0(r7)
@lab_040017e8:
/* [040017e8 / 768] c8891000 */ llv $v9[0], 0x0(r4)
/* [040017ec / 76c] c8aa1000 */ llv $v10[0], 0x0(r5)
/* [040017f0 / 770] c8cb1000 */ llv $v11[0], 0x0(r6)
/* [040017f4 / 774] 8fab0090 */ lw r11, 0x90(r29)
/* [040017f8 / 778] 4a095191 */ vsub $v6, $v10, $v9
/* [040017fc / 77c] 4a095951 */ vsub $v5, $v11, $v9
/* [04001800 / 780] 4a0a4a11 */ vsub $v8, $v9, $v10
/* [04001804 / 784] 20120000 */ addi r18, r0, 0x0
/* [04001808 / 788] 4b262b07 */ vmudh $v12, $v5, $v6[1]
/* [0400180c / 78c] 848c0002 */ lh r12, 0x2(r4)
/* [04001810 / 790] 4b2e739d */ vsar $v14, $v14, $v14[1]
/* [04001814 / 794] 84ad0002 */ lh r13, 0x2(r5)
/* [04001818 / 798] 4b0d6b5d */ vsar $v13, $v13, $v13[0]
/* [0400181c / 79c] 84ce0002 */ lh r14, 0x2(r6)
/* [04001820 / 7a0] 4b254307 */ vmudh $v12, $v8, $v5[1]
/* [04001824 / 7a4] 4b30841d */ vsar $v16, $v16, $v16[1]
/* [04001828 / 7a8] 316f2000 */ andi r15, r11, 0x2000
/* [0400182c / 7ac] 4b0f7bdd */ vsar $v15, $v15, $v15[0]
@@b:
/* [04001830 / 7b0] 01ac502a */ slt r10, r13, r12
/* [04001834 / 7b4] 19400008 */ blez r10, @@f
/* [04001838 / 7b8] 01a05020 */ add r10, r13, r0
/* [0400183c / 7bc] 01806820 */ add r13, r12, r0
/* [04001840 / 7c0] 01406020 */ add r12, r10, r0
/* [04001844 / 7c4] 00a05021 */ addu r10, r5, r0
/* [04001848 / 7c8] 00802821 */ addu r5, r4, r0
/* [0400184c / 7cc] 01402021 */ addu r4, r10, r0
/* [04001850 / 7d0] 3a520001 */ xori r18, r18, 0x1
/* [04001854 / 7d4] 00000000 */ nop
@@f:
/* [04001858 / 7d8] 4a107714 */ vaddc $v28, $v14, $v16
/* [0400185c / 7dc] 01cd502a */ slt r10, r14, r13
/* [04001860 / 7e0] 4a0f6f50 */ vadd $v29, $v13, $v15
/* [04001864 / 7e4] 19400008 */ blez r10, @@f2
/* [04001868 / 7e8] 01c05020 */ add r10, r14, r0
/* [0400186c / 7ec] 01a07020 */ add r14, r13, r0
/* [04001870 / 7f0] 01406820 */ add r13, r10, r0
/* [04001874 / 7f4] 00c05021 */ addu r10, r6, r0
/* [04001878 / 7f8] 00a03021 */ addu r6, r5, r0
/* [0400187c / 7fc] 01402821 */ addu r5, r10, r0
/* [04001880 / 800] 0900060c */ j @@b
/* [04001884 / 804] 3a520001 */ xori r18, r18, 0x1
@@f2:
/* [04001888 / 808] 4b1feee0 */ vlt $v27, $v29, $v31[0]
/* [0400188c / 80c] c8cb1000 */ llv $v11[0], 0x0(r6)
/* [04001890 / 810] 4a1ceeaa */ vor $v26, $v29, $v28
/* [04001894 / 814] c8aa1000 */ llv $v10[0], 0x0(r5)
/* [04001898 / 818] c8891000 */ llv $v9[0], 0x0(r4)
/* [0400189c / 81c] 1a400004 */ blez r18, @@f3
/* [040018a0 / 820] 4a0a5811 */ vsub $v0, $v11, $v10
/* [040018a4 / 824] 4b7fe706 */ vmudn $v28, $v28, $v31[3]
/* [040018a8 / 828] 4b7fef4f */ vmadh $v29, $v29, $v31[3]
/* [040018ac / 82c] 4b1fff0e */ vmadn $v28, $v31, $v31[0]
@@f3:
/* [040018b0 / 830] 4a095191 */ vsub $v6, $v10, $v9
/* [040018b4 / 834] 4811d800 */ mfc2 r17, $v27[0]
/* [040018b8 / 838] 4a095951 */ vsub $v5, $v11, $v9
/* [040018bc / 83c] 4810d000 */ mfc2 r16, $v26[0]
/* [040018c0 / 840] 20ca0004 */ addi r10, r6, 0x4
/* [040018c4 / 844] c9513801 */ luv $v17[0], 0x8(r10)
/* [040018c8 / 848] 208a0004 */ addi r10, r4, 0x4
/* [040018cc / 84c] c9533801 */ luv $v19[0], 0x8(r10)
/* [040018d0 / 850] 4a1ffd2c */ vxor $v20, $v31, $v31
/* [040018d4 / 854] 20aa0004 */ addi r10, r5, 0x4
/* [040018d8 / 858] c9523801 */ luv $v18[0], 0x8(r10)
/* [040018dc / 85c] 316a0200 */ andi r10, r11, 0x200
/* [040018e0 / 860] 1d400004 */ bgtz r10, @@f4
/* [040018e4 / 864] 20ea0004 */ addi r10, r7, 0x4
/* [040018e8 / 868] c9513801 */ luv $v17[0], 0x8(r10)
/* [040018ec / 86c] c9533801 */ luv $v19[0], 0x8(r10)
/* [040018f0 / 870] c9523801 */ luv $v18[0], 0x8(r10)
@@f4:
/* [040018f4 / 874] 00118fc3 */ sra r17, r17, 31
/* [040018f8 / 878] 4b1d5f73 */ vmov $v29[3], $v29[0]
/* [040018fc / 87c] 01f17824 */ and r15, r15, r17
/* [04001900 / 880] 4b1c5f33 */ vmov $v28[3], $v28[0]
/* [04001904 / 884] 4b065033 */ vmov $v0[2], $v6[0]
/* [04001908 / 888] 12000097 */ beqz r16, @@f8
/* [0400190c / 88c] 4bff8c45 */ vmudm $v17, $v17, $v31[7]
/* [04001910 / 890] 4bff9cc5 */ vmudm $v19, $v19, $v31[7]
/* [04001914 / 894] 1de00094 */ bgtz r15, @@f8
/* [04001918 / 898] 4bff9485 */ vmudm $v18, $v18, $v31[7]
/* [0400191c / 89c] 4b1feee0 */ vlt $v27, $v29, $v31[0]
/* [04001920 / 8a0] 318cfffc */ andi r12, r12, 0xfffc
/* [04001924 / 8a4] 4b265833 */ vmov $v0[3], $v6[1]
/* [04001928 / 8a8] 31adfffc */ andi r13, r13, 0xfffc
/* [0400192c / 8ac] 4b056033 */ vmov $v0[4], $v5[0]
/* [04001930 / 8b0] 31cefffc */ andi r14, r14, 0xfffc
/* [04001934 / 8b4] 4b256833 */ vmov $v0[5], $v5[1]
/* [04001938 / 8b8] 480ad800 */ mfc2 r10, $v27[0]
/* [0400193c / 8bc] c8931402 */ llv $v19[8], 0x8(r4)
/* [04001940 / 8c0] 4b7d5ef2 */ vrcph $v27[3], $v29[3]
/* [04001944 / 8c4] c8b21402 */ llv $v18[8], 0x8(r5)
/* [04001948 / 8c8] 4b7c5eb1 */ vrcpl $v26[3], $v28[3]
/* [0400194c / 8cc] c8d11402 */ llv $v17[8], 0x8(r6)
/* [04001950 / 8d0] 4b1f5ef2 */ vrcph $v27[3], $v31[0]
/* [04001954 / 8d4] 4b1e74f3 */ vmov $v19[6], $v30[0]
/* [04001958 / 8d8] 4b1e74b3 */ vmov $v18[6], $v30[0]
/* [0400195c / 8dc] c8930f02 */ lsv $v19[14], 0x4(r4)
/* [04001960 / 8e0] 4b5fd686 */ vmudn $v26, $v26, $v31[2]
/* [04001964 / 8e4] c8b20f02 */ lsv $v18[14], 0x4(r5)
/* [04001968 / 8e8] 4b5fdecf */ vmadh $v27, $v27, $v31[2]
/* [0400196c / 8ec] c8d10f02 */ lsv $v17[14], 0x4(r6)
/* [04001970 / 8f0] 4b1ffe8e */ vmadn $v26, $v31, $v31[0]
/* [04001974 / 8f4] 4b1e7473 */ vmov $v17[6], $v30[0]
/* [04001978 / 8f8] c8172003 */ lqv $v23[0], 0x30(r0)
/* [0400197c / 8fc] 4a1ffdac */ vxor $v22, $v31, $v31
/* [04001980 / 900] 4a1cd604 */ vmudl $v24, $v26, $v28
/* [04001984 / 904] 4a1cde0d */ vmadm $v24, $v27, $v28
/* [04001988 / 908] 4a1dd60e */ vmadn $v24, $v26, $v29
/* [0400198c / 90c] 4a1dde4f */ vmadh $v25, $v27, $v29
/* [04001990 / 910] 4a119b91 */ vsub $v14, $v19, $v17
/* [04001994 / 914] 4a129bd1 */ vsub $v15, $v19, $v18
/* [04001998 / 918] 4a18b615 */ vsubc $v24, $v22, $v24
/* [0400199c / 91c] 4a19be51 */ vsub $v25, $v23, $v25
/* [040019a0 / 920] 4a139551 */ vsub $v21, $v18, $v19
/* [040019a4 / 924] 4a138d91 */ vsub $v22, $v17, $v19
/* [040019a8 / 928] 4a18d404 */ vmudl $v16, $v26, $v24
/* [040019ac / 92c] 4a18dc0d */ vmadm $v16, $v27, $v24
/* [040019b0 / 930] 20090080 */ addi r9, r0, 0x80
/* [040019b4 / 934] 4a19d68e */ vmadn $v26, $v26, $v25
/* [040019b8 / 938] 4a19decf */ vmadh $v27, $v27, $v25
/* [040019bc / 93c] 05400002 */ bltz r10, @@f5
/* [040019c0 / 940] 83a80093 */ lb r8, 0x93(r29)
/* [040019c4 / 944] 20090000 */ addi r9, r0, 0x0
@@f5:
/* [040019c8 / 948] 4b9f0145 */ vmudm $v5, $v0, $v31[4]
/* [040019cc / 94c] 4b1ff98e */ vmadn $v6, $v31, $v31[0]
/* [040019d0 / 950] 4b204f30 */ vrcp $v28[1], $v0[1]
/* [040019d4 / 954] 83aa0097 */ lb r10, 0x97(r29)
/* [040019d8 / 958] 4b1f4f72 */ vrcph $v29[1], $v31[0]
/* [040019dc / 95c] 350800cc */ ori r8, r8, 0xcc
/* [040019e0 / 960] 4b605f30 */ vrcp $v28[3], $v0[3]
/* [040019e4 / 964] 4b1f5f72 */ vrcph $v29[3], $v31[0]
/* [040019e8 / 968] 4ba06f30 */ vrcp $v28[5], $v0[5]
/* [040019ec / 96c] 012a4825 */ or r9, r9, r10
/* [040019f0 / 970] 4b1f6f72 */ vrcph $v29[5], $v31[0]
/* [040019f4 / 974] 4b5ee704 */ vmudl $v28, $v28, $v30[2]
/* [040019f8 / 978] a2e80000 */ sb r8, 0x0(r23)
/* [040019fc / 97c] 4b5eef4d */ vmadm $v29, $v29, $v30[2]
/* [04001a00 / 980] a2e90001 */ sb r9, 0x1(r23)
/* [04001a04 / 984] 4b1fff0e */ vmadn $v28, $v31, $v31[0]
/* [04001a08 / 988] 4bbf0007 */ vmudh $v0, $v0, $v31[5]
/* [04001a0c / 98c] c8a70800 */ lsv $v7[0], 0x0(r5)
/* [04001a10 / 990] 4a46e084 */ vmudl $v2, $v28, $v6[0q]
/* [04001a14 / 994] c8870a00 */ lsv $v7[4], 0x0(r4)
/* [04001a18 / 998] 4a46e88d */ vmadm $v2, $v29, $v6[0q]
/* [04001a1c / 99c] c8870c00 */ lsv $v7[8], 0x0(r4)
/* [04001a20 / 9a0] 4a45e08e */ vmadn $v2, $v28, $v5[0q]
/* [04001a24 / 9a4] 4a45e84f */ vmadh $v1, $v29, $v5[0q]
/* [04001a28 / 9a8] a6ee0002 */ sh r14, 0x2(r23)
/* [04001a2c / 9ac] 4b1ff88e */ vmadn $v2, $v31, $v31[0]
/* [04001a30 / 9b0] a6ec0006 */ sh r12, 0x6(r23)
/* [04001a34 / 9b4] 4b9f39c5 */ vmudm $v7, $v7, $v31[4]
/* [04001a38 / 9b8] 4b1ffa0e */ vmadn $v8, $v31, $v31[0]
/* [04001a3c / 9bc] a6ed0004 */ sh r13, 0x4(r23)
/* [04001a40 / 9c0] 4bde0866 */ vcr $v1, $v1, $v30[6]
/* [04001a44 / 9c4] eae20907 */ ssv $v2[2], 0xe(r23)
/* [04001a48 / 9c8] 4bbcb405 */ vmudm $v16, $v22, $v28[5]
/* [04001a4c / 9cc] eae20d0b */ ssv $v2[10], 0x16(r23)
/* [04001a50 / 9d0] 4bbdb64f */ vmadh $v25, $v22, $v29[5]
/* [04001a54 / 9d4] eae20b0f */ ssv $v2[6], 0x1e(r23)
/* [04001a58 / 9d8] 4b1ffe0e */ vmadn $v24, $v31, $v31[0]
/* [04001a5c / 9dc] eae70804 */ ssv $v7[0], 0x8(r23)
/* [04001a60 / 9e0] 4b60b407 */ vmudh $v16, $v22, $v0[3]
/* [04001a64 / 9e4] eae80805 */ ssv $v8[0], 0xa(r23)
/* [04001a68 / 9e8] 4ba07c0f */ vmadh $v16, $v15, $v0[5]
/* [04001a6c / 9ec] eae10906 */ ssv $v1[2], 0xc(r23)
/* [04001a70 / 9f0] 4b16b59d */ vsar $v22, $v22, $v22[0]
/* [04001a74 / 9f4] eae10d0a */ ssv $v1[10], 0x14(r23)
/* [04001a78 / 9f8] 4b37bddd */ vsar $v23, $v23, $v23[1]
/* [04001a7c / 9fc] eae10b0e */ ssv $v1[6], 0x1c(r23)
/* [04001a80 / a00] eae70c08 */ ssv $v7[8], 0x10(r23)
/* [04001a84 / a04] eae80c09 */ ssv $v8[8], 0x12(r23)
/* [04001a88 / a08] eae70a0c */ ssv $v7[4], 0x18(r23)
/* [04001a8c / a0c] eae80a0d */ ssv $v8[4], 0x1a(r23)
/* [04001a90 / a10] 22f70020 */ addi r23, r23, 0x20
/* [04001a94 / a14] 4b7abc04 */ vmudl $v16, $v23, $v26[3]
/* [04001a98 / a18] eaf41805 */ sdv $v20[0], 0x28(r23)
/* [04001a9c / a1c] 4b7ab40d */ vmadm $v16, $v22, $v26[3]
/* [04001aa0 / a20] eaf41807 */ sdv $v20[0], 0x38(r23)
/* [04001aa4 / a24] 4b7bbdce */ vmadn $v23, $v23, $v27[3]
/* [04001aa8 / a28] eaf91804 */ sdv $v25[0], 0x20(r23)
/* [04001aac / a2c] 4b7bb58f */ vmadh $v22, $v22, $v27[3]
/* [04001ab0 / a30] eaf81806 */ sdv $v24[0], 0x30(r23)
/* [04001ab4 / a34] eaf31800 */ sdv $v19[0], 0x0(r23)
/* [04001ab8 / a38] eaf41802 */ sdv $v20[0], 0x10(r23)
/* [04001abc / a3c] 310a0002 */ andi r10, r8, 0x2
/* [04001ac0 / a40] eaf61801 */ sdv $v22[0], 0x8(r23)
/* [04001ac4 / a44] eaf71803 */ sdv $v23[0], 0x18(r23)
/* [04001ac8 / a48] 1940000a */ blez r10, @@f6
/* [04001acc / a4c] 22f70040 */ addi r23, r23, 0x40
/* [04001ad0 / a50] eaf31c00 */ sdv $v19[8], 0x0(r23)
/* [04001ad4 / a54] eaf41c02 */ sdv $v20[8], 0x10(r23)
/* [04001ad8 / a58] eaf61c01 */ sdv $v22[8], 0x8(r23)
/* [04001adc / a5c] eaf71c03 */ sdv $v23[8], 0x18(r23)
/* [04001ae0 / a60] eaf41805 */ sdv $v20[0], 0x28(r23)
/* [04001ae4 / a64] eaf41807 */ sdv $v20[0], 0x38(r23)
/* [04001ae8 / a68] eaf91c04 */ sdv $v25[8], 0x20(r23)
/* [04001aec / a6c] eaf81c06 */ sdv $v24[8], 0x30(r23)
/* [04001af0 / a70] 22f70040 */ addi r23, r23, 0x40
@@f6:
/* [04001af4 / a74] 310a0001 */ andi r10, r8, 0x1
/* [04001af8 / a78] 1940001a */ blez r10, @@f7
/* [04001afc / a7c] 4b80ac07 */ vmudh $v16, $v21, $v0[4]
/* [04001b00 / a80] 4b40ac0f */ vmadh $v16, $v21, $v0[2]
/* [04001b04 / a84] 4b15ad5d */ vsar $v21, $v21, $v21[0]
/* [04001b08 / a88] 4b25295d */ vsar $v5, $v5, $v5[1]
/* [04001b0c / a8c] 4b7a2c04 */ vmudl $v16, $v5, $v26[3]
/* [04001b10 / a90] 4b7aac0d */ vmadm $v16, $v21, $v26[3]
/* [04001b14 / a94] 4b7b294e */ vmadn $v5, $v5, $v27[3]
/* [04001b18 / a98] 4b7bad4f */ vmadh $v21, $v21, $v27[3]
/* [04001b1c / a9c] 4b9ec606 */ vmudn $v24, $v24, $v30[4]
/* [04001b20 / aa0] 4b9ece4f */ vmadh $v25, $v25, $v30[4]
/* [04001b24 / aa4] 4b1ffe0e */ vmadn $v24, $v31, $v31[0]
/* [04001b28 / aa8] 4b9ea046 */ vmudn $v1, $v20, $v30[4]
/* [04001b2c / aac] 4b9e9ccf */ vmadh $v19, $v19, $v30[4]
/* [04001b30 / ab0] 4b1ff84e */ vmadn $v1, $v31, $v31[0]
/* [04001b34 / ab4] eaf90f04 */ ssv $v25[14], 0x8(r23)
/* [04001b38 / ab8] 4b9ebdc6 */ vmudn $v23, $v23, $v30[4]
/* [04001b3c / abc] eaf80f05 */ ssv $v24[14], 0xa(r23)
/* [04001b40 / ac0] 4b9eb58f */ vmadh $v22, $v22, $v30[4]
/* [04001b44 / ac4] 4b1ffdce */ vmadn $v23, $v31, $v31[0]
/* [04001b48 / ac8] eaf60f02 */ ssv $v22[14], 0x4(r23)
/* [04001b4c / acc] eaf70f03 */ ssv $v23[14], 0x6(r23)
/* [04001b50 / ad0] eaf50f06 */ ssv $v21[14], 0xc(r23)
/* [04001b54 / ad4] eae50f07 */ ssv $v5[14], 0xe(r23)
/* [04001b58 / ad8] 22f70010 */ addi r23, r23, 0x10
/* [04001b5c / adc] eaf30f78 */ ssv $v19[14], -0x10(r23)
/* [04001b60 / ae0] eae10f79 */ ssv $v1[14], -0xe(r23)
@@f7:
/* [04001b64 / ae4] 0d0004d0 */ jal turbo3d_04001340
@@f8:
/* [04001b68 / ae8] 00000000 */ nop
/* [04001b6c / aec] 090005dd */ j @bigman_loop
/* [04001b70 / af0] 00000000 */ nop
/* [04001b74 / af4] 00000000 */ nop
/* [04001b78 / af8] 00000000 */ nop
/* [04001b7c / afc] 00000000 */ nop
.close

