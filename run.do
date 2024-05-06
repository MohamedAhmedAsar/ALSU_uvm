vlib work
vlog -f ALSU_uvm/code/file_list.list -mfcu +cover
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all
#coverage save fiforpt.ucdb -onexit -du work.top
#add wave *
run -all
coverage report -detail -cvg -directive -comments -output fcover_report.txt /ALSU_coverage_pkg/ALSU_coverage/cvr_grp
#quit -sim
#vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt
