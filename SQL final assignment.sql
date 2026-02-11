create database if not exists E_Learning;
use E_Learning;

CREATE TABLE IF Not exists learners (
    learner_id  INT PRIMARY KEY,
     full_name VARCHAR(50),
     Country VARCHAR(50)
);

CREATE TABLE IF Not exists courses (
     course_id INT PRIMARY KEY,
     course_name VARCHAR(50),
     category VARCHAR(50),
     unit_price decimal(10,2)
);

CREATE TABLE IF Not exists purchases(
     purchase_id INT PRIMARY KEY,
     learner_id INT,
     course_id INT,
     Quantity INT,
     purchase_date DATE,
     FOREIGN KEY (learner_id) REFERENCES learners(learner_id)
	 on delete cascade
	 on update cascade,
	 FOREIGN KEY (course_id) REFERENCES courses(course_id)
     on delete cascade
	 on update cascade
);

USE E_Learning;

INSERT INTO  learners (learner_id,full_name,Country) VALUES
(1,"manikandan","india"),
(2,"hariharan","china"),
(3,"pasupathy","korea"),
(4,"shadhu","japan"),
(5,"rethu","australia"),
(6,"manju","malasiya"),
(7,"kovil","singapore");

INSERT INTO  courses (course_id,course_name,category,unit_price) VALUES
(1001,"data analyst","IT",40000),
(1002,"digital marketing","NON IT",30000),
(1003,"layer analyst","NON IT",35000),
(1004,"account analyst","NON IT",30000),
(1005,"UI UX design","IT",50000),
(1006,"teaching analyst","NON IT",30000),
(1007,"bussiness analyst","IT",45000);

INSERT INTO purchases (purchase_id,learner_id,course_id,Quantity,purchase_date) VALUES
(101,1,1001,2,"2026-01-10"),
(102,2,1002,1,"2026-01-11"),
(103,3,1003,2,"2026-01-12"),
(104,4,1004,1,"2026-01-13"),
(105,5,1005,3,"2026-01-14"),
(106,6,1006,1,"2026-01-15"),
(107,7,1007,2,"2026-01-16");

/*Format currency values to 2 decimal places.*/

select round(unit_price,2) from courses;

/*Use aliases for column names (e.g., AS total_revenue).*/

select sum(unit_price) as total_revenue from courses;

/*Sort results appropriately (e.g., highest total_spent first).*/

select unit_price as highest_total_spend_first from courses order by unit_price desc limit 1;

/*Combine learner, course, and purchase data.*/

select * from purchases p
 join learners l on p.learner_id=l.learner_id 
join courses c on p.course_id=c.course_id;

/*Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).*/

select full_name,course_name,category,Quantity,unit_price,purchase_date from purchases p
left join courses c on p.course_id=c.course_id
left join learners l on p.learner_id=l.learner_id;

/*Display each learner’s total spending (quantity × unit_price) along with their country*/

select l.learner_id,l.full_name,l.country,SUM(p.quantity * c.unit_price) as total_spending
from learners l
join purchases p on l.learner_id = p.learner_id
join courses c on p.course_id = c.course_id
group by l.learner_id,l.full_name,l.country;

/*Find the top 3 most purchased courses based on total quantity sold.*/

select c.course_id,c.course_name,SUM(p.quantity) as total_quantity_sold
from courses c
join purchases p on c.course_id = p.course_id
group by c.course_id,c.course_name
order by total_quantity_sold desc limit 3;

/*Show each course category’s total revenue and the number of unique learners who purchased from that category.*/

select c.category,SUM(p.quantity * c.unit_price) as total_revenue,COUNT(DISTINCT p.learner_id) as unique_learners
from courses c
join purchases p on c.course_id = p.course_id
group by c.category;

/*. List all learners who have purchased courses from more than one category.*/

select l.learner_id,l.full_name,COUNT(DISTINCT c.category) as category_count
from learners l
join purchases p on l.learner_id = p.learner_id
join courses c on p.course_id = c.course_id
group by l.learner_id,l.full_name
having category_count> 1;

/*Identify courses that have not been purchased at all.*/

select c.course_id,c.course_name,c.category
from courses c
left join purchases p on c.course_id = p.course_id
where p.course_id is null;



