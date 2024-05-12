import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin
cred = credentials.Certificate('firebase-adminsdk.json')
firebase_admin.initialize_app(cred)

db = firestore.client()


def get_user_doc(user_id):
    user_ref = db.collection('users').document(user_id)
    return user_ref.get()


def fetch_user_expenses(user_id):
    doc = get_user_doc(user_id)

    expenses_list = []
    if doc.exists:
        user_data = doc.to_dict()
        expenses_list = user_data.get("expenses", [])

    return expenses_list


def fetch_user_goals(user_id):
    doc = get_user_doc(user_id)

    goals_list = []
    if doc.exists:
        user_data = doc.to_dict()
        goals_list = user_data.get("goals", [])
    return goals_list


def fetch_user_incomes(user_id):
    doc = get_user_doc(user_id)

    incomes_list = []
    if doc.exists:
        user_data = doc.to_dict()
        incomes_list = user_data.get("incomes", [])

    return incomes_list


def fetch_user_profile_info(user_id):
    doc = get_user_doc(user_id)

    if doc.exists:
        user_data = doc.to_dict()
        profile_info = user_data.get("personalInfo", {})
    return profile_info


def fetch_current_balance(user_id):
    doc = get_user_doc(user_id)

    if doc.exists:
        user_data = doc.to_dict()
        current_balance = user_data.get("currentBalance")
        if current_balance is not None:
            return current_balance
        else:
            print("currentBalance is not set for this user")
            return 0 
