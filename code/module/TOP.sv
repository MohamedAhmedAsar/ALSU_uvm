import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_test_pkg::*;
module TOP;

    bit clk;
    always #5 clk=~clk;

    ALSU_if alsuf(clk);

    ALSU dut(alsuf);

    initial begin
        uvm_config_db#(virtual ALSU_if)::set(null, "uvm_test_top", "INTF", alsuf);
            
        run_test("ALSU_test");
    end

endmodule