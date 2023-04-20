import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Initialize the Firebase app
cred = credentials.Certificate('E:\Major Project\App\python\private_key.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://soildata-7a0fa-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

# Initialize the Google Sheets client
scope = ['https://www.googleapis.com/auth/spreadsheets']
cred = ServiceAccountCredentials.from_json_keyfile_name('E:\Major Project\App\python\private_key.json', scope)
client = gspread.authorize(cred)

# Get a reference to the Firebase Realtime Database
ref = db.reference('/realtimeSoilData')

# Read the data from the Realtime Database
data = ref.get()

# Initialize the Google Sheets spreadsheet
sheet = client.open('Periodic Data').sheet1

# Write the data to the spreadsheet
for row in data.values():
    sheet.append_row(row)
