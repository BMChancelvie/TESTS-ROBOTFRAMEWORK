*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}       https://automationplayground.com/crm/index.html
${BROWSER}   firefox

*** Test Cases ***
Home Page Should Load
    Wait Until Page Contains    Customer Service    timeout=10s
    Title Should Be             Customer Service
    Capture Page Screenshot

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
