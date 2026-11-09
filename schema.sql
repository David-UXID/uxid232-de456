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

-- Not dropped on re-run so existing accounts are kept. Only a password hash is stored.
CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
),
(
    'bucatini-tomato-sauce',
    'Bucatini & Tomato Sauce',
    'with Roasted Broccoli',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'Made with petite datterini tomatoes, the sauce for tonight''s bucatini highlights briny olives and capers, hot red pepper flakes, and savory Grana Padano cheese. We''re mixing in roasted broccoli for contrasting texture and nutty-sweet flavor.',
    10,
    5
),
(
    'cheesy-enchiladas-rojas',
    'Cheesy Enchiladas Rojas',
    'with Mushrooms & Kale',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    4,
    'Our hearty vegetarian enchiladas are filled with a combination of fragrant, Mexican-spiced rice and sautéed mushrooms and kale. For even more flavor, we''re baking them under a smoky-sweet tomato sauce flavored with ancho chile paste and a layer of melty white cheddar. A dollop of lime-seasoned sour cream adds creamy, cooling balance. (You may receive green curly, dark green lacinato, or red kale.)',
    13,
    6
),
(
    'crispy-fish-sandwiches',
    'Crispy Fish Sandwiches',
    'with Tartar Sauce & Roasted Sweet Potato Wedges',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    4,
    'These sandwiches highlight wild Alaskan pollock—flavored with aromatic seasonings, coated with panko breadcrumbs, and pan-fried for a golden-brown crust. In classic fashion, a tangy, mayo-based tartar sauce perfectly balances the fish.',
    10,
    6
),
(
    'general-tsos-chicken',
    'General Tso''s Chicken',
    'with Bok Choy & Jasmine Rice',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'In this quick-cooking spin on a takeout favorite, hoisin sauce, honey, sriracha, and sesame oil lend our chicken the sweet, spicy, and nutty flavors General Tso''s is known for. A light dusting of cornstarch on the chicken just before it hits the pan creates a delicately crispy exterior (and helps it soak up the irresistible sauce later).',
    11,
    5
),
(
    'hoisin-glazed-pork-chops',
    'Hoisin-Glazed Pork Chops',
    'with Stir-Fried Vegetables & Wonton Noodles',
    (SELECT id FROM categories WHERE name = 'Pork'),
    4,
    'Delightfully chewy wonton noodles tossed in a nutty, savory sauce are a delicious accompaniment to these pork chops. For depth of flavor, we''re pan-searing the pork chops, then glazing them with barbecue-like hoisin, whose sweetness perfectly matches bites of sautéed carrots in the noodles.',
    11,
    6
);
