# Namespaces (app, module, categroy)
namespace eval ea::sched::code {}
namespace eval ea::sched::gui {}
namespace eval ea::sched::db {}

package ifneeded eAssist_ModScheduler 1.0 "[list source [file join $dir sched_db.tcl]]
                                            [list source [file join $dir sched_gui.tcl]]"