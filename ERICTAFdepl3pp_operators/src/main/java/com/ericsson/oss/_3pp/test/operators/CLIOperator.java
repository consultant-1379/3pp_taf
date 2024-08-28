package com.ericsson.oss._3pp.test.operators;

import java.io.FileNotFoundException;
import java.util.List;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.Operator;
import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.handlers.RemoteFileHandler;
import com.ericsson.cifwk.taf.tools.cli.CLI;
import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.cifwk.taf.tools.cli.TimeoutException;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.google.inject.Singleton;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;


@Operator(context = Context.CLI)
@Singleton
public class CLIOperator implements GenericOperator {

    private CLI cli;
    private Shell shell;
    private static String myString;

    Logger logger = Logger.getLogger(CLIOperator.class);

    @Override
    public String getCommand(String command) {
        return DataHandler.getAttribute(cliCommandPropertyPrefix + command)
                .toString();
    }

    public static boolean initialise() {
     Host host = DataHandler.getHostByName("ossmasterRoot");

        String source = FileFinder.findFile("UserDetails.sh").get(0);
        String target = DataHandler.getAttribute("TESTFILES").toString();
        RemoteObjectHandler remoteObjectHandler = new RemoteObjectHandler(host);
        if (!remoteObjectHandler.remoteFileExists(target)) {
            return remoteObjectHandler.copyLocalFileToRemote(source, target);
        } else
            return true;

    }

    @Override
    public Shell initializeShell(Host host) {
        cli = new CLI(host);
        if (shell == null) {
            shell = cli.openShell();
            logger.debug("Creating new shell instance");
        }
                return shell;
    }



    @Override
    public void writeln(String command, String args) {
        String cmd = getCommand(command);
        logger.trace("Writing " + cmd + " " + args + " to standard input");
        logger.info("Executing commmand " + cmd + " with args " + args);
        shell.writeln(cmd + " " + args);
    }


    @Override
    public void writeln(String command) {
        //String cmd = getCommand(command);
        String cmd = command;
        logger.trace("Writing " + cmd + " to standard input");
        logger.info("Executing commmand " + cmd);
        shell.writeln(cmd);
    }

    @Override
    public int getExitValue() {
        int exitValue = shell.getExitValue();
        logger.debug("Getting exit value from shell, exit value is :"
                + exitValue);
        return exitValue;
    }

    @Override
    public String expect(String expectedText) throws TimeoutException {
        logger.debug("Expected return is " + expectedText);
        String found = shell.expect(expectedText);
        return found;
    }

    public void expect( String expectedText2, int expectedText ) throws TimeoutException {
        logger.debug("Expected return is " + expectedText2+ " " +expectedText);
        //String found = shell.expect(expectedText);
        //return found;
    }

    @Override
    public void expectClose(int timeout) throws TimeoutException {
        shell.expectClose(timeout);
    }

    @Override
    public boolean isClosed() throws TimeoutException {
        return shell.isClosed();
    }

    @Override
    public String checkForNullError(String error) {
        if (error == null) {
            error = "";
            return error;
        }
        return error;
    }

    @Override
    public String getStdOut() {
        String result = shell.read();
        logger.debug("Standard out: " + result);
        return result;
    }

    @Override
    public void disconnect() {
        logger.info("Disconnecting from shell");
        shell.disconnect();
        shell = null;
    }

    @Override
    public void sendFileRemotely(Host host, String fileServerLocation, String fileName) throws FileNotFoundException {

//       RemoteObjectHandler remoteObjectHandler = new RemoteObjectHandler(host);
//

//         File file = new File("src/main/resources/scripts/");
//         File[] allFiles = file.listFiles();
//
//         for(int i=0; i<allFiles.length; i++){
//               remoteObjectHandler.copyLocalFileToRemote(allFiles[i].getAbsolutePath(),remoteFileLocation);
//         logger.debug("Copying " + allFiles[i].getAbsolutePath() + " to " + remoteFileLocation
//                 + " on remote host");
//          }
        RemoteObjectHandler remote = new RemoteObjectHandler(host);
        List<String> fileLocation = FileFinder.findFile(fileName);
        String remoteFileLocation = fileServerLocation; // unix address
        remote.copyLocalFileToRemote(fileLocation.get(0), remoteFileLocation);
        logger.debug("Copying " + fileName + " to " + remoteFileLocation
                + " on remote host");

    }

    @Override
    public void deleteRemoteFile(Host host, String fileName,
            String fileServerLocation) throws FileNotFoundException {

        RemoteObjectHandler remoteObjectHandler = new RemoteObjectHandler(host);
        String remoteFileLocation = fileServerLocation;
        remoteObjectHandler.deleteRemoteFile(remoteFileLocation + fileName);
        logger.debug("deleting " + fileName + " at location "
                + remoteFileLocation + " on remote host");
    }

    @Override
    public void scriptInput(String message) {
        logger.info("Writing " + message + " to standard in");
        shell.writeln(message);
    }

    @Override
    public Shell executeCommand(String... commands) {
        logger.info("Executing command(s) " + commands);
        return cli.executeCommand(commands);

    }

        @Override
        public void execute(String command, String args) {
                // TODO Auto-generated method stub
                String cmd = command;
                 logger.trace("Writing " + cmd + " " + args + " to standard input");
                logger.info("Executing commmand " + cmd + " with args " + args);
                shell.writeln(cmd + " " + args);
        }
}
