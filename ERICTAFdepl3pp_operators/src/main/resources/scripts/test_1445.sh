#!/bin/bash -x
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
#  27-3-2014     epelene        Sybase Backup test

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

        # coded to pass

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

        # Coded to pass

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

tc_test(){

RETURN_STATUS=0
SCRIPT=/ericsson/syb/backup/syb_dbdump
TARGET_DB="ActivitySupportDatabase"
SERVER_NAME=masterdataservice
G_SMTOOL=/opt/ericsson/nms_cif_sm/bin/smtool
JOBMANAGER_OFFLINE="$G_SMTOOL -offline job_manager -reason=upgrade -reasontext=n/a"
JOBMANAGER_ONLINE="$G_SMTOOL -online job_manager"
echo $G_SMTOOL
        if [ -d /var/opt/sybase/sybase/dbdumps ]; then
                echo "/var/opt/sybase/sybase/dbdumps is mounted"
        else
                echo "/var/opt/sybase/sybase/dbdumps is not mounted"
        fi
        $JOBMANAGER_OFFLINE
        ssh masterdataservice
        echo $($G_SMTOOL -l | grep -i job)
        $SCRIPT -D $TARGET_DB db $SERVER_NAME

        RETURN_STATUS=$?

        if [ $RETURN_STATUS -ne 0 ]; then

                RETURN_STATUS_REASON="Terminated with error!!"
                echo [OUTPUT:REASON:$RETURN_STATUS_REASON]
        fi
        $JOBMANAGER_ONLINE
        echo $($G_SMTOOL -l | grep -i job)
        #logout

return $RETURN_STATUS

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
         # Coded to pass

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
         # Coded to pass

        return 0
}
tc_test