import os 
import datetime
import collections
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
    
    def setExpectedTimeFormat (self, str_date):
        date_time_obj = datetime.strptime(str_date, '%d-%m-%Y')
        new_format = datetime.strftime(date_time_obj,'%Y%m%d')
        str_orderDate = str(new_format)
        return str_orderDate
        
    def sendToFireStoreCollection (self,delivery,orderDate,point,bill,price,amount,product_list):
             
        #Convert to expected format and data type
        date_time_obj = datetime.strptime(orderDate, '%d-%m-%Y')
        str_orderDate=self.setExpectedTimeFormat(orderDate)
        int_point = int(point)
        float_price = float(price)
        int_amount = int(amount)
        
        #Check and create Document
        doc_date=db.collection('Order').document(str_orderDate).get()
        if doc_date.exists:
            
            db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).set({
                'Delivery':delivery,
                'BillID':bill,
                'OrderDate':date_time_obj,
                'ProductList':product_list,
                'AmountOfCups': int_amount,
                'Point':int_point,
                'SubTotalBillPrice':float_price
            }, merge=True)
            
            
        #Create the document if the document is not yet exist
        else: 
            
            #Create Document for this date=str_orderDate and init Saletotal 
            db.collection('Order').document(str_orderDate).set({})
            
            #Add the bill data to the date document
            db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).set({
            'Delivery':delivery,
            'BillID':bill,
            'OrderDate':date_time_obj,
            'ProductList':product_list,
            'AmountOfCups': int_amount,
            'Point':int_point,
            'SubTotalBillPrice':float_price
        }, merge=True)

    def getPrevNumber (self, date):
        str_orderDate=self.setExpectedTimeFormat(date)
        
        #Set destination
        line=db.collection('Mita').document(str_orderDate).get()
        if line.exists:
            
            return line.to_dict()
        
        else:
            
            result = {'line': 'False'}
            return result
        

    def setPrevNumber (self, date, prev_number):
        str_orderDate=self.setExpectedTimeFormat(date)
        prev_number = int(prev_number)
        db.collection('Mita').document(str_orderDate).set({
                'line': prev_number,
            })
            

    def deleteAllOlderDoc (self, date):
        str_orderDate=self.setExpectedTimeFormat(date)
        
        #Get all doc from collection Mita
        col=db.collection('Order').get()
        older_doc= []
        
        #Search and get every doc that older than $date
        for doc in col:
            if doc.id < str_orderDate:
                older_doc.append(doc.id)
        #Check if there are no doc older than 7 days then return False
        if not older_doc:
            return False
        
        #Delete every Document from the list
        for doc_date in older_doc:
            
            #Get all bill id from date subcollection and add to list
            doc_bill=db.collection('Order').document(doc_date).collection('OrderDetail').get()
            for bill in doc_bill:
                db.collection('Order').document(doc_date).collection('OrderDetail').document(bill.id).delete()
                
            #Delete date document
            db.collection('Order').document(doc_date).delete()
        
        #Check and if not failed add to list
        list_of_failed = []
        for check_doc in older_doc:
            check_result=db.collection('Order').document(check_doc).get()
            if check_result.exists:
                list_of_failed.append(check_doc)

        #Return the list of failed doc
        return  list_of_failed
        
    # def deleteAllOlderPrev (self, date):
    #     str_orderDate=self.setExpectedTimeFormat(date)
        
    #     #Get all doc from collection Mita
    #     col=db.collection('Mita').get()
    #     result= []
        
    #     #Search and get every doc that older than $date
    #     for doc in col:
    #         if doc.id < str_orderDate:
    #             result.append(doc.id)

    #     #Delete every doc from the list
    #     for doc_id in result:
    #         db.collection('Mita').document(doc_id).delete()
        
    #     #Check and if not failed add to list
    #     list_of_failed = []
    #     for check_doc in result:
    #         check_result=db.collection('Mita').document(check_doc).get()
    #         if check_result.exists:
    #             list_of_failed.append(check_doc)

    #     #Return the list of failed doc
    #     return  list_of_failed

    def billShouldExist (self, bill_list, date):
        str_orderDate=self.setExpectedTimeFormat(date)
        
        doc_date=db.collection('Order').document(str_orderDate).collection('OrderDetail').get()
        
        doc_list = []
        for doc in doc_date:
            doc_list.append(doc.id)
        
        # Check if the list of bill exist in the doc date
        is_sucess_list = []
        not_existing_list = []
        existing_list = []
        for bill in bill_list:
            if bill in doc_list:
                
                is_sucess_list.append('success')
                existing_list.append(bill)

            else:
                
                is_sucess_list.append('failed')
                not_existing_list.append(bill)
        
        #If any bill not exist return false
        if 'failed' in is_sucess_list:
            
            return False, not_existing_list
        
        else:
            
            return True, existing_list
        
    def updateDeliveryBillToCloud (self,bill_dict):
        #Get key list and get data date
        key_list = bill_dict.keys()
        orderDate = bill_dict.get(key_list[0]).get('Order_date')
        str_orderDate=self.setExpectedTimeFormat(orderDate)
        
        doc_date=db.collection('Order').document(str_orderDate).get()
        #Check if the date document is already exist
        if doc_date.exists:
            date_db=db.collection('Order').document(str_orderDate).collection('OrderDetail').get()
            #Get list of bill in the date document
            fs_bill_list = []
            if date_db.exists:
                for doc in date_db:
                    fs_bill_list.append(doc.id)
            
            #Check if the bill_dict already up to date
            is_new = collections.Counter(fs_bill_list) != collections.Counter(key_list)
            if is_new:
                #Check to get exist and non-exist bill from date document
                not_exist_list = []
                exist_list = []
                for bill in key_list:
                    if bill not in fs_bill_list:
                        not_exist_list.append(bill)
                    else:
                        exist_list.append(bill)
                
                #Append all non-exist bill value to not_exist_dict_list prepare to add to Firestore
                not_exist_dict_list = []
                for key in not_exist_list:
                    dict = bill_dict.get(key)
                    not_exist_dict_list.append(dict)
                
                #Update/add every non-exist bill to Firestore
                for bill in not_exist_dict_list:
                    delivery=bill.Type
                    bill_id=bill.Bill_id
                    date=bill.Order_date
                    # product_list=bill.Product_list
                    amount=bill.Amount
                    point=bill.Point
                    price=bill.Price
                    
                    date_time_obj = datetime.strptime(date, '%d-%m-%Y')
                    amount_int = int(amount)
                    point_int = int(point)
                    price_float = float(price)
                    bill_db=db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill_id).get()
                    if bill_db.exists:  #If the bill is already exist, do the update
                    
                        db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).update({
                            'Delivery':delivery,
                            'BillID':bill,
                            'OrderDate':date_time_obj,
                            # 'ProductList':product_list,
                            'AmountOfCups': amount_int,
                            'Point':point_int,
                            'SubTotalBillPrice':price_float
                        })
                    
                    else:  #If the bill is not exist, do the set new doc
                    
                        db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).set({
                            'Delivery':delivery,
                            'BillID':bill,
                            'OrderDate':date_time_obj,
                            # 'ProductList':product_list,
                            'AmountOfCups': amount_int,
                            'Point':point_int,
                            'SubTotalBillPrice':price_float
                        })
                #Return is_update = true and the new dawdupdate list
                return True, not_exist_list
            else:
                #Return is_update=False
                return False
            
        #If document date is not exist
        else: 
                
            #Create Document for this date=str_orderDate and init Saletotal 
            db.collection('Order').document(str_orderDate).set({})
                
            for bill in bill_dict:
                delivery=bill.Type
                bill_id=bill.Bill_id
                date=bill.Order_date
                # product_list=bill.Product_list
                amount=bill.Amount
                point=bill.Point
                price=bill.Price
                
                date_time_obj = datetime.strptime(date, '%d-%m-%Y')
                amount_int = int(amount)
                point_int = int(point)
                price_float = float(price)
                
                #Add the bill data to the date document
                db.collection('Order').document(str_orderDate).collection('OrderDetail').document(bill).set({
                    'Delivery':delivery,
                    'BillID':bill,
                    'OrderDate':date_time_obj,
                    # 'ProductList':product_list,
                    'AmountOfCups': amount_int,
                    'Point':point_int,
                    'SubTotalBillPrice':price_float
                })
            return True, key_list
    
    def removeRedeemHistory (self, used_due_date, expire_date):
        # used_time_obj = datetime.strptime(used_due_date, '%d-%m-%Y')
        expired_time_obj = datetime.strptime(expire_date, '%d-%m-%Y')
        expired = db.collection('RedeemHistory').where('ExpiredDate', '<=', expired_time_obj).get()
        used = db.collection('RedeemHistory').where('UsedDate', '==', expired_time_obj).get()
        # delete_list = []
        # for doc in expired:
        #     used_date = doc.get('UsedDate')
        #     delete_list.append(used_date)
            # if used_date == None:
            #     delete_list.append(doc.id)
        # for doc in used:
        #     delete_list.append(doc.id)
        
        # return delete_list