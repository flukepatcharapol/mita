import datetime
import firebase_admin
import firestore
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime

# Set Firestore DB Credential For Local
cred = credentials.Certificate('matinomita.json')
firebase_admin.initialize_app('cred')
db=firestore.client()

class Uploader ():
    def sendToFireStoreCollection (self,delivery,earnedDate,lineUserId,orderDate,point,bill,price,amount,product_list):
             
        #Convert to expected format and data type
        date_time_obj = datetime.strptime(orderDate, '%d-%m-%Y')
        str_orderDate = str(orderDate)
        str_orderDate = str_orderDate.replace( '-' , '' )
        int_point = int(point)
        float_price = float(price)
        int_amount = int(amount)
        
        #Check and create Document
        doc_date=db.collection("Order").document(str_orderDate).get()
        if doc_date.exists:
            #Set destination and add the data to target document
            db.collection("Order").document(str_orderDate).collection("OrderDetail").document(bill).set({
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
            
        #Create the document if the document is not yet exist
        else: 
            # Create Document for this date
            db.collection("Order").document(str_orderDate).set({})
            
            #Add the data to the document
            db.collection("Order").document(str_orderDate).collection("OrderDetail").document(bill).set({
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
        check=db.collection("Order").document(str_orderDate).collection("OrderDetail").document(bill).get()
        
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
            
    
    def deletePrevNumDoc (self, date):
        str_orderDate = str(date)

        db.collection("Mita").document(str_orderDate).delete()

    def deleteAllOlderDoc (self, date):
        str_orderDate = str(date)
        
        #Get all doc from collection Mita
        col=db.collection("Mita").get()
        result= []
        
        #Search and get every doc that older than $date
        for doc in col:
            if doc.id <= str_orderDate:
                result.append(doc.id) 
        print("result:",result)

        #Delete every doc from the list
        for doc_id in result:
            db.collection("Mita").document(doc_id).delete()
        
        #Check and if not failed add to list
        list_of_failed = []
        for check_doc in result:
            check_result=db.collection("Order").document(check_doc).get()
            if check_result.exists:
                list_of_failed.append(check_doc)

        #Return the list of failed doc
        return  list_of_failed
        
    def testServicAccount (self):

        check=db.collection("Order").document('19052021').collection("OrderDetail").document('271QZ').get()
        print(check.id)
        return check.id
        
    def initFirestoreApp (self, project_id):
        
        #Set up creadential
        cred = credentials.ApplicationDefault()
        app = firebase_admin.initialize_app(cred, {
        'projectId': project_id,
        })
        db = firestore.client(app)
        
        return db
