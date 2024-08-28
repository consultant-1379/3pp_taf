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
        #source needed variables
        . /ericsson/glassfish/bin/common_glassfish.sh
        ALIAS_ERIC_BIN="cd $ERIC_BIN"
        $ALIAS_ERIC_BIN
        retcode=0
        #check for needed files
        FILE_LIST="config_ldap.sh update_tss.sh change_masterpassword.sh change_masterpassword.exp install_cert.sh install_p12.sh"
        for file in $FILE_LIST; do
        if [ -s $file ]; then
           echo "$file  found ok"
        else
           echo " Needed file $file Not found or is zero bytes."
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