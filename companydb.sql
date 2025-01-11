create table employee(
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    birth_date DATE,
    sex ENUM('Male', 'Female', 'Other') NOT NULL,
    salary INT NOT NULL,
    super_id INT DEFAULT(NULL),
    branch_id INT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)

)AUTO_INCREMENT= 100 ;

ALTER TABLE employee
MODIFY COLUMN super_id INT DEFAULT NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id); 

select *from employee;

create table audit_employee(
    status varchar(255)
);

create trigger trigger_employee
after insert on employee
for each row
begin
    insert into audit_employee(status)
    VALUES('new employee added');
    select *from trigger_employee;
end;

drop trigger trigger_employee;

select *from audit_employee;

create table branch(
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(40) NOT NULL,
    mgr_id INT NOT NULL,
    mgr_start_date DATE
);

create table client(
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(40) NOT NULL,
    branch_id INT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
)AUTO_INCREMENT=400;

create table works_with (
    emp_id INT,
    client_id INT,
    PRIMARY KEY (emp_id, client_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    total_sales INT NOT NULL
);

create table branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (branch_id, supplier_name),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    supply_type VARCHAR (40)
);

INSERT INTO branch(branch_id, branch_name, mgr_id, mgr_start_date)
VALUES
('1', 'Corporate', '100', '2006-02-09'),
('2', 'Scranton', '102', '1992-04-06'),
('3', 'Stamford', '106', '1998-02-13');

select *from branch;

INSERT INTO employee(first_name, last_name, birth_date, sex, salary, branch_id)
VALUES
('David', 'Wallace', '1967-11-17', 'Male', '250000', '1');

INSERT INTO employee(first_name, last_name, birth_date, sex, salary, super_id, branch_id)
VALUES
('Jan', 'Levinson', '1961-05-11', 'Female', '110000', '100', '1'),
('Michael', 'Scott', '1964-03-15', 'Male', '75000', '100', '2'),
('Angela', 'Martin', '1971-03-25', 'Female', '63000', '102','2'),
('Kelly', 'Kapoor', '1980-02-05', 'Female', '55000', '102', '2'),
('Stanley', 'Hudson', '1958-02-19', 'Male', '69000', '102', '2'),
('Josh', 'Porter', '1969-09-05', 'Male', '78000', '100', '3'),
('Andy', 'Bernard', '1973-07-22', 'Male', '65000', '106', '3'),
('Jim', 'Halpert', '1978-10-01', 'Male', '71000', '106', '3');
INSERT INTO employee(first_name, last_name, birth_date, sex, salary, super_id, branch_id)
VALUES ('John', 'doe', '1978-11-01', 'Male', '71500', '106', '2');

INSERT INTO client(client_name, branch_id)
VALUES 
('Dunmore Highschool', '2'),
('Lackawana Country', '2'),
('FedEx', '3'),
('John Daly Law, LLC', '3'),
('Scranton Whitepages', '2'),
('Times Newspaper', '3'),
('FedEx', '2');

select *from client;

INSERT INTO works_with(emp_id, client_id, total_sales)
VALUES 
('105', '400', '55000'),
('102', '401', '267000'),
('108', '402', '22500'),
('107', '403', '5000'),
('108', '403', '12000'),
('105', '404', '33000'),
('107', '405', '26000'),
('102', '406', '15000'),
('105', '406', '130000'); 

select *from works_with;

INSERT INTO branch_supplier(branch_id, supplier_name, supply_type)
VALUES 
('2', 'Hammer Mill', 'Paper'),
('2', 'Uni-ball', 'Writing Utensils'),
('3', 'Partiot Paper', 'Paper'),
('2', 'J.T. Forms & Labels', 'Custom Forms'),
('3', 'Uni-ball', 'Writing Utensils'),
('3', 'Hammer Mill', 'Paper'),
('3', 'Stamford Lables', 'Custom Forms');

select *from branch_supplier;

select CONCAT(first_name, ' ', last_name) as employees, salary from employee
order by salary desc;

select *from employee
order by sex, first_name, last_name;

select *from employee
limit 5;

select distinct sex from employee;

select COUNT(emp_id) from employee;
select SUM(salary) from employee where sex = 'Male';

select COUNT(sex), sex from employee group by sex;


select COUNT(emp_id), sex from employee where (birth_date >= '1971-01-01' and sex='Female');

select emp_id, SUM(total_sales) from works_with
group by emp_id;

select *from branch_supplier
where supply_type like '%Forms';

select *from employee
where birth_date like '____-10%';

select *from client
where client_name like '%school'
or client_name like '%Country';

 select client_name from client
 union
 select total_sales as total_purchases from works_with;

select salary from employee
union
select total_sales from works_with;

select emp_id, first_name, branch_name from employee
join branch
on employee.emp_id = branch.mgr_id;
 
select employee.first_name, employee.last_name
from employee 
where emp_id in (
select works_with.emp_id 
from works_with 
where works_with.total_sales > 30000);

select client.client_name
from client
where client.branch_id = (
select employee.branch_id 
from employee
where employee.first_name = 'Michael');


create table test_branch(
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(40) NOT NULL,
    mgr_id INT NOT NULL,
    mgr_start_date DATE
);

INSERT INTO test_branch(branch_id, branch_name, mgr_id, mgr_start_date)
VALUES
('1', 'Corporate', '100', '2006-02-09'),
('2', 'Scranton', '102', '1992-04-06'),
('3', 'Stamford', '106', '1998-02-13');

create table test_employee(
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    birth_date DATE,
    sex ENUM('Male', 'Female', 'Other') NOT NULL,
    salary INT NOT NULL,
    super_id INT DEFAULT(NULL),
    branch_id INT DEFAULT(NULL),
    FOREIGN KEY (branch_id) REFERENCES test_branch(branch_id) ON DELETE SET NULL

)AUTO_INCREMENT= 100 ;

ALTER TABLE test_employee
MODIFY COLUMN super_id INT DEFAULT NULL;

ALTER TABLE test_employee
ADD FOREIGN KEY(super_id)
REFERENCES test_employee(emp_id) ON DELETE SET NULL; 

INSERT INTO test_employee(first_name, last_name, birth_date, sex, salary, super_id, branch_id)
VALUES
('Jan', 'Levinson', '1961-05-11', 'Female', '110000', '100', '1'),
('Michael', 'Scott', '1964-03-15', 'Male', '75000', '100', '2'),
('Angela', 'Martin', '1971-03-25', 'Female', '63000', '102','2'),
('Kelly', 'Kapoor', '1980-02-05', 'Female', '55000', '102', '2'),
('Stanley', 'Hudson', '1958-02-19', 'Male', '69000', '102', '2'),
('Josh', 'Porter', '1969-09-05', 'Male', '78000', '100', '3'),
('Andy', 'Bernard', '1973-07-22', 'Male', '65000', '106', '3'),
('Jim', 'Halpert', '1978-10-01', 'Male', '71000', '106', '3');

drop table test_employee;

DELETE FROM test_employee WHERE branch_id= 1;
DELETE FROM test_branch WHERE branch_id= 3;
alter table test_branch
drop column mgr_start_date;

select *from test_employee;
select *from test_branch; 

TRUNCATE table test_employee;