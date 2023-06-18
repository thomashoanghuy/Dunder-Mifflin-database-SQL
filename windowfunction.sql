create schema window_function;

use window_function;


#Create a mock tables to practice Window Functions

DROP TABLE IF EXISTS student_score;

CREATE TABLE student_score (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(30),
  dep_name VARCHAR(40),
  score INT
);

INSERT INTO student_score VALUES (11, 'Ibrahim', 'Computer Science', 80);
INSERT INTO student_score VALUES (7, 'Taiwo', 'Microbiology', 76);
INSERT INTO student_score VALUES (9, 'Nurain', 'Biochemistry', 80);
INSERT INTO student_score VALUES (8, 'Joel', 'Computer Science', 90);
INSERT INTO student_score VALUES (10, 'Mustapha', 'Industrial Chemistry', 78);
INSERT INTO student_score VALUES (5, 'Muritadoh', 'Biochemistry', 85);
INSERT INTO student_score VALUES (2, 'Yusuf', 'Biochemistry', 70);
INSERT INTO student_score VALUES (3, 'Habeebah', 'Microbiology', 80);
INSERT INTO student_score VALUES (1, 'Tomiwa', 'Microbiology', 65);
INSERT INTO student_score VALUES (4, 'Gbadebo', 'Computer Science', 80);
INSERT INTO student_score VALUES (12, 'Tolu', 'Computer Science', 67);

select * from student_score;

#The syntax of WINDOW function is usually 
#function(expression|column) OVER(
#	[ PARTITION BY expr_list optional]
#    [ ORDER BY order_list optional])

#Easiest way to understand this is by using Window function with Aggregate prompt to replace the GROUP BY 
#for example, you want to find out the average scores for each of the dept_name 

select dep_name , avg(score) as Average_score
from student_score
group by dep_name;

#this query above reduce the table down to 4 departments with their average scores, but we cannot see the individual students score to compare with the dept's average
#if we SELECT student_id, student_name , then we need to include STUDENT_ID and STUDENT_NAME under GROUP BY statement too.alter

#Now if we use Window function with the OVER( PARTITION BY) 

SELECT 
	*,
	AVG(score)OVER(PARTITION BY dep_name) AS dep_average_score
FROM student_score;

#instead of reducing the entire table to 4 dept ( to calculate the average scores for each dept) , now with WINDOW function
#we introduce a new column, with the dept_average_score for EACH of the students ( depending on what is their department) 

#not just average, we can introduce other aggregate functions as such sum or max / min

SELECT 
	*,
	sum(score) OVER(PARTITION BY dep_name) AS dep_total_score
FROM student_score;

SELECT 
	*,
	max(score) OVER(PARTITION BY dep_name) AS dep_highest_score
FROM student_score;

#Other window function is also rank() and row_number()

SELECT ROW_number() OVER (ORDER BY score) AS RowNumber, student_name, score
FROM student_score;
#row_number create a new column to assign an unique id for each of the rows in the table, just in case if that table does not have any unique ID yet

SELECT rank() OVER ( partition by dep_name ORDER BY score desc ) AS Dept_rank, student_id, student_name, score , dep_name
FROM student_score;

#above query, we can see that this will rank each students ONLY WITHIN their department, rank() OVER (partition by dep_name ORDER BY score)
#it does not require complicated subquery.

#note another function is DENSE_RANK()
#notice how in COMPUTER SCIENCE dept, it goes 1-2-2-4 ? It's because Tolu is the 4th person in the dept, despite Ghadebo and Ibrahim share the same score and same rank

SELECT dense_rank() OVER ( partition by dep_name ORDER BY score desc ) AS Dept_rank, student_id, student_name, score , dep_name
FROM student_score;
#dense_rank will give more accurate ranking in case 2 students having the same scores.


#Another useful window function is LAG or LEAD, which indicates the rows before or after the selected row
SELECT
	*,
	LAG(score) OVER() as previous_student
FROM student_score;

#as you can see, the new column, stated the student before Yusuf, get score = 65, then before Habeebah, Yusuf scored 70 and so on
#you can even combine this with PARTITION BY 

SELECT
	*,
	LAG(score) OVER(PARTITION BY dep_name ORDER BY score) as prev_student_score
FROM student_score;

#partition by split table into department wise, sort it with ORDER BY, and apply LAG() function



#One more useful window function is manipulate by FRAME clause ROWS
#for example, what if we want to calculate a running cumulative score of all students, (next row = current row student score + previous row student score)

#we can use "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW" ( UNBOUNDED PRECEDING means we start using the rows from beginning row )

SELECT
	*,
	SUM(score)OVER(ORDER BY student_id ROWS BETWEEN UNBOUNDED PRECEDING PRECEDING AND CURRENT ROW) AS cummulative_sum
FROM student_score;

#2nd row = 135 = 65 + 70. 
#3rd row = 215 = 65 +70 +80 

#We also can manipulate this by ROWS BETWEEN <insert how many row before this current row> AND CURRENT ROW
# 1/2/3/UNBOUNDED PRECEDING
SELECT
	*,
    AVG(score) OVER (ORDER BY student_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS average_previous_score
FROM student_score;

#As you can see, we will just take ONE preceding row and current row to calculate the average of 2 rows.
# There are few combinations of this FRAME clauses: # 1/2/3/ UNBOUNDED FOLLOWING

SELECT
	*,
    AVG(score) OVER (ORDER BY student_id ROWS BETWEEN current row  AND 1 FOLLOWING) AS average_previous_score
FROM student_score;
