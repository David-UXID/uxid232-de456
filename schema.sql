CREATE DATABASE IF NOT EXISTS recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_db;

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL DEFAULT '',
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    prep_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO recipes (name, description, ingredients, instructions, prep_minutes) VALUES
('Spaghetti Aglio e Olio', 'Simple garlic and olive oil pasta.', 'Spaghetti, garlic, olive oil, chili flakes, parsley', 'Boil pasta. Saute garlic in oil with chili. Toss with pasta and parsley.', 20),
('Pancakes', 'Fluffy breakfast pancakes.', 'Flour, milk, eggs, sugar, baking powder, butter', 'Mix batter. Cook on a buttered griddle until golden on both sides.', 25),
('Guacamole', 'Fresh avocado dip.', 'Avocados, lime, onion, cilantro, salt', 'Mash avocados and stir in remaining ingredients.', 10),
('Chicken Stir Fry', 'Quick weeknight dinner.', 'Chicken, broccoli, soy sauce, garlic, ginger, rice', 'Stir fry chicken and vegetables, add sauce, serve over rice.', 30);
