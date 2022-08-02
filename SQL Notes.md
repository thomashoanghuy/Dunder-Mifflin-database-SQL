Sequence of SQL clauses
SELECT 
FROM (name of left table) 
<join type> JOIN (name of right table) 
ON <conditions for the joint>
WHERE <filter clause * cannot be used with aggregate function (sum/average/ min / max), because WHERE will filter the data prior the aggregate
GROUP BY < the field / columns on how to sort results of the query from above>
HAVING <similar to WHERE, a filter clause but CAN be used with aggregate function, because HAVING will filter the data AFTER the aggregate function>
ORDER BY <the condition to sort the results of the query from above, similar to GROUP BY, but can only used after HAVING>
