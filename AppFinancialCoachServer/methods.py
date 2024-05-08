import pandas as pd
from statistics import stdev
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import numpy as np
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Dense
from datetime import datetime
import pytz
from sklearn.preprocessing import RobustScaler
import sys
from collections import defaultdict
from pprint import pprint
from joblib import dump, load


def detect_anomalies(expenses_list, new_expense):
    expenses = pd.DataFrame(expenses_list)

    print("new expense")
    print(new_expense.expenseCategory)
    print(new_expense.expenseAmount)

    # Create a defaultdict to store expenses for each category
    df = defaultdict(list)
    months = sorted(expenses['date'].dt.strftime('%b').unique())

    # Iterate over expenses and organize them by category and month
    df = defaultdict(lambda: defaultdict(float))

    # Iterate over expenses and sum up expenses for each category and month
    for index, expense in expenses.iterrows():
        month = expense['date'].strftime('%b')
        category = expense['parentCategory']
        amount = expense['amount']
        df[category][month] += amount

    # Convert defaultdict to a regular dictionary
    df = {category: [expenses.get(month, 0) for month in months]
          for category, expenses in df.items()}

    # Add missing categories with zero expenses for each month
    for category, expenses_list in df.items():
        if len(expenses_list) < len(months):
            expenses_list.extend([0] * (len(months) - len(expenses_list)))

    # Add months as the first row in the dictionary
    df = {'Month': months, **df}

    pprint(df)

    #  StandardScaler transforms data such that each feature (expense category) has a mean of 0 and a standard deviation of 1.
    data_for_model = np.array(df[new_expense.expenseCategory]).reshape(-1, 1)
    print(data_for_model)
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(data_for_model)
    input_dim = scaled_data.shape[1]
    input_layer = Input(shape=(input_dim,))
    encoded = Dense(2, activation='relu')(input_layer)
    decoded = Dense(input_dim, activation='sigmoid')(encoded)
    autoencoder = Model(input_layer, decoded)
    autoencoder.compile(optimizer='adam', loss='mean_squared_error')

    # Train the autoencoder
    autoencoder.fit(scaled_data, scaled_data, epochs=100,
                    batch_size=32, shuffle=True)

    new_expense_scaled = scaler.transform([[new_expense.expenseAmount]])

    print("new_expense_scaled ", new_expense_scaled)

    prediction = autoencoder.predict([new_expense_scaled])

    mse = np.mean(np.power(new_expense_scaled - prediction, 2), axis=1)

    mse_threshold = np.percentile(mse, 95)
    is_anomaly = mse > mse_threshold
    is_anomaly_list = is_anomaly.tolist()
    print("is anomaly?", is_anomaly_list[0])
    return is_anomaly_list[0]


importance_dict = {
    'Housing': 10,
    'Transportation': 8,
    'Food and Dining': 5,
    'Health': 10,
    'Entertainment': 2,
    'Personal Care': 4,
    'Shopping': 3,
    'Debt Payments': 9,
    'Education': 8,
    'Savings and Investments': 7
}


def suggest_budget_cuts(expenses_list, required_savings, current_savings, months=5):
    """
    Suggests budget cuts based on required savings, current savings, and the flexibility
    inferred from historical expenses variability.
    """
    # Calculate flexibility scores from historical data
    #flexibility_scores = calculate_flexibility_scores(expenses_list)

    additional_savings_needed = required_savings - current_savings / months
    if additional_savings_needed <= 0:
        return {}

    adjustments = {}
    sorted_expenses = sorted(expenses_list, key=lambda x: importance_dict.get(
        x['parentCategory'], 0), reverse=True)

    for expense in sorted_expenses:
        category = expense['parentCategory']
        amount = expense['amount']
        if additional_savings_needed <= 0:
            break  # No more adjustments needed

        # Use dynamic_cut_percentage to determine the cut percentage
        cut_percentage = dynamic_cut_percentage(category, expenses_list)
        possible_savings = amount * cut_percentage
        if possible_savings > additional_savings_needed:
            possible_savings = additional_savings_needed

        adjustments[category] = -possible_savings
        additional_savings_needed -= possible_savings

    print("adjustments: ",  adjustments)

    return adjustments


def months_until(goal_date):
    now_utc = datetime.now(pytz.UTC)  # Makes datetime offset-aware in UTC
    return (goal_date - now_utc).days // 30


def required_monthly_savings(goals):
    """
    Calculates monthly minimum amount of money to be saved in order to meet goals
    """
    monthly_savings_required = 0
    for goal in goals:
        save_amount = goal['amountToBeSaved'] / months_until(goal['dueDate'])
        monthly_savings_required += save_amount
        print("Monthly savings required: ", monthly_savings_required)
    return monthly_savings_required


def calculate_net_savings(incomes_list, expenses_list):
    """
    Calculates income - expense to find money surplus
    """
    total_income = sum(item['amount'] for item in incomes_list)
    total_expenses = sum(item['amount'] for item in expenses_list)
    return total_income - total_expenses


def evaluateFinancialSituation(expenses_list, incomes_list, goals):
    """
    Calculates income - expense to find money surplus
    """
    net_savings = calculate_net_savings(incomes_list, expenses_list)
    print("Net savings ", net_savings)
    required_savings = required_monthly_savings(goals)

    if net_savings < 0:
        return -1
    elif (net_savings/5) < required_savings:  # divide by the number of months
        return 0
    else:
        return 1


def calculate_flexibility_scores(expenses_list):
    """
    Calculates flexibility scores based on the variability of historical expenses.
    A higher standard deviation in a category's expenses indicates higher flexibility.
    """
    df = pd.DataFrame(expenses_list)

    df['date'] = pd.to_datetime(df['date'])
    df['year_month'] = df['date'].dt.to_period('M')

    # Group by category and year_month, then sum amounts
    monthly_expenses = df.groupby(['parentCategory', 'year_month'])[
        'amount'].sum().reset_index()

    # Pivot the data to have categories as columns and months as rows
    pivot_df = monthly_expenses.pivot(
        index='year_month', columns='parentCategory', values='amount').fillna(0)

    # Calculate month-to-month percentage change
    pct_change_df = pivot_df.pct_change().fillna(0)

    # Calculate standard deviation of the percentage changes as flexibility score
    flexibility_scores = pct_change_df.std().to_dict()

    return flexibility_scores


def dynamic_cut_percentage(category, expenses_list):
    """
    Determine the cut percentage based on category importance and calculated flexibility scores.
    """
    print("category:", category)
    flexibility_scores = calculate_flexibility_scores(expenses_list)
    base_cut = 0.01  # Start with a 5% base cut
    importance_factor = (10 - importance_dict.get(category, 5)) / 10
    print("importance factor calculated: ", importance_factor)
    # Default to medium flexibility if unknown
    flexibility_factor = flexibility_scores.get(category, 0.5)
    print("flexibility factor calculated: ", flexibility_factor)
    cut_percentage = base_cut + (importance_factor * flexibility_factor * 0.15)
    print("cut percentage ", cut_percentage)
    print("\n")
    return min(0.1, max(0.01, cut_percentage))


def budget_planning(expenses_list, incomes_list, goals):

    response = {
        "plannedExpenses": {},
        "savingPerMonth": 0
    }

    adjustments = {}
    financialSituationScore = evaluateFinancialSituation(
        expenses_list, incomes_list, goals)  # Uses the corrected variable passing

    net_savings = calculate_net_savings(incomes_list, expenses_list)
    if financialSituationScore != 1:
        adjustments = forcasted_expenses(
            expenses_list, incomes_list, goals)

    total_adjustments = 0
    for category, amount in adjustments.items():
        # Assuming expenses_list is a list of dicts with 'category' and 'amount'
        original_amount = next(
            (item['amount'] for item in expenses_list if item['parentCategory'] == category), 0)
        # Ensure non-negative
        adjusted_amount = max(0, original_amount + amount)
        response["plannedExpenses"][category] = adjusted_amount
        print("\n")
        print("Amounts", amount)
        print("\n")
        total_adjustments += (-1 * amount)

    # Update savingPerMonth based on adjustments
    response["savingPerMonth"] = max(0, total_adjustments)
    print("Suggested expenses adjustments:", response)
    return response


def forcasted_expenses(expenses_list, incomes_list, goals):
    net_savings = calculate_net_savings(incomes_list, expenses_list)
    required_savings = required_monthly_savings(goals)
    suggested_expenses = suggest_budget_cuts(
        expenses_list, required_savings, net_savings)
    print("suggested_expenses")
    print(suggested_expenses)
    return suggested_expenses


# Clustering a new user into an existing cluster.
# Their cluster is determined based on their data to provide them tailored advice,
# based on their spending patterns and personal information

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
