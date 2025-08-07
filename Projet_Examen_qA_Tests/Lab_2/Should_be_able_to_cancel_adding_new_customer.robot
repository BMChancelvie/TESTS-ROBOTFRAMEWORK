*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn

*** Variables ***
${URL}               https://automationplayground.com/crm/
${LOGIN_EMAIL}       admin@robotframeworktutorial.com
${LOGIN_PASSWORD}    pa55word

*** Test Cases ***
Should Be Able To Cancel Adding New Customer
    Open Browser    ${URL}    firefox
    Maximize Browser Window

    Click Link    Sign In
    Input Text    name:email-name     ${LOGIN_EMAIL}
    Input Text    name:password-name     ${LOGIN_PASSWORD}
    Click Button    id:submit-id
    Wait Until Page Contains    Customers

    Click Link    New Customer
    Wait Until Page Contains    Add Customer

    Click Link    Cancel
    # ou Click Element    css:a.btn.btn-default
    Wait Until Page Contains    Customers

    Close Browser
