import datetime
import collections
import firebase_admin
import firestore
import google.cloud.firestore
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore import ArrayUnion

from datetime import datetime

#Set Firestore DB Credential
cred=credentials.Certificate("D:\\Code\\accessKey-test.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

class Uploader ():
    def sendToFireStoreCollection (self,delivery,earnedDate,lineUserId,orderDate,point,bill,price,amount,product_list):
        #Set Firestore DB Credential
        cred=credentials.Certificate("D:\\Code\\accessKey-test.json")
        fb_app = firebase_admin.initialize_app(cred)
        db=firestore.client()

        print("delivery type",delivery)
        print("earn date",earnedDate)
        print("lineUserId",lineUserId)
        print("orderDate",orderDate)
        print("point",point)
        print("price",price)
        print("amount",amount)
        print("bill",bill)
        print("product list",product_list)

        date_time_obj = datetime.strptime(orderDate, '%d-%m-%Y')
        # print("converted time",date_time_obj)
        str_orderDate = str(orderDate)
        str_orderDate = str_orderDate.replace( '-' , '' )
        int_point = int(point)
        float_price = float(price)
        int_amount = int(amount)
        
        #Check and create Document
        db=firestore.client()
        doc_date=db.collection("Order").document(str_orderDate).get()
        if doc_date.exists:
            #Set destination
            doc=db.collection("Order").document(str_orderDate).collection("OrderDetail").document(bill)

            #Set Information to document destination
            doc.set({
            "Delivery":delivery,
            "BillID":bill,
            "EarnedDate":None,
            "LineUserId":None,
            "OrderDate":date_time_obj,
            "ProductList":product_list,
            "AmountOfCups": int_amount,
            "Point":int_point,
            "SubTotalBillPrice":float_price
        })
        
            #Check that Order-date-OrderDeatil-BillId should exist and return result
            check = doc.get()
            if check.exists:
            
                return True
        
            else:
            
                return False
            
        else: #Create the document if the document is not yet exist
            
            doc_date=db.collection("Order").document(str_orderDate).set({
                
            })
        
        

    def getPrevNumber (self, date):
        str_orderDate = str(date)

        #Set destination
        line=db.collection("Mita").document(str_orderDate).get()
        if line.exists:
            return line.to_dict()
        else:
            result = {"line": "False"}
            return result

    def setPrevNumber (self, date, prev_number):
        prev_number = int(prev_number)
        str_orderDate = str(date)

        prev=db.collection("Mita").document(str_orderDate).get()
        if prev.exists:
            db.collection("Mita").document(str_orderDate).update({
                "line": prev_number
            })
        else:
            db.collection("Mita").document(str_orderDate).set({
                "line": prev_number,
                "amount": 0
            })
    
    
    def deletePrevNumDoc (self, date):
        str_orderDate = str(date)
        db=firestore.client()

        db.collection("Mita").document(str_orderDate).delete()

    def deleteAllOlderDoc (self, date):
        str_orderDate = str(date)
        print(str_orderDate)
        col=db.collection("Mita").get()
        result= []
        for doc in col:
            if doc.id < 'str_orderDate':
                result.append(doc.id) 
        print("result:",result)

        for doc_id in result:
            db.collection("Mita").document(doc_id).delete()

        return  result
        

cred=credentials.Certificate("D:\\Code\\accessKey-test.json")
fb_app = firebase_admin.initialize_app(cred)
print(fb_app)
db = firestore.client(fb_app)
db2 = firebase_admin.get_app(fb_app)

print("db",db)
print("db2",db2)