from flask import request, jsonify
from firebase_service import fetch_user_expenses, fetch_user_goals, fetch_user_incomes, fetch_user_profile_info, fetch_current_balance
from methods import detect_anomalies, budget_planning, new_user_cluster
from Models.CheckAnomalyRequestModel import CheckAnomalyRequestModel
from datetime import datetime, timedelta
import pytz
from calendar import monthrange
from pprint import pprint


def filter_last_5_months(items):
    # GET THE LATEST EXPENSE
    # STARTING FROM THE MONTH OF THE LATEST EXPENSE, THAT TAKE THE PREVIOUS 5 MONTHS
    utc = pytz.UTC
    latest_expense_date = max(item['date']
                              for item in items).replace(tzinfo=utc)
    first_day_of_latest_expense_month = latest_expense_date.replace(day=1)

    # Calculate the last day of the month for the latest expense
    last_day_of_latest_expense_month = latest_expense_date.replace(
        day=monthrange(latest_expense_date.year, latest_expense_date.month)[1]
    )

    # Calculate the start date of the 5 months period, starting from the month of the latest expense
    start_of_target_period = first_day_of_latest_expense_month - \
        timedelta(days=150)
    start_of_target_period = start_of_target_period.replace(day=1)

    # Filter items to include the whole month of the latest expense and the previous 5 months
    filtered_items = [item for item in items if start_of_target_period <=
                      item['date'].replace(tzinfo=utc) <= last_day_of_latest_expense_month]

    return filtered_items


def calculate_average_per_month(items):
    filtered_items = filter_last_5_months(items)
    transaction_by_month = {}

    for item in filtered_items:
        month_key = item['date'].strftime('%Y-%m')
        if month_key not in transaction_by_month:
            transaction_by_month[month_key] = []
        transaction_by_month[month_key].append(item['amount'])

    #print("transaction by month: \n")
    # pprint(transaction_by_month)

    # Calculate the total sum of all transactions and the number of months
    total_sum = sum(sum(transactions)
                    for transactions in transaction_by_month.values())
    number_of_months = len(transaction_by_month)

    # Avoid division by zero
    if number_of_months > 0:
        average_amount = total_sum / number_of_months
    else:
        average_amount = 0

    return average_amount


def register_routes(app):

    @app.route('/check_anomalies', methods=['POST'])
    def check_anomalies():
        data = request.json
        user_id = data.get('userId')

        new_expense = CheckAnomalyRequestModel(userId=data.get('userId'), expenseAmount=data.get(
            'expenseAmount'), expenseCategory=data.get('expenseCategory'))

        print("ROUTE CHECK ANOMALIES")
        print("NEW EXPENSE:", new_expense.expenseAmount,
              new_expense.expenseCategory)

        if not user_id:
            return jsonify({"error": "Missing userId in request"}), 400

        expenses_list = filter_last_5_months(fetch_user_expenses(user_id))
        print("EXPENSES LIST:")
        pprint(expenses_list)
        print("DONE ROUTE CHECK ANOMALIES")
        if expenses_list:
            is_anomaly = detect_anomalies(expenses_list, new_expense)
        else:
            return jsonify({"isAnomaly": False}), 200

        return jsonify({"isAnomaly": is_anomaly}), 200

    @app.route('/future_planning', methods=['POST'])
    def future_planning():
        data = request.json
        user_id = data.get('userId')

        if not user_id:
            return jsonify({"error": "Missing userId in request"}), 400

        expenses_list = filter_last_5_months(fetch_user_expenses(user_id))
        incomes_list = filter_last_5_months(fetch_user_incomes(user_id))

        goals = fetch_user_goals(user_id)
        if not expenses_list:
            return jsonify({"error": "No expenses found for user"}), 404

        suggested_list = budget_planning(expenses_list, incomes_list, goals)

        return jsonify(suggested_list)

    @app.route('/cluster_new_user', methods=['POST'])
    def cluster_new_user():
        data = request.json
        user_id = data.get('userId')

        average_expense = calculate_average_per_month(
            fetch_user_expenses(user_id))
        average_income = calculate_average_per_month(
            fetch_user_incomes(user_id))
        goals = fetch_user_goals(user_id)

        profile_score = fetch_user_profile_info(user_id).get("profileScore")
        current_balance = fetch_current_balance(user_id)

        new_user_cluster(average_expense, average_income,
                         goals, profile_score, current_balance)
        return '', 204
