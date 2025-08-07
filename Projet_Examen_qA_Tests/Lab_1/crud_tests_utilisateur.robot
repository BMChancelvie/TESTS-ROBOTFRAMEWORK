*** Settings ***
Library           RequestsLibrary
Library           Collections

Suite Setup       Create Session    fakestore    https://fakestoreapi.com

*** Variables ***
${headers}                Content-Type=application/json

# Cas valides
${valid_user}=            Evaluate    {"username": "john_doe", "email": "john@example.com", "password": "123456"}    json
${update_user}=           Evaluate    {"username": "jane_doe", "email": "jane@example.com", "password": "abcdef"}    json

# Cas invalides
${missing_email}=         Evaluate    {"username": "no_email", "password": "123456"}    json
${invalid_email_type}=    Evaluate    {"username": "bad_email", "email": 12345, "password": "abc"}    json
${invalid_fields}=        Evaluate    {"username": "", "email": "x", "password": ""}    json

*** Test Cases ***

# ------------------- AJOUT -------------------

Ajout Utilisateur - Scénario Passant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${valid_user}=    Evaluate    {"username": "john_doe", "email": "john@example.com", "password": "123456"}    json
    ${response}=    POST On Session    fakestore    /users    json=${valid_user}    headers=${headers}
    Status Should Be    201    ${response}
    ${json}=    Evaluate    json.loads('''${response.content}''')    json
    Dictionary Should Contain Key    ${json}    id

Ajout Utilisateur - Champ Obligatoire Manquant
    ${response}=    POST On Session    fakestore    /users    json=${missing_email}    headers=${headers}
    Status Should Be    400    ${response}

Ajout Utilisateur - Email au Mauvais Format
    ${response}=    POST On Session    fakestore    /users    json=${invalid_email_type}    headers=${headers}
    Status Should Be    400    ${response}

# ------------------- LECTURE -------------------

Lecture Utilisateur - Scénario Passant
    ${response}=    GET On Session    fakestore    /users/1
    Status Should Be    200    ${response}
    ${json}=    Evaluate    json.loads('''${response.content}''')    json
    Dictionary Should Contain Key    ${json}    id

Lecture Utilisateur - ID Inexistant
    ${response}=    GET On Session    fakestore    /users/9999
    Status Should Be    404    ${response}

Lecture Utilisateur - ID Malformé
    ${response}=    GET On Session    fakestore    /users/abc
    Status Should Be    400    ${response}

# ------------------- MODIFICATION -------------------

Modification Utilisateur - Scénario Passant
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${update_user}=    Evaluate    {"username": "new_name", "email": "new@example.com", "password": "newpass"}    json
    ${response}=    PUT On Session    fakestore    /users/1    json=${update_user}    headers=${headers}
    Status Should Be    200    ${response}
    ${json}=    Evaluate    json.loads('''${response.content}''')    json
    Log    ${json}
    Dictionary Should Contain Key    ${json}    username

Modification Utilisateur - Inexistant
    ${response}=    PUT On Session    fakestore    /users/9999    json=${update_user}    headers=${headers}
    Status Should Be    404    ${response}

Modification Utilisateur - Champs Invalides
    ${response}=    PUT On Session    fakestore    /users/1    json=${invalid_fields}    headers=${headers}
    Status Should Be    400    ${response}

# ------------------- SUPPRESSION -------------------

Suppression Utilisateur - Scénario Passant
    ${response}=    DELETE On Session    fakestore    /users/2
    Should Be True    ${response.status_code} in [200, 204]

Suppression Utilisateur - Inexistant
    ${response}=    DELETE On Session    fakestore    /users/9999
    Status Should Be    404    ${response}

Suppression Utilisateur - ID Malformé
    ${response}=    DELETE On Session    fakestore    /users/abc
    Status Should Be    400    ${response}
