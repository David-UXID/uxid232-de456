CREATE DATABASE IF NOT EXISTS recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_db;

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    subtitle VARCHAR(255) NOT NULL DEFAULT '',
    category VARCHAR(100) NOT NULL DEFAULT '',
    servings SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    description VARCHAR(255) NOT NULL DEFAULT '',
    ingredient_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    step_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO recipes (title, subtitle, category, servings, description, ingredient_count, step_count) VALUES
('Ancho-Orange Chicken', 'with Kale Rice & Roasted Carrots', 'Chicken', 4, 'We''re amping up chicken breasts with a glaze of smoky ancho chile paste and fresh orange juice in this recipe. On the side, roasted carrots and lightly creamy, golden raisin-studded rice perfectly accent the sweetness of the glaze.', 11, 6),
('Beef Medallions & Mushroom Sauce', 'with Mashed Potatoes', 'Beef', 2, 'In this easy recipe, inspired by steak Diane (an American restaurant classic), we''re searing beef medallions, then using the fond in the pan to make a rich, bright mushroom sauce for spooning on top. Garlic mashed potatoes and sautéed kale make for delicious, simple sides.', 9, 6);
