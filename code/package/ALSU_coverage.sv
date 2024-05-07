
package ALSU_coverage_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
    parameter VALID_OP = 6;
    typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    typedef enum {MAXPOS=3, ZERO = 0, MAXNEG=-4} reg_e;

    class ALSU_coverage extends uvm_component;
        `uvm_component_utils(ALSU_coverage)
        uvm_analysis_export #(ALSU_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(ALSU_seq_item) cov_fifo;
        ALSU_seq_item seq_item_cov;

    covergroup cvr_grp;
            A_cvp_values_ADD_MULT : coverpoint seq_item_cov.A
            {
                bins A_data_e = {0};
                bins A_data_max = {3};
                bins A_data_min = {-4};
                bins A_data_default = default;
            }

            A_cvp_values_RED : coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A) {
                bins A_walkingones[] = {3'b001, 3'b010, 3'b100};
            }

            B_cvp_values_ADD_MULT : coverpoint seq_item_cov.B {
                bins B_data_0 = {0};
                bins B_data_max = {3};
                bins B_data_min = {-4};
                bins B_data_default = default;
            }

            B_cvp_values_RED : coverpoint seq_item_cov.B iff (seq_item_cov.red_op_B & !seq_item_cov.red_op_A) {
                bins B_walkingones[] = {3'b001, 3'b010, 3'b100};
            }
            opcode_cvp_values : coverpoint seq_item_cov.opcode {
                bins bins_shift[] = {SHIFT, ROTATE};
                bins bins_arith[] = {ADD, MULT};
                illegal_bins opcode_invalid = {INVALID_6, INVALID_7};
                bins opcode_valid_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);

            }

            opcode_bitwise_cp: coverpoint seq_item_cov.opcode {
                bins bins_bitwise[] = {OR, XOR};

            }

            cross_ARTTH_PERM: cross A_cvp_values_ADD_MULT, B_cvp_values_ADD_MULT, opcode_cvp_values {
                ignore_bins ig_bins_shift = binsof(opcode_cvp_values.bins_shift);
                ignore_bins ig_bins_trans = binsof(opcode_cvp_values.opcode_valid_trans);
            }

            cross_ARITH_CIN: cross seq_item_cov.cin, opcode_cvp_values {
                ignore_bins ig_bins_shift = binsof(opcode_cvp_values.bins_shift);
                ignore_bins ig_bins_trans = binsof(opcode_cvp_values.opcode_valid_trans);
            }

            cross_SHIFT_opcode: cross seq_item_cov.direction, opcode_cvp_values {
                ignore_bins ig_bins_arith = binsof(opcode_cvp_values.bins_arith);
                ignore_bins ig_bins_trans = binsof(opcode_cvp_values.opcode_valid_trans);
            }
            opcode_SHIFT_cp: coverpoint seq_item_cov.opcode {
                bins bins_SHIFT = {SHIFT};
            }
            
            cross_SHIFT: cross opcode_SHIFT_cp, seq_item_cov.serial_in;
            
            cross_reduction_A: cross A_cvp_values_RED, B_cvp_values_ADD_MULT, opcode_bitwise_cp {
                ignore_bins B_data_max_ = binsof(B_cvp_values_ADD_MULT.B_data_max);
                ignore_bins B_data_min_ = binsof(B_cvp_values_ADD_MULT.B_data_min);
            }
            
            cross_reduction_B: cross B_cvp_values_RED, A_cvp_values_ADD_MULT, opcode_bitwise_cp {
                ignore_bins A_data_max_ = binsof(A_cvp_values_ADD_MULT.A_data_max);
                ignore_bins A_data_min_ = binsof(A_cvp_values_ADD_MULT.A_data_min);
            }
            
            opcode_not_bitwise_cp: coverpoint seq_item_cov.opcode {
                bins bins_not_bitwise[] = {[ADD:$]};
            }
            red_op_B_point:coverpoint seq_item_cov.red_op_B;
            red_op_A_point:coverpoint seq_item_cov.red_op_A;
            
            cross_invalid_A: cross opcode_not_bitwise_cp, red_op_A_point {
                ignore_bins red_A_0 = binsof(red_op_A_point) intersect {0};
                illegal_bins red_A_ill = binsof(red_op_A_point) intersect {1};
            }
            
            cross_invalid_B: cross opcode_not_bitwise_cp,red_op_B_point{
                ignore_bins red_B_0 = binsof(red_op_B_point) intersect {0};
                illegal_bins red_B_ill = binsof(red_op_B_point) intersect {1};
            }
        
        endgroup
    
        function new(string name = "ALSU_coverage", uvm_component parent = null);
        super.new(name,parent);
        cvr_grp = new();
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export" , this);
            cov_fifo =new("cov_fifo" , this);
        endfunction


        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                cvr_grp.sample();
            end
        endtask
    
    endclass
    
    endpackage
