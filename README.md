# faasos_analysis_project

SQL FUNCTIONS:
COUNT: Explanation of how you used the COUNT function in your project.

GROUP BY: Discuss how you utilized the GROUP BY clause for aggregating data.

ROW_NUMBER(): Explain the purpose and application of the ROW_NUMBER() function in your project.

COALESCE(): Detail how you handled null values, blanks, and NaN using the COALESCE function.

JOIN: Describe the scenarios where you employed the JOIN operation to combine data from multiple tables.

CASE Statement: Provide examples of how you utilized the CASE statement in your queries.

Subqueries: Discuss the instances where you implemented subqueries to retrieve data.

Challenges and Solutions:
Issue: Dealing with Blank Rows in the Dataset
When I first got the dataset, there was a tricky problem – some rows in certain columns were completely empty. This caused confusion when I tried to filter the data using the WHERE clause with methods like IN or =. Those empty rows messed up my results, making things not quite right.

Solution: Fixing Null Values with COALESCE
To solve this, I used a handy function called COALESCE in my queries. COALESCE is like a backup plan for null values. It lets you replace null values with a specific default value. In my case, I used COALESCE to replace the blank spots with something sensible, making sure my queries gave me reliable and accurate results. This simple trick sorted out the unexpected issues caused by those empty rows in the dataset.
