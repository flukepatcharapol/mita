import os 
import datetime
import firebase_admin
import firestore
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime

# Set Firestore DB Credential For Local
private_key_id = os.getenv('FS_KEY_ID')
client_id = os.getenv('FS_CLI_ID')
cred = {
  "type": "service_account",
  "project_id": "line-bot-firebear-sothorn-aqve",
  "private_key_id": private_key_id,
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCjZod8S/4wn1wS\nCAslzQZaJ4gWQcEGt7Q9SWbNEfogEoMPk0t3hW/g9+QSqDuQqMFeBLJRXUI2rHfL\nJa9XfvquWtfOPnPHh1Gv6RWKQ2LWFBYrV14jyHDfVNkmTAwftHQLuNT5Ih4pHTC1\nzZW/bEtAbnMxK7Ei9cYeCK+WyxoOkoVojcMK885qjkm+DDBjs5D5lSaS/3eP25Oh\nKykhi55/xy4fzsBHODLGyJqaN0TpwkSpY81w39xFfdG26YbMBYWSSpRaCOBYFXNL\nNsBBsH5GaIlhePr/BgXFQjDYr8G3ZdZm8nI+2s27uJmDC9R1889q9G6by5an704j\nZHEwlop9AgMBAAECggEADespZlKY0+53KsgJnw4wWNSeOHsgZKCYV1Id0iESY9H/\n3P9IgeVZatni0R4IeOGPGyGeSOT/Q2X8jE7o+TSFSP3O/S//r8Lcl/XsUks8K40p\neEaoa7biunthRexbagX2jpsPdStNU2Y7pHjfJR+l51ahNFKK87Xoyt0li9xAG3aH\nvR0KYfXLUUAh7R8hy8LYnCpIqKoIhlsxyoeGxi/xrzzwmIT6ySfzhe3Vu1qX2itL\nOD2QgIvct+xNg9jkVtjLAWbqElrRDkT3XG8pHmjx7dfXLuOWT/6xAfAtKHQVTPzI\nLO4L75uhMJuLBEgtw7/wF5D8rs2FwrVQGX3wMd69UQKBgQDblrAc3dU9EgNArzSb\nLOUyzCodYDkZAUDHTopXxoKLt+w7axG9rp1pCAtZGCARLDESUOQLXeCmgP51gaay\nlBQ/Ckv6wqbgEeILw6MKe+gwJGRGTlyj7KegTyOC1AQ5//7eaYpSR16xWtc1q5sA\nWs0na5nNspb98r/d8DC9/Wb4aQKBgQC+fraUIZnduDouKwTZHHRVGNsY1pHDFPr0\najr0RDA3/FtD5hPfk97VH40ZGVZFEAkM8n+tndwjxz97wE43TkrAHRqqgB1+cotI\n1R8F4e+irln3+OnjNXMZ1hdiTSjqg2s52sYpeaAqCHqvrNR/dMsV/JlTz6FkB5xn\nnFQomqqe9QKBgC5ow6HmNHoqw2s5XFnrfClnQwNgYdDqFeHJtK1mdBLJdXD9aQt4\nyyX2oEddNPHMMDbZx8irN56ZJq55D10wtLK6H2LJHvG+ddLcrym5FFKQbmz5hNTU\nYH0eHLg6zQXhF+Gz1psbIGVFeLSMJz9E8ZUCRchWlVjopCpo6DRPSSL5AoGBAJWc\nz6jn+wC4gHliMByUzIlJTErluvWMtMzh4guWwog2GzforBMdABZDAX6E98ymG3Wf\nv8eMBCnVg3aeQtANHYhlU1w14vQ84kgBmqv0F1GdveuUA53/jLbt/s+l6kzFiqGV\nwa0xaSmaH0F6bCruf9J04beBizAVCjIWBcMeNoNBAoGAfYCeGciMXgJHFsZF7klp\nlMBDE3PjWr1gOYMG3MuKmMRTiTyi7Zn6K1GjNItnj5eQnZup0NQpw6zW98TIgPqG\ndTwzEXmOAJZ1mapQjDs4VZ25tZhmhsfwsVfW+ubOoWP04vglZXvppI08yBIP/eaL\nxKBP3fBzlgeB0H+FFO1OAbU=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-he355@line-bot-firebear-sothorn-aqve.iam.gserviceaccount.com",
  "client_id": client_id,
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-he355%40line-bot-firebear-sothorn-aqve.iam.gserviceaccount.com"
}
creds = firebase_admin.credentials.Certificate(cred)
firebase_admin.initialize_app(creds)
db=firestore.client()

class Uploader ():
    def sendToFireStoreCollection (self,delivery,orderDate,point,bill,price,amount,product_list):
             
        #Convert to expected format and data type
        date_time_obj = datetime.strptime(orderDate, '%d-%m-%Y')
        new_format = orderDate.strftime('%Y-%m-%d')
        str_orderDate = str(new_format)
        str_orderDate = str_orderDate.replace( '-' , '' )  #Remove - from input date
        int_point = int(point)
        float_price = float(price)
        int_amount = int(amount)
        
        #Check and create Document
        doc_date=db.collection('Order').document(str_orderDate).get()
        if doc_date.exists:
            #Set destination and add the data to target document
            db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).update({
            'Delivery':delivery,
            'BillID':bill,
            'OrderDate':date_time_obj,
            'ProductList':product_list,
            'AmountOfCups': int_amount,
            'Point':int_point,
            'SubTotalBillPrice':float_price
        })
            
        #Create the document if the document is not yet exist
        else: 
            # Create Document for this date
            db.collection('Order').document(str_orderDate).set({})
            
            #Add the data to the document
            db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).set({
            'Delivery':delivery,
            'BillID':bill,
            'OrderDate':date_time_obj,
            'ProductList':product_list,
            'AmountOfCups': int_amount,
            'Point':int_point,
            'SubTotalBillPrice':float_price
        })
            
        
        #Check that Order-date-OrderDeatil-BillId should exist and return result
        check=db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).get()
        
        if check.exists:
            
            return True
        
        else:
            
            return False

    def getPrevNumber (self, date):
        str_orderDate = str(date)
        str_orderDate = str_orderDate.replace( '-' , '' )  #Remove - from input date
        
        #Set destination
        line=db.collection('Mita').document(str_orderDate).get()

        
        if line.exists:
            return line.to_dict()
        else:
            result = {'line': 'False'}
            return result
        

    def setPrevNumber (self, date, prev_number):
        prev_number = int(prev_number)
        str_orderDate = str(date)
        str_orderDate = str_orderDate.replace( '-' , '' )  #Remove - from input date

        prev=db.collection('Mita').document(str_orderDate).get()
        if prev.exists:
            db.collection('Mita').document(str_orderDate).update({
                'line': prev_number
            })
        else:
            db.collection('Mita').document(str_orderDate).set({
                'line': prev_number,
            })
            
    
    def deletePrevNumDoc (self, date):
        str_orderDate = str(date)

        db.collection('Mita').document(str_orderDate).delete()

    def deleteAllOlderDoc (self, date):
        str_orderDate = str(date)
        
        #Get all doc from collection Mita
        col=db.collection('Order').get()
        result= []
        
        #Search and get every doc that older than $date
        for doc in col:
            if doc.id <= str_orderDate:
                result.append(doc.id)

        #Delete every doc from the list
        for doc_id in result:
            db.collection('Order').document(doc_id).delete()
        
        #Check and if not failed add to list
        list_of_failed = []
        for check_doc in result:
            check_result=db.collection('Order').document(check_doc).get()
            if check_result.exists:
                list_of_failed.append(check_doc)

        #Return the list of failed doc
        return  list_of_failed
        
    def deleteAllOlderPrev (self, date):
        str_orderDate = str(date)
        
        #Get all doc from collection Mita
        col=db.collection('Mita').get()
        result= []
        
        #Search and get every doc that older than $date
        for doc in col:
            if doc.id <= str_orderDate:
                result.append(doc.id)

        #Delete every doc from the list
        for doc_id in result:
            db.collection('Mita').document(doc_id).delete()
        
        #Check and if not failed add to list
        list_of_failed = []
        for check_doc in result:
            check_result=db.collection('Mita').document(check_doc).get()
            if check_result.exists:
                list_of_failed.append(check_doc)

        #Return the list of failed doc
        return  list_of_failed