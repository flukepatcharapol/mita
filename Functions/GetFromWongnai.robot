***Variables***
#Locator
${LOG_user}                 id=email
${LOG_pass}                 id=password
${LOG_submit_btn}           id=btn_submit  
${HOM_scetion}              id=bs-example-navbar-collapse-1
${HOM_promo_model}          id=closeModal
${HOM_order_report}         xpath=//div[@id='menu_report']/ul/li[3]
${HOM_report_btn}           xpath=//div[@id='menu_report']/ul/li[3]//a[@href='/th/salebybilldetail']
${HOM_header}               xpath=//section[@class='header']//div[contains(@class,'col-md-6 col-sm-8')]
${HOM_bill_report_lbl}      รายงานยอดขายแยกตามรายละเอียดบิล
${HOM_date}                 id=dateranges
${DATE_start_date}           xpath=//div[contains(@class,'daterangepicker')][1]//div[@class='calendar left']//input[contains(@class,'input-mini form-control')]
${DATE_end_date}            xpath=//div[contains(@class,'daterangepicker')][1]//div[@class='calendar right']//input[contains(@class,'input-mini form-control')]
${DATE_apply_btn}           xpath=//body//div[3]//div[@class='ranges']//button[contains(@class,'applyBtn')]
${HOM_sale_total}           id=sale_total_amount
${DATE_today_btn}           xpath=//body//div[3]//div[@class='ranges']//li[@data-range-key='วันนี้']
${REP_ok_btn}               id=apply-branch 
${REP_csv_dwn_btn}          xpath=//div[@id='show_table_billDetail_wrapper']//a[@class='btn btn-default buttons-csv buttons-html5']
${REP_search}               xpath=//div[@id='show_table_billDetail_filter']//input[@type='search']
${REP_loading}              xpath=//div[@id='show_table_billDetail_processing']
${REP_show_btn}             xpath=//a[@class='btn btn-default buttons-collection buttons-page-length']
${REP_show_all_row}         xpath=//ul[@class='dt-button-collection dropdown-menu']/li/a[contains(text(),'Show all')]
${REP_time}                 xpath=//div[@class='dataTables_scrollHead']//th[contains(@class,'col_2 sorting')]

#Table
# ${TAB_table}                xpath=//table[@id='show_table_billDetail']//tbody
# ${TAB_row}                  xpath=//table[@id='show_table_billDetail']//tbody/tr  #Use to count the row
${TAB_order_date_bill}      xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[1]  #Get date value from this ele 
${TAB_order_time}           xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[2]  #Get time value from this ele 
${TAB_bill_id}              xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[3]
${TAB_product_name}         xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[6]
${TAB_amount}               xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[8]
${TAB_price}                xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[10]
${TAB_payment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[18]
${TAB_comment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[19]
${TAB_order_type}           xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'<bill>')][<index>]/td[21]
${TAB_order_date}           xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[1]  #Get date value from this ele 
#Table
${TAB_row}                  xpath=//table[@id='show_table_billDetail']//tbody/tr  #Use to count the all row
${TAB_online_remark}        xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'${counter_reward}')]  #Use to count all counter bill that have online remark
${TAB_counter_bill}         xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'${counter_reward}')][<index>]/td[3]  #Use to get all counter bill that have online remark
${TAB_void_remark}          xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'${void_remark}')]  #Use to count all counter bill that have online remark
${TAB_void_bill}            xpath=//table[@id='show_table_billDetail']//tbody/tr[contains(.,'${void_remark}')][<index>]/td[3]  #Use to get all counter bill that have online remark
# ${TAB_order_date_bill}      xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[1]  #Get date value from this ele 
# ${TAB_order_time}           xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[2]  #Get time value from this ele 
# ${TAB_bill_id}              xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[3]
# ${TAB_product_name}         xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[6]
# ${TAB_amount}               xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[8]
# ${TAB_price}                xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[10]
# ${TAB_payment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[18]
# ${TAB_comment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[19]
# ${TAB_order_type}           xpath=//table[@id='show_table_billDetail']//tbody/tr[<index>]/td[21]
# ${TAB_order_date}           xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[1]  #Get date value from this ele 


${TAB_table_delivery}       xpath=//table[@id='show_table_billDetail']//tbody//tr[not(contains(.,'${exclude_counter}')) and not(contains(.,'${void_remark}'))]  #Use to count all not counter row and not void
${TAB_bill_list}            xpath=//table[@id='show_table_billDetail']//tbody//tr[contains(.,'<bill>')]  #Use to count bill row
${TAB_delivery_just_bill}   xpath=//table[@id='show_table_billDetail']//tbody//tr[not(contains(.,'${exclude_counter}')) and not(contains(.,'${void_remark}'))][<index>]/td[3]

#10 Points List
${gang_mhee}             แก๊งค์หมี

#4 Points List
${tid_char}             ติดชา
${tid_nom}              ติดนม
${tid_char_tid_nom}     ติดชาติดนม
${look_tid}             ลูกติด

#3 Points List
${samker}               สามเกลอ

#2 Points List
${kuhoo_lookme}         คู่หูลูกหมี
${kuhoo_dad}            คู่หูพ่อลูก
${kuhoo_mom}            คู่หูแม่ลูก
${kun_dad_mom}          คุณพ่อคุณแม่

#1 Point List
${koko}         โกโก้
${thai}         ชาไทย
${mom}          แม่หมี
${dad}          พ่อหมี
${chanom}       ชานมหมี
${matcha}       ชาเขียวมัทฉะ
${mocha}        มอคค่า
${hokkaido}     นมหมีฮอกไกโด
${latte}        ลาเต้
${espreso}      เอสเพรสโซ่
${chanom_fep}   ชานมหมีปั่น
${koko_fep}     โกโก้ปั่น
${hok_fep}      นมหมีฮอกไกโดปั่น
${matcha_fep}   ชาเขียวมัทฉะปั่น
${thai_fep}     ชาไทยปั่น
${milk_j}       นมถั่วเหลือง
${koko_j}       โกโก้เจ
${wip}          วิปครีมมูส
${bloody}       บลัดดี้
${xmas}         เมอร์รี
${valentine}    ชาหมีคอลลาเจน
${white_mali}   ชาขาวมะลิ
${peach_japan}  ชาดำพีชญี่ปุ่น

#Exclue_list
${counter}     หน้าร้าน
${free}        หมีแลกแต้ม

#Special Order
${counter_reward}    สะสมแต้มออนไลน์
${void_remark}       Void
${exclude_counter}   หน้าร้าน

#Dynamic Variable
${lineman_detecter}    Line Man
 
***Keywords***
############################################################################################################################################
# Normal Function
############################################################################################################################################
Check Should Be On Home Page
    Wait Until Element Is Visible  ${HOM_scetion}  10 sec
    Reload Page

Click Report At Nav Bar
    # Click Element When Ready  ${HOM_order_report}
    Common Click Element when ready    ${HOM_order_report}

Click Billing Report Button
    # Click Element When Ready  ${HOM_report_btn}
    Common Click Element when ready    ${HOM_report_btn}

Check Daily Billing Should Show 
    # Element Should Be Visible With Retry  ${HOM_header}
    # Element Should Contain  ${HOM_header}  ${HOM_bill_report_lbl}
    Common element should contain    ${HOM_header}   ${HOM_bill_report_lbl}

Go To Daily Billing Page
    # Click Report At Nav Bar
    # Import Library  DebugLibrary
    # debug
    Go to    https://pos.wongnai.com/th/salebybilldetail
    # Click Billing Report Button
    Check Daily Billing Should Show
    Log To Console  ${\n}Visiting Daily Billing Page

The Date Should Be expect date
    ${expect_date}=  Replace String    ${FS_DATE}  -  /
    ${web_date}=  Get Value  ${HOM_date}
    ${web_date}=  Get SubString  ${web_date}  0  10
    Should Be Equal As Strings  ${expect_date}  ${web_date}  msg=Setup Date is not ${expect_date}. It's ${web_date}

Click Download Report .CSV File
    BuiltIn.Wait Until Keyword Succeeds  3  3 sec  Expect File Should Exist

Expect File Should Exist
    Click Element When Ready  ${REP_csv_dwn_btn}
    Sleep  0.5 s
    @{list}  List Files In Directory  ${DOWNLOAD_DIR}
    File Should Exist  ${DOWNLOAD_DIR}/${list}[0]
    Set Global Variable  ${DOWNLOADFILE}  ${DOWNLOAD_DIR}/${list}[0]

Search For Menu '${menu}'
    ${menu}=  Remove String  ${menu}  ${SPACE}
    Input Text When Ready  ${REP_search}  ${menu}
    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Should Finish Load
    Log To Console  ${\n}Search For menu:${menu}!

Should Finish Load
    ${is_loading}  Get Element Attribute  ${REP_loading}  style
    Should Not Contain  ${is_loading}  block

Click To Show All Row
    # log to console  ${\n}Click Show All Row Entry
    # BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Click Show All Row With Retry
    # Click Element When Ready  ${REP_show_all_row}
    # Log To Console  ${\n}Show All Row

    log to console  ${\n}Click Show All Row Entry
    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Click Show All Row With Retry
    Common Click Element when ready    ${REP_show_all_row}
    Log To Console  ${\n}Show All Row

Click Show All Row With Retry
    # Click Element When Ready  ${REP_show_btn}
    # Click Element When Ready  ${REP_show_all_row}
    # Click Element When Ready  ${REP_show_btn}
    # ${show_all_is_active}  Get Element Attribute  ${REP_show_all_row}/..  class
    # ${is_not_active}  Run Keyword and Return Status  Should Not Contain  ${show_all_is_active}  active

    # IF  ${is_not_active}
    #     Reload Page
    #     Should Be True  ${False}
    # ELSE
    #     log to console  ${\n}show all does active
    # END

    Common Click Element when ready    ${REP_show_btn}
    Common Click Element when ready    ${REP_show_all_row}
    Common Click Element when ready    ${REP_show_btn}
    ${show_all_is_active}  Get Element Attribute  ${REP_show_all_row}/..  class
    ${is_not_active}  Run Keyword and Return Status  Should Not Contain  ${show_all_is_active}  active

    IF  ${is_not_active}
        Reload Page
        Should Be True  ${False}
    ELSE
        log to console  ${\n}Show button row is active
    END

Click To Expected Time Order Need Retry
    ${class}  Get Element Attribute  ${REP_time}  class
    ${is_desc}  Run Keyword And Return Status  Should contain  ${class}  desc
    Run Keyword Unless  ${is_desc}  Click Element When Ready  ${REP_time}
    ${class}  Get Element Attribute  ${REP_time}  class
    Should contain  ${class}  desc

Click To Expected Time Order
    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Click To Expected Time Order Need Retry
    Log To Console  ${\n}Click to get the latest on top

Count Row
    ${row}    Get Element Count    ${TAB_row}
    Set Test Variable  ${CURRENT_ROW}  ${row}
    [Return]  ${row}

Get Element Locator From Row
    [Arguments]    ${index}    ${row_name}
    ${ele}=    Replace String  ${TAB_${row_name}}     $INDEX    ${index}
    ${text}=   Get Text    ${ele}
    Element Should Be Visible With Retry    ${ele}
    [Return]  ${text}

Get Element Locator From Row Only Not Exist
    [Arguments]    ${tr_condition}    ${index}    ${row_name}
    ${ele}=    Replace String  ${TAB_${row_name}}     <index>    ${index}
    ${ele}=    Replace String  ${ele}   <tr_condition>    ${tr_condition}
    ${text}=   Get Text    ${ele}
    [Return]  ${text}

Get Sale total
    ${sale_total}  Get Text  ${HOM_sale_total}
    log to console  ${\n}Sale total: ${sale_total}
    LineCaller.Sent Alert To Line By ID  message=Current Sale total for ${FS_DATE} is ${sale_total}

Get New Order Detail
    ${newline_detail}  Create Dictionary
    ${bill_list}  Create List
    ${row}=  Count Row
    ${prev_point}    Set Variable
    ${prev_bill}     Set Variable
    ${prev_price}    Set Variable
    ${prev_amount}   Set Variable
    ${product_list}  Create List
    FOR    ${INDEX}    IN RANGE    ${row}

        #Get the correct row number
        ${row_number}=    Evaluate  ${INDEX}+1
        ${row_number}=    Convert To String    ${row_number}
        ${detail}    Create Dictionary    Point=0

        #Check this row should not be voided
        ${comment}  Get Element Locator From Row    ${row_number}    comment
        ${is_void}=    Run Keyword And Return Status    '${comment}' Should Not Have Void

        IF  ${is_void}

            #If the row is void. We ignore the row
            Set To Dictionary  ${detail}  Is_valid  False

        ELSE
            #Get the text Value from the element
            ${date}     Get Element Locator From Row    ${row_number}    order_date
            ${time}     Get Element Locator From Row    ${row_number}    order_time
            ${bill_id}  Get Element Locator From Row    ${row_number}    bill_id
            ${name}     Get Element Locator From Row    ${row_number}    product_name
            ${payment}  Get Element Locator From Row    ${row_number}    payment
            ${type}     Get Element Locator From Row    ${row_number}    order_type
            ${amount}   Get Element Locator From Row    ${row_number}    amount
            ${price}    Get Element Locator From Row    ${row_number}    price
            log to console  ${\n}Index: ${row_number}, ${bill_id}
            ${bill_id}  Convert To Upper Case  ${bill_id}
            
            Set Test Variable  ${DATA_DATE}  ${date}

            #Validate Information
            ${product_point}    Recalculate Point For The Set Product    ${name}
            ${point}  Evaluate  ${product_point}*${amount}

            #Check amount information
            ${product_amount}  Recalculate Amount For The Set Product  ${name}
            ${amount}  Evaluate  ${product_amount}*${amount}

            # Update produce name
            ${name}  Remove String  ${name}  \n
            ${name}  Catenate    ${name} จำนวน ${amount} แก้ว
            ${date}  Replace String  ${date}  /  -
            ${time}  Catenate  ${date}  ${SPACE}  ${time}:00
            ${time}  Convert Date  ${time}  date_format=%d-%m-%Y %H:%M:%S  exclude_millis=True
            log to console  ${\n}${time}
            ${time}  Add Time To Date  ${time}  - 7 hours  exclude_millis=True
            log to console  ${\n}${time}

            #Check if หน้าร้าน Type
            ${is_counter}    Check If From Counter    ${type}
            IF  ${is_counter}
                Set To Dictionary  ${detail}  Is_valid  False
            ELSE
                Set To Dictionary  ${detail}  Is_valid  True
            END


            #Set the value to dictionary
            Set To Dictionary  ${detail}  Order_date  ${date}  
            Set To Dictionary  ${detail}  Order_time  ${time}
            Set To Dictionary  ${detail}  Bill_id  ${bill_id}
            Set To Dictionary  ${detail}  Dup  False
            

            #Check If the row is lineman
            ${is_lineman}    Check Payment For Lineman Type  ${payment}
            IF  ${is_lineman}
                # Log to console    ${\n}Set to LINEMAN
                Set To Dictionary  ${detail}  Type  LINEMAN
            ELSE
                # Log to console    ${\n}Set to ${type}
                Set To Dictionary  ${detail}  Type  ${type}
            END

            #Check If the bill are many items and calculate the point
            IF  '${bill_id}'=='${prev_bill}'

                
                Set To Dictionary  ${detail}  Dup  True
                #Re-calculate point
                ${point}=  Evaluate  ${prev_point}+${point}
                Set To Dictionary  ${detail}  Point  ${point}
                #Re-calculate pprice
                ${price}=   Evaluate  ${prev_price}+${price}
                Set To Dictionary  ${detail}  Price  ${price}
                #Re-calculate amount
                ${amount}=  Evaluate  ${prev_amount}+${amount}
                Set To Dictionary  ${detail}  Amount  ${amount}
                
                # Append current product to the list ID by bill
                Append To List  ${PROD_LIST_${bill_id}}  ${name}
                # Set Test Variable    ${PROD_LIST_${bill_id}}    ${product_list}
                Set To Dictionary  ${detail}  Product_list  ${PROD_LIST_${bill_id}}

            ELSE
                
                Set To Dictionary  ${detail}  Point  ${point}
                Set To Dictionary  ${detail}  Price  ${price}
                Set To Dictionary  ${detail}  Amount  ${amount}
                
                # Create new list and append current product to list
                ${product_list}=  Create List  ${name}
                Set Test Variable  ${PROD_LIST_${bill_id}}  ${product_list}
                Set To Dictionary  ${detail}  Product_list  ${PROD_LIST_${bill_id}}
            
            END

            #Set Detail to NEW LINE DETAIL DICT only valid bill
            ${is_valid}  Get From Dictionary  ${detail}  Is_valid
            IF  ${is_valid}
                Set To Dictionary  ${newline_detail}    ${bill_id}=${detail}
                Append to list  ${bill_list}  ${bill_id}
            END
            ${prev_bill}=    Set Variable    ${bill_id}
            ${prev_point}=   Set Variable    ${point}
            ${prev_amount}=  Set Variable    ${amount}
            ${prev_price}=   Set Variable    ${price}
        END
    END
    Log to console  ${\n}DATA_DATE: ${DATA_DATE}
    ${bill_list}  Remove Duplicates  ${bill_list}
    [Return]  ${newline_detail}  ${bill_list}

'${comment}' Should Not Have Void
    Should Contain  ${comment}  Void

Recalculate Point For The Set Product
    [Arguments]  ${name}

    ${is_10}    Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${gang_mhee}

    ${is_4}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${tid_char}  ${tid_nom}  ${tid_char_tid_nom}  ${look_tid}

    ${is_3}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${samker}

    ${is_2}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${kuhoo_lookme}  ${kuhoo_dad}  ${kuhoo_mom}  ${kun_dad_mom}

    ${is_1}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${koko}  ${thai}  ${mom}  ${dad}  ${chanom}  ${matcha}  ${mocha}
    ...               ${hokkaido}  ${latte}  ${espreso}
    ...               ${hok_fep}  ${matcha_fep}  ${thai_fep}  ${chanom_fep}  ${koko_fep}
    ...               ${koko_j}  ${milk_j}   ${wip}    ${bloody}    ${xmas}    ${valentine}
    ...               ${white_mali}    ${peach_japan}

    ${not_free}  Run Keyword And Return Status  Should Not Contain Any
    ...  ${name}      ${free}
    
    IF  ${is_10}

        BuiltIn.Return From Keyword   10

    ELSE IF  ${is_4}

        BuiltIn.Return From Keyword   4

    ELSE IF  ${is_3}

        BuiltIn.Return From Keyword   3

    ELSE IF  ${is_2}

        BuiltIn.Return From Keyword   2

    ELSE IF  ${is_1} and ${not_free}

        BuiltIn.Return From Keyword   1

    ELSE

        BuiltIn.Return From Keyword   0

    END


Check If From Counter
    [Arguments]    ${type}
    ${is_counter}  Run Keyword And Return Status  Should Contain Any  ${type}  ${counter}
    [Return]  ${is_counter}

Check Payment For Lineman Type  
    [Arguments]    ${payment}
    ${is_lineman}    Run Keyword And Return Status  Should Contain Any  ${payment}  ${lineman_detecter}
    [Return]  ${is_lineman}

Recalculate Amount For The Set Product  
    [Arguments]  ${name}

    ${is_10}    Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${gang_mhee}

    ${is_4}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${tid_char}  ${tid_nom}  ${tid_char_tid_nom}  ${look_tid}

    ${is_3}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${samker}

    ${is_2}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${kuhoo_lookme}  ${kuhoo_dad}  ${kuhoo_mom}  ${kun_dad_mom}   

    ${is_1}  Run Keyword And Return Status  Should Contain Any
    ...  ${name}      ${koko}  ${thai}  ${mom}  ${dad}  ${chanom}  ${matcha}  ${mocha}
    ...               ${hokkaido}  ${latte}  ${espreso}
    ...               ${hok_fep}  ${matcha_fep}  ${thai_fep}  ${chanom_fep}  ${koko_fep}
    ...               ${koko_j}  ${milk_j}    ${bloody}    ${xmas}    ${valentine}
    ...               ${white_mali}    ${peach_japan}
    ...               ${wip}  ${free}
    
    IF  ${is_10}

        BuiltIn.Return From Keyword   10
    
    ELSE IF  ${is_4}

        BuiltIn.Return From Keyword   4

    ELSE IF  ${is_3}

        BuiltIn.Return From Keyword   3

    ELSE IF  ${is_2}

        BuiltIn.Return From Keyword   2

    ELSE IF  ${is_1}

        BuiltIn.Return From Keyword   1

    ELSE

        BuiltIn.Return From Keyword   0

    END

Check date button should be visible
    Common wait element is visible    ${HOM_date}    30

Set Date To Expect date
    # Click Element When Ready  ${HOM_date}
    # ${expect_date}  Replace String  ${FS_DATE}  -  /
    # Input Text When Ready  ${DATE_start_date}  ${expect_date}
    # Input Text When Ready  ${DATE_end_date}  ${expect_date}
    # Click Element When Ready  ${DATE_apply_btn}
    # Click Element When Ready  ${REP_ok_btn}
    # The Date Should Be expect date

    # BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Should Finish Load

    # Log To Console  ${\n}Set Date To expect date ${expect_date}

    Common Click Element when ready    ${HOM_date}
    ${expect_date}  Replace String  ${FS_DATE}  -  /
    Common Input text when ready    ${DATE_start_date}  ${expect_date}
    Common Input text when ready    ${DATE_end_date}  ${expect_date}
    Common Click Element when ready    ${DATE_apply_btn}
    Common Click Element when ready    ${REP_ok_btn}
    The Date Should Be expect date

    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Should Finish Load

    Log To Console  ${\n}Set Date To expect date ${expect_date}

Validate Data date should be Expect Date
    log to console  ${\n}Validate Data date should be ${FS_DATE}

    Set Date To Expect date
    ${expect_date}=  Replace String  ${FS_DATE}  -  /
    ${date}     Get Element Locator From Row    1    order_date
    Should Not Be Equal as Strings  ${date}  No data available in table

    log to console  ${\n}Data date: ${date}
    Should be Equal as Strings  ${expect_date}  ${date}

Set Date To Expect Date and Validate Data Date Should be Expecte Date
    log to console  ${\n}Set Date To Expect Date and Validate Data Date Should be Expecte Date
    ${is_set_date_success}  Run Keyword And Return Status  BuiltIn.Wait Until Keyword Succeeds  5 x  1 sec  Validate Data date should be Expect Date
    ${date}     Get Element Locator From Row    1    order_date
    ${is_no_order}  Run Keyword And Return Status  Should Be Equal as Strings  ${date}  No data available in table

    IF  ${is_set_date_success}

        log to console  ${\n}Success set date to ${FS_DATE}

    ELSE IF  ${is_no_order}

        log to console  ${\n}No data found in table
        # LineCaller.Sent Alert To Line By ID  message=No Order in the table
        Pass Execution  No Order in the table

    ELSE

        Fail  not sucess set date to expect date

    END

Get Element Locator From Row and Bill
    [Arguments]    ${bill_id}    ${index}    ${row_name}
    ${ele}=    Replace String  ${TAB_${row_name}}     <index>    ${index}
    ${ele}=    Replace String  ${ele}     <bill>    ${bill_id}
    ${text}=   Get Text    ${ele}
    [Return]  ${text}

Get New Order Detail From Bill List
    [Arguments]    ${bill_list}
    ${newline_detail}  Create Dictionary
    ${prev_point}    Set Variable
    ${prev_bill}     Set Variable
    ${prev_price}    Set Variable
    ${prev_amount}   Set Variable
    ${product_list}  Create List
    FOR  ${BILL}  IN  @{bill_list}
        ${bill_row}  Replace String  ${TAB_bill_list}  <bill>  ${BILL}
        ${bill_row_count}  Get Element Count  ${bill_row}
        log to console  ${\n}${bill_row_count} indexs for ${BILL}

        FOR  ${BILL_ROW}  IN RANGE  ${bill_row_count}

            #Get the correct row number
            ${row_number}=    Evaluate  ${BILL_ROW}+1
            ${row_number}=    Convert To String    ${row_number}
            ${detail}    Create Dictionary    Point=0

            #Check this row should not be voided
            ${comment}  Get Element Locator From Row and Bill    ${BILL}    ${row_number}    comment
            ${is_void}=    Run Keyword And Return Status    '${comment}' Should Not Have Void

            IF  ${is_void}

                #If the row is void. We ignore the row
                Set To Dictionary  ${detail}  Is_valid  ${False}

            ELSE

                Set To Dictionary  ${detail}  Is_valid  ${True}

                #Get the text Value from the element
                ${date}     Get Element Locator From Row and Bill    ${BILL}    ${row_number}    order_date_bill
                ${time}     Get Element Locator From Row and Bill    ${BILL}    ${row_number}    order_time
                ${bill_id}  Get Element Locator From Row and Bill    ${BILL}    ${row_number}    bill_id
                ${name}     Get Element Locator From Row and Bill    ${BILL}    ${row_number}    product_name
                ${payment}  Get Element Locator From Row and Bill    ${BILL}    ${row_number}    payment
                ${type}     Get Element Locator From Row and Bill    ${BILL}    ${row_number}    order_type
                ${amount}   Get Element Locator From Row and Bill    ${BILL}    ${row_number}    amount
                ${price}    Get Element Locator From Row and Bill    ${BILL}    ${row_number}    price
                ${bill_id}  Convert To Upper Case  ${bill_id}
                
                Set Test Variable  ${DATA_DATE}  ${date}

                #Validate Information
                ${product_point}    Recalculate Point For The Set Product    ${name}
                ${point}  Evaluate  ${product_point}*${amount}

                #Check amount information
                ${product_amount}  Recalculate Amount For The Set Product  ${name}
                ${amount}  Evaluate  ${product_amount}*${amount}

                # Update produce name
                ${name}  Remove String  ${name}  \n
                ${name}  Catenate    ${name} จำนวน ${amount} แก้ว
                ${date}  Replace String  ${date}  /  -
                ${time}  Catenate  ${date}  ${SPACE}  ${time}:00
                ${time}  Convert Date  ${time}  date_format=%d-%m-%Y %H:%M:%S  exclude_millis=True
                ${time}  Add Time To Date  ${time}  - 7 hours  exclude_millis=True

                #Check if หน้าร้าน Type
                # ${is_counter}    Check If From Counter    ${type}
                # IF  ${is_counter}
                #     Set To Dictionary  ${detail}  Is_valid  False
                #     Set To Dictionary  ${detail}  Is_counter  True
                # ELSE
                #     Set To Dictionary  ${detail}  Is_valid  True
                #     Set To Dictionary  ${detail}  Is_counter  False
                # END


                #Set the value to dictionary
                Set To Dictionary  ${detail}  Order_date  ${date}  
                Set To Dictionary  ${detail}  Order_time  ${time}
                Set To Dictionary  ${detail}  Bill_id  ${bill_id}
                Set To Dictionary  ${detail}  Dup  False
                

                #Check If the row is lineman
                ${is_lineman}    Check Payment For Lineman Type  ${payment}
                IF  ${is_lineman}
                    # Log to console    ${\n}Set to LINEMAN
                    Set To Dictionary  ${detail}  Type  LINEMAN
                ELSE
                    # Log to console    ${\n}Set to ${type}
                    Set To Dictionary  ${detail}  Type  ${type}
                END

                #Check If the bill are many items and calculate the point
                IF  '${bill_id}'=='${prev_bill}'

                    
                    Set To Dictionary  ${detail}  Dup  True
                    #Re-calculate point
                    ${point}=  Evaluate  ${prev_point}+${point}
                    Set To Dictionary  ${detail}  Point  ${point}
                    #Re-calculate pprice
                    ${price}=   Evaluate  ${prev_price}+${price}
                    Set To Dictionary  ${detail}  Price  ${price}
                    #Re-calculate amount
                    ${amount}=  Evaluate  ${prev_amount}+${amount}
                    Set To Dictionary  ${detail}  Amount  ${amount}
                    
                    # Append current product to the list ID by bill
                    Append To List  ${PROD_LIST_${bill_id}}  ${name}
                    # Set Test Variable    ${PROD_LIST_${bill_id}}    ${product_list}
                    Set To Dictionary  ${detail}  Product_list  ${PROD_LIST_${bill_id}}

                ELSE
                    
                    Set To Dictionary  ${detail}  Point  ${point}
                    Set To Dictionary  ${detail}  Price  ${price}
                    Set To Dictionary  ${detail}  Amount  ${amount}
                    
                    # Create new list and append current product to list
                    ${product_list}=  Create List  ${name}
                    Set Test Variable  ${PROD_LIST_${bill_id}}  ${product_list}
                    Set To Dictionary  ${detail}  Product_list  ${PROD_LIST_${bill_id}}
                
                END

                #Set Detail to NEW LINE DETAIL DICT only valid bill
                ${is_valid}  Get From Dictionary  ${detail}  Is_valid
                IF  ${is_valid}
                    Set To Dictionary  ${newline_detail}    ${bill_id}=${detail}
                END
                ${prev_bill}=    Set Variable    ${bill_id}
                ${prev_point}=   Set Variable    ${point}
                ${prev_amount}=  Set Variable    ${amount}
                ${prev_price}=   Set Variable    ${price}
            END
        END
    END
    Log to console  ${\n}DATA_DATE: ${DATA_DATE}
    [Return]  ${newline_detail}

Get All Current Bill Exclude Counter
    ${row_amount}  Get Element Count  ${TAB_table_delivery}
    ${current_bill_list}  Create List
    
    FOR  ${ROW}  IN RANGE  ${row_amount}
        # ${index}  Evaluate  ${ROW+1}
        ${index}  Convert to String  ${ROW+1}
        ${ele}  Replace String  ${TAB_delivery_just_bill}  <index>  ${index}
        ${bill_id}  Get Text  ${ele}
        Append To List  ${current_bill_list}  ${bill_id}
    END

    ${current_bill_list}  Remove Duplicates  ${current_bill_list}
    [Return]  ${current_bill_list}

Get All Current Bill
    ${row_amount}  Get Element Count  ${TAB_row}
    ${current_bill_list}  Create List
    
    FOR  ${ROW}  IN RANGE  ${row_amount}
        # ${index}  Evaluate  ${ROW}+1
        ${index}  Convert to String  ${ROW+1}
        ${ele}  Replace String  ${TAB_bill_id}  <index>  ${index}
        ${bill_id}  Get Text  ${ele}
        Append To List  ${current_bill_list}  ${bill_id}
    END

    ${current_bill_list}  Remove Duplicates  ${current_bill_list}
    [Return]  ${current_bill_list}

Get Rewardable Counter Bill
    ${row_amount}  Get Element Count  ${TAB_online_remark}
    ${reward_coundter_list}  Create List
    
    FOR  ${ROW}  IN RANGE  ${row_amount}
        # ${index}  Evaluate  ${ROW}+1
        ${index}  Convert to String  ${ROW+1}
        ${ele}  Replace String  ${TAB_counter_bill}  <index>  ${index}
        ${bill_id}  Get Text  ${ele}
        Append To List  ${reward_coundter_list}  ${bill_id}
    END

    ${reward_coundter_list}  Remove Duplicates  ${reward_coundter_list}
    [Return]  ${reward_coundter_list}

Get void order if exist
    ${row_amount}  Get Element Count  ${TAB_void_remark}
    ${void_list}  Create List
    
    IF  ${row_amount}>0
    
        FOR  ${ROW}  IN RANGE  ${row_amount}
            ${index}  Convert to String  ${ROW+1}
            ${ele}  Replace String  ${TAB_void_bill}  <index>  ${index}
            ${bill_id}  Get Text  ${ele}
            Append To List  ${void_list}  ${bill_id}
        END

        ${void_list}  Remove Duplicates  ${void_list}
        Return From Keyword    ${True}    ${void_list}

    ELSE

        Return From Keyword    ${False}    ${void_list}

    END
