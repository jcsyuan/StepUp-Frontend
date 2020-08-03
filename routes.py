# aws server
# http://3.14.11.198:5000/

# local server
# http://127.0.0.1:5000/ 


import mysql.connector
import jwt
from flask import request
from app import app


# choose which database to connect to
local_db = True
def connect(local_database, include_database=True):
    options={
        "host":"db.c5lxfxfeobzr.us-east-2.rds.amazonaws.com",
        "user":"admin",
        "password":"Jonnatkeldash123",
        "port":3306,
    }
    if local_database:
        options["host"]="localhost"
        options["user"]="root"
        options["password"]="Neehowma01"
        options["port"]=3306
    if include_database:
        options["database"]="db"
    return mysql.connector.connect(**options)

# initial endpoint
@app.route('/')
@app.route('/index')
def index():
    return "makin moves"

# create database
@app.route('/create-database')
def create_database():
    mydb = connect(local_database=local_db, include_database=False)
    mycursor = mydb.cursor()
    mycursor.execute("CREATE DATABASE db")
    return {}
        
# create tables: accounts, steps, friendships, friendship_requests, worn_items, bag, historical_rankings, shop
@app.route('/create-tables', methods=['POST'])
def create_tables():
    mydb = connect(local_database=local_db)
    mycursor = mydb.cursor()
    mycursor.execute("CREATE TABLE accounts (user_id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255), password VARCHAR(255), display_name VARCHAR(255), email VARCHAR(255), coins INT, token VARCHAR(255))")
    mycursor.execute("CREATE TABLE steps (user_id INT PRIMARY KEY, daily_steps INT,weekly_steps INT, aggregate_steps INT, highest_daily_steps INT, highest_weekly_steps INT)")
    mycursor.execute("CREATE TABLE friendships (user_id INT, friend_id INT, PRIMARY KEY(user_id, friend_id))")
    mycursor.execute("CREATE TABLE friendship_requests (user_id INT, friend_id INT, accepted BOOLEAN, PRIMARY KEY(user_id, friend_id))")
    mycursor.execute("CREATE TABLE worn_items (user_id INT, item_id INT, PRIMARY KEY(user_id, item_id))")
    mycursor.execute("CREATE TABLE bag (user_id INT, item_id INT, category_id INT, PRIMARY KEY(user_id, item_id, category))")
    mycursor.execute("CREATE TABLE historical_data (user_id INT , user_rank INT, steps_that_week INT, end_date DATE, PRIMARY KEY(user_id, end_date))")
    mycursor.execute("CREATE TABLE items (item_id INT AUTO_INCREMENT, item_cost INT, category_id INT, PRIMARY KEY(item_id))")
    mycursor.execute("CREATE TABLE categories (category_id INT AUTO_INCREMENT PRIMARY KEY, category_name VARCHAR(255))")
    return {}

# initialize a new account
@app.route('/initialize-account', methods=['POST'])
def initialize_account():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    username = data['username']
    password = data['password']
    display_name = data['display_name']
    email = data['email']
    coins = data['coins']
    # check if username exists in database
    result = {}
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT COUNT(1) FROM accounts WHERE username = '{username}' OR email = '{email}'")
    myresult = mycursor.fetchall()
    request_exists = myresult[0][0]
    if request_exists == 1:
        result["created"] = "false"
        return result
    result["created"] = "true"
    # authentication token
    token = jwt.encode({"username": username}, password)
    # put data into db
    mycursor = mydb.cursor()
    sql = "INSERT INTO accounts (username, password, display_name, email, coins, token) VALUES (%s, %s, %s, %s, %s, %s)"
    val = (username, password, display_name, email, coins, token)
    mycursor.execute(sql, val)
    mydb.commit()
    # get user_id
    mycursor.execute(f"SELECT user_id FROM accounts WHERE username = '{username}'")
    myresult = mycursor.fetchall()
    user_id = myresult[0][0]
    # initialize 'steps' data
    sql = "INSERT INTO steps (user_id, daily_steps, weekly_steps, aggregate_steps, highest_daily_steps, highest_weekly_steps) VALUES (%s, %s, %s, %s, %s, %s)"
    val = (user_id, 0, 0, 0, 0, 0)
    mycursor.execute(sql, val)
    mydb.commit()
    # initialize 'worn_items' data
    sql = "INSERT INTO worn_items (user_id, item_id) VALUES (%s, %s)"
    val = [(user_id, 1), (user_id, 2), (user_id, 3), (user_id, 4)]
    mycursor.executemany(sql, val)
    mydb.commit()
    # initialize 'bag' data
    sql = "INSERT INTO bag (user_id, item_id, category_id) VALUES (%s, %s, %s)"
    val = [(user_id, 1, 1), (user_id, 2, 2), (user_id, 3, 3), (user_id, 4, 4)]
    mycursor.executemany(sql, val)
    mydb.commit()
    return result
    
# get all steps data
@app.route('/login', methods=['POST'])
def login():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    username= data['username']
    password = data['password']
    # check if username exists in database
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT COUNT(1) FROM accounts WHERE username = '{username}' AND password = '{password}'")
    myresult = mycursor.fetchall()
    request_exists = myresult[0][0]
    # return token if username and password match
    result = {}
    if request_exists == 1:
        sql = f"SELECT user_id, token FROM accounts WHERE username = '{username}'"
        mycursor.execute(sql)
        myresult = mycursor.fetchall()
        result["user_id"] = myresult[0][0]
        result["token"] = myresult[0][1]
        return result
    result["user_id"] = 0
    result["token"] = "0"
    return result

# update steps
@app.route('/update-steps', methods=['POST'])
def update_steps():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    new_steps = data['new_steps']
    step_category = data['step_category']
    # update steps in database
    mycursor = mydb.cursor()
    sql = f"UPDATE steps SET {step_category} = '{new_steps}' WHERE user_id = '{user_id}'"
    mycursor.execute(sql)
    mydb.commit()
    return {}

# get all steps data
@app.route('/get-steps-data', methods=['GET'])
def get_steps_data():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    # get 'steps' data from database for specific user_id row
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT * FROM steps WHERE user_id = '{user_id}'")
    myresult = mycursor.fetchall()
    # concatenate data into json object
    result = {}
    result['daily_steps'] = myresult[0][1]
    result['weekly_steps'] = myresult[0][2]
    result['aggregate_steps'] = myresult[0][3]
    result['highest_daily_steps'] = myresult[0][4]
    result['highest_weekly_steps'] = myresult[0][5]
    return result

# get worn items for avatar
@app.route('/get-worn-items', methods=['GET'])
def get_worn_items():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    # get 'worn_items' data for specific user_id
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT w.*, c.category_name FROM worn_items AS w JOIN items AS i USING (item_id) JOIN categories AS c ON i.category_id = c.category_id WHERE user_id = '{user_id}'")
    # concatenate data to json object 'result'
    items = []
    for item_data in mycursor:
        temp = {}
        temp["item_id"] = item_data[1]
        temp["category_name"] = item_data[2]
        items.append(temp)
    result = {}
    result["results"] = items
    return result

# get bag items for bag tab
@app.route('/get-owned-items', methods=['GET'])
def get_owned_items():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    # get items that are associated with user_id
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT b.item_id, c.category_name FROM bag AS b JOIN categories AS c ON b.category_id = c.category_id WHERE user_id = '{user_id}'")
    # concatenate data into json object
    items = []
    for item_data in mycursor:
        temp = {}
        temp["item_id"] = item_data[0]
        temp["category_name"] = item_data[1]
        items.append(temp)
    result = {}
    result["results"] = items
    return result

# get id associated with username
@app.route('/get-user-id', methods = ['POST'])
def get_user_id():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    username = data['username']
    # get user_id associated with username
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT user_id FROM accounts WHERE username = '{username}'")
    myresult = mycursor.fetchall()
    result = {}
    result["friend_id"] = myresult[0][0]
    return result

# get account data
@app.route('/get-account-data', methods = ['GET'])
def get_account_data():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    # get user_id associated with username
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT username, display_name, coins FROM accounts WHERE user_id = '{user_id}'")
    myresult = mycursor.fetchall()
    result= {}
    result['username'] = myresult[0][0]
    result['display_name'] = myresult[0][1]
    result['coins'] = myresult[0][2]
    return result

# get all friends
@app.route('/get-friends', methods = ['POST'])
def get_friends():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    # get friend ids from 'friendship' database
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT a.display_name FROM friendships as f JOIN accounts as a ON f.user_id = '{user_id}' AND a.user_id = f.friend_id")
    friend_id_result = []
    for x in mycursor:
        friend_id_result.append(x[0])
    result = {}
    result["result"] = friend_id_result
    return result

# get daily steps
@app.route('/get-daily-steps', methods=['POST'])
def get_daily_steps():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    # get 'steps' data from database for specific user_id row
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT daily_steps FROM steps WHERE user_id = '{user_id}'")
    myresult = mycursor.fetchall()
    # concatenate data into json object
    result = {}
    result['daily_steps'] = myresult[0][0]
    return result

# get all items
@app.route('/get-unowned-items', methods=['GET'])
def get_unowned_items():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    # get all unowned items
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT i.item_id, c.category_name FROM items AS i LEFT JOIN bag AS b ON i.item_id = b.item_id AND user_id='{user_id}' JOIN categories AS c ON i.category_id = c.category_id WHERE b.item_id IS NULL")
    # concatenate data into json object
    items = []
    for item_data in mycursor:
        temp = {}
        temp["item_id"] = item_data[0]
        temp["category_name"] = item_data[1]
        items.append(temp)
    result = {}
    result["results"] = items
    return result

# buy an item
@app.route('/buy-item', methods=['POST'])
def buy_item():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    item_id = data['item_id']
    item_cost = data['item_cost']
    category_id = data['category_id']
    # get all item id's 'item' table
    mycursor = mydb.cursor()
    sql = "INSERT INTO bag (user_id, item_id, category_id) VALUES (%s, %s, %s)"
    val = (user_id, item_id, category_id)
    mycursor.execute(sql ,val)
    mydb.commit()
    # update user's coins
    mycursor.execute(f"UPDATE accounts SET coins = coins - '{item_cost}' WHERE user_id = '{user_id}'")
    mydb.commit()
    return {}

# return user's coins
@app.route('/get-coins', methods=['GET'])
def get_coins():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    # get all item id's 'item' table
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT coins FROM accounts WHERE user_id = '{user_id}'")
    myresult = mycursor.fetchall()
    return str(myresult[0][0])

# update 'highest' data
@app.route('/update-highest-data', methods=['POST'])
def update_highest_data():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    new_steps = int(data['new_steps'])
    step_category = data['step_category']
    # get current steps in table
    mycursor = mydb.cursor()
    sql = f"SELECT {step_category} FROM steps WHERE user_id = '{user_id}'"
    mycursor.execute(sql)
    myresult = mycursor.fetchall()
    curr_steps = myresult[0][0]
    # if new_steps > curr_steps, replace
    if curr_steps < new_steps:
        sql = f"UPDATE steps SET {step_category} = '{new_steps}' WHERE user_id = '{user_id}'"
        mycursor.execute(sql)
        mydb.commit()
    return {}

# update historical data and aggregate steps
@app.route('/weekly-update', methods=['POST'])
def weekly_update():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    rank = data['rank']
    steps_that_week = data['steps_that_week']
    end_date = data['end_date']
    # send in data to historical data table
    mycursor = mydb.cursor()
    sql = "INSERT INTO historical_data (user_id, user_rank, steps_that_week, end_date) VALUES (%s, %s, %s, %s)"
    val = (user_id, rank, steps_that_week, end_date)
    mycursor.execute(sql, val)
    mydb.commit()
    # update aggregate steps
    sql = f"UPDATE steps SET aggregate_steps = aggregate_steps + {steps_that_week} WHERE user_id = '{user_id}'"
    mycursor.execute(sql)
    mydb.commit()
    return {}

# change password
@app.route('/change-password', methods=['POST'])
def change_password():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    old_password = data['old_password']
    new_password = data['new_password']
    # send in data to historical data table
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT password FROM accounts WHERE user_id = '{user_id}'")
    myresult = mycursor.fetchall()
    curr_password = myresult[0][0]
    if curr_password == old_password:
        mycursor.execute(f"UPDATE accounts SET password = '{new_password}' WHERE user_id = '{user_id}'")
        mydb.commit()
        return str(True)
    else:
        return str(False)

# send friend request
@app.route('/send-friend-request', methods=['POST'])
def send_friend_request():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    friend_id = data['friend_id']
    # send in data to friendship requests
    mycursor = mydb.cursor()
    # check to see if friendship exists
    mycursor.execute(f"SELECT COUNT(1) FROM friendships WHERE user_id = '{user_id}' AND friend_id = '{friend_id}'")
    myresult = mycursor.fetchall()
    request_exists = myresult[0][0]
    if request_exists == 1:
        return "friendship already exists"
    # check to see if you already sent this friendship request
    mycursor.execute(f"SELECT COUNT(1) FROM friendship_requests WHERE user_id = '{user_id}' AND friend_id = '{friend_id}'")
    myresult = mycursor.fetchall()
    request_exists = myresult[0][0]
    if request_exists == 1:
        return "request already sent"
    # if none of the above then send friendship request
    sql = "INSERT INTO friendship_requests (user_id, friend_id, accepted) VALUES (%s, %s, %s)"
    val = (user_id, friend_id, False)
    mycursor.execute(sql, val)
    mydb.commit()
    return "request sent"

# return your friend requests
@app.route('/get-friend-requests', methods=['POST'])
def get_friend_requests():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    # send in data to friendship requests
    mycursor = mydb.cursor()
    # check to see if friendship exists
    mycursor.execute(f"SELECT a.username FROM friendship_requests as f JOIN accounts as a ON f.friend_id = '{user_id}' AND a.user_id = f.user_id")
    ids = []
    for friend_id in mycursor:
        print(friend_id[0])
        ids.append(friend_id[0])
    result = {}
    result["results"]=ids
    return result

# accepting/declining friend request
@app.route('/accept-decline-request', methods=['POST'])
def accept_decline_request():
    mydb = connect(local_database=local_db)
    # get body data
    data = request.form
    user_id = data['user_id']
    friend_username = data['friend_username']
    response = data['response']
    # send in data to friendship requests
    mycursor = mydb.cursor()
    # get friend id from friend username
    mycursor.execute(f"SELECT user_id FROM accounts WHERE username = '{friend_username}'")
    myresult = mycursor.fetchall()
    friend_id = myresult[0][0]
    # check to see if friendship exists
    mycursor.execute(f"SELECT COUNT(1) FROM friendships WHERE user_id = '{user_id}' AND friend_id = '{friend_id}'")
    myresult = mycursor.fetchall()
    request_exists = myresult[0][0]
    if request_exists == 1:
        return "friendship already exists"
    # if not friends and accepted
    if response == "accept":
        sql = "INSERT INTO friendships (user_id, friend_id) VALUES (%s, %s)"
        # add user, friend friendship
        val = (user_id, friend_id)
        mycursor.execute(sql, val)
        mydb.commit()
        # add friend, user friendship
        val = (friend_id, user_id)
        mycursor.execute(sql, val)
        mydb.commit()
        # check to see if user also sent friend request
        mycursor.execute(f"SELECT COUNT(1) FROM friendship_requests WHERE user_id = '{user_id}' AND friend_id = '{friend_id}'")
        myresult = mycursor.fetchall()
        request_exists = myresult[0][0]
        # if user also sent friend request then delete that request
        if request_exists == 1:
            mycursor.execute(f"DELETE FROM friendship_requests WHERE user_id = '{user_id}' AND friend_id = '{friend_id}'")
            mydb.commit()
    # delete this request no matter the response
    mycursor.execute(f"DELETE FROM friendship_requests WHERE user_id = '{friend_id}' AND friend_id = '{user_id}'")
    mydb.commit()
    return "request handled"

# get all friends
@app.route('/get-friends-steps', methods = ['POST'])
def get_friends_steps():
    mydb = connect(local_database=local_db)
    # get body data
    data= request.form
    user_id = data['user_id']
    # get friend ids from 'friendship' database
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT a.display_name FROM friendships as f JOIN accounts as a ON f.user_id = '{user_id}' AND a.user_id = f.friend_id")
    friend_id_result = []
    for x in mycursor:
        friend_id_result.append(x[0])
    result = {}
    result["result"] = friend_id_result
    return result

