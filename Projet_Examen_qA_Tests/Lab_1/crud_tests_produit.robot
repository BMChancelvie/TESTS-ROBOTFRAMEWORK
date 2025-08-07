*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    BuiltIn

Suite Setup       Create Session    fakestore    https://fakestoreapi.com    verify=False

*** Variables ***
${BODY}    {"title": "test product", "price": 13.5, "description": "lorem ipsum set", "image": "https://i.pravatar.cc", "category": "electronic"}

*** Test Cases ***
Ajouter un produit - Scénario Passant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=   POST On Session    fakestore    /products    headers=${headers}    data=${BODY}
    Log    ${response.status_code}
    Log    ${response.text}
    Should Be Equal As Integers    ${response.status_code}    201

*** Test Cases ***
Ajouter un produit - Scénario Non Passant - Champ manquant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Set Variable    {"price": 13.5, "description": "lorem ipsum set", "image": "https://i.pravatar.cc", "category": "electronic"}
    ${response}=   POST On Session    fakestore    /products    headers=${headers}    data=${body}
    Should Be Equal As Integers    ${response.status_code}    400

*** Test Cases ***
Ajouter un produit - Scénario Non Passant - Type invalide
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Set Variable    {"title": "test", "price": "treize euros", "description": "test", "image": "https://i.pravatar.cc", "category": "electronic"}
    ${response}=   POST On Session    fakestore    /products    headers=${headers}    data=${body}
    Should Be Equal As Integers    ${response.status_code}    400

*** Test Cases ***
Lire un produit - Scénario Passant
    Create Session    fakestore    https://fakestoreapi.com
    ${response}=    GET On Session    fakestore    /products/1
    ${json}=    Evaluate    json.loads('''${response.content}''')    json
    Should Be Equal As Numbers    ${json['id']}    1

Lire un produit - Scénario Non Passant - ID inexistant
    ${response}=   GET On Session    fakestore    /products/99999
    Should Be Equal As Integers    ${response.status_code}    404

Lire un produit - Scénario Non Passant - ID invalide
    ${response}=   GET On Session    fakestore    /products/abc
    Should Be Equal As Integers    ${response.status_code}    400

Modifier un produit - Scénario Passant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Set Variable    {"title": "Produit modifié", "price": 99.99}
    ${response}=   PUT On Session    fakestore    /products/1    headers=${headers}    data=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    Produit modifié

Modifier un produit - Scénario Non Passant - ID inexistant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Set Variable    {"title": "Impossible"}
    ${response}=   PUT On Session    fakestore    /products/99999    headers=${headers}    data=${body}
    Should Be Equal As Integers    ${response.status_code}    404

Modifier un produit - Scénario Non Passant - Données invalides
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Set Variable    {"price": "gratuit"}
    ${response}=   PUT On Session    fakestore    /products/1    headers=${headers}    data=${body}
    Should Be Equal As Integers    ${response.status_code}    400

Supprimer un produit - Scénario Passant
    ${response}=   DELETE On Session    fakestore    /products/1
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    id

Supprimer un produit - Scénario Non Passant - ID inexistant
    ${response}=   DELETE On Session    fakestore    /products/99999
    Should Be Equal As Integers    ${response.status_code}    404

Supprimer un produit - Scénario Non Passant - ID invalide
    ${response}=   DELETE On Session    fakestore    /products/abc
    Should Be Equal As Integers    ${response.status_code}    400

