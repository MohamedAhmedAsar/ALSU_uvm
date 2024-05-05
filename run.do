vlib work
vlog -f ALSU_uvm/code/file_list.list -mfcu  
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all
#coverage save fiforpt.ucdb -onexit -du work.top
#add wave *
run -all
#quit -sim
#vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt
