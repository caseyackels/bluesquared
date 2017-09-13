# Creator: Casey Ackels
# Initial Date: December 12, 2016]

#proc ea::sched::code::writeDateType {cbox w} {
#    global log sched   
#    
#    set grp [$cbox get]
#    set desc [$w get]
#    
#    #${log}::debug $grp $desc $sched(avoid_weekend) $sched(avoid_plantHoliday) $sched(avoid_freightHoliday) $sched(avoid_USPSHoliday)
#    ea::sched::db::addDateType $desc $grp $sched(avoid_weekend) $sched(avoid_plantHoliday) $sched(avoid_freightHoliday) $sched(avoid_USPSHoliday)
#}
#
#proc ea::sched::code::writeFrequency {wid_desc wid_frequency} {
#    global log sched
#    
#    set desc [$wid_desc get]
#    set freq [$wid_frequency get]
#    
#    ea::sched::db::writeFreqency $desc $freq
#}