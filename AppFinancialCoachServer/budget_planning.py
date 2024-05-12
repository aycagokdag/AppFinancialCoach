import pandas as pd
from datetime import datetime
import pytz
import sys
from pprint import pprint
from joblib import dump, load
from utils import required_monthly_savings, calculate_net_savings


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
    # flexibility_scores = calculate_flexibility_scores(expenses_list)

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


def get_current_expense_breakdown(expenses_list):
    categorized_expenses = {}

    for expense in expenses_list:
        month_year_string = expense["date"].strftime("%Y-%m")

        if month_year_string not in categorized_expenses:
            categorized_expenses[month_year_string] = {}

        if expense["parentCategory"] not in categorized_expenses[month_year_string]:
            categorized_expenses[month_year_string][expense["parentCategory"]] = [
            ]

        categorized_expenses[month_year_string][expense["parentCategory"]].append(
            expense)

    monthly_spending_by_category = {}

    for month_year, expenses_by_category in categorized_expenses.items():
        monthly_spending_by_category[month_year] = {}

        for parent_category, expenses in expenses_by_category.items():
            total_spending = sum(expense["amount"] for expense in expenses)
            monthly_spending_by_category[month_year][parent_category] = total_spending

    total_spending_by_category = {}

    for _, spending_by_category in monthly_spending_by_category.items():
        for category, spending in spending_by_category.items():
            if category not in total_spending_by_category:
                total_spending_by_category[category] = 0.0
            total_spending_by_category[category] += spending

    for category, spending in total_spending_by_category.items():
        total_spending_by_category[category] /= 5

    print("total spending by category", total_spending_by_category)

    return total_spending_by_category


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
    current_expense_breakdown = get_current_expense_breakdown(expenses_list)

    print("adjustments here:")
    pprint(adjustments)
    for category, amount in adjustments.items():
        original_amount = current_expense_breakdown.get(category, 0)
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
