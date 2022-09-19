1) Sequence of SQL clauses
SELECT <specify the result you want> 

FROM (name of left table) 

<join type> JOIN (name of right table) 

ON <conditions for the joint>

WHERE <filter clause * cannot be used with aggregate function (sum/average/ min / max), because WHERE will filter the data prior the aggregate

GROUP BY < the field / columns on how to sort results of the query from above>

HAVING <similar to WHERE, a filter clause but CAN be used with aggregate function, because HAVING will filter the data AFTER the aggregate function>

ORDER BY <the condition to sort the results of the query from above, similar to GROUP BY, but can only used after HAVING>
  
AGGREGATE (SUM / MIN / MAX / AVERAGE) usually be used with AS. Example: SELECT NAME, SUM(working_hours) AS <name_of_result> 
  
  
  
2) For MySQL, when you wanna search by texts, DO NOT use "=" , use LIKE and '% <insert text> %' 
SELECT * FROM table WHERE name LIKE '%Thao%'

Or SELECT * FROM table WHERE name IN ('Thomas' , 'Thao' , 'Michael' ) #searching multiple strings
if you wanna use "=" , you must indicate the table ( for example:   <table name>.name = "Thomas" ) 

3) TIMESTAMP On SQL 
SELECT TIMESTAMP ('2022-03-12' , '13:05:12') #convert string to timestamp to be selected
In PostgreSQL, SELECT * FROM table.time WHERE time >= '2022-03-12' #u can be more direct
