# Beyond Repair: A Case Study in Unusable Financial Data
![skyscraper WEB](https://github.com/user-attachments/assets/16f03688-1d64-4516-9bfa-85ca22e19b49)
## Disclaimer
This project is based on a hypothetical scenario created for educational and analytical purposes. Summit Wealth Partners does not represent a real company, and the datasets, transactions, and financial records used in this analysis are simulated. Any resemblance to actual persons, businesses, or financial institutions is purely coincidental.

## Table of Contents

## 1. Introduction
Summit Wealth Partners, a premier investment firm, launched a data analytics initiative to optimize client portfolio performance, detect investment trends, and mitigate risks. The project aimed to clean and analyze datasets related to clients, accounts, investments, transactions, and market prices using SQL for data cleaning and Python for advanced analysis and visualization.

However, the project did not progress beyond the data preparation phase due to critical data integrity issues. This report documents the data cleaning and preparation efforts, highlights challenges encountered, and explains why the dataset was ultimately deemed unusable for further analysis.

## 2. Dataset Overview
The project involved five key datasets: clients, accounts, investments, transactions, and market prices. The clients dataset contained demographic information, including age, city of residence, and risk tolerance. The accounts dataset stored details of various account types, including brokerage, savings, and retirement accounts, along with account balances. The investments dataset tracked client holdings in securities such as stocks, bonds, and ETFs. The transactions dataset recorded buy and sell transactions, documenting transaction types, dates, and associated prices. Lastly, the market prices dataset contained historical closing prices for various securities, which would have been essential for evaluating portfolio performance.

Each dataset required thorough cleaning to ensure data integrity before moving into the analysis phase. The preparation process focused on detecting and resolving missing values, identifying duplicate records, ensuring valid relationships between datasets, and validating financial consistency.

## 3. Data Preparation & Cleaning (SQL)
### 3.1 Handling Duplicates
One of the initial steps in data cleaning involved identifying and removing duplicate records. The clients dataset had approximately 500 duplicate records, which were systematically removed while ensuring that unique client IDs remained intact. Removing duplicates was essential to prevent misleading client portfolio summaries and redundant reporting. Similarly, the market prices dataset contained duplicate records for certain securities on specific dates. Since historical pricing must be unique to avoid skewed performance calculations, all duplicate price records were eliminated.

The accounts, investments, and transactions datasets were also examined for duplication. Fortunately, these tables did not contain duplicate records, ensuring that financial transactions and asset holdings were already well-structured. Addressing duplicates at an early stage was crucial in preventing erroneous aggregations in subsequent analyses.

### 3.2 Handling Null Values
Missing values posed a significant challenge, particularly in the accounts and transactions datasets. Within the accounts dataset, 350 records were missing account balances, accounting for approximately 5% of the total records. Given that account balance is a critical financial metric, these missing values could not be left unresolved. The median balance per account type was used to impute the missing values, ensuring that imputed values closely reflected real-world financial distributions.

The transactions dataset presented a more complex issue, with 3,000 missing transaction prices. Since transaction price is essential for computing investment returns and profitability, leaving these values blank would render financial assessments unreliable. The missing values were addressed by computing the median transaction price for each transaction type (Buy/Sell) and using these values to replace the missing entries. This approach ensured that the imputation did not distort transaction trends.

### 3.3 Data Integrity Checks
Ensuring data integrity required validating numerical values and categorical consistency. First, all numerical fields, such as account balances, investment quantities, and transaction prices, were checked for negative values. No negative values were found, confirming that financial data was well-structured in this regard. Next, the risk tolerance field in the clients dataset was examined to ensure consistency in labels, with risk categories standardized to prevent discrepancies in segmentation analyses.

Additionally, relationships between datasets were verified. Each account was confirmed to be linked to a valid client, and every investment was assigned to an existing account. Ensuring these relationships was necessary to maintain database normalization and prevent orphaned records from distorting financial assessments.

### 3.4 Establishing Relationships
To maintain referential integrity across tables, foreign key constraints were implemented. The accounts table was linked to the clients table, ensuring that every account was associated with an actual client. The investments table was connected to accounts, preventing any investments from being linked to non-existent accounts. Similarly, the transactions table was linked to the investments table, ensuring that all recorded transactions were tied to valid securities. By enforcing these constraints, the database was structured to prevent invalid data entries and maintain consistency across records.

## 4. Critical Data Issues
Despite extensive data cleaning, several severe issues prevented further analysis from proceeding.

### 4.1 Invalid Sell Transactions
A major issue was discovered within the transactions dataset, where 1,580 records showed clients selling securities they had never purchased. This issue led to inaccuracies in portfolio valuation and return calculations since the system could not verify an original purchase for these securities. The root cause of this problem appeared to be missing Buy transactions, data entry errors, or flaws in the recording system. Given the financial implications of incorrect transactions, this issue made further analysis unreliable.

### 4.2 Over-Selling of Securities
An even more critical issue was detected when 34,108 transactions showed clients selling more shares than they actually owned. This raised concerns about missing buy transactions, erroneous record-keeping, or data corruption. To mitigate this issue, sell transactions were adjusted so that clients could not sell more shares than they possessed. However, even with this correction, the dataset remained unreliable, as the original source of these inconsistencies could not be fully determined.

### 4.3 Account Balances Inconsistencies
Account balances across different accounts did not align with recorded transaction activity. Some accounts displayed negative balances, despite deposits and withdrawals suggesting otherwise. This discrepancy indicated missing financial transactions, incorrect balance calculations, or improper handling of deposits and withdrawals. Since account balances were critical for evaluating portfolio health and liquidity, this issue severely undermined the reliability of the dataset.

Given these data integrity issues, the dataset was deemed unsuitable for further analysis. Without a trustworthy foundation, proceeding with portfolio performance assessments or risk analyses would lead to misleading insights and erroneous conclusions.

## 5. Conclusion & Recommendations
### 5.1 Key Takeaways
The project did not proceed beyond the data cleaning phase due to significant data integrity issues. Although duplicate, missing, and inconsistent records were addressed, invalid transactions and account mismatches rendered the dataset unreliable. Attempting financial analysis on this dataset would have resulted in misleading insights and poor decision-making.

### 5.2 Recommendations
To improve data quality for future analysis, stricter data validation protocols should be implemented. Real-time validation should be used to flag transactions where a client attempts to sell securities they have not purchased. Additionally, transaction history should be reconstructed to ensure that each sell transaction has a corresponding buy record. Automated account balance reconciliation should be implemented to detect and correct discrepancies before data analysis. Furthermore, regular data audits should be performed to identify inconsistencies early and prevent flawed records from accumulating.

Due to the fundamental flaws in the dataset, the project was halted before exploratory data analysis or portfolio performance assessments could begin. This report serves as documentation of the data preparation efforts and highlights areas where data integrity improvements are necessary for future projects.



















