# Smart-University-Analytics-Academic-Performance-Platform---Mock-Hackathon
A cloud-based student analytics solution using Snowflake to process and analyze academic performance, attendance trends, and departmental insights for data-driven decision-making in educational institutions.
# UniPulse Intelligence Dashboard

### Real-Time Student Performance & Attendance Analytics

---

# Overview

UniPulse Intelligence Dashboard is a modern analytics solution designed to monitor and analyze:

* Student academic performance
* Attendance trends
* Pass percentage analytics
* Department-wise insights
* High-risk student identification

The project leverages:

* **Snowflake Cloud Data Warehouse**
* **Power BI**
* **Kaggle Student Performance Dataset**

to build an interactive and visually rich academic analytics platform.

---

# Features

✅ Student Performance Analytics
✅ Attendance Monitoring
✅ Pass vs Fail Analysis
✅ Department-wise Insights
✅ High Risk Student Detection
✅ Interactive KPI Cards
✅ Modern Power BI Dashboard
✅ Dynamic Filtering & Slicers
✅ Conditional Formatting Heatmaps
✅ Secure Data Access using RBAC

---

# Tech Stack

| Technology     | Purpose                 |
| -------------- | ----------------------- |
| Snowflake      | Cloud Data Warehouse    |
| Power BI       | Dashboard Visualization |
| SQL            | Data Transformation     |
| DAX            | KPI Calculations        |
| Kaggle Dataset | Source Data             |

---

# Dataset

Dataset Source: Kaggle — Students Performance Dataset

Dataset contains:

* Student ID
* Gender
* Department
* Attendance (%)
* Midterm Score
* Final Score
* Result Status

---

# System Architecture

```text
                    ┌────────────────────────┐
                    │  Kaggle Dataset (CSV) │
                    └──────────┬─────────────┘
                               │
                               ▼
                    ┌────────────────────────┐
                    │  Snowflake RAW Layer   │
                    │  Raw Data Ingestion    │
                    └──────────┬─────────────┘
                               │
                               ▼
                    ┌────────────────────────┐
                    │  CORE Layer            │
                    │  Cleaned & Transformed │
                    │  Student Analytics     │
                    └──────────┬─────────────┘
                               │
                               ▼
                    ┌────────────────────────┐
                    │  MART Layer            │
                    │ KPI & Summary Tables   │
                    │ Analytics Views        │
                    └──────────┬─────────────┘
                               │
                               ▼
                    ┌────────────────────────┐
                    │       Power BI         │
                    │ Interactive Dashboard  │
                    │ KPI + Visual Analytics │
                    └────────────────────────┘
```

---

# Data Warehouse Layers

## RAW Layer

Stores raw ingested dataset.

### Example Tables

* STUDENT_RAW

---

## CORE Layer

Performs:

* data cleaning
* duplicate removal
* transformations
* business rule implementation

### Example Tables

* STUDENT_CORE
* ATTENDANCE_CORE
* RESULT_CORE

---

## MART Layer

Contains analytics-ready tables optimized for dashboards.

### Example Tables

* STUDENT_PERFORMANCE_SUMMARY
* DEPARTMENT_PERFORMANCE
* PASS_PERCENTAGE_SUMMARY
* ATTENDANCE_ALERT_SUMMARY

---

# Dashboard Components

## KPI Cards

* Total Students
* Average Score
* Pass Percentage
* High Risk Students

---

## Visual Analytics

| Visual         | Purpose                   |
| -------------- | ------------------------- |
| Area Chart     | Student Performance Trend |
| Gauge Chart    | Attendance Performance    |
| Treemap        | Department Distribution   |
| Funnel Chart   | Pass vs Fail Analysis     |
| Matrix Heatmap | Attendance Analysis       |
| Table Visual   | High Risk Students        |

---

# Dashboard Design

* Dark Theme UI
* Rounded Containers
* Interactive Slicers
* Dynamic Filtering
* Heatmaps
* Premium Analytics Layout
* Modern Visualization Structure

---

# Security Implementation

Implemented:

* Role-Based Access Control (RBAC)
* Masking Policies
* Secure Analytics Access

---

#  Power BI Features Used

* KPI Cards
* Area Charts
* Funnel Charts
* Treemap
* Gauge Charts
* Matrix Heatmaps
* Conditional Formatting
* Slicers
* DAX Measures

---

# KPI Measures

## Total Students

```DAX
Total Students =
DISTINCTCOUNT(Students[Student_ID])
```

---

## Average Score

```DAX
Average Score =
AVERAGE(Students[Final_Score])
```

---

## Pass Percentage

```DAX
Pass Percentage =

DIVIDE(

    CALCULATE(
        COUNTROWS(Students),
        Students[Final_Score] >= 40
    ),

    COUNTROWS(Students)

) * 100
```

---

##  High Risk Students

```DAX
High Risk Students =

CALCULATE(

    DISTINCTCOUNT(
        Students[Student_ID]
    ),

    Students[Attendance] < 75

)
```

---

#  Dashboard Layout

```text
 ---------------------------------------------------------
| TITLE + GLOBAL FILTERS                                |
 ---------------------------------------------------------
| KPI CARDS                                             |
 ---------------------------------------------------------
| Student Score Trend | Attendance Gauge                |
 ---------------------------------------------------------
| Department Treemap  | Pass vs Fail Funnel             |
 ---------------------------------------------------------
| Attendance Heatmap  | Risk Students Table             |
 ---------------------------------------------------------
```

---

# Key Insights

The dashboard helps educational institutions:

* monitor student performance
* analyze attendance behavior
* identify academic risks
* compare department performance
* improve academic decision-making

---

# Project Outcome

Successfully developed:

* centralized academic analytics platform
* interactive reporting dashboard
* student risk analysis system
* attendance monitoring solution
* modern BI visualization platform

---

# Future Enhancements

* Machine Learning Integration
* Real-Time Streaming Analytics
* Predictive Performance Modeling
* AI-Powered Recommendations
* Mobile Dashboard Optimization

---

# Developed By

Uma Maheswari K

