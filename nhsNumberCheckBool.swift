import Foundation

func nhsNumberCheckBool(nhsNumber: String) -> Bool {

	/* 
	*  returns a bool corresponding to "is this a valid NHS number?" 
	*  See http://www.datadictionary.nhs.uk/version2/data_dictionary/data_field_notes/n/nhs_number_de.asp
	*  This is written for Swift 3.0, backwards compatibility is not guaranteed.
	*/
	
	// checks that nhsNumber actually contains something
	//  using guard not empty, remove spaces & dashes, guard = 10 to allow less strict arguments.
    guard nhsNumber.isEmpty == false else {
        return false
    }
    
    // sets up nhsNum as a separate var, not let since it can be modified
    var nhsNum:String = nhsNumber
    
    // removes any dashes or spaces
    nhsNum = String(nhsNum.characters.filter {$0 != " " && $0 != "-"})
    
    // checks that the number contains exactly 10 characters
    guard nhsNum.characters.count == 10 else {
        return false
    }
    
    // need to declare this as it is an optional? Checks it only contains numbers.
    let nhsInt:Int? = Int(nhsNum)
    
	// Checks it only contains numbers.
    guard nhsInt != nil else {
        return false
    }
    
    // removes the last digit
    let rangeCheck = Int(nhsInt! / 10)
    
    // check that NHS number is in range, see http://systems.hscic.gov.uk/nhsnumber/staff/comms/4788factsheet.pdf
    guard rangeCheck >= 400000000 && rangeCheck < 800000000
    	&& (rangeCheck < 500000000 || rangeCheck >= 600000000) else {
            return false
    }
    
    // calculates the final check sum before we recycle the rangeCheck variable
    let providedCs:Int = nhsInt! - 10*rangeCheck
    
    var tot:Int = 0
    var rangeCheckIterate:Int = rangeCheck
    var j:Int = 1
    var multiplier:Int = 10
    
    /* 
    *  Having initialised tot as 0, then working back from the last digit
    *  before the check sum, multiplies by 10 and adds to the total, multiplies 
    *  by 9 and adds to the total and so on for all digits.
    */
    
    while j < 10 {
        tot += multiplier * (rangeCheckIterate - 10*(Int(rangeCheckIterate/10)))
        rangeCheckIterate = Int(rangeCheckIterate/10)
        j+=1
        multiplier-=1
    }
    
    // computes tot(mod 11) then takes this from 11
    var m:Int = 11 - (tot % 11)
    
    // if m is 10, this NHS number is not valid. If m is 11, sets m to 10
    switch m {
    case 10:
        return false
    case 11:
        m = 0
    default:
        ()
    }
    
    // returns whether or not m matches providedCs
    return(m == providedCs)
}

var z: Int = 0
var nhs: Int = 4160000000
var nhsChar: String

// starts the timer
let date_start = NSDate()

/* 
*  loops from z which is 0 by default to some number, calculating if the number
*  is valid, returning a bool then adding 1 to both z and the nhs variable
*  by this method all numbers in the starting nhs value to nhs + some number
*  will be checked for validity
*/

while z < 1000 {
    nhsChar = String(nhs)
    // these bits are for testing, leave as comments by default
    // print(nhsChar)
	print(nhsNumberCheckBool(nhsNumber: nhsChar))
	// nhsNumberCheckBool(nhsNumber: nhsChar)
    z+=1
    nhs+=1
}

// prints the time elapsed since the timer began
print("\(-date_start.timeIntervalSinceNow)")
