import datetime
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

