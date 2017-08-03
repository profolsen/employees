--  Sample employee database for PostgreSQL
--  See changelog table for details
--  Created from MySQL Employee Sample Database (http://dev.mysql.com/doc/employee/en/index.html)
--  Created by Vraj Mohan
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

-- drop the tables first.
-- notice that the drop order is the reverse of the creation order.
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS works_in;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  TIMESTAMP       NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    hire_date   TIMESTAMP       NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE   	(dept_name)
);

CREATE TABLE dept_manager (
   dept_no      CHAR(4)         NOT NULL,
   emp_no       INT             NOT NULL,
   from_date    TIMESTAMP       NOT NULL,
   to_date      TIMESTAMP       ,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE works_in (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   TIMESTAMP       NOT NULL,
    to_date     TIMESTAMP       ,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   TIMESTAMP       NOT NULL,
    to_date     TIMESTAMP,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
); 


CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   TIMESTAMP       NOT NULL,
    to_date     TIMESTAMP       ,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
);

DROP TABLE IF EXISTS firstnames;
CREATE TABLE firstnames (
    firstname VARCHAR(14),
    id INT
);

DROP TABLE IF EXISTS lastnames;
CREATE TABLE lastnames (
    lastname VARCHAR(16),
    id INT
);
INSERT INTO firstnames VALUES
    ('Alice', 0),
    ('Bob', 1),
    ('Charlotte', 3),
    ('Dagwood', 4),
    ('Edward', 5),
    ('Felicity', 6),
    ('Garry', 7),
    ('Heather', 8),
    ('Ivan', 9),
    ('Jada', 10),
    ('Paul', 2),
    ('Quentin', 11),
    ('Rachel', 12);

INSERT INTO lastnames VALUES
    ('Karenin', 0),
    ('Levin', 1),
    ('Mirsky', 2),
    ('Karamozov', 4),
    ('Scherbatsky', 5),
    ('Tolstoy', 3),
    ('DeLillo', 6);

INSERT INTO employees
    SELECT generate_series as emp_no,
           ((1980 + generate_series % 37) || '-' || ((generate_series % 12) + 1) || '-' || ((generate_series % 29) + 1))::TIMESTAMP - ((generate_series % 50) || 'years')::INTERVAL as birthdate,
           (SELECT firstname from firstnames WHERE id = generate_series % (SELECT MAX(id) + 1 FROM firstnames)) as firstname,
           (SELECT lastname from lastnames WHERE id = generate_series % (SELECT MAX(id) + 1 FROM lastnames)) as lastname,
           ((1980 + generate_series % 37) || '-' || ((generate_series % 12) + 1) || '-' || ((generate_series % 29) + 1))::TIMESTAMP as hire_date
    FROM generate_series(1, 101);

DROP TABLE firstnames, lastnames;

INSERT INTO departments(dept_no, dept_name) VALUES
    ('0001', 'Marketing'),
    ('0002', 'Sales'),
    ('0003', 'Legal'),
    ('0004', 'Java Development'),
    ('0005', 'Database Administration'),
    ('0006', 'Strategic Momentum');

INSERT INTO dept_manager
    SELECT '0001',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        hire_date + (18 || ' years')::INTERVAL + ('3 years')::INTERVAL
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) <= (SELECT MIN(date_part('year', hire_date)) FROM employees) ORDER BY emp_no LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager
    SELECT '0002',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        null
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) <= (SELECT MIN(date_part('year', hire_date)) FROM employees) ORDER BY ((emp_no + 37) % 100) LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager
    SELECT '0003',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        hire_date + (18 || ' years')::INTERVAL + ('3 years')::INTERVAL
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) = (SELECT MIN(date_part('year', hire_date)) + 1 FROM employees) ORDER BY ((emp_no + 73) % 100) LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager
    SELECT '0004',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        hire_date + (18 || ' years')::INTERVAL + ('3 years')::INTERVAL
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) = (SELECT MIN(date_part('year', hire_date)) + 1 FROM employees) ORDER BY (emp_no) LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager
    SELECT '0005',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        null
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) = (SELECT MIN(date_part('year', hire_date)) + 2 FROM employees) ORDER BY (emp_no) LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager
    SELECT '0006',
        emp_no,
        hire_date + ('3 years')::INTERVAL,
        hire_date + (18 || ' years')::INTERVAL + ('3 years')::INTERVAL
    FROM (SELECT * FROM employees WHERE date_part('year', hire_date) = (SELECT MIN(date_part('year', hire_date)) + 3 FROM employees) ORDER BY (emp_no) LIMIT 1) AS oldest_employees;

INSERT INTO dept_manager(dept_no, emp_no, from_date, to_date) VALUES
    ('0001', 1, '2005-10-5', null);

INSERT INTO dept_manager(dept_no, emp_no, from_date, to_date) VALUES
    ('0004', 19, '2003-2-28', '2015-12-31');