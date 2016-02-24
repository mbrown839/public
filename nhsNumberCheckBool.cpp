#include <iostream>
#include <algorithm>

bool nhsNumberCheckBool(std::string nhsNumber) {
	// returns a bool corresponding to "is this a valid NHS number?" 
	// See http://www.datadictionary.nhs.uk/version2/data_dictionary/data_field_notes/n/nhs_number_de.asp?shownav=0	
	// checks that nhsNumber actually contains something
	if (nhsNumber.empty()) {
		return false;
	}
	// replaces any dashes '-' in nhsNumber with spaces
	std::replace( nhsNumber.begin(), nhsNumber.end(), '-', ' '); 	
	// removes any spaces from nhsNumber
	nhsNumber.erase(std::remove (nhsNumber.begin(), nhsNumber.end(), ' '), nhsNumber.end());
	// checks that nhsNumber has a length of 10
	if (nhsNumber.length() != 10) {
		return false;
	}
	// checks that nhsNumber now only contains digits
	if ((nhsNumber.find_first_not_of("0123456789") == std::string::npos) == 0) {
		return false;
	}
	// check that NHS number is in range, see http://systems.hscic.gov.uk/nhsnumber/staff/comms/4788factsheet.pdf
	// stoi is a c++11 function so will produce an error without -std=c++11
	int rangeCheck = std::stoi(nhsNumber.substr(0,9));
	if (rangeCheck < 400000000 || rangeCheck >= 800000000
		|| (rangeCheck >= 500000000 && rangeCheck < 600000000)) {
		return false;
	}
	// initialises the integer tot as 0, then working back from the last digit
	// before the check sum multiplies by 10 and adds to the total, multiplies 
	// by 9 and adds to the total and so on for all digits.
	int tot = 0;
	for (int pos = 0; pos < 9; pos++) {
		tot += std::stoi(nhsNumber.substr (pos,1)) * (10 - pos);
	}
	// initialises m as tot (mod 11), then takes m from 11.
	int m = 11 - (tot % 11);

	// if m is 11, reassigns to 0
	// if m = 10, this is an invalid NHS number, so returns false

	if (m == 11) {
		m = 0;
    	} else if (m == 10) {
		return false;
	}
	// checks that the computed check digit agrees with the one provided
	int providedCs = std::stoi(nhsNumber.substr(9,1));
	return (providedCs == m);
}

int main (int argc, char** argv)
{
    // reset the clock
    timespec tS;
    tS.tv_sec = 0;
    tS.tv_nsec = 0;
    clock_settime(CLOCK_PROCESS_CPUTIME_ID, &tS);
    
	for (long int i = 4000000000; i <= 4064100000; i++) {
		std::string nhsNumber = std::to_string(i);
		// std::cout << nhsNumber << '\n';
		// std::cout << nhsNumberCheckBool(nhsNumber) << '\n';
		nhsNumberCheckBool(nhsNumber);
	}
	
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tS);
    std::cout << "Time taken is: " << tS.tv_sec << '.' << tS.tv_nsec << '\n';

    return 0;
}
