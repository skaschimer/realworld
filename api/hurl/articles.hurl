# Setup: Register
POST {{host}}/api/users
{
  "user": {
    "username": "art_{{uid}}",
    "email": "art_{{uid}}@test.com",
    "password": "password123"
  }
}
HTTP 201
[Captures]
token: jsonpath "$.user.token"

# Create article with tags
POST {{host}}/api/articles
Authorization: Token {{token}}
{
  "article": {
    "title": "Test Article {{uid}}",
    "description": "Test description",
    "body": "Test body content",
    "tagList": ["d_{{uid}}", "t_{{uid}}"]
  }
}
HTTP 201
[Asserts]
jsonpath "$.article.title" == "Test Article {{uid}}"
jsonpath "$.article.slug" isString
jsonpath "$.article.description" == "Test description"
jsonpath "$.article.body" == "Test body content"
jsonpath "$.article.tagList" contains "d_{{uid}}"
jsonpath "$.article.tagList" contains "t_{{uid}}"
jsonpath "$.article.createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T"
jsonpath "$.article.updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T"
jsonpath "$.article.favorited" == false
jsonpath "$.article.favoritesCount" == 0
jsonpath "$.article.author.username" == "art_{{uid}}"
[Captures]
slug: jsonpath "$.article.slug"

# List all articles
GET {{host}}/api/articles
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].title" isString
jsonpath "$.articles[0].slug" isString
jsonpath "$.articles[0].description" isString
jsonpath "$.articles[0].body" not exists
jsonpath "$.articles[0].tagList" isCollection
jsonpath "$.articles[0].createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].favorited" isBoolean
jsonpath "$.articles[0].favoritesCount" isInteger
jsonpath "$.articles[0].author.username" isString

# List by author
GET {{host}}/api/articles?author=art_{{uid}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].title" isString
jsonpath "$.articles[0].slug" isString
jsonpath "$.articles[0].description" isString
jsonpath "$.articles[0].body" not exists
jsonpath "$.articles[0].tagList" isCollection
jsonpath "$.articles[0].createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].favorited" isBoolean
jsonpath "$.articles[0].favoritesCount" isInteger
jsonpath "$.articles[0].author.username" == "art_{{uid}}"

# List all articles with auth
GET {{host}}/api/articles
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].title" isString
jsonpath "$.articles[0].slug" isString
jsonpath "$.articles[0].description" isString
jsonpath "$.articles[0].body" not exists
jsonpath "$.articles[0].tagList" isCollection
jsonpath "$.articles[0].createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].favorited" isBoolean
jsonpath "$.articles[0].favoritesCount" isInteger
jsonpath "$.articles[0].author.username" isString

# List by author with auth
GET {{host}}/api/articles?author=art_{{uid}}
Authorization: Token {{token}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].title" isString
jsonpath "$.articles[0].slug" isString
jsonpath "$.articles[0].description" isString
jsonpath "$.articles[0].body" not exists
jsonpath "$.articles[0].tagList" isCollection
jsonpath "$.articles[0].createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].favorited" isBoolean
jsonpath "$.articles[0].favoritesCount" isInteger
jsonpath "$.articles[0].author.username" == "art_{{uid}}"

# List by tag
GET {{host}}/api/articles?tag=d_{{uid}}
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger
jsonpath "$.articlesCount" >= 1
jsonpath "$.articles[0].title" isString
jsonpath "$.articles[0].slug" isString
jsonpath "$.articles[0].description" isString
jsonpath "$.articles[0].body" not exists
jsonpath "$.articles[0].tagList" isCollection
jsonpath "$.articles[0].tagList" contains "d_{{uid}}"
jsonpath "$.articles[0].createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.articles[0].favorited" isBoolean
jsonpath "$.articles[0].favoritesCount" isInteger
jsonpath "$.articles[0].author.username" isString

# List articles without auth
GET {{host}}/api/articles
HTTP 200
[Asserts]
jsonpath "$.articles" isCollection
jsonpath "$.articlesCount" isInteger

# Get single article
GET {{host}}/api/articles/{{slug}}
HTTP 200
[Asserts]
jsonpath "$.article.title" == "Test Article {{uid}}"
jsonpath "$.article.slug" == "{{slug}}"
jsonpath "$.article.description" == "Test description"
jsonpath "$.article.body" == "Test body content"
jsonpath "$.article.tagList" isCollection
jsonpath "$.article.createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.favorited" == false
jsonpath "$.article.favoritesCount" == 0
jsonpath "$.article.author.username" == "art_{{uid}}"

# Update article body
PUT {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
{
  "article": {
    "body": "Updated body content"
  }
}
HTTP 200
[Asserts]
jsonpath "$.article.title" == "Test Article {{uid}}"
jsonpath "$.article.slug" == "{{slug}}"
jsonpath "$.article.description" == "Test description"
jsonpath "$.article.body" == "Updated body content"
jsonpath "$.article.tagList" isCollection
jsonpath "$.article.createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.favorited" isBoolean
jsonpath "$.article.favoritesCount" isInteger
jsonpath "$.article.author.username" == "art_{{uid}}"

# Verify update persisted
GET {{host}}/api/articles/{{slug}}
HTTP 200
[Asserts]
jsonpath "$.article.title" == "Test Article {{uid}}"
jsonpath "$.article.slug" == "{{slug}}"
jsonpath "$.article.description" == "Test description"
jsonpath "$.article.body" == "Updated body content"
jsonpath "$.article.tagList" isCollection
jsonpath "$.article.createdAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.updatedAt" matches "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
jsonpath "$.article.favorited" isBoolean
jsonpath "$.article.favoritesCount" isInteger
jsonpath "$.article.author.username" == "art_{{uid}}"

# Delete article
DELETE {{host}}/api/articles/{{slug}}
Authorization: Token {{token}}
HTTP 204

# Verify deletion
GET {{host}}/api/articles/{{slug}}
HTTP 404
[Asserts]
jsonpath "$.errors.article[0]" == "not found"
