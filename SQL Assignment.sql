-- Q1
SELECT FName, LName, Pname
FROM Employee, Project, Works_On
WHERE LName in ("Wong", "Borg", "English") and ESSN = SSN and Pnumber = Pno;

-- Q2
SELECT DISTINCT Fname, Lname
FROM Employee, Dependent
WHERE Relationship in ("daughter", "son") and ESSN = SSN;

-- Q3
SELECT Dlocation, Pname, COUNT(DISTINCT SSN) as NumOfEmployees
FROM Employee, DeptLocations, Project, Works_On
WHERE Dnumber = Dnum and Pnumber = Pno and ESSN = SSN
GROUP BY Pname, Dlocation;

-- Q4
SELECT *
FROM
    (SELECT Pname, Pno
     FROM Employee JOIN Project JOIN Works_On
     WHERE Lname =  "Narayan" and SSN = ESSN and Pno=Pnumber) as Narayan
WHERE Narayan.Pno in
    (SELECT Pno
     FROM Employee JOIN Project JOIN Works_On
     WHERE Lname = "Jabbar" and SSN = ESSN and Pno=Pnumber);

-- Q5
SELECT Fname, Lname, (2020 - year(Dependent.Bdate)) as age
FROM Employee, Dependent
WHERE year(Dependent.Bdate) >= 1970 and SSN = ESSN;

-- Q6
CREATE TEMPORARY TABLE numOfProject as
Select ESSN
From Works_On, Project
Where PNO = PNUMBER and Plocation = 'Sugarland'
Group By ESSN
Having count(*) =
  (Select count(PNUMBER)
   From Project
   Where Plocation = 'Sugarland');

Select FNAME,LNAME,PNAME,HOURS
From numOfProject NATURAL JOIN Employee NATURAL join Project NATURAL JOIN Works_On
Where numOfProject.ESSN = SSN and PNO = PNUMBER and Plocation = 'Sugarland';

-- Q7
CREATE TEMPORARY TABLE DuplicateE AS
SELECT *
FROM Employee;

SELECT Employee.Fname AS EmployeeFName, Employee.Lname AS EmployeeLName,
if (Employee.SuperSSN is null, null, DuplicateE.FName) AS ManagerFName,
if (Employee.SuperSSN is null, null, DuplicateE.LName) AS ManagerLName
FROM Employee, DuplicateE
WHERE Employee.SuperSSN = DuplicateE.SSN OR Employee.SuperSSN IS null
GROUP BY Employee.Lname;

-- Q8
SELECT Pname, Fname, Lname, Plocation
FROM Project, Department, Employee
WHERE Dnum = Dnumber and MGRSSN = SSN;

-- Q9
SELECT Fname, Lname, SSN
FROM Employee
WHERE Salary = (SELECT MAX(Salary) FROM Employee);

-- Q10
CREATE TEMPORARY TABLE Managers AS
SELECT Fname, Lname, Salary
FROM Employee, Department
WHERE MGRSSN = SSN;

SELECT Fname, Lname
FROM Managers
WHERE Salary = (SELECT MAX(Salary) FROM Managers); 
