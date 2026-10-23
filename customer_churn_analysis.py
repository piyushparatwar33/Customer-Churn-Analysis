"""
Customer Churn Analysis
Tools: Python, Pandas, Matplotlib
Dataset: Telco Customer Churn
Run: python Python/customer_churn_analysis.py
"""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "Dataset" / "Customer-Churn.csv"
OUTPUT_DIR = ROOT / "Python" / "outputs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA_PATH)
df.columns = df.columns.str.strip()

# Clean data
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
df["Churn"] = df["Churn"].astype(str).str.strip()
df["Contract"] = df["Contract"].astype(str).str.strip()
df["tenure"] = pd.to_numeric(df["tenure"], errors="coerce")
df["MonthlyCharges"] = pd.to_numeric(df["MonthlyCharges"], errors="coerce")
df = df.drop_duplicates()
df = df.dropna(subset=["Churn", "tenure", "MonthlyCharges"])

# Core KPIs
total_customers = len(df)
churned_customers = int((df["Churn"] == "Yes").sum())
churn_rate = churned_customers / total_customers * 100 if total_customers else 0
retained_customers = total_customers - churned_customers

print("=" * 48)
print("CUSTOMER CHURN ANALYSIS")
print("=" * 48)
print(f"Total customers: {total_customers:,}")
print(f"Churned customers: {churned_customers:,}")
print(f"Retained customers: {retained_customers:,}")
print(f"Churn rate: {churn_rate:.2f}%")
print(f"Rows with missing TotalCharges after conversion: {df['TotalCharges'].isna().sum():,}")

# Churn by contract
contract_summary = (
    df.groupby("Contract")
      .agg(total_customers=("customerID", "count"),
           churned_customers=("Churn", lambda s: (s == "Yes").sum()))
      .reset_index()
)
contract_summary["churn_rate_pct"] = (
    contract_summary["churned_customers"] / contract_summary["total_customers"] * 100
).round(2)
contract_summary.to_csv(OUTPUT_DIR / "churn_by_contract.csv", index=False)
print("\nChurn by contract:")
print(contract_summary.to_string(index=False))

# Churn by payment method
payment_summary = (
    df.groupby("PaymentMethod")
      .agg(total_customers=("customerID", "count"),
           churned_customers=("Churn", lambda s: (s == "Yes").sum()))
      .reset_index()
)
payment_summary["churn_rate_pct"] = (
    payment_summary["churned_customers"] / payment_summary["total_customers"] * 100
).round(2)
payment_summary.to_csv(OUTPUT_DIR / "churn_by_payment_method.csv", index=False)

# Average monthly charges by churn status
charges_summary = df.groupby("Churn")["MonthlyCharges"].mean().round(2)
print("\nAverage monthly charges by churn status:")
print(charges_summary.to_string())

# Churn by tenure group
df["tenure_group"] = pd.cut(
    df["tenure"], bins=[-1, 12, 24, 48, float("inf")],
    labels=["0-12 months", "13-24 months", "25-48 months", "49+ months"]
)
tenure_summary = (
    df.groupby("tenure_group", observed=False)
      .agg(total_customers=("customerID", "count"),
           churned_customers=("Churn", lambda s: (s == "Yes").sum())
      ).reset_index()
)
tenure_summary["churn_rate_pct"] = (
    tenure_summary["churned_customers"] / tenure_summary["total_customers"] * 100
).round(2)
tenure_summary.to_csv(OUTPUT_DIR / "churn_by_tenure.csv", index=False)

# Export cleaned dataset
df.to_csv(OUTPUT_DIR / "customer_churn_cleaned.csv", index=False)

# Chart 1: Churn distribution
churn_counts = df["Churn"].value_counts().reindex(["No", "Yes"], fill_value=0)
plt.figure(figsize=(7, 5))
churn_counts.plot(kind="bar")
plt.title("Customer Churn Distribution")
plt.xlabel("Churn")
plt.ylabel("Number of Customers")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "churn_distribution.png", dpi=150)
plt.close()

# Chart 2: Churn rate by contract
plt.figure(figsize=(8, 5))
plt.bar(contract_summary["Contract"], contract_summary["churn_rate_pct"])
plt.title("Churn Rate by Contract Type")
plt.xlabel("Contract Type")
plt.ylabel("Churn Rate (%)")
plt.xticks(rotation=15, ha="right")
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "churn_by_contract.png", dpi=150)
plt.close()

# Chart 3: Churn rate by tenure group
plt.figure(figsize=(8, 5))
plt.bar(tenure_summary["tenure_group"].astype(str), tenure_summary["churn_rate_pct"])
plt.title("Churn Rate by Customer Tenure")
plt.xlabel("Tenure Group")
plt.ylabel("Churn Rate (%)")
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "churn_by_tenure.png", dpi=150)
plt.close()

print(f"\nOutputs saved to: {OUTPUT_DIR}")
print("Analysis complete.")
