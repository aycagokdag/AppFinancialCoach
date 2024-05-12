from datetime import datetime
import pytz


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
