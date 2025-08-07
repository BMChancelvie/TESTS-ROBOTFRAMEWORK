*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}         https://automationplayground.com/crm/index.html
${BROWSER}     firefox
${USERNAME}    admin@robotframeworktutorial.com
${PASSWORD}    qwe123

*** Test Cases ***
Login Should Succeed With Valid Credentials
    Click Link    Sign In 
    Wait Until Page Contains Element    name:email-name    10s

    Input Text    name:email-name    ${USERNAME}
    Input Text    name:password-name    ${PASSWORD}
    Click Element    name:submit-name

    Wait Until Page Contains    Customers    timeout=10s
    Title Should Be             Customers

    Capture Page Screenshot

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
