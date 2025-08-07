*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Home Page
Suite Teardown    Close Browser

*** Variables ***
${URL}           https://automationplayground.com/crm/
${BROWSER}       firefox
${EMAIL}         admin@robotframeworktutorial.com
${PASSWORD}      pa55word

${CUST_FIRST}    Test
${CUST_LAST}     User
${CUST_CITY}     Paris
${CUST_STATE}    id:StateOrRegion
${CUST_GENDER}   xpath://input[@name='gender'][@value='male']

*** Test Cases ***
Should Be Able To Add New Customer
    [Documentation]    Connecte-toi et ajoute un nouveau client avec des données 
    
    ${RANDOM}        Evaluate    random.randint(1000, 9999)    modules=random
    ${CUST_EMAIL}    Set Variable    testuser${RANDOM}@example.com

    # Authentification
    Click Link    Sign In
    Wait Until Page Contains    Sign In
    Input Text    name:email-name    ${EMAIL}
    Input Text    name:password-name   ${PASSWORD}
    Click Button    id:submit-id
    Wait Until Page Contains    Customers

    # Aller à la page ajout client
    Click Link    New Customer
    Wait Until Page Contains    Add Customer

    # Remplir les champs du formulaire
    Input Text    id:EmailAddress    ${CUST_EMAIL}
    Input Text    id:FirstName       ${CUST_FIRST}
    Input Text    id:LastName        ${CUST_LAST}
    Input Text    id:City            ${CUST_CITY}
    Select From List By Value    ${CUST_STATE}    FL
    Click Element    ${CUST_GENDER}
    Click Element    name:promos-name   # facultatif : cocher la case "promotion"

    # Soumettre
    Click Button    xpath://button[text()='Submit']
    Wait Until Page Contains    Customers

*** Keywords ***
Open Browser To Home Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
