-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TASK 1: Perform comprehensive data cleaning by resolving inconsistencies, handling null values, removing duplicates, and addressing normalization issues 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
EXPLORING ACCOUNTS TABLE
*/

SELECT * FROM accounts; 
/*
Retrieving all records from the 'accounts' table, which consists of 4 columns: account_id, client_id, 
account_type, and balance.

To maintain consistency and clarity, the 'balance' column will be renamed to 'account_balance' for better 
readability and standardization.
*/
ALTER TABLE accounts RENAME COLUMN balance TO account_balance;

-- Verifying that the column rename was successful
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'accounts' AND column_name LIKE '%balance'; 
-- The query correctly returned 'account_balance', confirming the rename was applied successfully.  

-- Retrieving the total number of records in the 'accounts' table
SELECT COUNT(*) FROM accounts; -- The query confirms that the table contains 7,000 rows.  

-- Identifying duplicate records in the 'accounts' table
SELECT
	account_id,
	client_id,
	account_type,
	account_balance,
	COUNT(*) AS duplicated_records
FROM accounts
GROUP BY account_id, client_id, account_type, account_balance
HAVING COUNT(*) > 1;
-- The query returned no records, confirming that there are no duplicate rows in the table, ensuring data integrity.  


-- Verifying that the 'account_id', 'client_id', and 'account_balance' columns contain only non-negative values
SELECT *
FROM accounts
WHERE 
	account_id < 0 OR
	client_id <0 OR
	account_balance < 0; 
-- The query returned 0 records, confirming that all values in the specified columns are non-negative, ensuring data consistency.

-- Retrieving the distinct account types available in the 'accounts' table  
SELECT DISTINCT account_type
FROM accounts; -- The query returned three account types: Retirement, Brokerage, and Savings, confirming the available classifications.

-- Identifying records with NULL values in the 'accounts' table
SELECT *
FROM accounts
WHERE account_id IS NULL OR
	client_id IS NULL OR
	account_type IS NULL OR
	account_balance IS NULL; 
/*  
The query revealed that 350 records (approximately 5%) contain NULL values, all of which are exclusively in the 'account_balance' column.  
No other columns have missing values.  

At this stage, these NULL values will remain unchanged while a comprehensive review of all related tables is conducted.  
Gaining broader context will ensure a well-informed approach to handling missing values.  

Prematurely modifying or removing NULL values could lead to unintended consequences, potentially affecting data integrity.  
Therefore, decisions regarding the 'account_balance' NULL values will be revisited after a thorough exploration of all tables.  
This ensures a data-driven resolution aligned with overall dataset trends and relationships.  
*/  

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXPLORING THE STRUCTURE AND CONTENTS OF THE 'clients' TABLE

SELECT * FROM clients; -- The table consists of 4 columns: client_id, name, age, city, and risk_tolerance. 

/*
Renaming 'name' column to client_name to improve clarity and avoid potential conflicts, as name is a reserved keyword
in PostgreSQL
*/
ALTER TABLE clients RENAME COLUMN name TO client_name;

-- Retrieving the total number of records in the 'clients' table 
SELECT COUNT(*) FROM clients; -- Table has 5500 records

-- Verifying that the 'client_id' and 'age' columns contain only non-negative values
SELECT *
FROM clients
WHERE client_id < 0 OR 
	age < 0; -- The query returned no records, confirming that all values in the specified columns are non-negative, ensuring data integrity.

-- Identifying duplicate records in the 'clients' table
SELECT
	client_id,
	client_name,
	age,
	city,
	risk_tolerance,
	COUNT(*) AS duplicate_count
FROM clients
GROUP BY client_id, client_name, age, city, risk_tolerance
HAVING COUNT(*) > 1; -- The query revealed that 500 records have been duplicated twice each, indicating potential data redundancy.

/*  
Handling duplicate records in the 'clients' table through a structured approach:  

STEP 1: Create a new table, 'clients_2', as a copy of the original 'clients' table.  
         This new table will include an additional column, 'duplicate_number',  
         which assigns a row number to each record. The first occurrence of each record  
         is assigned 1, while duplicates are assigned 2, 3, etc.  

STEP 2: Remove all duplicate records by deleting rows where 'duplicate_number' is 2 or higher.  

STEP 3: Drop the original 'clients' table to replace it with the cleaned version.  

STEP 4: Rename 'clients_2' back to 'clients' to maintain the original table name.  

STEP 5: Remove the 'duplicate_number' column to restore the table to its original structure,  
         ensuring all duplicates are eliminated while preserving data integrity.  
*/  
CREATE TABLE clients_2 AS (
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY client_id,client_name,age,city,risk_tolerance ORDER BY client_id) AS duplicate_number
FROM clients
);

DELETE FROM clients_2 WHERE duplicate_number > 1;

DROP TABLE clients;

ALTER TABLE clients_2 RENAME TO clients;

ALTER TABLE clients DROP COLUMN duplicate_number;
-- The block of code above successfully results in a deduplicated 'clients' table.

-- Checking for NULL values in the 'clients' table 
SELECT *
FROM clients
WHERE client_id IS NULL OR
	client_name IS NULL OR
	age IS NULL OR
	city IS NULL OR
	risk_tolerance IS NULL; -- The query returned no records, confirming that there are no NULL values in the table, ensuring data completeness.

-- Retrieving the distinct values in the 'risk_tolerance' column to check for uniqueness and consistency
SELECT DISTINCT risk_tolerance 
FROM clients;
-- This query ensures that there are no duplicate variations of the same category, confirming data integrity.  
/*
Verifying that the 'clients' table has been thoroughly checked for completeness  All necessary validations, including checking for duplicate records,
NULL values,  negative values, and consistency in categorical data, have been performed.  The table is confirmed to be complete and ready for further analysis.
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXAMINING THE STRUCTURE AND CONTENTS OF THE 'investments' TABLE

SELECT * FROM investments; -- The table contains 6 columns: investment_id, account_id, security_name, investment_type, quantity, and purchase_price.

SELECT COUNT(*) FROM investments; -- Table has 20,000 records

-- Identifying and verifying duplicate records in the 'investments' table 
SELECT
	investment_id, 
	account_id,
	security_name,
	investment_type,
	quantity,
	purchase_price,
	COUNT(*) AS duplicate_count
FROM investments
GROUP BY
	investment_id, 
	account_id,
	security_name,
	investment_type,
	quantity,
	purchase_price
HAVING COUNT(*) > 1; -- The query returned no records, confirming that there are no duplicate entries in the table.

-- Checking for NULL values in the 'investments' table
SELECT *
FROM investments
WHERE
	investment_id IS NULL OR
	account_id IS NULL OR
	security_name IS NULL OR
	investment_type IS NULL OR
	quantity IS NULL OR
	purchase_price IS NULL; -- The query returned 0 records, confirming that there are no NULL values in the table, ensuring data completeness.

-- Verifying that all numerical columns in the 'investments' table contain only non-negative values
SELECT *
FROM investments
WHERE
	investment_id < 0 OR
	account_id < 0 OR
	quantity <0 OR
	purchase_price < 0; -- The query returned no records, confirming that all numerical values are non-negative, ensuring data integrity.

-- Retrieving distinct security names from the 'investments' table to ensure uniqueness and consistency
SELECT DISTINCT security_name
FROM investments; -- The query identified 6 unique companies: Amazon, Apple, Google, Microsoft, Netflix, and Tesla.

-- Retrieving distinct investment types from the 'investments' table to ensure uniqueness and consistency
SELECT DISTINCT investment_type
FROM investments; -- The query identified 3 unique investment types: ETF, Bond, and Stock.

/*
Verifying that the 'investments' table has been thoroughly checked for completeness. All necessary validations, including checking for 
duplicate records, NULL values, negative values, and consistency in categorical data, have been performed.  The table is confirmed to be complete 
and ready for further analysis.  
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXAMINING THE STRUCTURE AND CONTENTS OF THE 'market_prices' TABLE

SELECT * FROM market_prices; -- The table contains 3 columns: security_name, date, and closing_price.

-- Identifying and verifying duplicate records in the 'market_prices' table 
SELECT 
	security_name,
	date,
	closing_price,
	COUNT(*) AS duplicate_count
FROM market_prices
GROUP BY security_name, date, closing_price
HAVING COUNT(*) > 1; -- The query identified one record that is duplicated twice, indicating potential data redundancy.

/*
Duplicates in the market_prices table will be handled using the same approach as in the clients table. 
First, a new table, market_prices_2, will be created with an additional column to identify duplicate records. 
Duplicates will then be removed, ensuring only the first occurrence of each record is retained. Once the data 
is cleaned, the original market_prices table will be dropped, followed by the removal of the duplicate identifier 
column. Finally, market_prices_2 will be renamed back to market_prices, preserving the original table structure 
but without duplicates.
*/

-- STEP 1: Creating a duplicate market_prices table with an extra column identifying a duplicate with a number > 1
CREATE TABLE market_prices_2 AS (
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY security_name, date, closing_price ORDER BY security_name) AS duplicate_number
FROM market_prices
);

-- STEP 2: Dropping the duplicate row
DELETE FROM market_prices_2 WHERE duplicate_number > 1;

-- STEP 3: Dropping the original table with duplicated rows
DROP TABLE market_prices;

-- STEP 4: Dropping the duplicate_number column from market_prices_2 table since it's no longer needed
ALTER TABLE market_prices_2
DROP COLUMN duplicate_number;

-- STEP 5: Renaming market_prices_2 back to market_prices to preserve original table structure without duplicates
ALTER TABLE market_prices_2 RENAME TO market_prices;

-- Checking for null values in the 'market_prices' table
SELECT * 
FROM market_prices 
WHERE
	security_name IS NULL OR
	date IS NULL OR
	closing_price IS NULL; -- The query returned no records, confirming that there are no NULL values in the table, ensuring data completeness.

-- Verifying that the 'closing_price' column contains only non-negative values
SELECT *
FROM market_prices
WHERE closing_price < 0; -- The query returned no records, confirming that there are no negative values in the column, ensuring data integrity

/*
Verifying that the 'market_prices' table has been thoroughly checked for completeness. All necessary validations, including checking for duplicate records, 
NULL values and negative values, have been performed. The table is confirmed to be complete and ready for further analysis.  
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXAMINING THE STRUCTURE AND CONTENTS OF THE 'transactions' TABLE 

SELECT * FROM transactions;
-- The table consists of 6 columns: transaction_id, investment_id, transaction_type, transaction_date, quantity, and transaction_price.

-- Retrieving the total number of records in the 'transactions' table
SELECT COUNT(*) FROM transactions; -- The query reveals that the table contains 100,000 records. 

-- Identifying and verifying duplicate records in the 'transactions' table
SELECT
transaction_id,
	investment_id,
	transaction_type,
	transaction_date,
	quantity,
	transaction_price,
	COUNT(*) AS duplicate_count
FROM transactions
GROUP BY
	transaction_id,
	investment_id,
	transaction_type,
	transaction_date,
	quantity,
	transaction_price
HAVING COUNT(*) > 1 -- The query returned no records, confirming that there are no duplicate transactions in the table.

-- Verifying that all numerical columns contain only non-negative values
SELECT *
FROM transactions
WHERE 
	transaction_id < 0 OR
	investment_id < 0 OR
	quantity < 0 OR
	transaction_price < 0; -- All numerical columns are confirmed to be non-negative, which ensures data integrity.

-- Checking for NULL values in the 'transactions' table
SELECT *
FROM transactions
WHERE
	transaction_id IS NULL OR 
	investment_id IS NULL OR
	transaction_type IS NULL OR
	transaction_date IS NULL OR
	quantity IS NULL OR
	transaction_price IS NULL; -- The query revealed that 3,000 rows out of 100,000 (roughly 3%) contain NULL values.
/*
The query below identifies which column contains the 3,000 NULL values by systematically checking each column 
individually in the WHERE clause.
*/
SELECT COUNT(*) AS missing_values_count
FROM transactions
WHERE transaction_price IS NULL; -- All 3,000 NULL values are exclusively due to missing transaction prices.

SELECT account_balance
FROM accounts
WHERE account_type = 'Savings'

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- HANDLING NULL VALUES IN 'accounts' TABLE

/*  
It was not possible to retrieve the missing `account_balance` information from any external source.  
Since `account_balance` is a critical financial metric, removing these records could result in the loss of valuable client data.  

Given that there are three account types (`Brokerage`, `Savings`, and `Retirement`),  
the first step is to determine how many missing values exist within each account type.  

The query below identifies the distribution of NULL values across account types.  
*/

SELECT 
	account_type,
	COUNT(*) AS null_rows_count
FROM accounts
WHERE account_balance IS NULL
GROUP BY account_type
ORDER BY 2 DESC;
/*  
The query results indicate that the missing values are distributed across all three account types:  
- Brokerage: 123 missing values  
- Savings: 120 missing values  
- Retirement: 107 missing values  

To determine the best imputation method, a distribution analysis of `account_balance` values was conducted in Python.  
The analysis revealed that each account type follows a distinct distribution pattern, with a slight skew in each case.  

Given the skewed distributions, the most appropriate method for handling missing values is to use the median account balance per 
account type, ensuring that imputed values  better represent the central tendency of each group.  
*/


-- STEP 1: This CTE calculates the median 'account_balance' per 'account_type',ensuring NULL values are excluded from the calculation.
WITH account_balance_median AS (
	SELECT
		account_type,
		ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY account_balance) AS NUMERIC),2) AS median_balance
	FROM accounts
	WHERE account_balance IS NOT NULL
	GROUP BY account_type
)
-- STEP 2: The UPDATE statement ensures that any NULL values in 'account_balance'are replaced with the median balance corresponding to their 'account_type'.
UPDATE accounts 
SET account_balance = abm.median_balance
FROM account_balance_median AS abm
WHERE accounts.account_balance IS NULL AND
accounts.account_type = abm.account_type;

-- Verifying to ensure all NULL values in the account_balance column have been filled
SELECT account_balance
FROM accounts
WHERE account_balance IS NULL; -- No record has been returned. This confirms that there are no any NULL values in the account_balance column

/*
The NULL values in the 'account_balance' column of the 'accounts' table have been successfully handled by replacing them with the respective median balance
for each 'account_type'. This ensures data consistency, enhances the accuracy of financial analysis, and prevents NULL values from skewing future queries and reports. 
By filling missing values with a statistically representative measure, the dataset remains reliable for business insights and decision-making.
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- HANDLING MISSNG VALUES IN 'transactions' TABLE

/*
Just like with the accounts table, it wasn't possible to retrieve missing 'transaction_price' data. The overall distribution of the transaction_price
was evaluated and the data appeared relatively symmetrical with median and mean values very close to each other.

The query below  returns the mean and median transaction prices
*/
SELECT
	ROUND(CAST(AVG(transaction_price) AS NUMERIC),2) AS mean,
	ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY transaction_price) AS NUMERIC),2) AS median
FROM transactions;

SELECT * FROM transactions;
/*
To be even more specific, identifying how many missing values are present for each transaction_type will provide better insight on how to handle them

This query returns the number of missing transaction prices values for each transaction type
*/
SELECT
	transaction_type,
	COUNT(*) AS null_values_count
FROM transactions
WHERE transaction_price IS NULL
GROUP BY transaction_type; -- The results reveal that there are 1505 NULL values for Buy and 1495 For Sell.

/*
The query below computes both the mean and median transaction price for each transaction type (Buy and Sell), ensuring missing values 
are excluded from the analysis.
*/
SELECT
	transaction_type,
	ROUND(CAST(AVG(transaction_price) AS NUMERIC),2) AS mean_transaction_price,
	ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY transaction_price) AS NUMERIC),2) AS median_transaction_price
FROM transactions
WHERE transaction_price IS NOT NULL
GROUP BY transaction_type;
/*
- For Buy transactions, the mean (755.61) is slightly lower than the median (758.30), indicating a slight left skew.
- For Sell transactions, the mean (755.16) is slightly higher than the median (754.57), suggesting a slight right skew.
- Despite these small differences, the distributions for both transaction types appear mostly symmetrical.

Since the **mean is slightly affected by skewness, using the median per transaction type is a more robust choice for handling missing values.
This approach ensures better alignment with the transaction type’s natural distribution, minimizing distortions caused by skewness.
*/

-- STEP 1: Compute the median transaction_price separately for each transaction_type (Buy/Sell)
WITH transaction_type_median AS (
	SELECT
		transaction_type,
		ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY transaction_price) AS NUMERIC),2) AS median_transaction_price
	FROM transactions
	WHERE transaction_price IS NOT NULL
	GROUP BY transaction_type
)
-- STEP 2: Update missing transaction_price values with the corresponding median for each transaction type.
UPDATE transactions
SET transaction_price = ttm.median_transaction_price
FROM transaction_type_median AS ttm
WHERE ttm.transaction_type = transactions.transaction_type 
AND transactions.transaction_price IS NULL;

-- Verifying to make sure NULL values have been completely filled in the transaction_price column
SELECT transaction_price
FROM transactions
WHERE transaction_price IS NULL; -- No records have been returned. This verifies that the NULL values in this column have been handled successfully

/*
The NULL values in the transaction_price column of the transactions table have been successfully handled by replacing them with the respective 
median price for each transaction_type. This approach ensures data consistency, improves the accuracy of transaction analysis, and prevents NULL values 
from distorting financial reports and trend evaluations. By using a statistically representative measure, the dataset remains reliable for business insights, 
pricing strategies, and decision-making.

All tables have been fully normalized, deduplicated, and cleansed of NULL values, ensuring data integrity, consistency, and optimal performance for analysis
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 2: Establishing Relationships Between Tables for Data Integrity
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- All tables have primary keys except for 'clients' 
-- Query below assigns primary key to 'client_id' column in 'clients' table 

ALTER TABLE clients
ADD CONSTRAINT pk_clients PRIMARY KEY (client_id); -- Primary key established successfully


-- This query established relationship between 'accounts' and 'clients' tables
ALTER TABLE accounts
ADD CONSTRAINT fk_accounts_clients
FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE;

-- Establishing relationship between 'investments' and 'accounts' tables
ALTER TABLE investments
ADD CONSTRAINT fk_investments_accounts
FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE;

-- Establishing relationship between 'transactions' and 'investments' tables
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_investments
FOREIGN KEY (investment_id) REFERENCES investments(investment_id) ON DELETE CASCADE;

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 3: Generating Insightful and Actionable Summary Tables/Views
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW 1: Total Investments Per Client

/*
The query  below creates a view that summarizes each client's total investments by investment type (Stock, Bond, ETF) and 
calculates their overall investment value. The following is the step-by-step breakdown of how that is achieved

Step 1: Clients, Accounts, and Investments tables are joined to retrieve investment details per client.
Step 2: Investment Values for each investment_type (Stock, Bond, ETF) are aggregated for each client.
Step 3: Investment types are pivoted into Separate columns using conditional aggregation to enhance data clarity and structure.
Step 4: The total investment value as the sum of all investment types per client is computed.
Step 5: The result is stored as a view, making it easy to query without recalculating each time.

This enables quick access to each client's investment portfolio breakdown.
*/
CREATE VIEW total_investments_per_client AS (
	WITH investments_info AS (
		SELECT 
			c.client_id,
			c.client_name,
			i.investment_Type,
			SUM(i.quantity * i.purchase_price) AS total_investments
		FROM clients AS c
		INNER JOIN accounts AS a
		USING(client_id)
		INNER JOIN investments AS i
		ON a.account_id = i.account_id
		GROUP BY c.client_id, c.client_name, i.investment_type
		),
		investor_info_final AS (
		SELECT
			client_id,
			client_name,
			SUM(CASE WHEN investment_type = 'Stock' THEN total_investments ELSE 0 END) AS Stock,
			SUM(CASE WHEN investment_type = 'Bond' THEN total_investments ELSE 0 END) AS Bond,
			SUM(CASE WHEN investment_type = 'ETF' THEN total_investments ELSE 0 END) AS ETF
		FROM investments_info
		GROUP BY client_id,client_name
		)
	SELECT
		*,
		stock + bond + etf AS total_investments
	FROM investor_info_final
	ORDER BY client_id, client_name
);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW 2: Yearly Transaction Trends (Transaction value)

/*
The query below creates a view that summarizes yearly transaction trends by calculating the total value of Buy and Sell transactions for each year
and computing the overall transaction value. The following is the step-by-step breakdown of how that is achieved:

Step 1: The transactions and investments tables are joined to retrieve transaction details, ensuring accurate data linkage.

Step 2: The transaction year is extracted using DATE_PART('year', transaction_date), allowing for year-based aggregation.

Step 3: Transaction values for each year and transaction type (Buy and Sell) are aggregated by summing quantity * transaction_price, 
ensuring accurate financial computation.

Step 4: Transaction types are pivoted into separate columns using conditional aggregation, improving data clarity and making comparisons 
between Buy and Sell transactions easier.

Step 5: The total transaction value per year is computed as the sum of Buy and Sell transaction values, providing a comprehensive view
of yearly transaction trends.

Step 6: The final summarized data is stored as a view, allowing for quick access to historical transaction trends without recalculating each time.

This enables efficient analysis of yearly investment transaction patterns, helping stakeholders assess trading activity and financial 
trends over time. 
*/
CREATE VIEW yearly_trends_transaction_value AS (
	WITH transaction_summary_1 AS (
		SELECT 
			DATE_PART('year', t.transaction_date) AS transaction_year,
			t.transaction_type,
			ROUND(SUM(t.quantity * t.transaction_price),2) AS transaction_value
		FROM transactions AS t
		INNER JOIN investments AS i
		USING(investment_id)
		GROUP BY DATE_PART('year', t.transaction_date), t.transaction_type
		),
		transaction_summary_2 AS (
		SELECT
			transaction_year,
			SUM(CASE WHEN transaction_type = 'Buy' THEN transaction_value ELSE 0 END ) AS Buy,
			SUM(CASE WHEN transaction_type = 'Sell' THEN transaction_value ELSE 0 END) AS Sell
		FROM transaction_summary_1
		GROUP BY transaction_year
		)
	SELECT
		*,
		buy + sell AS total_transaction_value
	FROM transaction_summary_2
	ORDER BY transaction_year
);

-- VIEW 3: Yearly Transaction Trends (Transaction count)

/*
This query follows the same structured approach as the `yearly_trends_transaction_value` view. However, instead of calculating the 
total transaction value, this query **counts the number of transactions** for each year, categorized by transaction type (Buy and Sell).

Key Differences from yearly_trends_transaction_value:  
1. Instead of summing transaction values, this query uses COUNT(*) to count the number of transactions per year.  
2. The resulting columns represent the total number of Buy and Sell transactions rather than their monetary value.  
*/
CREATE VIEW yearly_trends_transaction_count AS (
	WITH transaction_count_summary_1 AS (
		SELECT 
			DATE_PART('year', t.transaction_date) AS transaction_year,
			t.transaction_type,
			COUNT(*) AS transaction_count
		FROM transactions AS t
		INNER JOIN investments AS i
		USING(investment_id)
		GROUP BY DATE_PART('year', t.transaction_date), t.transaction_type
		),
		transaction_count_summary_2 AS (
		SELECT
			transaction_year,
			SUM(CASE WHEN transaction_type = 'Buy' THEN transaction_count ELSE 0 END ) AS Buy,
			SUM(CASE WHEN transaction_type = 'Sell' THEN transaction_count ELSE 0 END) AS Sell
		FROM transaction_count_summary_1
		GROUP BY transaction_year
		)
	SELECT
		*,
		buy + sell AS total_transaction_value
	FROM transaction_count_summary_2
	ORDER BY transaction_year
);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW 4: Account Balances Per Client

/*
he query below creates a view that summarizes each client's total account balance by account type (Retirement, Savings, Brokerage) 
and calculates their overall account balance. The following is the step-by-step breakdown of how that is achieved:

Step 1: The clients and accounts tables are joined to retrieve account balance details for each client.
Step 2: Account balances for each account type (Retirement, Savings, Brokerage) are aggregated per client.
Step 3: Account types are pivoted into separate columns using conditional aggregation to enhance data clarity and structure.
Step 4: The total account balance is computed as the sum of all account types for each client.
Step 5: The result is stored as a view, allowing for quick access to each client's account balance breakdown without recalculating each time.

This enables efficient tracking of client account balances, making it easier to analyze financial distributions across different account types.
*/
CREATE VIEW account_balance_per_client AS (
	WITH balance_summary_1 AS (
		SELECT 
			c.client_id,
			c.client_name,
			a.account_type,
			SUM(a.account_balance) AS account_balance
		FROM accounts AS a
		INNER JOIN clients AS c
		USING(client_id)
		GROUP BY c.client_id, c.client_name, a.account_type
		),
		balance_summary_2 AS (
		SELECT
			client_id,
			client_name,
			SUM(CASE WHEN account_type = 'Retirement' THEN account_balance ELSE 0 END) AS retirement,
			SUM(CASE WHEN account_Type = 'Savings' THEN account_balance ELSE 0 END) AS savings,
			SUM(CASE WHEN account_type = 'Brokerage' THEN account_balance ELSE 0 END) AS brokerage
		FROM balance_summary_1
		GROUP BY client_id, client_name
		)
	SELECT
		*,
		retirement + savings + brokerage AS total_account_balance
	FROM balance_summary_2
	ORDER BY client_id
);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW 5: Investment Distribution by Security Type

/*
The query below creates a view that summarizes the distribution of investments by investment type, showing both the total quantity
and total investment value for each type. 
*/
CREATE VIEW investment_distribution AS (
	SELECT 
		investment_type,
		SUM(quantity) AS total_quantity,
		SUM(quantity * purchase_price) AS total_investment_value
	FROM investments
	GROUP BY investment_type
);

----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Designing a comprehensive table that consolidates client information and portfolio activity into a single, unified dashboard. 
This holistic perspective allows for a clearer understanding of data trends, facilitates anomaly detection, and uncovers 
insights into investment behavior and account movements.
*/ 

CREATE TABLE general_table AS (
SELECT 
	c.client_id,
	c.client_name,
	a.account_type,
	i.security_name,
	i.investment_type,
	i.quantity,
	i.purchase_price,
	t.transaction_type,
	t.transaction_date,
	t.quantity AS transaction_quantity,
	t.transaction_price, 
	a.account_balance
FROM transactions AS t
INNER JOIN investments AS i
USING(investment_id)
INNER JOIN accounts AS a
ON a.account_id = i.account_id
INNER JOIN clients AS c
ON c.client_id = a.client_id
ORDER BY c.client_id, transaction_date
);
----------------------------------------------------------------------------------------------------------------------------------------------------------


/*
DATA EXPLORATION: 
Conducting an in-depth analysis of the temp_view dataset to gain insights, identify patterns, and detect potential inconsistencies. 
This process ensures data integrity and helps uncover hidden trends that may impact decision-making.
*/
SELECT * 
FROM general_table;

/*

Validating Sell Transactions: Ensuring that every sell transaction is backed by a prior buy transaction, confirming that clients only sell 
securities they have previously purchased. The query below verifies this by cross-checking all sell transactions against corresponding buy records,
helping to maintain data accuracy and prevent inconsistencies. 

STEP 1: Create a Common Table Expression (CTE) named buy_transactions that stores distinct client-security pairs where a buy transaction has occurred.

STEP 2:  LEFT JOIN temp_view with buy_transactions to retain all buy and sell transactions in temp_view. If no corresponding buy exists, 
b.security_name will be NULL.

STEP 3: : Filter for sell transactions where b.security_name IS NULL, flagging instances where a client has attempted to sell a security they never purchased.

The query returned 1580 records or instances where clients sold securities they never bought. This issue suggests missing or incorrect data entries, leading to 
inaccurate portfolio valuations and incorrect return on investment (ROI) calculations later on during the analysis phase. Without a valid 'Buy' record, it's impossible 
to determine the original cost basis for these securities, making profitability analysis unreliable.
*/
WITH buy_transactions AS (
    SELECT 
		DISTINCT client_id, security_name
    FROM general_table
    WHERE transaction_type = 'Buy'
)
SELECT 
	g.client_id,
	g.client_name,
	g.security_name, 
	g.transaction_date,
	g.transaction_quantity
FROM general_table AS g
LEFT JOIN buy_transactions AS b
ON g.client_id = b.client_id AND g.security_name = b.security_name
WHERE g.transaction_type = 'Sell' AND b.security_name IS NULL;

/*
Since these records could significantly impact analysis, they will be removed. The query below accomplishes this

Following the query execution, 1,580 records (approximately 1.6%) were removed, leaving a total of 98,420 records.
*/

WITH buy_transactions AS (
    SELECT DISTINCT client_id, security_name
    FROM general_table
    WHERE transaction_type = 'Buy'
)
DELETE FROM general_table
WHERE transaction_type = 'Sell'
AND (client_id, security_name) NOT IN (
    SELECT client_id, security_name FROM buy_transactions
);

/*
It’s important to verify that clients cannot sell more securities than they own. If a client attempts to sell a security, 
the quantity they wish to sell must not exceed the amount they currently hold in their portfolio. To ensure this, we compare 
the transaction_quantity of each 'Sell' transaction with the corresponding quantity held. If the transaction_quantity is greater 
than the quantity owned, it indicates a potential issue, such as bad data entry or missing 'Buy' transactions, which should be addressed.

The query below returned 34108 transactions where the quantity sold is greater than the total quantity held. This indicates either data entry 
errors or missing 'Buy' transactions. Selling more shares than a client owns is unrealistic and distorts portfolio performance metrics, 
risk assessments, and investment recommendations.
*/

WITH net_holdings AS (
    SELECT client_id, security_name, 
           SUM(CASE 
                   WHEN transaction_type = 'Buy' THEN transaction_quantity 
                   WHEN transaction_type = 'Sell' THEN -transaction_quantity 
                   ELSE 0 
               END) AS total_quantity
    FROM general_table
    GROUP BY client_id, security_name
)
SELECT g.client_id, g.security_name, g.transaction_date, g.transaction_quantity, h.total_quantity
FROM general_table AS g
JOIN net_holdings h
ON g.client_id = h.client_id AND g.security_name = h.security_name
WHERE g.transaction_type = 'Sell' AND g.transaction_quantity > h.total_quantity;

/*
There are two ways to fix the transactions where the quantity sold is greater than total quantity held. One way is to delete the records.
This will ensure absolute data accuracy since the remaining records will make logical sense. This will also prevent errors from influencing
analysis. However, deleting this data will eliminate a significant portion of the dataset (approximately 35% of the data will be gone).This 
can lead to the loss of variable transaction history. This could affect reporting and ROI calculations. 

Alternatively, the transaction quantity can be capped to ensure that it does not exceed the total holdings available. This will preserve as
much data as possible. This will ensure valuable transaction history is not lost. Moreover, this reflects a realistic real-life scenario. For
example, if a person tries to sell more than they own, the system automatically limits their sale to their available holdings instead of outright
rejecting the order. There's a good chance that the overselling is due to missing 'Buy' data. This is a more likely cause. It doesn't make logical
sense to sell more than you own. Despite capping transaction quantity being the most ideal approach than outright deleting records, it can 
potentially alter historical transaction records through adjusting the recorded transaction quantity. This may raise data integrity concerns
especially if transactions need to reflect exactly what was recorded. Moreover, if the root cause is missing 'Buy' transactions, simply capping
transactions quantity does not correct the issue. The client might have rightfully owned the shares, but due to missing buy data, they appear to be over-selling.

Given these considerations, the capping approach will be used to fix the issue.
*/
UPDATE general_table g
SET transaction_quantity = ABS(h.total_quantity)  -- Ensures positive values
FROM (
    SELECT client_id, security_name, 
           SUM(CASE 
                   WHEN transaction_type = 'Buy' THEN transaction_quantity 
                   WHEN transaction_type = 'Sell' THEN -transaction_quantity 
                   ELSE 0 
               END) AS total_quantity
    FROM general_table
    GROUP BY client_id, security_name
) h
WHERE g.client_id = h.client_id
AND g.security_name = h.security_name
AND g.transaction_type = 'Sell'
AND g.transaction_quantity > h.total_quantity; -- Query has successfully capped the transaction quantity ensuring sale doesn't exceed holdings


-- Verifying to confirm whether the query has executed successfully (running the previous code that returned 34108 records)
WITH net_holdings AS (
    SELECT client_id, security_name, 
           SUM(CASE 
                   WHEN transaction_type = 'Buy' THEN transaction_quantity 
                   WHEN transaction_type = 'Sell' THEN -transaction_quantity 
                   ELSE 0 
               END) AS total_quantity
    FROM general_table
    GROUP BY client_id, security_name
)
SELECT g.client_id, g.security_name, g.transaction_date, g.transaction_quantity, h.total_quantity
FROM general_table AS g
JOIN net_holdings h
ON g.client_id = h.client_id AND g.security_name = h.security_name
WHERE g.transaction_type = 'Sell' AND g.transaction_quantity > h.total_quantity;
-- The query returned 0 transactions confirming that there's no longer any transaction where the quantity sold is greater than the quantity held.

/*
The account_balance does not appear to reflect accurately, and the modifications made thus far pose a significant risk of erroneous financial analysis. 
The presence of incorrect entries further undermines the reliability of the dataset, jeopardizing accurate assessments.

Given the nature of the analysis required—such as portfolio performance evaluation, ROI calculations, and other financial metrics—accurate data is critical. 
Since these analyses rely on precise reporting, this dataset is deemed unusable for such purposes. Conducting financial analysis based on flawed data could 
lead to misleading insights and, consequently, poor decision-making. Therefore, no financial analysis will be performed using this dataset.
*/