# A1 College Prep Database Development

## Description

My project at A1 College Prep, a tutoring organization I worked at for many years, focused on developing a database to enhance our sales, marketing, and administrative efficiency. I then used the database to create dashboards and perform descriptive analytics, as well as create materials for use in sales and marketing. I ultimately created a website, https://a1educationalconsulting.org/, for which I wrote all copy and used the insights generated from querying against the database to create powerful visuals. This was my first project that directly impacted a business.

### Motivation

I wanted to use my burgeoning data science skills to address technical needs of the company I worked for.

## Business Problems Addressed

A1 had no single source of truth; the existing system was fragmented, making it challenging to access comprehensive information for marketing strategies or student support.

### Learning Experience

- This project was a foundational learning experience in database design and data management. It honed my skills in SQL and R, particularly in the context of real-world application.
- I learned to work with stakeholders throughout the business and ask the right questions to learn relationship among data and the right business cases to address.
- I gained valuable insights into the ethical aspects of data management, especially concerning privacy and security in handling personal information.

## Impact and Results

- The new database streamlined administrative processes, providing a unified view of student and parent information.
- Targeted marketing strategies, based on analyzed student demographics and service usage patterns, led to a notable increase in student enrollments.
- The accessible database empowered tutors, counselors, and administrators with valuable insights into student progress, enhancing the quality of tutoring services.

## Installation

To set up the development environment, follow these steps:

1. Clone the repository to your local machine.
2. Install the libraries using the script. For specifics about versions and dependencies, see the requirements.txt file.
3. Ensure your version of R is compatible with the libraries. The last time I ran the script, I used R version 4.3.2 (2023-10-31 ucrt) -- "Eye Holes"
4. Change the filepaths of datasets to match your machine's filepaths.
5. Set up a local or remote MS SQL Server. I used Microsoft SQL Server 2019 and SSMS 18 on a virtual machine.

## Usage

### Database Schema Design 

The core of the project is designing a robust database schema. This involved identifying key entities like students, parents, and sessions, and defining relationships between them. The schema was meticulously planned to capture complex relationships and hierarchies within the data, and is ready to use for college counseling, tutoring, or similar client-facing businesses.

### Programming and Implementation 
The implementation phase requires a blend of SQL for database structuring and R for scripting ETL and performing data analysis and manipulation. I developed custom scripts to automate data entry and ensure data consistency.

### Data Integration and Cleaning
In addition to thoroughly understanding the business rules, the biggest technical challenge is integrating disparate data sources. I employ various data cleaning techniques to standardize and deduplicate data.

## Future Development

I intend to rewrite this code in Python and use SQLAlchemy for ETL; in my experience SQLAlchemy is a powerful ORM. I would also like to set up a Dash app that displays my dashboards.