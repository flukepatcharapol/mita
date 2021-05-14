***Settings***
Library      ${CURDIR}/python/Uploader.py

***Keywords***
Transform To Firestore Format And Sent To FireStore
    [Arguments]    ${newline_detail}
    ${key}=    Get Dictionary Keys  ${newline_detail}
    ${dict_length}=    Get Length    ${key}
    ${result}=    Create List
    FOR  ${INDEX}    IN    @{key}
        ${body}=    Get From Dictionary   ${newline_detail}   ${INDEX}  #INDEX is key
        ${is_valid}=    Get From Dictionary    ${body}    Is_valid
        IF  ${is_valid}
            #Transforming

            #Get info
            ${order_date}    Get From Dictionary  ${body}  Order_date
            ${point}         Get From Dictionary  ${body}  Point
            ${bill}          Get From Dictionary  ${body}  Bill_id
            ${type}          Get From Dictionary  ${body}  Type
            ${product_list}  Get From Dictionary  ${body}  Product_list

            #Convert dateime format to timestamp
            # ${year}=  Get Substring  ${order_date}    8
            # ${month}=    Get Substring    ${order_date}    3   5
            # ${day}=    Get Substring    ${order_date}    0   2
            # ${time_stamp}=  Catenate  ${day}\/${month}\/${year}

            #Set into Doc info to Document format
            ${result_body}=  Create Dictionary    Delivery=${type}    EarnedDate=    
            ...    LineUserId=    OrderDate=${order_date}    Point=${point}
            ...    BillId=${bill}  ProductList=${product_list}  isValid=${is_valid}

            #Append Info to Document
            Append To List    ${result}    ${result_body}
            log to console  ${\n}${result_body}

        END
    END
    Set New Line To The FireStore  ${result}

Set New Line To The FireStore
    [Arguments]    ${list}
    ${I}    Set Variable    0
    ${fail_list}    Create List
    ${new_data_length}  Get Length  ${list}

    FOR  ${INDEX}  IN  @{list}

        #Get information from ordered dict
        ${delivery}    Get From Dictionary  ${INDEX}  Delivery
        ${earn}        Get From Dictionary  ${INDEX}  EarnedDate
        ${line}        Get From Dictionary  ${INDEX}  LineUserId
        ${date}        Get From Dictionary  ${INDEX}  OrderDate
        ${bill}        Get From Dictionary  ${INDEX}  BillId
        ${prod_list}   Get From Dictionary  ${INDEX}  ProductList
        ${is_valid}    Get From Dictionary  ${INDEX}  isValid

        # Get Point and convert to Int
        ${point}       Get From Dictionary  ${INDEX}  Point
        ${point}       Convert To Integer   ${point}
        ${date}        Convert To String    ${date}

        #Call uploader to send info to firestore
        IF  ${is_valid}
            ${upload_result}=    Uploader.sendToFireStoreCollection    ${delivery}  ${earn}  ${line}
            ...    ${date}  ${point}  ${bill}  ${prod_list}

            #Validate Upload result
            IF  ${upload_result}

                No Operation

            ELSE

                Append TO List  ${fail_list}  ${bill}

            END
        END
    
    END

    ${is_success}=  Run Keyword And Return Status  Should Be Empty  ${fail_list}

    IF  ${is_success}

        LineCaller.Sent Alert To Line Group By ID  message=SuccessFully Upload new Line To Firestore. New ${new_data_length} records.
        EventLogger.Log to Logger File  log_status=SUCCESS  event=Add New Line  message=SuccessFully Upload new Line To Firestore. New ${new_data_length} records.
        
        #Set the OutPuts/prev.text File = ${CURRENT_ROW}
        ${cur_row}  Convert To String  ${CURRENT_ROW}
        ${date}=  Replace String  ${DATA_DATE}  /  -
        Update New Prev Number  ${date}  ${cur_row}

    ELSE

        LineCaller.Sent Alert To Line Group By ID  message=Failed To Upload new Line To Firestore. Fail list: ${fail_list}.
        EventLogger.Log to Logger File  log_status=FAILED  event=Add New Line  message=Failed To Upload new Line To Firestore ${fail_list}
        #Not Set anything wait for retry on the next time

    END

Get Prev Line Saved
    [Arguments]  ${date}
    ${result}=    Uploader.getPrevNumber  ${date}
    ${line}=  Get From Dictionary  ${result}  line
    [Return]  ${line}

Update New Prev Number
    [Documentation]  Date format  11-05-2021
    [Arguments]  ${date}  ${number}
    Uploader.setPrevNumber    ${date}    ${number}

Delete Prev Number From Date
    [Arguments]  ${date}
    Uploader.deletePrevNumDoc   ${date}

Set New Total Sold Amount
    [Arguments]  ${date}=${DATA_DATE}  ${amount}=${CUR_AMOUNT}
    ${date}=  Replace String    ${date}    /    -
    ${updated_amount}=  Uploader.setAllAmountNumber  ${date}  ${amount}
    LineCaller.Sent Alert To Line Group By ID  message=Update current delivery sold ${updated_amount} for ${FS_DATE}.
    EventLogger.Log to Logger File  log_status=UNKNOWN  event=SOLD AMOUNT  message=Update current delivery sold ${updated_amount} for ${FS_DATE}.
    
Delete Older Docs in the Collection
    [Arguments]  ${date}
    ${list}=  Uploader.deleteAllOlderDoc  ${date}
    log to console  ${\n}Result: ${list}