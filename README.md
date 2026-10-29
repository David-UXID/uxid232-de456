# My Cookbook

A small PHP and MySQL cookbook project for browsing recipe summaries.

## Pages

- `recipes.php` displays recipes loaded from the `recipe_db` MySQL database. It shows each recipe's title, optional subtitle and category, servings, description, ingredient count, and step count.
- `index.php` lets you enter a recipe name and displays a playful sample recipe. This page is currently a demo and does not read from the database.

## Requirements

- MAMP (or another local web server with PHP and MySQL)
- PHP's MySQLi extension

## Database notes

`schema.sql` creates the `recipe_db` database, a `categories` table, and a `recipes` table, then inserts sample categories and recipes. **Running this script drops and recreates the `recipes` and `categories` tables**, so existing data in those tables will be deleted.

## AI use

ChatGPT was used for guidance on the user form. Gemini was used to help troubleshoot some code issues.
