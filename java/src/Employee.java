import java.util.*;

/**
 * Created by po917265 on 8/3/17.
 */
public class Employee {
    private int empNo;
    private String firstName;
    private String lastName;
    private GregorianCalendar birthDate;
    private GregorianCalendar hireDate;
    private int salary;
    private int title;
    private int departmentid;
    private GregorianCalendar lastMoveDate;

    private static String[] titles = new String[] {
            "Tech Lev 1",
            "Tech Lev 2",
            "Programmer Lev 1",
            "Programmer Lev 2",
            "Junior Architecht",
            "Senior Architecht",
            "Strategist"
    };

    private static String[] departments = new String[] {
            "BOAT",
            "HAMMER",
            "JOIST",
            "FROG",
            "OPERA",
            "ABSTRACT",
            "HELP",
            "RANDOM",
            "WORDS",
            "ARE",
            "FUN",
            "DELETE",
            "TABLE",
            "POSTGRESQL"
    };

    private static String[] departmentIDs = new String[departments.length];
    private static Integer[] departmentHeads = new Integer[departments.length];

    public static void main(String[] args) {
        double probabilityOfBirthOrHire = (double)NumEmployees*3/(double)(365*70);
        double probabilityOfTitleChange = (double)NumEmployees*3/(double)(365*70);
        double probabilityOfMove = (double)NumEmployees*3/(double)(365*70);


        LinkedList<Employee> unhired = new LinkedList<Employee>();
        LinkedList<Employee> hired = new LinkedList<Employee>();
        for(int year = (2017-70); year <= 2017; year++) {
            for(int month = 1; month <= 12; month++) {
                Calendar c = new GregorianCalendar(year, month, 1);
                for(int day = 1; day <= 27; day++) {
                    if(Math.random() < probabilityOfBirthOrHire) {
                        if (unhired.size() > 0 && oldEnough(unhired.peekFirst(), year, month, day)) {
                            Employee e = unhired.removeFirst();
                            hired.add(e);
                            if (month == 0) throw new RuntimeException("" + month);
                            e.hire(year, month, day);
                            e.setSalary(10000 + random.nextInt(50000), year, month, day);
                            e.setTitle(0, year, month, day);
                            e.setDepartmentID(random.nextInt(departments.length), year, month, day);

                        } else {
                            unhired.add(new Employee(year, month, day));
                        }
                    }
                    else if(Math.random() < probabilityOfTitleChange && hired.size() > 0) {
                        Employee e = hired.get(random.nextInt(hired.size()));
                        if(Math.random() > .9) {
                            if(e.title != 0) e.setTitle(e.title - 1, year, month, day);
                        } else if(e.title != titles.length - 1){
                            e.setTitle(e.title + 1, year, month, day);
                        }
                    }
                    else if(Math.random() < probabilityOfMove && hired.size() > 0) {
                        Employee e = hired.get(random.nextInt(hired.size()));
                        int did = random.nextInt(departments.length);
                        if(did != e.departmentid) {
                            e.setDepartmentID(did, year, month, day);
                        }
                    }
                }
            }
        }
    }

    private void hire(int year, int month, int day) {
        hireDate = new GregorianCalendar(year, month, day);
        lastMoveDate = hireDate;
        System.out.println("INSERT INTO employees VALUES (" +
                empNo +  ", " +
                string(birthDate) + ", '" +
                firstName + "', '" +
                lastName + "', " +
                string(hireDate) + ");");
    }

    private static String string(GregorianCalendar date) {
        return "'" +
                (date.get(GregorianCalendar.YEAR) + 1) + "-" +
                (date.get(GregorianCalendar.MONTH) + 1) + "-" +
                (date.get(GregorianCalendar.DAY_OF_MONTH) + 1) + "'";
    }

    private static boolean oldEnough(Employee employee, int year, int month, int day) {
        GregorianCalendar gc = (GregorianCalendar)employee.birthDate.clone();
        gc.add(GregorianCalendar.YEAR, 20);
        return gc.before(new GregorianCalendar(year, month, day));
    }

    private static Random random = new Random();
    private static int NumEmployees = 100;
    private static int startEmployeeID = 54321;

    public Employee(int year, int month, int day) {
        empNo = ++startEmployeeID;
        firstName = randomFirstName();
        lastName = randomLastName();
        birthDate = new GregorianCalendar(year, month, day);
    }

    public void setSalary(int amount, int year, int month, int day) {
        GregorianCalendar today = new GregorianCalendar(year, month, day);
        this.salary = amount;
        System.out.println("INSERT INTO salaries VALUES ('" +
                empNo + "', " +
                salary + ", " +
                string(today) + ");"
        );
    }

    public void setTitle(int title, int year, int month, int day) {
        GregorianCalendar today = new GregorianCalendar(year, month, day);
        this.title = title;
        System.out.println("INSERT INTO titles VALUES ( '" +
                empNo + "', '" +
                titles[title] + "', " +
                string(today) + ");"
        );
    }

    private String randomFirstName() {
        String[] names = { "Alice",
            "Bob",
            "Charlotte",
            "Dagwood",
            "Edward",
            "Felicity",
            "Garry",
            "Heather",
            "Ivan",
            "Jada",
            "Kyle",
            "Lindsay",
            "Mary",
            "Nathan",
            "Olivia",
            "Paul",
            "Quentin",
            "Rachel",
            "Samuel",
            "Tanya",
            "Ursula",
            "Vanessa",
            "William",
            "Xander",
            "Yvonne",
            "Zelda",
            "Konstantin",
            "Kitty",
            "Anna"
        };
        return names[random.nextInt(names.length)];
    }

    private String randomLastName() {
        String[] names = new String[] {
                "Anderson",
                "Belleci",
                "Cameron",
                "Diaz",
                "Einstein",
                "Feynman",
                "Gyser",
                "Hyte",
                "Jordan",
                "Karamazov",
                "Linderman",
                "Mason",
                "Oblansky",
                "Pierce",
                "Raskolnikov",
                "Scherbatsky",
                "Tileman",
                "Urx",
                "Vanderhund",
                "Waxman",
                "Yewbeam",
        };
        return names[random.nextInt(names.length)];
    }

    public void setDepartmentID(int departmentid, int year, int month, int day) {
        moveOut(year, month, day);
        this.departmentid = departmentid;
        moveIn(year, month, day);
        GregorianCalendar gc = new GregorianCalendar(year, month, day);
        System.out.println("INSERT INTO works_in VALUES (" +
                empNo + ", '" +
                departmentIDs[departmentid] + "', " +
                string(gc) + ", " +
                "null);"
        );
    }

    private void moveOut(int year, int month, int day) {
        if(departmentHeads[departmentid] != null && departmentHeads[departmentid] == empNo) {
            System.out.println("UPDATE dept_manager SET to_date = " + string(new GregorianCalendar(year, month, day)) +
                    " WHERE emp_no = " + empNo + " AND from_date = " + string(lastMoveDate) + ";"
            );
            departmentHeads[departmentid] = null;
        }
        System.out.println("UPDATE works_in SET to_date = " + string(new GregorianCalendar(year, month, day)) +
                " WHERE emp_no = " + empNo + " AND from_date = " + string(lastMoveDate) + ";"
        );
    }

    private void moveIn(int year, int month, int day) {
        GregorianCalendar gc = new GregorianCalendar(year, month, day);
        lastMoveDate = gc;
        String id = String.format("%04d", departmentid);
        if(departmentIDs[departmentid] == null) {
            System.out.println("INSERT INTO departments VALUES ('" +
                    id + "', '" +
                    departments[departmentid] + "');"
            );
            departmentIDs[departmentid] = id;
        }
        if(departmentHeads[departmentid] == null) {
            System.out.println("INSERT INTO dept_manager VALUES ('" +
                    departmentIDs[departmentid] + "', " +
                    empNo + ", " +
                    string(gc) + ", " +
                    "null);"
            );
            departmentHeads[departmentid] = empNo;
        }
    }
}
