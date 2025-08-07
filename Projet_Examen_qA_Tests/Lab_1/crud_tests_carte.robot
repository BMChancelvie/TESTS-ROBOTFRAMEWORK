*** Settings ***
Library           RequestsLibrary
Library           Collections

Suite Setup       Create Session    fakestore    https://fakestoreapi.com

*** Variables ***
${headers}        Content-Type=application/json
${valid_cart}     {"userId": 5, "products": [{"productId": 1, "quantity": 2}]}
${missing_user}   {"products": [{"productId": 1, "quantity": 2}]}
${wrong_products}    {"userId": 5, "products": "invalid data"}

*** Test Cases ***

Ajout Carte - Scénario Passant
    ${valid_cart}=    Evaluate    {"userId": 5, "products": [{"productId": 1, "quantity": 2}]}    json
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    fakestore    /carts    json=${valid_cart}    headers=${headers}
    Status Should Be    201    ${response}
    ${json}=    Evaluate    json.loads('''${response.content}''')    json
    Dictionary Should Contain Key    ${json}    id

Ajout Carte - Champ manquant
    ${missing_user}=    Evaluate    {"products": [{"productId": 1, "quantity": 2}]}    json
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    fakestore    /carts    json=${missing_user}    headers=${headers}
    Status Should Be    400    ${response}
    
Ajout Carte - Format produit incorrect
    ${wrong_products}=    Evaluate    {"userId": 5, "products": "invalid data"}    json
    ${response}=    POST On Session    fakestore    /carts    json=${wrong_products}    headers=${headers}
    Status Should Be    400    ${response}

# READ (Lecture Carte)
Lecture Carte - Scénario Passant
    ${response}=    GET On Session    fakestore    /carts/1
    Status Should Be    200    ${response}
    ${json}=    To Json    ${response.content}
    Dictionary Should Contain Key    ${json}    id

Lecture Carte - ID inexistant
    ${response}=    GET On Session    fakestore    /carts/9999
    Status Should Be    404    ${response}

Lecture Carte - ID malformé
    ${response}=    GET On Session    fakestore    /carts/abc
    Status Should Be    400    ${response}

# UPDATE (Modification Carte)
Modification Carte - Scénario Passant
    ${update_data}=    Evaluate    {"userId": 6, "products": [{"productId": 2, "quantity": 4}]}    json
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    fakestore    /carts/1    json=${update_data}    headers=${headers}
    Status Should Be    200    ${response}

Modification Carte - Carte inexistante
    ${response}=    PUT On Session    fakestore    /carts/9999    data=${valid_cart}    headers=${headers}
    Status Should Be    404    ${response}

Modification Carte - Données invalides
    ${response}=    PUT On Session    fakestore    /carts/1    data=${wrong_products}    headers=${headers}
    Status Should Be    400    ${response}

# DELETE (Suppression Carte)
Suppression Carte - Scénario Passant
    ${response}=    DELETE On Session    fakestore    /carts/6
    Should Be True    ${response.status_code} in [200, 204]

Suppression Carte - Carte inexistante
    ${response}=    DELETE On Session    fakestore    /carts/9999
    Status Should Be    404    ${response}

Suppression Carte - ID malformé
    ${response}=    DELETE On Session    fakestore    /carts/abc
    Status Should Be    400    ${response}
