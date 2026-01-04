import streamlit as st
import pandas as pd
import snowflake.connector

st.set_page_config(
    page_title="Inventory Heatmap & Stock-Out Alerts",
    layout="wide"
)

st.title("Inventory Heatmap & Stock-Out Alerts")

# -----------------------------
# Snowflake connection details
# -----------------------------
conn = snowflake.connector.connect(
    user="aditya18",
    password="AdItyAsIngh1801",
    account="GJYAUQN-PD21127",
    warehouse="WH_INVENTORY",
    database="INVENTORY_A4G",
    schema="PUBLIC"
)

# -----------------------------
# Sidebar filters
# -----------------------------
st.sidebar.header("Filters")
risk_filter = st.sidebar.multiselect(
    "Risk Level",
    ["CRITICAL", "WARNING", "OK"],
    default=["CRITICAL", "WARNING", "OK"]
)

# -----------------------------
# Load stock health data
# -----------------------------
query_stock = """
SELECT
    location,
    item,
    closing_stock,
    daily_demand_est,
    days_of_cover,
    risk_level,
    computed_at
FROM V_STOCK_HEALTH
"""

df = pd.read_sql(query_stock, conn)

df = df[df["RISK_LEVEL"].isin(risk_filter)]

# -----------------------------
# Top metrics
# -----------------------------
col1, col2, col3, col4 = st.columns(4)

col1.metric("Locations", df["LOCATION"].nunique())
col2.metric("Items", df["ITEM"].nunique())
col3.metric("Critical Items", (df["RISK_LEVEL"] == "CRITICAL").sum())
col4.metric("Warning Items", (df["RISK_LEVEL"] == "WARNING").sum())

st.divider()

# -----------------------------
# Heatmap-style table
# -----------------------------
st.subheader("Heatmap: Days of Cover (Location × Item)")

heat_df = df.pivot_table(
    index="LOCATION",
    columns="ITEM",
    values="DAYS_OF_COVER",
    aggfunc="max"
)

st.dataframe(heat_df, use_container_width=True)

st.caption(
    "Lower days of cover indicates higher stock-out risk."
)

st.divider()

# -----------------------------
# Alerts section
# -----------------------------
st.subheader("Early Stock-Out Warnings")

alerts = df[df["RISK_LEVEL"].isin(["CRITICAL", "WARNING"])]
alerts = alerts.sort_values(
    ["RISK_LEVEL", "DAYS_OF_COVER"],
    ascending=[True, True]
)

st.dataframe(alerts, use_container_width=True)

st.divider()

# -----------------------------
# Procurement priority list
# -----------------------------
st.subheader("Procurement Priority List")

query_priority = """
SELECT *
FROM V_PROCUREMENT_PRIORITY
"""

priority_df = pd.read_sql(query_priority, conn)

st.dataframe(priority_df, use_container_width=True)

# -----------------------------
# CSV download
# -----------------------------
csv = priority_df.to_csv(index=False).encode("utf-8")

st.download_button(
    label="Download Procurement Priority CSV",
    data=csv,
    file_name="procurement_priority.csv",
    mime="text/csv"
)

# -----------------------------
# Close connection
# -----------------------------
conn.close()
