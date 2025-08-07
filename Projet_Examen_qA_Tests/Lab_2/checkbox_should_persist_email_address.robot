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
Remember Me Checkbox Should Persist Email Address
    Click Link    Sign In
    Wait Until Element Is Visible    name:email-name    10s

    Input Text    name:email-name    ${USERNAME}
    Input Text    name:password-name    ${PASSWORD}
    Click Element    id:remember    # coche la case "Remember me"
    Click Element    name:submit-name

    Wait Until Page Contains Element    class:nav-link    10s
    Click Link    Sign Out

    Wait Until Page Contains Element    class:nav-link    10s
    Click Link    Sign In

    Comment    Fonctionnalité non fonctionnelle côté application
    [Tags]    expected_failure
    Wait Until Element Is Visible    name:email-name    10s
    ${prefilled_email}=    Get Value    name:email-name
    Should Be Equal As Strings    ${prefilled_email}    ${USERNAME}

    Capture Page Screenshot

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
