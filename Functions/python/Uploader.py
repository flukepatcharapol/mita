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
# cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")
# firebase_admin.initialize_app(cred)
# db=firestore.client()

class Uploader ():
    def sendToFireStoreCollection (self,delivery,earnedDate,lineUserId,orderDate,point,bill,price,amount,product_list):
        
        cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")  #("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-prod.json")
        firebase_admin.initialize_app(cred)
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
        int_point = int(point)
        float_price = float(price)
        int_amount = int(amount)
        #Set destination
        db=firestore.client()
        doc=db.collection("Order").document(str_orderDate).collection("OrderDetail").document(bill)
        
        #Set Information to document destination
        doc.set({
            "Delivery":delivery,
            "BillID":bill,
            "EarnedDate":earnedDate,
            "LineUserId":lineUserId,
            "OrderDate":date_time_obj,
            "ProductList":product_list,
            "Amount Of Cups": int_amount,
            "Point":int_point,
            "SubTotal Bill Price":float_price
        })
        
        #Check that Order-date-OrderDeatil-BillId should exist and return result
        check = doc.get()
        if check.exists:
            
            return True
        
        else:
            
            return False

    def getPrevNumber (self, date):
        str_orderDate = str(date)
        
        cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")
        firebase_admin.initialize_app(cred)
        db=firestore.client()

        #Set destination
        line=db.collection("Mita").document(str_orderDate).get()
        if line.exists:
            return line.to_dict()
        else:
            return False

    def setPrevNumber (self, date, prev_number):
        str_orderDate = str(date)
        
        cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")
        firebase_admin.initialize_app(cred)
        db=firestore.client()

        prev=db.collection("Mita").document(str_orderDate)
        prev.set({
            "line": prev_number
        })
    
    
    def deletePrevNumDoc (self, date):
        str_orderDate = str(date)
        
        cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")
        firebase_admin.initialize_app(cred)
        db=firestore.client()

        db.collection("Mita").document(str_orderDate).delete()