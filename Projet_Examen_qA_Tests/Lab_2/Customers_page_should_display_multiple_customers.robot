*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}           https://automationplayground.com/crm/
${BROWSER}       firefox
${EMAIL}         admin@robotframeworktutorial.com
${PASSWORD}      pa55word

*** Test Cases ***
Customers Page Should Display Multiple Customers
    Click Link    Sign In
    Wait Until Page Contains    Sign In
    Input Text    name:email-name   ${EMAIL}
    Input Text    name:password-name    ${PASSWORD}
    Click Button    id:submit-id
    Wait Until Page Contains    Customers

    ${rows}=    Get Element Count    xpath://table[@id='customers']/tbody/tr
    Should Be True    ${rows} > 1    Il y a encore plus de clients que ceux affichés à la page d'Acceuil.

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
