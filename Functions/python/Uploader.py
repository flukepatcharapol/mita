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
cred=credentials.Certificate("D:\\Code\\Firebear-v-0-2\\Firebear\\Functions\\python\\accessKey-test.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

class Uploader ():
    def sendToFireStoreCollection (self,delivery,earnedDate,lineUserId,orderDate,point,bill,product_list):
        
        print("delivery type",delivery)
        print("earn date",earnedDate)
        print("lineUserId",lineUserId)
        print("orderDate",orderDate)
        print("point",point)
        print("bill",bill)
        print("product list",product_list)

        date_time_obj = datetime.strptime(orderDate, '%d-%m-%Y')
        # print("converted time",date_time_obj)
        str_orderDate = str(orderDate)
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
            "Point":point
        })
        
        #Check that Order-date-OrderDeatil-BillId should exist and return result
        check = doc.get()
        if check.exists:
            
            return True
        
        else:
            
            return False

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
    
        
        
    def setAllAmountNumber (self, date, cur_amount):
        cur_amount = int(cur_amount)
        str_orderDate = str(date)

        doc=db.collection("Mita").document(str_orderDate).get()
        if doc.exists:
            amount_dict =  doc.to_dict()
            amount_int = int(amount_dict["amount"])
            new_amount = amount_int + cur_amount
            amount=db.collection("Mita").document(str_orderDate)
            amount.update({
                "amount": new_amount
            })
            return  new_amount
            
        else:
            amount=db.collection("Mita").document(str_orderDate)
            amount.set({
                "line": 0,
                "amount": cur_amount
            })
            
            return  cur_amount
    
    
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
        
