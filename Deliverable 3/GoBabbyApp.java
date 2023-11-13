import java.util.HashMap;
import java.util.Scanner;
import java.util.Random;
import java.sql.*;

public class GoBabbyApp {
    public static void main(String[] args) throws SQLException {
        Scanner reader = new Scanner(System.in);

        int sqlCode=0;      // Variable to hold SQLCODE
        String sqlState="00000";  // Variable to hold SQLSTATE

        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // This is the url you must use for DB2.
        //Note: This url may not valid now ! Check for the correct year and semester and server name.
        String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";

        // My user id and password were removed, please input valid credentials to be able to use the application.
        String your_userid = null;
        String your_password = null;

        if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null) {
            System.err.println("Error!! do not have a user id to connect to the database!");
            System.exit(1);
        }
        if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null) {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }

        Connection con = DriverManager.getConnection(url,your_userid,your_password);
        Statement statement = con.createStatement();
        while(true) {
            System.out.println("Please enter your practioner id [E] to exit:");
            String practID = reader.nextLine();

            if (exit(practID)) { // check if the user wants to exit
                statement.close();
                con.close();
                System.exit(0);
            }
            try {
                String practIDSQL = "select practID from midwives m " + "where m.practID=" + practID;
                ResultSet rsID = statement.executeQuery(practIDSQL);
                if (rsID.next()) { // if the midwife practID exists, then continue
                    int id = rsID.getInt(1); // get the practID
                    if (practID.equals(String.valueOf(id))){ // check if it equals the value of the one entered
                        while(true) {
                            System.out.println("Please enter the date for appointment list [E] to exit:");
                            String date = reader.nextLine();
                            if (exit(date)) { // check if the user wants to exit
                                statement.close();
                                con.close();
                                System.exit(0);
                            }
                            try {
                                while (true){
                                    String dateSQL = "select heldDate from appointments where heldDate=\'" + date + "\' and practID=" + practID;
                                    ResultSet rsDateExists = statement.executeQuery(dateSQL);
                                    if (rsDateExists.next()) { // if the queried appointment exists
                                        String primaryMidwifeSQL = "select pregID, ppractID from pregnancy where ppractID=" + practID;
                                        ResultSet rsPrimary = statement.executeQuery(primaryMidwifeSQL);
                                        HashMap<Integer, Integer> primaryMidwifeResult = new HashMap<>();
                                        while (rsPrimary.next()) { // get pregnancies for which midwife is the primary midwife
                                            int tempPregID = rsPrimary.getInt(1);
                                            int tempPPractID = rsPrimary.getInt(2);
                                            primaryMidwifeResult.put(tempPregID, tempPPractID);
                                        }

                                        String backupMidwifeSQL = "select pregID, bpractID from pregnancy where bpractID=" + practID;
                                        ResultSet rsBackup = statement.executeQuery(backupMidwifeSQL);
                                        HashMap<Integer, Integer> backupMidwifeResult = new HashMap<>();
                                        while (rsBackup.next()) { // get pregnancies for which midwife is the backup midwife
                                            int tempPregID = rsBackup.getInt(1);
                                            int tempBPractID = rsBackup.getInt(2);
                                            backupMidwifeResult.put(tempPregID, tempBPractID);
                                        }

                                        String motherInfoSQL = "select distinct pregID, insuranceInfo.hCardID, p.pname from\n" +
                                                "    (select pregID, m.hCardID from (\n" +
                                                "        select pregID, c.hCardID from\n" +
                                                "            (select pregID, coupleID from pregnancy\n" +
                                                "            where " + practID + " in (select ppractID from pregnancy where ppractID =" + practID + ")\n" +
                                                "            or " + practID + " in (select bpractID from pregnancy where bpractID =" + practID + "))assocPreg\n" +
                                                "        inner join couples c on c.coupleID = assocPreg.coupleID)mothers\n" +
                                                "    inner join mother m on m.hCardID = mothers.hCardID)insuranceInfo\n" +
                                                "inner join parent p on p.hCardID = insuranceInfo.hCardID";
                                        ResultSet motherInfo = statement.executeQuery(motherInfoSQL);
                                        HashMap<Integer, String> motherInfoResult = new HashMap<>();
                                        while (motherInfo.next()) { // get the necessary information of the mother (hCardID, associated pregID, name)
                                            int tempPregID = motherInfo.getInt(1);
                                            int tempHCardID = motherInfo.getInt(2);
                                            String tempName = motherInfo.getString(3);

                                            String hCardIDAndName = tempName + " " + tempHCardID;
                                            motherInfoResult.put(tempPregID, hCardIDAndName);
                                        }

                                        String appointmentDateSQL = "select heldTime, practID, pregID, apptID from appointments where heldDate=\'" + date + "\' and practID=" + practID + " order by heldTime";
                                        ResultSet rsAppt = statement.executeQuery(appointmentDateSQL);
                                        HashMap<Integer, Integer> apptNumAndID = new HashMap<>();
                                        HashMap<Integer, String> apptNumAndMotherInfo = new HashMap<>();
                                        HashMap<Integer, Integer> apptNumAndPregID = new HashMap<>();
                                        int count = 1;

                                        while (rsAppt.next()) { // print out appointments with associated date in required format and store important information for later
                                            String heldTime = rsAppt.getString(1);
                                            int tempPractID = rsAppt.getInt(2);
                                            int pregID = rsAppt.getInt(3);
                                            int apptID = rsAppt.getInt(4);
                                            String hCardIDAndName = motherInfoResult.get(pregID);

                                            if (isPrimary(pregID, Integer.valueOf(practID), primaryMidwifeResult)) {
                                                System.out.println(count + ":  " + heldTime + " P " + hCardIDAndName);
                                            }
                                            else {
                                                System.out.println(count + ":  " + heldTime + " B " + hCardIDAndName);
                                            }
                                            apptNumAndID.put(count, apptID);
                                            apptNumAndMotherInfo.put(count, hCardIDAndName);
                                            apptNumAndPregID.put(count, pregID);
                                            count += 1;
                                        }
                                        System.out.println("Enter the appointment number that you would like to work on.\n" +
                                                "[E] to exit [D] to go back to another date :");
                                        String apptResponse = reader.nextLine();
                                        if (exit(apptResponse)) { // check if the user wants to exit
                                            statement.close();
                                            con.close();
                                            System.exit(0);
                                        }
                                        else if(apptResponse.equals(("D"))) { // check if use wants to switch to a different date
                                            break;
                                        }
                                        if (Integer.valueOf(apptResponse) >= 1 && Integer.valueOf(apptResponse) <= count){ // check if values user selected are within the bounds of the list generated
                                            while(true){
                                                int apptNum = Integer.valueOf(apptResponse);  // convert selected appt to int to be used to retrieve stored data
                                                String hCardIDAndName = apptNumAndMotherInfo.get(apptNum);
                                                System.out.println("For " + hCardIDAndName + "\n" +
                                                        "1. Review Notes\n" +
                                                        "2. Review Tests\n" +
                                                        "3. Add a note\n" +
                                                        "4. Prescribe a test\n" +
                                                        "5. Go back to appointments.\n\n" +
                                                        "Enter your choice:");

                                                int response = reader.nextInt();
                                                if (response == 1) { // retrieve stored data, query for associated notes
                                                    try {
                                                        int tempApptID = apptNumAndID.get(apptNum);
                                                        int pregID = apptNumAndPregID.get(apptNum);
                                                        String apptNotesSQL = "select takenDate, takenTime, observation from notes where apptID in (select apptID from appointments where pregID = " + pregID + ") order by takenDate desc, takenTime asc";
                                                        ResultSet rsRelevantNotes = statement.executeQuery(apptNotesSQL);
                                                        while (rsRelevantNotes.next()) {
                                                            String heldDate = rsRelevantNotes.getString(1);
                                                            String heldTime = rsRelevantNotes.getString(2);
                                                            String observation = rsRelevantNotes.getString(3);
                                                            if(observation.length() > 50){ // truncate if length of observation > 50 characters
                                                                System.out.println(heldDate + " " + heldTime + " " + observation.substring(0,50));
                                                            }
                                                            else {
                                                                System.out.println(heldDate + " " + heldTime + " " + observation);
                                                            }
                                                        }
                                                    }
                                                    catch (SQLException e) { // if invalid date was entered
                                                        System.out.println("No appointments for this date were found.");
                                                        continue;
                                                    }
                                                }
                                                else if (response == 2) {
                                                    try { // read stored data, query database for tests
                                                        int tempPregID = apptNumAndPregID.get(apptNum);
                                                        String tempMotherNameAndInfo = apptNumAndMotherInfo.get(apptNum).trim();
                                                        int motherHCardID = Integer.valueOf(tempMotherNameAndInfo.substring(tempMotherNameAndInfo.lastIndexOf(" ") + 1, tempMotherNameAndInfo.length())); // read hCardID
                                                        String motherTestsSQL = "select prescribedDate, ttype, result from\n" +
                                                                "    (select pregTests.testID from\n" +
                                                                "        (select testID from testsTakenDuring where pregID = " + tempPregID + ")pregTests\n" +
                                                                "    inner join motherTests mt on mt.testID = pregTests.testID\n" +
                                                                "    where mt.mother = " + motherHCardID + ")motherTests\n" +
                                                                "inner join tests t on t.testID = motherTests.testID\n" +
                                                                "order by prescribedDate desc";
                                                        ResultSet rsMotherTests = statement.executeQuery(motherTestsSQL);
                                                        while(rsMotherTests.next()) {
                                                            String prescribedDate = rsMotherTests.getString(1);
                                                            String testType = rsMotherTests.getString(2);
                                                            String result = rsMotherTests.getString(3);
                                                            if(result == null) { // if resultSet returns null, output pending
                                                                System.out.println(prescribedDate + " [" + testType + "] PENDING");
                                                            }
                                                            else if (result.length() > 50) { // truncate to 50 if result description is too long
                                                                System.out.println(prescribedDate + " [" + testType + "] " + result.substring(0, 50));
                                                            }
                                                            else { // output result description like normal
                                                                System.out.println(prescribedDate + " [" + testType + "] " + result);
                                                            }
                                                        }
                                                    }
                                                    catch (SQLException e) { // if there were no tests found with associated pregnancy
                                                        System.out.println("No tests for this pregnancy were found.");
                                                        continue;
                                                    }
                                                }
                                                else if (response == 3) {
                                                    try {
                                                        Random rand = new Random();
                                                        int pregID = apptNumAndPregID.get(apptNum);
                                                        int tempApptID = apptNumAndID.get(apptNum);
                                                        int newApptID = tempApptID + rand.nextInt(9999 - 1000) + 1000;
                                                        System.out.println("Please type your observations (no more than 200 characters):");
                                                        String observation = reader.nextLine();
                                                        observation = reader.nextLine(); // weird bug from cs in high school
                                                        String insertApptSQL = "insert into appointments (apptID, heldDate, heldTime, practID, pregID) values (" + newApptID + ", CURRENT DATE, CURRENT TIME, " + practID + ", " + pregID + ")";
                                                        statement.executeUpdate(insertApptSQL);
                                                        String insertNoteSQL = "insert into notes (apptID, takenDate, takenTime, observation) values (" + newApptID + ", CURRENT DATE, CURRENT TIME, \'" + observation + "\')";
                                                        statement.executeUpdate(insertNoteSQL);
                                                    }
                                                    catch (SQLException e) { // handle error with inserting information into table
                                                        System.out.println("Could not insert notes into the database, please select the option and try again.");
                                                        continue;
                                                    }
                                                }
                                                else if (response == 4) {
                                                    try {
                                                        Random rand = new Random();
                                                        int pregID = apptNumAndPregID.get(apptNum);
                                                        String tempMotherNameAndInfo = apptNumAndMotherInfo.get(apptNum).trim();
                                                        int motherHCardID = Integer.valueOf(tempMotherNameAndInfo.substring(tempMotherNameAndInfo.lastIndexOf(" ") + 1, tempMotherNameAndInfo.length()));
                                                        int newTestID = rand.nextInt(9999 - 1000) + 1000;
                                                        System.out.println("Please enter the type of test:");
                                                        String testType = reader.nextLine();
                                                        testType = reader.nextLine();
                                                        String insertTestSQL = "insert into tests (testID, ttype, prescribedDate, sampleDate, labWorkDate, result) values (" + newTestID + ", \'" + testType + "\', CURRENT DATE, CURRENT DATE, NULL, NULL)";
                                                        statement.executeUpdate(insertTestSQL);
                                                        String insertMotherTestSQL = "insert into motherTests (testID, practID, mother) values (" + newTestID + ", " + practID + ", " + motherHCardID + ")";
                                                        statement.executeUpdate(insertMotherTestSQL);
                                                        String insertTestsTakenDuringSQL = "insert into testsTakenDuring (testID, pregID, birthTime) values (" + newTestID + ", " + pregID + ", NULL)";
                                                        statement.executeUpdate(insertTestsTakenDuringSQL);
                                                    }
                                                    catch (SQLException e) { // handle error with inserting information into table
                                                        System.out.println("Could not insert the test into the database, please select the option and try again.");
                                                        continue;
                                                    }
                                                }
                                                else if (response == 5) {
                                                    System.out.println("Going back to appointments.");
                                                    reader.nextLine();
                                                    break;
                                                }
                                                else {
                                                    System.out.println("Wrong option selected, please select from one of the available option.");
                                                }
                                            }
                                        }
                                        else {
                                            System.out.println("Please select a valid option from the list.");
                                            continue;
                                        }
                                    }
                                    else {
                                        System.out.println("No appointments for this date found.");
                                        continue;
                                    }
                                }
                            }
                            catch (SQLException e) {
                                System.out.println("No appointments for this date found.");
                                continue;
                            }
                        }
                    }
                    else {
                        System.out.println("The practioner ID you entered was not found.");
                        continue;
                    }
                }
                else {
                    System.out.println("The practioner ID you entered was not found.");
                    continue;
                }
            }
            catch (SQLException e) {
                System.out.println("The practioner ID you entered was not found.");
                continue;
            }
        }
    }

    // check if user entry equals E
    public static boolean exit(String response) {
        return response.equals("E");
    }

    // check if midwife is primary
    public static boolean isPrimary(int pregID, int practID, HashMap<Integer, Integer> primaries) {
        try {
            if (primaries.get(pregID) == practID){
                return true;
            }
            return false;
        }
        catch (NullPointerException e) {
            return false;
        }
    }

    // check if midwife is backup
    public static boolean isBackup(int pregID, int practID, HashMap<Integer, Integer>backups) {
        try {
            if (backups.get(pregID) == practID){
                return true;
            }
            return false;
        }
        catch (NullPointerException e) {
            return false;
        }
    }
}