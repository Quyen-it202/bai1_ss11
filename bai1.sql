create database bai1_ss11;
use bai1_ss11;


CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);


CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Completed', 'Cancelled'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');


INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);


INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');


DELIMITER //
CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
		UPDATE Appointments
		SET status = 'Cancelled'
		WHERE appointment_id = p_appointment_id;
END //
DELIMITER ;

CALL CancelAppointment(200);
-- lỗi hệ thống ở đây là khi update với id là 200 thì hệ thống vẫn báo chạy thành công, tuy nhiên trong bảng không có id =200. Câu lệnh UPDATE không thay đổi status đến dòng nào nhưng hệ thống không thông báo lỗi, gây ra lỗi logic vì người dùng không biết thao tác nào thất bại.

SELECT * FROM Appointments;

-- Sửa chữa mã nguồn
drop procedure CancelAppointment;

DELIMITER //
create procedure CancelAppointment(IN p_appointment_id INT)
	begin
		UPDATE Appointments
		SET status = 'Cancelled'
		WHERE appointment_id = p_appointment_id 
		AND status = 'Pending';
    end //

DELIMITER ;

call CancelAppointment(104);
