*** Settings ***
Test Teardown     Close Browser
Library           SeleniumLibrary
Library           Collections
Library           String
Library           BuiltIn
Library           ExcelLibrary

*** Variables ***
${baseurl}        https://www.xerago.com/
${browser}        chrome
${excel_name}     urls.xls
*** Test Cases ***
Internal link count validation
    Open Excel    ${CURDIR}/${excel_name}
    ${Col}=    Get Row Count    Sheet1
    FOR    ${i}    IN RANGE    0    ${Col}
        ${excel_url}=    Read Cell Data By Coordinates    Sheet1    0    ${i}
        Jenkins browser launch    ${excel_url}
        ${links_count}=    Get Element Count    xpath=.//a
        For loop code for internal links    ${links_count}    ${excel_url}
        Close Browser
    END

Page word count
    Jenkins browser launch  ${baseurl}
    ${text}=    Get Text    //body
    @{result} =    Split String    ${text}    ${EMPTY}    -1
    ${len}=    Get Length    ${result}
    Run Keyword If    100<${len}    Log To Console    Word are presented more than 100

*** Keywords ***
For loop code for external links
    [Arguments]    ${links_count}    ${excel_url}
    FOR    ${INDEX}    IN RANGE    1    ${links_count}
        ${lintext}=    SeleniumLibrary.Get Element Attribute    xpath=(//a)[${INDEX}]    href
        Continue For Loop If    '${lintext}'=='javascript:void(0)'
        Continue For Loop If    '${lintext}'=='None'
        Continue For Loop If    '${lintext}'=='javascript:;'
        Continue For Loop If    '${lintext}'=='mailto:salesusa@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesapac@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesme@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesindia@xerago.com'
        Continue For Loop If    '${lintext}'=='javascript:void(0);'
        Continue For Loop If    '${lintext}'=='#infinite-top-anchor;'
        Continue For Loop If    '${lintext}'=='#'
        ${split_val}=    Fetch From Left    ${lintext}    m/
        Run Keyword If    '${split_val}'!='https://www.xerago.co'    Log To Console    URL is ${excel_url} External links no is: ${lintext}
    END

For loop code for internal links
    [Arguments]    ${links_count}    ${excel_url}
    FOR    ${INDEX}    IN RANGE    1    ${links_count}
        ${lintext}=    SeleniumLibrary.Get Element Attribute    xpath=(//a)[${INDEX}]    href
        Continue For Loop If    '${lintext}'=='javascript:void(0)'
        Continue For Loop If    '${lintext}'=='None'
        Continue For Loop If    '${lintext}'=='javascript:;'
        Continue For Loop If    '${lintext}'=='mailto:salesusa@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesapac@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesme@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesindia@xerago.com'
        Continue For Loop If    '${lintext}'=='javascript:void(0);'
        Continue For Loop If    '${lintext}'=='#infinite-top-anchor;'
        Continue For Loop If    '${lintext}'=='#'
        ${split_val}=    Fetch From Left    ${lintext}    m/
        Run Keyword If    '${split_val}'=='https://www.xerago.co'    Log To Console    URL is ${excel_url} Interternal links present
        Run Keyword If    ${INDEX}==4    Log    Internal links are present more than 3 times in this URL:${excel_url}  
        Exit For Loop If    ${INDEX}==4
    END
    
Local browser launch
    Set Selenium Speed    1s
    Open Browser    ${baseurl}    ${browser}
    Maximize Browser Window
    Set Browser Implicit Wait    15s

Jenkins browser launch
    [Arguments]    ${url}
    Set Selenium Speed    1s
    ${chrome_options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    headless
    Call Method    ${chrome_options}    add_argument    disable-gpu
    Call Method    ${chrome_options}    add_argument    no-sandbox
    Create WebDriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}
    Maximize Browser Window
    Set Browser Implicit Wait    15s

Internalcountno
    [Arguments]    ${index_val}
    ${val}=    Evaluate    ${index_val}+0
    [Return]    ${val}
