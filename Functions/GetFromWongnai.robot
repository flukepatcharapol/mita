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
${TAB_table}                xpath=//table[@id='show_table_billDetail']//tbody
${TAB_row}                  xpath=//table[@id='show_table_billDetail']//tbody/tr  #Use to count the row
${TAB_order_date}           xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[1]  #Get date value from this ele 
${TAB_bill_id}              xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[3]
${TAB_product_name}         xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[6]
${TAB_amount}               xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[8]
${TAB_price}                xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[10]
${TAB_payment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[18]
${TAB_comment}              xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[19]
${TAB_order_type}           xpath=//table[@id='show_table_billDetail']//tbody/tr[$INDEX]/td[21]

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
${espreso}      เอสเปรสโซ่
${chanom_fep}   ชานมหมีปั่น
${koko_fep}     โกโก้ปั่น
${hok_fep}      นมหมีฮอกไกโดปั่น
${matcha_fep}   ชาเขียวมัทฉะปั่น
${thai_fep}     ชาไทยปั่น

#Exclue_list
${wip}         วิปครีมมูส
${counter}     หน้าร้าน

#Dinamic Variable
${lineman_detecter}    Line Man
 
***Keywords***
############################################################################################################################################
# Normal Function
############################################################################################################################################
Check Should Be On Home Page
    [Arguments]  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    Element Should Be Visible With Retry  ${HOM_scetion}
    # BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Check and Clear If Promo is Exist
    Reload Page

Check and Clear If Promo is Exist
    Reload Page

Click Report At Nav Bar
    Click Element When Ready  ${HOM_order_report}

Click Billing Report Button
    Click Element When Ready  ${HOM_report_btn}

Check Daily Billing Should Show 
    Element Should Be Visible With Retry  ${HOM_header}
    Element Should Contain  ${HOM_header}  ${HOM_bill_report_lbl}

Go To Daily Billing Page
    Click Report At Nav Bar
    Click Billing Report Button
    Check Daily Billing Should Show
    Log To Console  ${\n}Visiting Daily Billing Page

Set Date To Today
    Click Element When Ready  ${HOM_date}
    Click Element When Ready  ${DATE_today_btn}
    Click Element When Ready  ${REP_ok_btn}
    The Date Should Be Today

    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Should Finish Load

    Log To Console  ${\n}Set Date To Today

The Date Should Be Today
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

Click Show All Row
    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Click Show All Row With Retry
    Click Element When Ready  ${REP_show_all_row}
    Log To Console  ${\n}Show All Row

Click Show All Row With Retry
    Click Element When Ready  ${REP_show_btn}
    Click Element When Ready  ${REP_show_all_row}
    Click Element When Ready  ${REP_show_btn}
    ${show_all_is_active}  Get Element Attribute  ${REP_show_all_row}/..  class
    Should Contain  ${show_all_is_active}  active

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
    [Return]  ${text}

Get Sale total
    ${sale_total}  Get Text  ${HOM_sale_total}
    log to console  ${\n}Sale total: ${sale_total}
    LineCaller.Sent Alert To Line By ID  message=Current Sale total for ${FS_DATE} is ${sale_total}

Get New Order Detail
    [Arguments]    ${latest_number}
    ${newline_detail}  Create Dictionary
    ${bill_list}  Create List
    ${row}=  Count Row
    ${new_line_amount}=    Evaluate    ${row}-${latest_number}
    ${prev_point}    Set Variable
    ${prev_bill}     Set Variable
    ${prev_price}    Set Variable
    ${prev_amount}   Set Variable
    ${product_list}  Create List
    FOR    ${INDEX}    IN RANGE    ${new_line_amount}

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
            ${product_point}    Recalculate Price For The Set Product    ${name}
            ${point}  Evaluate  ${product_point}*${amount}

            #Check amount information
            ${product_amount}  Recalculate Amount For The Set Product  ${name}
            ${amount}  Evaluate  ${product_amount}*${amount}

            # Update produce name
            ${name}  Remove String  ${name}  \n
            ${name}  Catenate    ${name} จำนวน ${amount} แก้ว
            ${date}  Replace String  ${date}  /  -

            #Check if หน้าร้าน Type
            ${is_counter}    Check If From Counter    ${type}
            IF  ${is_counter}
                Set To Dictionary  ${detail}  Is_valid  False
            ELSE
                Set To Dictionary  ${detail}  Is_valid  True
            END


            #Set the value to dictionary
            Set To Dictionary  ${detail}  Order_date  ${date}  
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
    [Return]  ${newline_detail}  ${bill_list}

'${comment}' Should Not Have Void
    Should Contain  ${comment}  Void

Recalculate Price For The Set Product
    [Arguments]  ${name}

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
    
    IF  ${is_4}

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


Check If From Counter
    [Arguments]    ${type}
    ${is_counter}  Run Keyword And Return Status  Should Contain Any  ${type}  ${counter}
    [Return]  ${is_counter}

Check Payment For Lineman Type  
    [Arguments]    ${payment}
    ${is_lineman}    Run Keyword And Return Status  Should Contain Any  ${payment}  ${lineman_detecter}
    # log to console   ${\n}Checker: ${is_lineman}
    [Return]  ${is_lineman}

Recalculate Amount For The Set Product  
    [Arguments]  ${name}

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
    ...               ${wip}
    
    IF  ${is_4}

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

Validate Data date should be today
    GetFromWongnai.Set Date To Today
    ${expect_date}=  Replace String  ${FS_DATE}  -  /
    ${date}     Get Element Locator From Row    1    order_date
    ${is_data_empty}  Run Keyword And Return Status  Should Be Equal as Strings  ${date}  No data available in table

    IF  ${is_data_empty}

        log to console  ${\n}No data found in table
        LineCaller.Sent Alert To Line By ID  message=No Order in the table
        Pass Execution  No Order in the table

    ELSE

        log to console  ${\n}Data date: ${date}
        Should be Equal as Strings  ${expect_date}  ${date}

    END

Set Date To Today and Validate Data Date Should be Today
    BuiltIn.Wait Until Keyword Succeeds  ${ATTEMPT}  ${WAIT}  Validate Data date should be today