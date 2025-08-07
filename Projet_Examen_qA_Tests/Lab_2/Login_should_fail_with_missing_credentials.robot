*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}         https://automationplayground.com/crm/index.html
${BROWSER}     firefox

*** Test Cases ***
Login Should Fail With Missing Credentials
    Click Link    Sign In
    Wait Until Page Contains Element    name:email-name    10s
    Click Element    name:submit-name

    Sleep    2s
    ${title}=    Get Title
    Log To Console    === TITLE: ${title}
    Capture Page Screenshot

    Title Should Be    Customer Service - Login

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
