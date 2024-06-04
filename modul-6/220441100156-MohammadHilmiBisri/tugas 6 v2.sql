CREATE DATABASE OutsourcingCompany;
USE OutsourcingCompany;

CREATE TABLE projects (
project_id INT PRIMARY KEY auto_increment,
project_name VARCHAR(100),
client_company VARCHAR(100),
start_date DATE,
end_date DATE
);

CREATE TABLE employees (
employee_id INT PRIMARY KEY auto_increment,
nama VARCHAR(100),
position VARCHAR(50),
salary FLOAT,
date_hired DATE,
project_id INT, 
FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE certificates (
certificate_id INT PRIMARY KEY auto_increment,
employee_id INT,
certificate_name VARCHAR(100),
issue_date DATE,
expiry_date DATE,
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE trainings (
training_id INT PRIMARY KEY auto_increment,
certificate_name VARCHAR(100),
duration_in_months INT
);

CREATE TABLE notifications (
notification_id INT PRIMARY KEY AUTO_INCREMENT ,
employee_id INT, 
message TEXT,
dates DATE,
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE companies (
company_id INT PRIMARY KEY auto_increment,
company_name VARCHAR(100),
address TEXT
);

INSERT INTO projects (project_name, client_company, start_date, end_date) VALUES ('Project 1', 'Company A', '2022-01-01', '2022-06-30'), ('Project 2', 'Company B', '2022-02-01', '2022-07-31'), ('Project 3', 'Company C', '2022-03-01', '2022-08-31'), ('Project 4', 'Company D', '2022-04-01', '2022-09-30'), ('Project 5', 'Company E', '2022-05-01', '2022-10-31'), ('Project 6', 'Company F', '2022-06-01', '2022-11-30'), ('Project 7', 'Company G', '2022-07-01', '2022-12-31'), ('Project 8', 'Company H', '2022-08-01', '2023-01-31'), ('Project 9', 'Company I', '2022-09-01', '2023-02-28'), ('Project 10', 'Company J', '2022-10-01', '2023-03-31');

INSERT INTO employees (nama, position, salary, date_hired, project_id) VALUES ('Employee 1', 'Position A', 5000, '2022-01-01', 1), ('Employee 2', 'Position B', 6000, '2022-02-01', 2), ('Employee 3', 'Position C', 7000, '2022-03-01', 3), ('Employee 4', 'Position D', 8000, '2022-04-01', 4), ('Employee 5', 'Position E', 9000, '2022-05-01', 5), ('Employee 6', 'Position F', 10000, '2022-06-01', 6), ('Employee 7', 'Position G', 11000, '2022-07-01', 7), ('Employee 8', 'Position H', 12000, '2022-08-01', 8), ('Employee 9', 'Position I', 13000, '2022-09-01', 9), ('Employee 10', 'Position J', 14000, '2022-10-01', 10);

INSERT INTO certificates (employee_id, certificate_name, issue_date, expiry_date) VALUES (1, 'Certificate 1', '2022-01-01', '2023-01-01'), (2, 'Certificate 2', '2022-02-01', '2023-02-01'), (3, 'Certificate 3', '2022-03-01', '2023-03-01'), (4, 'Certificate 4', '2022-04-01', '2023-04-01'), (5, 'Certificate 5', '2022-05-01', '2023-05-01'), (6, 'Certificate 6', '2022-06-01', '2023-06-01'), (7, 'Certificate 7', '2022-07-01', '2023-07-01'), (8, 'Certificate 8', '2022-08-01', '2023-08-01'), (9, 'Certificate 9', '2022-09-01', '2023-09-01'), (10, 'Certificate 10', '2022-10-01', '2023-10-01');

INSERT INTO trainings (certificate_name, duration_in_months) VALUES ('Training 1', 6), ('Training 2', 6), ('Training 3', 6), ('Training 4', 6), ('Training 5', 6), ('Training 6', 6), ('Training 7', 6), ('Training 8', 6), ('Training 9', 6), ('Training 10', 6);

INSERT INTO companies (company_name, address) VALUES ('Company A', 'Address A'), ('Company B', 'Address B'), ('Company C', 'Address C'), ('Company D', 'Address D'), ('Company E', 'Address E'), ('Company F', 'Address F'), ('Company G', 'Address G'), ('Company H', 'Address H'), ('Company I', 'Address I'), ('Company J', 'Address J'); 

INSERT INTO notifications (employee_id, message, dates) VALUES (1, 'Notification 1', '2022-01-01'), (2, 'Notification 2', '2022-02-01'), (3, 'Notification 3', '2022-03-01'), (4, 'Notification 4', '2022-04-01'), (5, 'Notification 5', '2022-05-01'), (6, 'Notification 6', '2022-06-01'), (7, 'Notification 7', '2022-07-01'), (8, 'Notification 8', '2022-08-01'), (9, 'Notification 9', '2022-09-01'), (10, 'Notification 10', '2022-10-01');


-- soal 1
DELIMITER //
CREATE PROCEDURE tambah_bonus()
BEGIN
    DECLARE bonus_gaji DECIMAL(10,2);
    DECLARE total_salary DECIMAL(10,2);
    
    SELECT nama, salary, 
        CASE 
            WHEN date_hired <= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) 
            THEN salary * 0.1
            ELSE 0 
        END AS bonus_gaji,
        CASE 
            WHEN date_hired <= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) 
            THEN salary + salary * 0.1
            ELSE salary 
        END AS total_salary
    FROM employees;
END //
DELIMITER ;

CALL tambah_bonus();


-- soal 2
DELIMITER //
CREATE PROCEDURE perpanjang_project()
BEGIN
DECLARE perpanjang_tanggal DATE;
SELECT project_id, project_name, end_date,
	CASE 
            WHEN end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 1 MONTH) 
            THEN DATE_ADD(end_date, INTERVAL 3 MONTH)
            ELSE end_date
        END AS perpanjang_tanggal
FROM projects;
END //
DELIMITER ;

CALL perpanjang_project();


-- soal 3
DELIMITER //
CREATE PROCEDURE updatesertif(
IN id_employee INT)
BEGIN
    DECLARE banyak_sertif INT;
    DECLARE tgl_sekarang DATE;
    DECLARE id_sertif_baru INT;
    DECLARE id_training_baru INT;
    
    SELECT COUNT(*) INTO banyak_sertif FROM certificates WHERE employee_id = id_employee;
    SET tgl_sekarang = CURDATE();

    IF banyak_sertif > 0 THEN
        UPDATE certificates 
        SET expiry_date = ADDDATE(expiry_date, INTERVAL 1 YEAR)
        WHERE employee_id = id_employee AND expiry_date < tgl_sekarang;

        IF ROW_COUNT() > 0 THEN
		SELECT CONCAT('Sertif karyawan ', id_employee, ' sudah diupdate.') AS message;
			INSERT INTO trainings (training_id, certificate_name, duration_in_months) VALUES
			(id_training_baru, 'Sertifikat Pelatihan HTML CSS', '5');
            INSERT INTO certificates (certificate_id, employee_id, certificate_name, issue_date, expiry_date) VALUES
			(id_sertif_baru, id_employee, 'Sertifikat Pelatihan HTML CSS', '2024-05-05', '2024-05-20');
        ELSE
		SELECT CONCAT('Sertifikat karyawan ', id_employee, ' tidak ada yang perlu diperbarui.') AS message;
        END IF;
    ELSE
        SELECT CONCAT('karyawan ', id_employee, ' tidak mempunya sertifikat.') AS message;
    END IF;

    SELECT IFNULL(MAX(certificate_id), 0) + 1 INTO id_sertif_baru FROM certificates;

    SELECT * FROM trainings;
    SELECT * FROM certificates;
END //
DELIMITER ;

call updatesertif(1);
select * from trainings;

-- soal 4
DELIMITER //
CREATE PROCEDURE kirim_notifikasi_pelatihan()
BEGIN
    DECLARE cur_date DATE;
    DECLARE emp_id INT DEFAULT 0;
    DECLARE last_emp_id INT;

    SET cur_date = CURDATE();
    SELECT MAX(employee_id) INTO last_emp_id FROM employees;

    REPEAT
        SET emp_id = emp_id + 1;

        IF EXISTS (SELECT * FROM employees WHERE employee_id = emp_id) THEN
            INSERT INTO notifications (employee_id, message, dates)
            SELECT emp_id, 'Pelatihan UI UX coming soon', cur_date;

        END IF;
    UNTIL emp_id >= last_emp_id END REPEAT;
    SELECT * FROM notifications;
END //
DELIMITER ;

CALL kirim_notifikasi_pelatihan();
select * from certificates;