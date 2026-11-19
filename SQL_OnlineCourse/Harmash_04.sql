--JOIN ( INNER OUTER LEFT RIGHT SELF)
USE harmash;
GO

CREATE TABLE countries (
    id     INT IDENTITY NOT NULL PRIMARY KEY,
    name   VARCHAR(100),
    UNIQUE (name)
);


INSERT INTO countries VALUES ( 'KSA');
INSERT INTO countries VALUES ( 'Oman');
INSERT INTO countries VALUES ( 'Egypt');
INSERT INTO countries VALUES ( 'Kuwait');
INSERT INTO countries VALUES ( 'Bahrain');
GO

CREATE TABLE Visitors (
    id         INT IDENTITY(10,10) NOT NULL PRIMARY KEY ,
    username   VARCHAR(30),
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    country_id INT,
    UNIQUE (username),
    CONSTRAINT fk_country_id 
    FOREIGN KEY (country_id)
    REFERENCES countries (id)
);

INSERT INTO Visitors VALUES ( 'rami', 'Rami', 'Masri', 1);
INSERT INTO Visitors VALUES ( 'ahmad', 'Ahmad', 'Naji', 2);
INSERT INTO Visitors VALUES ( 'hanan', 'Hanan', 'Mostafa', 5);
INSERT INTO Visitors VALUES ( 'saly', 'Saly', 'Harmush', null);
INSERT INTO Visitors VALUES ( 'samir', 'Samir', 'Saleh', 3);
INSERT INTO Visitors VALUES ( 'hamad', 'Hamad', 'Akel', 2);
INSERT INTO Visitors VALUES ( 'abdullah', 'Abdullah', 'Helmi', 1);
INSERT INTO Visitors VALUES ( 'rashed', 'Rashed', 'Masri', 5);
INSERT INTO Visitors VALUES ( 'majed', 'Majed', 'Alali', null);
INSERT INTO Visitors VALUES ( 'rayan', 'Rayan', 'Kasabi', null);

--JOIN (INNER JOIN )
SELECT Visitors.id, Visitors.username, countries.name AS 'country'  
FROM Visitors 
    JOIN countries ON Visitors.country_id = countries.id;   

--LEFT JOIN 
SELECT Visitors.id, Visitors.username, countries.name AS 'country'
FROM Visitors 
    LEFT JOIN countries ON Visitors.country_id = countries.id;
--mit einer Bedingung
SELECT Visitors.id, Visitors.username, countries.name AS 'country'
FROM Visitors 
    LEFT JOIN countries ON Visitors.country_id = countries.id
WHERE countries.name IN ('KSA','Oman');

--RIGHT JOIN 
SELECT v.id, v.username, c.name AS 'country' --v is Abkürzung von Visitors. In der folgenden Zeile definiert.
FROM Visitors AS v --muss man AS nicht schreiben
    RIGHT JOIN countries AS c ON v.country_id = c.id;

--FULL JOIN
SELECT v.id, v.username, c.name AS 'country'
FROM Visitors v
    FULL JOIN countries AS c ON v.country_id = c.id;

--Oder mit UNION / ALL UNION
SELECT v.id, v.username, c.name AS 'country'
FROM Visitors v
    LEFT JOIN countries AS c ON v.country_id = c.id
UNION
SELECT v.id, v.username, c.name AS 'country'
FROM Visitors v
    RIGHT JOIN countries AS c ON v.country_id = c.id;

--SELF JOIN (Wichtig)
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id         INT IDENTITY NOT NULL PRIMARY KEY ,
    name       VARCHAR(50),
    manager_id INT
);
GO

INSERT INTO employees VALUES ( 'Rami', null);
INSERT INTO employees VALUES ( 'Ahmad', 1);
INSERT INTO employees VALUES ( 'Hanan', 1);
INSERT INTO employees VALUES ( 'Saly', 1);
INSERT INTO employees VALUES ( 'Samir', 1);
GO

SELECT e1.id 'Employee Id', e1.name Employee, e2.name Manager 
FROM employees e1 
    JOIN employees e2  ON e1.manager_id = e2.id;
--LEFT JOIN MIT SELF
SELECT e1.id 'Employee Id', e1.name Employee, e2.name Manager 
FROM employees e1 
    LEFT JOIN employees e2  ON e1.manager_id = e2.id;

-- Mit "ISNULL"
SELECT e1.id 'Employee Id', e1.name Employee, ISNULL(e2.name,'No Manager') AS Manager 
FROM employees e1 
    LEFT JOIN employees e2  ON e1.manager_id = e2.id;
