# Setup: Register
POST {{host}}/api/users
{
  "user": {
    "username": "fav_{{uid}}",
    "email": "fav_{{uid}}@test.com",
    "password": "password123"
  }
}
HTTP 201
[Captures]
token: jsonpath "$.user.token"

# Setup: Create article
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Favorite Article {{uid}}",
    "description": "For favorites",
    "body": "Article body"
  }
}
HTTP 201
[Captures]
slug: jsonpath "$.article.slug"

# Favorite article
POST {{host}}/api/articles/{{slug}}/favorite
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.article.favorited" == true
jsonpath "$.article.favoritesCount" == 1

# Verify favorite persists
GET {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.article.favorited" == true
jsonpath "$.article.favoritesCount" == 1

# Articles filtered by favorited username
GET {{host}}/api/articles?favorited=fav_{{uid}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].favoritesCount" >= 1

# Articles filtered by favorited username with auth
GET {{host}}/api/articles?favorited=fav_{{uid}}
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].favoritesCount" >= 1

# Unfavorite article
DELETE {{host}}/api/articles/{{slug}}/favorite
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.article.favorited" == false
jsonpath "$.article.favoritesCount" == 0

# Verify unfavorite persists
GET {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.article.favorited" == false
jsonpath "$.article.favoritesCount" == 0

# Cleanup
DELETE {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
HTTP 204
