# Create article no auth
POST {{host}}/api/articles
{
  "article": {
    "title": "No Auth Article",
    "description": "test",
    "body": "test"
  }
}
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# GET unknown slug
GET {{host}}/api/articles/unknown-slug-{{uid}}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Update no auth
PUT {{host}}/api/articles/some-slug
{
  "article": {
    "body": "test"
  }
}
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# Delete no auth
DELETE {{host}}/api/articles/some-slug
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# GET feed no auth
GET {{host}}/api/articles/feed
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# Favorite no auth
POST {{host}}/api/articles/some-slug/favorite
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# Unfavorite no auth
DELETE {{host}}/api/articles/some-slug/favorite
HTTP 401
[Asserts]
jsonpath "$.errors.token[0]" == "is missing"

# Setup: Register for authenticated error tests
POST {{host}}/api/users
{
  "user": {
    "username": "ea_art_{{uid}}",
    "email": "ea_art_{{uid}}@test.com",
    "password": "password123"
  }
}
HTTP 201
[Captures]
token: jsonpath "$.user.token"

# Create article empty title
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "",
    "description": "test",
    "body": "test"
  }
}
HTTP 422
[Asserts]
jsonpath "$.errors.title[0]" == "can't be blank"

# Create article empty description
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Err Desc {{uid}}",
    "description": "",
    "body": "test"
  }
}
HTTP 422
[Asserts]
jsonpath "$.errors.description[0]" == "can't be blank"

# Create article empty body
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Err Body {{uid}}",
    "description": "test",
    "body": ""
  }
}
HTTP 422
[Asserts]
jsonpath "$.errors.body[0]" == "can't be blank"

# Create article for duplicate test
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Dup Article {{uid}}",
    "description": "test",
    "body": "test"
  }
}
HTTP 201
[Captures]
slug: jsonpath "$.article.slug"

# Create article duplicate title
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Dup Article {{uid}}",
    "description": "test",
    "body": "test"
  }
}
HTTP 409
[Asserts]
jsonpath "$.errors.title[0]" == "has already been taken"

# Update unknown slug
PUT {{host}}/api/articles/unknown-slug-{{uid}}
Authorization: Token {{token}}
{
  "article": {
    "body": "test"
  }
}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Favorite unknown slug
POST {{host}}/api/articles/unknown-slug-{{uid}}/favorite
Authorization: Token {{token}}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Unfavorite unknown slug
DELETE {{host}}/api/articles/unknown-slug-{{uid}}/favorite
Authorization: Token {{token}}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Update unknown slug
PUT {{host}}/api/articles/unknown-slug-{{uid}}
Authorization: Token {{token}}
{
  "article": {
    "body": "test"
  }
}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Delete unknown slug
DELETE {{host}}/api/articles/unknown-slug-{{uid}}
Authorization: Token {{token}}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"

# Cleanup
DELETE {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
HTTP 204
