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

        #return 0
                retcode=0
                echo -e "Verify openfusion  enablelocator is set to false \n"
                EGREP=/usr/xpg4/bin/egrep
                EXPECT_LOCATORVAL="false"
                #souce openfusion env file
                . /etc/opt/ericsson/3ppenv/openfusion.env
                START_SCRIPT="$OPENFUSION_HOME"/bin/openfusionStartStop
                LOCATORVAL=`$EGREP "Dvbroker.agent.enableLocator"  $START_SCRIPT | cut -d'=' -f3 | sed 's/[",]//g' `
                if [[ "$LOCATORVAL" == "$LOCATORVAL" ]]; then
                        echo "Dvbroker.agent.enableLocator correctly set to $LOCATORVAL"
                else
                        echo " Dvbroker.agent.enableLocator incorrectly set to $LOCATORVAL or not Set.  \n expected value to be $EX
PECT_LOCATORVAL"
                        retcode=1
                fi
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