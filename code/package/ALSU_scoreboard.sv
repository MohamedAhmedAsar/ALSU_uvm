package ALSU_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ALSU_seq_item_pkg::*;

    class ALSU_scoreboard extends uvm_scoreboard;
        parameter INPUT_PRIORITY = "A";
        parameter FULL_ADDER = "ON" ;
        `uvm_component_utils(ALSU_scoreboard)
        uvm_analysis_export #(ALSU_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo;
        ALSU_seq_item seq_item_sb;

        logic[5:0] alsu_out_ref;
        logic[15:0] alsu_leds_ref;

        int error_count = 0;
        int correct_count = 0;
    
        function new(string name = "ALSU_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
    
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb)
                if (seq_item_sb.out !== ALSU_out_ref && seq_item_sb.leds != alsu_leds_ref) begin
                    uvm_error("uvm_test_top", $sformatf("Comparison failed! Transaction received by the DUT differs from the reference output: %0s", seq_item_sb.convert2string(), alsu_out_ref));
                    error_count++;
                end else begin
                    uvm_info("uvm_test_top", $sformatf("Correct ALSU output: %s ", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        task ref_model(ALSU_seq_item seq_item_chk);
            if (seq_item_chk.rst) begin
                alsu_out_ref = 0;
                alsu_leds_ref = 0;
            end
            else begin
                case (seq_item_chk.opcode)
                    3'h0: begin
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B) begin
                            alsu_out_ref <= (INPUT_PRIORITY == "A") ? seq_item_chk.A : seq_item_chk.B;
                        end else if (seq_item_chk.red_op_A) begin
                            alsu_out_ref <= seq_item_chk.A;
                        end else if (seq_item_chk.red_op_B) begin
                            alsu_out_ref <= seq_item_chk.B;
                        end else begin
                            alsu_out_ref <= 0;
                        end
                    end
                    3'h1: begin
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B) begin
                            alsu_out_ref <= (INPUT_PRIORITY == "A") ? seq_item_chk.A +seq_item_chk.B : seq_item_chk.B + seq_item_chk.A;
                        end else if (seq_item_chk.red_op_A) begin
                            alsu_out_ref <= seq_item_chk.A + seq_item_chk.B;
                        end else if (seq_item_chk.red_op_B) begin
                            alsu_out_ref <= seq_item_chk.A + seq_item_chk.B;
                        end else begin
                            alsu_out_ref <= 0;
                        end
                    end
                    3'h2: begin
                        if (FULL_ADDER == "ON") begin
                            alsu_out_ref <= seq_item_chk.A + seq_item_chk.B + seq_item_chk.cin;
                        end else begin
                            alsu_out_ref <= seq_item_chk.A + seq_item_chk.B;
                        end
                    end
                    3'h3: begin
                        alsu_out_ref <= seq_item_chk.A * seq_item_chk.B;
                    end
                    3'h4: begin
                        alsu_out_ref <= (seq_item_chk.direction) ? {seq_item_chk.serial_in, seq_item_chk.out[5:1]} : {alsu_out_ref[4:0], seq_item_chk.serial_in};
                    end
                    3'h5: begin
                        if (seq_item_chk.direction) begin
                            alsu_out_ref <= {seq_item_chk.out[4:0], seq_item_chk.out[5]};
                        end else begin
                            alsu_out_ref <= {seq_item_chk.out[1], seq_item_chk.out[5:1]};
                        end
                    end
                endcase
                if (((seq_item_chk.red_op_A | seq_item_chk.red_op_B) & (seq_item_chk.opcode[1] | seq_item_chk.opcode[2])) | (seq_item_chk.opcode[1] & seq_item_chk.opcode[2])) begin
                    alsu_leds_ref = ~ alsu_leds_ref;
                end
                else begin
                    alsu_leds_ref = 0;
                end
            end
                

        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed transactions: %d", error_count), UVM_MEDIUM);
        endfunction
        
        endclass
    
endpackage