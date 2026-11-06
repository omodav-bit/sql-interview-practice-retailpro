RETAILPRO PRACTICE DATABASE
Companion files for SQL Interview Practice for Beginners

WHAT IS INCLUDED
1. 01_RetailPro_Database_Setup.sql
   Creates the RetailPro database, five related tables, fictional sample data,
   indexes and validation checks.

2. 02_RetailPro_Practice_Exercises.sql
   Thirty practice prompts that follow the topics taught in the book.

3. 03_RetailPro_Exercise_Solutions.sql
   Suggested SQL solutions for all thirty exercises.

REQUIREMENTS
- Microsoft SQL Server 2012 or later.
- SQL Server Management Studio (SSMS), or another SQL client able to run T-SQL.
- Permission to create a database on the SQL Server instance.

INSTALLATION
1. Open SSMS and connect to your SQL Server instance.
2. Open 01_RetailPro_Database_Setup.sql.
3. Read the warning at the top of the script.
4. Execute the script.
5. Refresh Databases in Object Explorer and expand RetailPro.
6. Confirm that the validation output reports:
   Customers: 15
   Employees: 5
   Products: 10
   Orders: 30
   OrderDetails: 50
7. The final consistency-check query should return no rows.

IMPORTANT IF YOU ALREADY HAVE A RETAILPRO DATABASE
The setup script deliberately stops if RetailPro already exists. It will not
overwrite or delete an existing database. If you already installed an earlier
version while following the book, do not run the setup script over it. Back up
your existing database first. For the clean companion release, use a separate
SQL Server instance or carefully rename/remove the earlier practice database
only after confirming that you no longer need it.

HOW TO PRACTISE
- Run the exercise prompts in 02_RetailPro_Practice_Exercises.sql.
- Write your own query below each prompt or in a separate query window.
- Use 03_RetailPro_Exercise_Solutions.sql only after attempting the questions.
- Some exercises may have more than one valid solution.

DATABASE OVERVIEW
Customers       Customer records
Employees       Employee records
Products        Product catalogue
Orders          Order headers
OrderDetails    Products and quantities within each order

All people, email addresses and business records in this practice database are
fictional and are supplied for educational purposes.

COMPATIBILITY
The scripts are written for Microsoft SQL Server 2012 or later. Features used
in the exercises include common T-SQL statements, CTEs and window functions.

LICENSE / PERMITTED USE
This companion dataset is intended to be freely downloaded and used for
personal learning, classroom teaching and practice alongside the book.
You may share the unmodified companion package with attribution to the book
title and author. Do not sell the files separately or present them as your own.
The author/publisher should confirm the final licence wording before public
release.

SUPPORT
For corrections or updated companion files, use the download location stated
in the book. Do not rely on an old copy if a newer release is announced.
