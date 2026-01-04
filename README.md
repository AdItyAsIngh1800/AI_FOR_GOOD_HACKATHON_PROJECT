# 📦 Inventory Health Monitoring & Stock-Out Alert System

**Built using Snowflake & Streamlit**

----------

## 📌 Project Overview

This project is an  **end-to-end Inventory Health Monitoring System**  designed to help organizations track stock levels, predict stock-outs, and generate actionable procurement insights.

The system analyzes daily inventory data across multiple  **locations**  and  **items**, calculates demand and risk levels, and presents insights through an interactive  **Streamlit dashboard**.

----------

## 🎯 Objectives

-   Monitor  **inventory health**  across locations and items
    
-   Predict  **early stock-out risks**  using demand estimation
    
-   Generate  **reorder suggestions**  based on Reorder Point (ROP) logic
    
-   Provide  **procurement-ready priority lists**  with CSV export
    
-   Visualize data using a  **heatmap-style dashboard**
    
-   Demonstrate  **automation design**  using Snowflake Streams & Tasks (conceptual)
    

----------

## 🧠 Business Use Case

This system is useful for:

-   Hospitals & healthcare supply chains
    
-   Public distribution systems (PDS)
    
-   NGOs and relief camps
    
-   Warehouses & retail inventory management
    

It helps decision-makers answer:

-   _Which items will run out soon?_
    
-   _How many days of stock are left?_
    
-   _What quantity should be reordered and when?_
    

----------

## 🏗️ Architecture Overview

`Raw  Inventory  Data  (Daily) ↓ Demand  Estimation ↓ Stock  Health  Metrics ↓ Risk  Classification ↓ Procurement  Priority  List ↓ Streamlit  Dashboard  &  CSV  Export` 

----------

## 🗂️ Project Structure

`inventory-health-monitor/
│
├── README.md
│
├── sql/
│   ├── setup/
│   ├── data/
│   ├── metrics/
│   ├── procurement/
│   ├── heatmap/
│   └── automation_optional/
│
├── streamlit/
│   └── streamlit_dashboard.py
│
├── sample_data/
│   └── daily_stock_sample.csv
│
├── screenshots/
│   ├── dashboard.png
│   ├── heatmap.png
│   ├── alerts.png
│   └── csv_export.png
│
└── docs/
    ├── automation_explanation.md
    └── viva_questions.md` 

----------

## 📊 Key Features

### 1️⃣ Inventory Health Metrics

-   **Daily demand estimation**
    
-   **Days of cover**  calculation
    
-   **Run-out date estimation**
    

### 2️⃣ Risk Classification

-   **CRITICAL**  – ≤ 3 days of cover
    
-   **WARNING**  – ≤ 7 days of cover
    
-   **OK**  – safe stock level
    

(Thresholds are configurable)

### 3️⃣ Reorder Logic

-   **Safety Stock**  = 2 days of demand
    
-   **Reorder Point (ROP)**  = demand × lead time + safety stock
    
-   **Reorder Quantity**  = max(0, ROP − current stock)
    

### 4️⃣ Procurement Priority List

-   Automatically sorted by:
    
    -   Risk level
        
    -   Urgency (days of cover)
        
-   Exportable as  **CSV**
    

### 5️⃣ Streamlit Dashboard

-   KPI cards (locations, items, critical alerts)
    
-   Heatmap-style table (Location × Item)
    
-   Alerts table
    
-   Download button for procurement list
    

----------

## 🖥️ Streamlit Dashboard

The dashboard provides:

-   A  **heatmap-like view**  using days of cover
    
-   **Early stock-out warnings**
    
-   **Procurement-ready action list**
    
-   One-click  **CSV export**
    

The dashboard can be run:

-   Inside  **Snowflake (Snowsight Streamlit)**
    
-   Or  **locally**  using the Snowflake Python Connector
    

----------

## ⚙️ Automation (Conceptual Design)

The system includes a designed automation pipeline:

`Daily CSV File
     ↓
Snowflake Stage
     ↓
Landing Table ↓
Stream (new  rows)
     ↓
Task (scheduled job)
     ↓
RAW_DAILY_STOCK` 

⚠️  **Note:**  
Due to restricted privileges in the student Snowflake account, Streams and Tasks are  **documented conceptually**  but not executed. This does not affect the analytics or dashboard functionality.

----------

## 🛠️ Technologies Used

-   **Snowflake SQL**
    
    -   Tables, Views, Dynamic Tables
        
-   **Streamlit**
    
    -   Interactive dashboard
        
-   **Python**
    
    -   Pandas
        
    -   Snowflake Connector
        
-   **Snowflake Snowsight UI**
    

----------

## ▶️ How to Run the Dashboard (Local)

`pip install streamlit pandas snowflake-connector-python cd streamlit
streamlit run streamlit_dashboard.py` 

----------

## 📸 Deliverables

-   SQL scripts for all layers
    
-   Streamlit dashboard
    
-   Screenshots of:
    
    -   Heatmap
        
    -   Alerts
        
    -   CSV export
        
-   Architecture & automation explanation
    
-   Viva-ready documentation
    

----------

## 🧾 Learning Outcomes

-   Designed a  **data-driven inventory monitoring system**
    
-   Applied  **demand forecasting logic**
    
-   Used  **Snowflake analytics features**
    
-   Built a  **business-ready dashboard**
    
-   Understood  **data automation concepts**
    

----------

## 📌 Author

**Name:**  _Aditya Singh_  
**Course / Program:**  _BTech/CSE_  
**Institution:**  _SRMIST, CHENNAI_
