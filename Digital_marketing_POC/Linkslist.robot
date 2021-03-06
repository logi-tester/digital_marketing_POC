*** Settings ***
Test Teardown     Close Browser
Library           SeleniumLibrary
Library           Collections
Library           String
Library           BuiltIn

*** Variables ***
${baseurl}        https://www.xerago.com/
${browser}        chrome

*** Test Cases ***
Get Internal Links
    Jenkins browser launch
    ${links_count}=    Get Element Count    xpath=.//a
    FOR    ${INDEX}    IN RANGE    1    ${links_count}
        ${lintext}=    SeleniumLibrary.Get Element Attribute    xpath=(//a)[${INDEX}]    href
        #Log To Console    url's are: ${lintext} ${INDEX}
        Continue For Loop If    '${lintext}'=='javascript:void(0)'
        Continue For Loop If    '${lintext}'=='None'
        Continue For Loop If    '${lintext}'=='javascript:;'
        Continue For Loop If    '${lintext}'=='mailto:salesusa@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesapac@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesme@xerago.com'
        Continue For Loop If    '${lintext}'=='mailto:salesindia@xerago.com'
        Continue For Loop If    '${lintext}'=='javascript:void(0);'
        ${split_val}=    Fetch From Left    ${lintext}    m/
        Run Keyword If    '${split_val}'=='https://www.xerago.co'    Log    Internal urls are presented
        ${test}    Internalcountno    ${INDEX}
        Exit For Loop If    ${test}==4
    END

Get pagesource content
    Jenkins browser launch
    ${pagesource_content}=    Get Source
    ${get_length}=    Get Length    ${pagesource_content}
    Run Keyword If    100<${get_length}    Log To Console    Letters are presented more than 100
    Log To Console    Sourecode letters length is ${get_length}
    Log    Sourecode letters length is ${get_length}

*** Keywords ***
Local browser launch
    Set Selenium Speed    1s
    Open Browser    ${baseurl}    ${browser}
    Maximize Browser Window
    Set Browser Implicit Wait    15s

Jenkins browser launch
    Set Selenium Speed    1s
    ${chrome_options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    headless
    Call Method    ${chrome_options}    add_argument    disable-gpu
    Call Method    ${chrome_options}    add_argument    no-sandbox
    Create WebDriver    Chrome    chrome_options=${chrome_options}
    Go To    ${baseurl}
    Maximize Browser Window
    Set Browser Implicit Wait    15s

Internalcountno
    [Arguments]    ${index_val}
    ${val}=    Evaluate    ${index_val}+0
    [Return]    ${val}
