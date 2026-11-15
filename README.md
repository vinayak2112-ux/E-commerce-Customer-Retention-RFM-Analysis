# Olist E-Commerce Sales Analysis 📊

## Project Overview

This project focuses on analysing the Brazilian E-Commerce Public Dataset by Olist to understand business performance, customer purchasing behaviour, product category performance, and order delivery trends.

The analysis was performed using MySQL to extract meaningful insights from multiple relational tables and Power BI to build an interactive dashboard for data visualization and business reporting.

The project demonstrates practical skills in SQL querying, data analysis, business intelligence, and data storytelling.

## Project Objectives

- Analyse overall e-commerce sales and order performance.
- Identify the highest-revenue product categories.
- Understand customer purchasing behaviour and repeat purchases.
- Evaluate order status and delivery performance.
- Analyse monthly revenue trends.
- Identify important business patterns using SQL.

## Dataset Information

The project uses the **Brazilian E-Commerce Public Dataset by Olist**, available on Kaggle.

The dataset contains approximately 100,000 orders made between 2016 and 2018. It provides information about customers, orders, products, sellers, payments, reviews, and geographical locations.

### Dataset Tables

The analysis uses the following nine tables:

1. Customers
2. Orders
3. Order Items
4. Order Payments
5. Order Reviews
6. Products
7. Sellers
8. Geolocation
9. Product Category Translation

**Dataset Source:** [Brazilian E-Commerce Public Dataset by Olist – Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Develop an interactive Power BI dashboard.
- Provide actionable recommendations based on the analysis.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| MySQL | Data querying, data analysis, joins, CTEs, and window functions |
| Power BI | Interactive dashboard and data visualization |
| SQL | Extracting business insights and analysing e-commerce data |
| Microsoft Excel | Data inspection and basic data handling |
| GitHub | Project documentation and version control |

## Database Structure

The project uses a relational MySQL database named `olist_ecommerce`, containing nine tables connected through primary and foreign key relationships.

| Table | Description |
|---|---|
| customers | Customer details and locations |
| orders | Order dates and order statuses |
| order_items | Products, quantities, prices, and freight values |
| order_payments | Payment methods and payment amounts |
| order_reviews | Customer ratings and review information |
| products | Product details and categories |
| sellers | Seller information |
| geolocation | Geographic coordinates |
| category_translation | Portuguese-to-English product category translations |

These tables were used together to perform SQL analysis and generate business insights.

## SQL Analysis

SQL was used to explore the dataset and answer important business questions.

The analysis included:

- **Sales Analysis:** Calculated total revenue, average order value, and monthly revenue trends.
- **Order Analysis:** Analysed total orders, delivered orders, and order status distribution.
- **Product Analysis:** Identified top-performing product categories based on revenue.
- **Customer Analysis:** Analysed unique customers, repeat customers, and customer purchasing behaviour.
- **Freight Analysis:** Examined freight charges in relation to product revenue.
- **RFM Analysis:** Segmented customers using Recency, Frequency, and Monetary values.

### SQL Concepts Used

- SELECT, WHERE, ORDER BY
- Aggregate Functions and GROUP BY
- INNER JOIN and LEFT JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- CASE Statements
- Date Functions

## Power BI Dashboard

An interactive Power BI dashboard was developed to present key business metrics and trends from the Olist e-commerce dataset.

### Dashboard Preview

<img width="965" height="542" alt="image" src="https://github.com/user-attachments/assets/acc43794-51b5-4ce6-846c-22d7f70371b6" />

### Download Power BI Dashboard

[Click here to download the interactive Power BI dashboard (.pbix)](https://drive.google.com/file/d/1YD2sAkrNueII5Km6xM6CFFqeRWKN7DFw/view?usp=sharing)

### Dashboard Features

- **KPI Cards:** Delivered Revenue, Total Orders, Delivered Orders, and Average Order Value.
- **Monthly Revenue Trend:** Tracks revenue performance over time.
- **Top 10 Categories by Revenue:** Highlights the highest-performing product categories.
- **Order Status Distribution:** Shows the distribution of orders across different statuses.
- **Customer Satisfaction:** Visualizes customer review score distribution.

The dashboard helps users explore sales performance, product categories, order trends, and customer satisfaction.

## Key Business Insights

The analysis revealed the following business insights:

1. **Overall Sales:** Delivered product revenue was approximately R$13.22 million across 96,478 delivered orders.
2. **Order Performance:** Out of 99,441 total orders, 96,478 were delivered, representing approximately 97.02%.
3. **Average Order Value:** The average order value was approximately R$137.04.
4. **Customer Retention:** Out of 93,358 customers, 2,801 were repeat customers, resulting in an approximate repeat customer rate of 3%.
5. **Top Product Category:** Health & Beauty generated the highest revenue at approximately R$1.23 million.
6. **Monthly Performance:** November 2017 recorded the highest monthly revenue at approximately R$987,765.
7. **Freight Charges:** Total freight charges were approximately R$2.20 million.

## Business Recommendations

Based on the analysis, the following recommendations can help improve business performance:

1. **Improve Customer Retention:** Introduce loyalty programs and targeted offers to encourage repeat purchases.
2. **Focus on Top Categories:** Strengthen marketing strategies for high-revenue categories such as Health & Beauty and Watches & Gifts.
3. **Monitor Order Performance:** Investigate unsuccessful and delayed orders to identify potential operational improvements.
4. **Analyse Seasonal Trends:** Study high-performing months such as November 2017 to plan future promotional campaigns.
5. **Use Customer Segmentation:** Apply RFM analysis to identify valuable customers and develop targeted marketing strategies.
6. **Review Freight Costs:** Monitor shipping charges to identify opportunities to improve delivery cost efficiency.

## Project Structure

```text
olist-ecommerce-sales-analysis/
│
├── README.md
│
├── dataset/
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── order_payments.csv
│   ├── order_reviews.csv
│   ├── products.csv
│   ├── sellers.csv
│   ├── geolocation.csv
│   └── category_translation.csv
│
├── sql/
│   └── analysis_queries.sql
│
├── powerbi/
│   └── olist-dashboard.pbix
│
└── images/
    └── olist-dashboard.png
```

## Conclusion

This project demonstrates how SQL and Power BI can be used to analyse e-commerce data, identify business trends, understand customer behaviour, and generate actionable insights.

Through this project, I gained practical experience in SQL querying, data analysis, customer segmentation, and interactive dashboard development.
