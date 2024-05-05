vlib work
vlog -f ALSU_uvm/code/file_list.list -mfcu  +cover
vsim -voptargs=+acc work.TOP -cover 
#coverage save fiforpt.ucdb -onexit -du work.top
add wave *
run -all
#quit -sim
#vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt
