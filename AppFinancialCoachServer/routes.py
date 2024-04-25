from flask import request, jsonify
from firebase_service import fetch_user_expenses, fetch_user_goals, fetch_user_incomes
from methods import detect_anomalies, budget_planning
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
