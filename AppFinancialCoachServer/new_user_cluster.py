import pandas as pd
from joblib import dump, load
from utils import required_monthly_savings


def new_user_cluster(average_expense, average_income, goals, profile_score, current_balance):
    goalScore = required_monthly_savings(goals) / average_income
    print("goalScore", goalScore)
    print("current_balance", current_balance)
    print("average_expense", average_expense)
    print("average_income", average_income)
    print("profile_score", profile_score)
    new_user = {'currentBalance': current_balance, 'totalExpenses': average_expense, 'averageIncome': average_income,
                'goalScore': goalScore, 'totalSavings': 6000, 'riskProfileScore': profile_score}
    new_user_df = pd.DataFrame([new_user])
    new_user_scaled = load('scaler.joblib').transform(new_user_df)

    # Predict the cluster for the new user using the loaded model
    new_user_cluster = load('dbscan.joblib').fit_predict(new_user_scaled)
    print("The new user belongs to cluster:", new_user_cluster[0])
