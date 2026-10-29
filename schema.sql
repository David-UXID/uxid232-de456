CREATE DATABASE IF NOT EXISTS recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_db;

DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO categories (name) VALUES
('Chicken'), ('Beef'), ('Pork'), ('Seafood'), ('Vegetarian'), ('Pasta'), ('Dessert');

CREATE TABLE recipes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    subtitle VARCHAR(255) NOT NULL DEFAULT '',
    category_id INT UNSIGNED NULL,
    servings SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    description VARCHAR(1000) NOT NULL DEFAULT '',
    ingredient_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    step_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recipes_category FOREIGN KEY (category_id) REFERENCES categories(id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO recipes (
    slug,
    title,
    subtitle,
    category_id,
    servings,
    description,
    ingredient_count,
    step_count
) VALUES
(
    'ancho-orange-chicken',
    'Ancho-Orange Chicken',
    'with Kale Rice & Roasted Carrots',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    4,
    'We''re amping up chicken breasts with a glaze of smoky ancho chile paste and fresh orange juice in this recipe. '
    'On the side, roasted carrots and lightly creamy, golden raisin-studded rice perfectly accent the sweetness of the glaze.',
    11,
    6
),
(
    'beef-medallions-mushroom-sauce',
    'Beef Medallions & Mushroom Sauce',
    'with Mashed Potatoes',
    (SELECT id FROM categories WHERE name = 'Beef'),
    2,
    'In this easy recipe, inspired by steak Diane (an American restaurant classic), we''re searing beef medallions, '
    'then using the fond in the pan to make a rich, bright mushroom sauce for spooning on top. Garlic mashed potatoes '
    'and sautéed kale make for delicious, simple sides.',
    9,
    6
),
(
    'broccoli-basil-pesto-sandwiches',
    'Broccoli & Basil Pesto Sandwiches',
    'with Romaine & Citrus Salad',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    4,
    'These Italian focaccia sandwiches are layered with broccoli, three cheeses, and a savory basil, cashew, and pine nut pesto, '
    'then baked in the oven to meld all the bright, aromatic flavors. On the side, we''re serving a refreshing salad of romaine '
    'and seasonal clementine, dressed in a creamy dressing made with fresh clementine juice.',
    14,
    6
),
(
    'broccoli-mozzarella-calzones',
    'Broccoli & Mozzarella Calzones',
    'with Caesar Salad',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    4,
    'These calzones are loaded with melty fresh mozzarella, creamy ricotta, and tender broccoli—balanced by a tangy tomato '
    'dipping sauce. For a refreshing side, we''re tossing crunchy romaine and briny black olives in our take on Caesar dressing.',
    12,
    6
),
(
    'bucatini-alfredo',
    'Bucatini Alfredo',
    'with Broccoli',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'This quick-cooking recipe captures all the deliciously creamy, rich flavor of the classic Italian-American sauce—with '
    'the welcome addition of quick-braised broccoli. A dusting of pecorino cheese completes each bowl with a touch of sharpness.',
    9,
    5
);
