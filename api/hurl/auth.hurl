# Register
POST {{host}}/api/users
{
  "user": {
    "username": "auth_{{uid}}",
    "email": "auth_{{uid}}@test.com",
    "password": "password123"
  }
}
HTTP 201
[Asserts]
jsonpath "$.user.username" == "auth_{{uid}}"
jsonpath "$.user.email" == "auth_{{uid}}@test.com"
jsonpath "$.user.bio" == null
jsonpath "$.user.image" == null
jsonpath "$.user.token" isString
jsonpath "$.user.token" not isEmpty
[Captures]
reg_token: jsonpath "$.user.token"

# Login
POST {{host}}/api/users/login
{
  "user": {
    "email": "auth_{{uid}}@test.com",
    "password": "password123"
  }
}
HTTP 200
[Asserts]
jsonpath "$.user.username" == "auth_{{uid}}"
jsonpath "$.user.email" == "auth_{{uid}}@test.com"
jsonpath "$.user.token" isString
jsonpath "$.user.token" not isEmpty
[Captures]
token: jsonpath "$.user.token"

# Get current user
GET {{host}}/api/user
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.user.username" == "auth_{{uid}}"
jsonpath "$.user.email" == "auth_{{uid}}@test.com"
jsonpath "$.user.token" isString
jsonpath "$.user.token" not isEmpty

# Update user
PUT {{host}}/api/user
Authorization: Token {{token}}
{
  "user": {
    "bio": "Updated bio"
  }
}
HTTP 200
[Asserts]
jsonpath "$.user.bio" == "Updated bio"
jsonpath "$.user.username" == "auth_{{uid}}"

# Verify update persisted
GET {{host}}/api/user
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.user.bio" == "Updated bio"

# Update username and email
PUT {{host}}/api/user
Authorization: Token {{token}}
{
  "user": {
    "username": "auth_{{uid}}_upd",
    "email": "auth_{{uid}}_upd@test.com"
  }
}
HTTP 200
[Asserts]
jsonpath "$.user.username" == "auth_{{uid}}_upd"
jsonpath "$.user.email" == "auth_{{uid}}_upd@test.com"
jsonpath "$.user.token" isString
jsonpath "$.user.token" not isEmpty
[Captures]
updated_token: jsonpath "$.user.token"

# Verify username/email update persisted
GET {{host}}/api/user
Authorization: Token {{updated_token}}
HTTP 200
[Asserts]
jsonpath "$.user.username" == "auth_{{uid}}_upd"
jsonpath "$.user.email" == "auth_{{uid}}_upd@test.com"
