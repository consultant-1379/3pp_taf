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

        #return 1
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
         # check to see if ERICjdk, EXTRjdk and ERIC3pp are installed

        pkginfo -q ERICjdk17
        JDK17=$?
        pkginfo -q ERICjdk16
        JDK16=$?
        if [ $JDK17 -eq 0 ]; then
                echo "ERICjdk17 is installed"
        elif [ $JDK16 -eq 0 ]; then
                echo "ERICjdk16 is installed"
                if [ $JDK17 -eq $JDK16 ]; then
                        echo "Warning, both ERICjdk16 and ERICjdk17 are installed"
                fi
        else
                echo "No ERICjdk package is installed"
                return 10
        fi

        pkginfo -q EXTRjdk17
        EXTRJDK17=$?
        pkginfo -q EXTRjdk16
        EXTRJDK16=$?
        if [ $EXTRJDK17 -eq 0 ]; then
                echo "ERICjdk17 is installed"
        elif [ $EXTRJDK16 -eq 0 ]; then
                echo "EXTRjdk16 is installed"
        else
                echo "No EXTRjdk package is installed"
                return 9
        fi

        pkginfo -q ERIC3pp
        if [ $? -eq 0 ]; then
                echo "ERIC3pp is installed"
        else
                echo "ERIC3pp is not installed"
                return 8
        fi

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
        JAVA=/opt/sun/jdk/java/bin/java
        JAVA_TEST=ProviderTest
        GREP=/bin/grep
        L_SECURITYFILE=/opt/sun/jdk/java/jre/lib/security/java.security

        if [ ! -f $L_SECURITYFILE ]; then
                return 4
        fi
         # Checks to see if the pkcs11 line that should be commented out
        # is so sun.security.pkcs11.SunPKCS11
        GREP 'sun.security.pkcs11.SunPKCS11' $L_SECURITYFILE | $GREP -v '^#'
        ret=$?
        # If pattern match found, then this means line exists and has not been hashed out.
        if [ $ret -eq 0 ]; then
                echo "PKCS11 line not commented out."
                return 3
        fi

        # Included Java test case that will try and retrieve the PKCS11
        # provider.  Returns > 0 if the provider can be retrieved.
        $JAVA $JAVA_TEST

        [ $? -eq 0 ] && return 0 || return 2

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
tc_precon
tc_test
