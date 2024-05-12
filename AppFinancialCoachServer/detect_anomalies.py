import pandas as pd
from sklearn.preprocessing import StandardScaler
import numpy as np
from tensorflow.keras.layers import Input, Dense
from collections import defaultdict
from pprint import pprint
from tensorflow.keras.models import Sequential


def detect_anomalies(expenses_list, new_expense):
    expenses = pd.DataFrame(expenses_list)

    # Assuming new_expense is an object with attributes expenseCategory and expenseAmount
    print("New expense category:", new_expense.expenseCategory)
    print("New expense amount:", new_expense.expenseAmount)

    # Organize data by category and month
    expenses['date'] = pd.to_datetime(expenses['date'])
    months = sorted(expenses['date'].dt.strftime('%b').unique())
    df = defaultdict(lambda: defaultdict(float))

    for index, expense in expenses.iterrows():
        month = expense['date'].strftime('%b')
        category = expense['parentCategory']
        amount = expense['amount']
        df[category][month] += amount

    df = {category: [expenses.get(month, 0) for month in months]
          for category, expenses in df.items()}

    for category, expenses_list in df.items():
        if len(expenses_list) < len(months):
            expenses_list.extend([0] * (len(months) - len(expenses_list)))

    df = {'Month': months, **df}
    pprint(df)

    # Use StandardScaler for normalization
    data_for_model = np.array(df[new_expense.expenseCategory]).reshape(-1, 1)
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(data_for_model)

    # Neural network model
    model = Sequential()
    model.add(Dense(10, input_dim=1, activation='relu'))
    model.add(Dense(1, activation='linear'))
    model.compile(loss='mean_squared_error', optimizer='adam')

    # Train the model
    model.fit(scaled_data, scaled_data, epochs=100, verbose=0)

    # Scale the new expense amount for prediction
    new_expense_scaled = scaler.transform([[new_expense.expenseAmount]])

    # Predict and calculate error
    prediction = model.predict(new_expense_scaled)
    error = np.abs(new_expense_scaled - prediction)

    # Determine if an anomaly based on a set threshold
    threshold = 1.5 * np.mean(np.abs(scaled_data - model.predict(scaled_data)))
    is_anomaly = error > threshold

    print("Scaled new expense:", new_expense_scaled)
    print("Prediction:", prediction)
    print("Error:", error)
    print("Threshold:", threshold)
    print("Is anomaly?", is_anomaly[0][0])

    return is_anomaly[0][0]