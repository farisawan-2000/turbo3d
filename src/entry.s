// start of gtinit

entry:
/* [000] */ addi rsp_state, r0, dmem_rsp_state
/* [004] */ ori r2, r0, (SP_CLR_YIELDED | SP_CLR_TASKDONE)
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
/* [040] */  mfc0 r4, dpc_end
/* [044] */ sub r23, r23, r4
/* [048] */ bgtz r23, @@f
/* [04c] */  mfc0 r5, dpc_current
/* [050] */ beqz r5, @@f
/* [054] */  nop
/* [058] */ beq r5, r4, @@f
/* [05c] */  nop
/* [060] */ j @@f2
/* [064] */  ori r3, r4, 0x0
@@f:
@@b:
/* [068] */ mfc0 r4, dpc_status
/* [06c] */ andi r4, r4, 0x400
/* [070] */ bnez r4, @@b
/* [074] */  addi r4, r0, 0x1
/* [078] */ mtc0 r4, dpc_status
/* [07c] */ mtc0 r3, dpc_start
/* [080] */ mtc0 r3, dpc_end
@@f2:
/* [084] */ sw r3, 0x4(rsp_state)
/* [088] */ addi r23, r0, 0x7b0
/* [08c] */ jal load_display_list
/* [090] */  lw r26, 0x30(OSTask) ; data_ptr
