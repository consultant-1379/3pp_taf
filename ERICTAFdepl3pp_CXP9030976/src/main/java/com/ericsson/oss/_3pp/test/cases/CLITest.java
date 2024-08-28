package com.ericsson.oss._3pp.test.cases ;

import java.io.FileNotFoundException;
import java.util.List;

import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.DataDriven;
import com.ericsson.cifwk.taf.annotations.Input;
import com.ericsson.cifwk.taf.annotations.Output;
import com.ericsson.cifwk.taf.annotations.TestId;
import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.cifwk.taf.tools.cli.Terminal;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.cifwk.taf.tools.cli.TimeoutException;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.ericsson.oss._3pp.test.operators.CLIOperator;
import com.ericsson.oss._3pp.test.operators.GenericOperator;
import com.google.inject.Inject;


public class CLITest extends TorTestCaseHelper implements TestCase {

	@Inject
	OperatorRegistry<GenericOperator> operatorRegistry;	
	Host host;
    String remoteFileLocation;
    String fileName;
	
	 /**@BeforeSuite
	 public void initialise()
	 {
	     host = DataHandler.getHostByName("ossmasterRoot");
	     assertTrue(CLIOperator.initialise());        
	 }**/

	/**
	 * @throws TimeoutException 
	 * @throws FileNotFoundException 
	 * @DESCRIPTION Verify the ability of CLI Shell commands to be executed
	 * @PRE Connection to SUT
	 * @VUsers 1
	 * @PRIORITY HIGH
	 */
	 
	@TestId(id = "CIP-3884_Func_1", title = "Verify CLI Commands can be executed")
	@Context(context = {Context.CLI})
	@Test(groups={"Acceptance"})
	@DataDriven(name = "commandData")
	public void verifyCLICommandsCanBeExecuted(			
			@Input("command")String command,
			@Input("timeout") int timeout,
			@Input("args")String args,
			@Output("expectedOut") String expectedOut,
			@Output("expectedExit") int expectedExitCode) throws InterruptedException, TimeoutException, FileNotFoundException {

	    host = DataHandler.getHostByName("ossmasterRoot");
	    assertTrue(CLIOperator.initialise());    
		GenericOperator cliOperator = operatorRegistry.provide(GenericOperator.class);
		cliOperator.initializeShell(host);   
		cliOperator.writeln(command, args); 
		assertTrue (cliOperator.getStdOut().contains(expectedOut));  	
	}
   
    
   /** 
    * @DESCRIPTION Check Deployment Time
    * @PRE NONE
    * @PRIORITY HIGH
    * @throws FileNotFoundException 
    */
	
    @TestId(id = "OSS-42633_Func_2", title = "Copy files to remote")
	@Context(context = {Context.CLI})
	@Test(groups={"Acceptance"})
	@DataDriven(name = "sequentialData")
	public void verifyCLICommandsCanBeExecutedSequentially(		
            //convert dos2unix
			@Input("command")String Cmd,
			@Input("timeout") int timeout,
			@Input("exitShell") String exitShellCmd,
			@Output("expectedOut") String expectedOut,
			@Output("expectedErr") String expectedErr,
			@Output("expectedExit") int expectedExitCode) throws InterruptedException, TimeoutException, FileNotFoundException {
    	host = DataHandler.getHostByName("ossmasterRoot");
 	    assertTrue(CLIOperator.initialise());
		GenericOperator cliOperator = operatorRegistry.provide(GenericOperator.class);
		cliOperator.initializeShell(host);   
		
		String remoteFileLocation = "/tmp/clitest/test_scripts/";
		cliOperator.sendFileRemotely(host, remoteFileLocation, Cmd);
		 exitShellCmd = "exit";
		 expectedExitCode = 0;
		 timeout = 10;
		 cliOperator.writeln(exitShellCmd);
		 cliOperator.expectClose(timeout);
		 assertTrue (cliOperator.isClosed());
		 cliOperator.disconnect();
		 
	}
    
    /**
     * @DESCRIPTION Verify symbolic links set in configure script exist
     * @PRE NONE
     * @PRIORITY HIGH
     * @throws FileNotFoundException 
     */
    
    @TestId(id = "OSS-42633_Func_3", title = "AT&T 11 TOL test cases")
    @Context(context = {Context.CLI})
    @Test(groups={"Acceptance"})
    @DataDriven(name = "sequentialDataGfish")
    public void verifySymbolicLinksSetInConfigureScriptExist(	
    		@Input("TCID") String testcaseid,
    		@Input("title") String testcasetitle,
    		@Input("command")String Cmd,
			@Input("timeout") int timeout,
			@Input("exitShell") String exitShellCmd,
			@Output("expectedOut") String expectedOut,
			//@Output("expectedErr") String expectedErr,
			@Output("expectedExit") int expectedExitCode) throws InterruptedException, TimeoutException, FileNotFoundException {

    	GenericOperator cliOperator = operatorRegistry.provide(GenericOperator.class);
		cliOperator.initializeShell(host); 
		setTestcase(testcaseid,testcasetitle);
		String remoteFileLocation = "/tmp/clitest/test_scripts/";
		cliOperator.sendFileRemotely(host, remoteFileLocation, Cmd);
		cliOperator.execute("cd ", " " +remoteFileLocation);
		cliOperator.execute("dos2unix", " " +Cmd+ " " +Cmd); 
		cliOperator.execute("chmod 777", "" +Cmd);
		//execute actual test script
		cliOperator.writeln(remoteFileLocation+Cmd);
        cliOperator.expect(expectedOut,timeout);
		cliOperator.writeln(exitShellCmd);
		cliOperator.expectClose(timeout);
		assertTrue (cliOperator.isClosed());
		assertEquals(expectedExitCode,cliOperator.getExitValue());
		
	    
	    cliOperator.deleteRemoteFile(host, Cmd, remoteFileLocation);
		cliOperator.disconnect();
    }
}

