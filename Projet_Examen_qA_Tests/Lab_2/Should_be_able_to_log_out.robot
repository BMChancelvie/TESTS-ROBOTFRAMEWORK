*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}           https://automationplayground.com/crm/
${LOGIN_URL}     https://automationplayground.com/crm/login.html
${BROWSER}       firefox
${EMAIL}         admin@robotframeworktutorial.com
${PASSWORD}      pa55word

*** Test Cases ***
Should Be Able To Log Out
    Click Link    Sign In
    Wait Until Page Contains    Sign In
    Input Text    name:email-name   ${EMAIL}
    Input Text    name:password-name    ${PASSWORD}
    Click Button    id:submit-id
    Wait Until Page Contains    Customers
    Click Link    Sign Out
    Wait Until Page Contains    Signed Out

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
