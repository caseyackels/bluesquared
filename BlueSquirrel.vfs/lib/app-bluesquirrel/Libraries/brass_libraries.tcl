# Creator: Casey Ackels
# Date: June 10th, 2007
# Last Updated:
# Version: .2
# Dependencies: See brass_launch_code.tcl



namespace eval Brass_Libraries {

proc doMath {totalQuantity maxPerBox} {
# Do mathmatical equations, then double check to make sure it comes out to the value of totalQty
    global boxSize
    #puts "Starting doMath"
    
    #puts "TOTALQUANTITY: $totalQuantity"
    if {$totalQuantity == "" || $totalQuantity == 0} {return}
    
    if {$totalQuantity < $maxPerBox} {
	lappend partialBoxQTY
    }
   
    #puts "TotalQty: $totalQuantity"
    #puts "maxPerBox: $maxPerBox"
    
    set divideTotalQuantity [expr {$totalQuantity/$maxPerBox}]
    
    set totalFullBoxs [expr {round($divideTotalQuantity)}]
    set fullBoxQTY [expr {round(floor($divideTotalQuantity) * $maxPerBox)}]
    
    ## Use fullBoxQty as a starting point for the partial box.
    lappend partialBoxQTY [expr {round($totalQuantity - $fullBoxQTY)}]
    
    # NumberOfFullBoxes, QtyOfPartial
    #puts "totalFullBoxs: $totalFullBoxs"
    #puts "partialBoxQTY: $partialBoxQTY"
    #return "$totalFullBoxs $partialBoxQTY"
    boxSizeSorter $totalFullBoxs $partialBoxQTY
    #puts "Ending doMath"
    
} ;# End of doMath

# Feed [doMath] into proc, [switch] through the BoxSize, with what [doMath] has returned
proc boxSizeSorter {numFullBoxes partialBoxQty} {
    global A_header boxSize
    #puts "Starting boxSizeSorter"
    
    if {$partialBoxQty <= $boxSize(2,qty)} {
	set boxSize(generic,qty) $partialBoxQty
	set boxSize(generic,lb) [expr {round(ceil($boxSize(generic,qty) * $boxSize(pieceWeight) + $boxSize(2,lb)))}]      
        
	} elseif {$partialBoxQty <= $boxSize(4,qty)} {
            set boxSize(generic,qty) $partialBoxQty
	    set boxSize(generic,lb) [expr {round(ceil($boxSize(generic,qty) * $boxSize(pieceWeight) + $boxSize(4,lb)))}]
        
        } elseif {$partialBoxQty <= $boxSize(6,qty)} {
            set boxSize(generic,qty) $partialBoxQty
	    set boxSize(generic,lb) [expr {round(ceil($boxSize(generic,qty) * $boxSize(pieceWeight) +  $boxSize(6,lb)))}]
        
        } elseif {$partialBoxQty <= $boxSize(9,qty)} {
	    set boxSize(generic,qty) $partialBoxQty
	    set boxSize(generic,lb) [expr {round(ceil($boxSize(generic,qty) * $boxSize(pieceWeight) + $boxSize(9,lb)))}]
    }

    
    set boxSize(numFullBoxes) $numFullBoxes
    set boxSize(fullBoxWeight) [expr {round(ceil($boxSize(9,qty) * $boxSize(pieceWeight) + $boxSize(9,lb)))}]
    set boxSize(partialBoxQty) $partialBoxQty
    #puts "Ending boxSizeSorter"
  
} ;# End of boxSizeSorter

} ;# End of Brass_Libraries