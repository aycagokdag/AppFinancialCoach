import pandas as pd
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from joblib import dump, load

data = {
    'uid': [
        'Saver', 'HighEarner', 'Spender', 'RiskTaker',
        'ConservativePlanner', 'Newcomer', 'AspiringInvestor', 'DebtManager',
        'RetirementPlanner', 'YoungProfessional', 'SeasonedExecutive',
        'BudgetEnthusiast', 'Traveler', 'Student', 'RealEstateInvestor', 'TechEnthusiast'
    ],
    'currentBalance': [
        5000, 30000, 1000, 15000, 10000, 1500, 5000, 300, 40000, 6000,
        50000, 4500, 2000, 1200, 50000, 5000
    ],
    'totalExpenses': [
        2000, 7000, 2500, 4000, 2000, 1200, 3000, 2000, 3000, 4500,
        4000, 1200, 700, 1800, 3500, 4000
    ],
    'averageIncome': [
        4000, 25000, 1800, 14000, 6000, 2400, 4800, 1400, 8000, 10000,
        20000, 3500, 4500, 1200, 9000, 5500
    ],
    'goalScore': [
        0.67, 0.33, 0.17, 0.50, 0.67, 0.33, 0.50, 0.17, 0.83, 0.17,
        1.00, 0.67, 0.33, 0.17, 0.83, 0.50
    ],
    'totalSavings': [
        8000, 12000, 500, 11000, 18000, 1000, 4500, 200, 45000, 3500,
        40000, 6000, 2500, 500, 35000, 2500
    ],
    'riskProfileScore': [
        2, 8, 3, 7, 1, 2, 6, 4, 2.5, 5, 3, 1.5, 3, 2, 5.5, 4
    ]
}


df = pd.DataFrame(data)

scaler = StandardScaler()
features = ['currentBalance', 'totalExpenses', 'averageIncome',
            'goalScore', 'totalSavings', 'riskProfileScore']
df_scaled = scaler.fit_transform(df[features])


# eps specifies how close points can be to each other
# Larger eps means fewer clusters
dbscan = DBSCAN(eps=1, min_samples=1)
df['cluster_dbscan'] = dbscan.fit_predict(df_scaled)

print(df[['uid', 'cluster_dbscan']])

# Plotting DBSCAN results
plt.figure(figsize=(10, 6))
plt.scatter(df['currentBalance'], df['totalSavings'],
            c=df['cluster_dbscan'], cmap='viridis', s=100, alpha=0.5)
plt.title('DBSCAN Clustering Visualization')
plt.xlabel('Current Balance')
plt.ylabel('Total Savings')
plt.colorbar(label='Cluster')
plt.show()


dump(scaler, 'scaler.joblib')
dump(dbscan, 'dbscan.joblib')
