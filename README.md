# Customer Churn Analysis | PostgreSQL & Python

## Project Overview
This project analyzes telecom customer churn to understand retention patterns and identify customer groups with higher churn rates. It uses PostgreSQL queries for business analysis and Python (Pandas, Matplotlib) for cleaning, KPI calculation, summaries, and charts.

## Dataset
- File: `Dataset/Customer-Churn.csv`
- Rows: 7,043
- Columns: 21
- Target field: `Churn` (`Yes` / `No`)

## Tools
- PostgreSQL
- Python 3
- Pandas
- Matplotlib
- Visual Studio Code

## Questions Answered
1. How many customers are in the dataset?
2. What percentage of customers churned?
3. Which contract types have higher churn rates?
4. How does churn vary by payment method?
5. How does churn vary by customer tenure?
6. How do average monthly charges differ by churn status?

## Repository Structure
```text
Customer-Churn-Analysis/
├── Dataset/
│   └── Customer-Churn.csv
├── SQL/
│   └── churn_analysis.sql
├── Python/
│   ├── customer_churn_analysis.py
│   └── outputs/                 # Created when the script runs
├── Screenshots/
├── requirements.txt
└── README.md
```

## Run the Python Analysis
Open a terminal in the project root and run:

```bash
python -m pip install -r requirements.txt
python Python/customer_churn_analysis.py
```

The script saves cleaned data, summary CSVs, and charts to `Python/outputs/`.

## PostgreSQL Setup
1. Create a PostgreSQL database.
2. Import the CSV into a table named `customer_churn`.
3. Check that the column names match the SQL file. The provided queries use quoted mixed-case column names such as `"Churn"` and `"Contract"`.
4. Run the queries in `SQL/churn_analysis.sql`.

## Key Metrics
The Python script calculates total customers, churned customers, retained customers, churn rate, churn by contract, churn by payment method, average monthly charges by churn status, and churn by tenure group.

## Notes
- `TotalCharges` is converted to numeric; blank or invalid values become missing values.
- The analysis is descriptive and does not claim to predict future churn.
- Add screenshots of your executed charts/dashboard to `Screenshots/` after running the project.

## Author
Piyush Paratwar
