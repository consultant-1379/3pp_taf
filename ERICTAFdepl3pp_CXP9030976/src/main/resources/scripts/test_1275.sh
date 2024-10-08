#!/bin/bash
#################################################################################
#
#
#       COPYRIGHT (C) ERICSSON RADIO SYSTEMS AB, Sweden
#
#       The copyright to the document(s) herein is the property of
#       Ericsson Radio Systems AB, Sweden.
#
#       The document(s) may be used and/or copied only with the written
#       permission from Ericsson Radio Systems AB or in accordance with
#       the terms and conditions stipulated in the agreement/contract
#       under which the document(s) have been supplied.
#
#################################################################################


# ATCOMINF Test Callback Library

# Revision History
# <date>        <signum>        <details>

# Complete the callbacks in this library to automate the test case.
#
# Callbacks are stateless, it is not possible to set a global variable in one callback
# and access it it in another.
#
# Callbacks are called by the test harness in the following order:
#
# tc_setup()            # Called only for independent TC execution mode to setup TC
# tc_precon()           # Conditions that should exist before TC can run
# tc_test()             # Runs the test for this TC
# tc_postcon()          # Conditions that should/should not exist after successful TC
# tc_cleanup()          # Called only for independent TC execution mode to cleanup after TC

# All callbacks must PASS for a TC PASS result

#################################################################################
#
# CALLBACK: TC_SETUP
#
# This callback function is only called if the harness execution mode is 'AT_INDEPENDENT'
#
# Return or exit codes:
#  0    success
# >0    failure

tc_setup() {

        # Coded to fail in case TC_AUTOMATED=1 before automation completed
        # Change return code as required

                return 0

}
#################################################################################

#################################################################################
#
# CALLBACK: TC_PRECON
#
# This callback function checks the correct conditions exist to run the TC.
#
# Return or exit codes:
#  0    success
# >0    failure

tc_precon() {

        # Coded to fail in case TC_AUTOMATED=1 before automation completed
        # Change return code as required

                return 0

}
#################################################################################


#################################################################################
#
# CALLBACK: TC_TEST
#
# This callback function runs the test.
# The harness compares the return code to the SPEC_TC_TEST_PASSCODE value set in the test spec.
#
# Return or exit codes:
#    SPEC_TC_TEST_PASSCODE      success
# != SPEC_TC_TEST_PASSCODE      failure


tc_test() {

        # Coded to fail in case TC_AUTOMATED=1 before automation complete
        # Change return code as required

        #return 123
        # verify file linking has been established
        echo -e "Check if symbolic links are setup for Domain1\lib \n"
        . /ericsson/glassfish/bin/common_glassfish.sh
        ALIAS_CLASSLOADER="cd $Common_Classloader"
        DEFAULT_SYM_LIST=" antlr-3.1.1-runtime.jar aspectjrt.jar cslib.jar activitysupport_jmagent.jar activitysupport_jmagent.jar jm_idl.jar jta-1.1.jar bcel.jar jdo2-api-2.1.jar nms_fwSysConf_util.jar csu.jar ssu.jar nms_cif_nsa.jar nms_cif_na.jar nms_fwSysConf_tss.jar nms_cif_mm.jar nms_cif_portal.jar RanosMim.jar pizza.jar"

        $ALIAS_CLASSLOADER
        retcode=0
        
	#default asm Jar version
	asmJarVer="asm-all-3.3.1.jar"
        
		ist_run -v | egrep "OSSRC_O16|OSSRC_O17|OSSRC_O18" >> /dev/null
        oss_ver=$?
        
	#asm jar upgraded to 5.0.3 after OSSRC_O16
        [[ $oss_ver -eq 0 ]] && asmJarVer="asm-all-5.0.3.jar"
        SYM_LIST="$asmJarVer$DEFAULT_SYM_LIST"

        for file in $SYM_LIST; do
           if [[ -L "$file" ]]; then
                echo "$file  symbolic linkng ok";
           else
                echo "$file is not a symbolic link or does not exist  ";
		echo "file is not a symbolic link";
                retcode=$(( $retcode + 1 ))
           fi
        done
        return $retcode

}





#################################################################################


#################################################################################
#
# CALLBACK: TC_POSTCON
#
# This callback function checks expected results.
#
# Return or exit codes:
#  0    success
# >0    failure

tc_postcon() {

        # Coded to fail in case TC_AUTOMATED=1 before automation complete.
        # Change return code as required

                return 0

}
#################################################################################


#################################################################################
#
# CALLBACK: TC_CLEANUP
#
# This callback function is only called if the harness execution mode is 'AT_INDEPENDENT'
#
# This callback restores the target system to the state it was in before the TC
# was run. It rolls back changes made by callbacks tc_setup() and tc_test()
#
# Return or exit codes:
#  0    success
# >0    failure

tc_cleanup() {

        # Coded to fail in case TC_AUTOMATED=1 before automation complete
        # Change return code as required

        return 0

}
tc_test
