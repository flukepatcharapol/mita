***Variables***
${LOG_DIR}     ${CURDIR}/../Logger/log.csv
${FAILEDLOG_DIR}     ${CURDIR}/../Logger/failedlog.csv

***Keywords***
Log to Logger File
    [Arguments]  ${log_status}  ${event}  ${message}

    ${path}=  Normalize Path  ${CURDIR}/../logger.csv
    ${cur_time}=  Get Time
    ${is_exist}=  Run Keyword And Return Status  File Should Exist  ${path}

    IF  ${is_exist}
        Append To File  ${path}  ${cur_time};${log_status};${event};${message}${\n}
    ELSE
        Append To File  ${path}  DATE_TIME:STATUS:EVENT:MESSAGE${\n}
        Append To File  ${path}  ${cur_time};${log_status};${event};${message}${\n}
    END

