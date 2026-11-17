# My Cookbook

A small PHP and MySQL cookbook project for browsing recipe summaries.

## Pages

- `recipes.php` displays recipes loaded from the `recipe_db` MySQL database. It shows each recipe's title, optional subtitle and category, servings, description, ingredient count, and step count.
- `admin.php` is the admin area. Only accounts with `users.is_admin = 1` can use it. Recipe upload is not built yet.
- `index.php` lets you enter a recipe name and displays a playful sample recipe. This page is currently a demo and does not read from the database.

## Requirements

- MAMP (or another local web server with PHP and MySQL)
- PHP's MySQLi extension

## Database notes

`schema.sql` creates the `recipe_db` database, a `categories` table, and a `recipes` table, then inserts sample categories and recipes. **Running this script drops and recreates the `recipes` and `categories` tables**, so existing data in those tables will be deleted.

Every account is an admin: new accounts default to `is_admin = 1`. The `users` table is not dropped on re-run, so databases created before the `is_admin` column was added need this one-time update:

```sql
ALTER TABLE users ADD COLUMN is_admin TINYINT(1) NOT NULL DEFAULT 1;
UPDATE users SET is_admin = 1;
```

If the column already exists, run only the `UPDATE` to make existing accounts admins.
## AI use

ChatGPT was used for guidance on the user form. Gemini was used to help troubleshoot some code issues.
