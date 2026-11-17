CREATE DATABASE IF NOT EXISTS recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_db;

DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO categories (name) VALUES
('Chicken'), ('Beef'), ('Pork'), ('Seafood'), ('Vegetarian'), ('Pasta'), ('Dessert'), ('Turkey');

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
    image VARCHAR(255) NOT NULL DEFAULT '',
    ingredients TEXT NULL,
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

INSERT INTO recipes (
    slug,
    title,
    subtitle,
    category_id,
    servings,
    description,
    ingredient_count,
    step_count,
    ingredients
) VALUES
(
    'honey-butter-barramundi',
    'Honey-Butter Barramundi',
    'with Za''atar Roasted Vegetables',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    4,
    'This Middle Eastern recipe pairs crispy barramundi—served in a family-friendly pan sauce of honey and butter—with a medley of winter vegetables. For savory, herby flavor, we''re seasoning the vegetables with za''atar before roasting them.',
    11,
    0,
    '4 Carrots
6 oz Radishes
1 Lemon
2 cloves Garlic
1 bunch Parsley
2 Tbsps Butter
2 Tbsps Honey
4 Skin-On Barramundi Fillets
½ cup Plain Greek Yogurt
1⅛ lbs Yukon Gold Potatoes
1 Tbsp Za''atar Seasoning (Ground Sumac, Sesame Seeds, Salt, Ground Thyme, Whole Dried Oregano, & Crushed Aleppo Pepper)'
),
(
    'kale-ricotta-quiche',
    'Kale & Ricotta Quiche',
    'with Romaine, Apple, & Almond Salad',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    4,
    'This crowd-pleasing quiche showcases a rich, eggy filling made with ricotta and cream —balanced by hearty sautéed kale. On the side, we''re serving a refreshing salad of crisp romaine and apple, wrapped in a creamy lemon dressing.',
    13,
    0,
    '1 Pie Crust (in Tin)
1 bunch Kale
2 cloves Garlic
1 Shallot
½ cup Heavy Cream
1 Lemon
1 Apple
4 Cage-Free Farm Eggs
1 cup Part-Skim Ricotta Cheese
1 Romaine Lettuce Heart
2 Tbsps Sliced Roasted Almonds
1 Tbsp Cajun Spice Blend (Smoked Paprika, Ground Yellow Mustard, Onion Powder, Garlic Powder, Whole Dried Oregano, Whole Dried Thyme, & Cayenne Pepper)
2 Tbsps Crème Fraîche'
),
(
    'mexican-spiced-barramundi',
    'Mexican-Spiced Barramundi',
    'with Kale, Sweet Potato, & Avocado Salad',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    2,
    'This recipe has been approved by Whole30®. To learn more about their guidelines, visit Whole30.com. We''re partnering with Whole30® to bring you the first of eight weeks of delicious recipes. Zesty spiced barramundi is the perfect partner for a salad of roasted sweet potato and kale, marinated in a creamy avocado and citrus dressing to soften the leaves.',
    9,
    0,
    '2 Skin-On Barramundi Fillets
1 Sweet Potato
1 bunch Kale
1 Avocado
1 Lime
1 Navel Orange
1 clove Garlic
2 Tbsps Roasted Pepitas
1 Tbsp Mexican Spice Blend (Ancho Chile Powder, Smoked Paprika, Garlic Powder, Ground Cumin, & Dried Mexican Oregano)'
),
(
    'mushroom-potato-tacos',
    'Mushroom & Potato Tacos',
    'with Romaine & Orange Salad',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'For this hearty vegetarian meal, we''re filling soft flour tortillas with mushrooms and potato—seasoned with a zesty, chorizo-inspired blend, then roasted. A pickled pepper relish lends bright flavor to the tacos, all tied together with a creamy sauce seasoned with the same spices. Our side salad of juicy orange and crunchy romaine rounds out the dish.',
    13,
    0,
    '4 Flour Tortillas
3 oz Radishes
1 Orange
¾ lb Yukon Gold Potatoes
6 oz Cremini Mushrooms
1 Shallot
3 Tbsps Roasted Peanuts
¼ cup Sour Cream
1 oz Sliced Pickled Jalapeño Pepper
1 oz Golden Or Red Sweet Piquante Peppers
1 Tbsp Spanish Spice Blend (Smoked Paprika, Ground Cumin, Ground Coriander, Dried Mexican Oregano, Cayenne Pepper, & Ground Cinnamon)
1 Romaine Lettuce Heart
2 Tbsps Rice Vinegar'
),
(
    'parmesan-crusted-chicken',
    'Parmesan-Crusted Chicken',
    'with Mashed Sweet Potatoes & Roasted Broccoli',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    4,
    'In this simple, seasonal recipe, you''ll coat chicken in a combination of flour, parmesan cheese, and savory spices before pan-searing it. We''re adding more of the same spices to a bright, creamy sauce, perfect for spooning over the chicken and broccoli.',
    9,
    0,
    '1½ lbs Sweet Potatoes
1 lb Broccoli
1 Lemon
2 Tbsps Butter
¼ cup Mayonnaise
4 Boneless, Skinless Chicken Breasts
¼ cup All-Purpose Flour
½ cup Grated Parmesan Cheese
1 Tbsp Weeknight Hero Spice Blend (Garlic Powder, Onion Powder, Smoked Paprika, & Whole Dried Parsley)'
),
(
    'pimento-cheeseburgers',
    'Pimento Cheeseburgers',
    'with Sweet Potato Oven Fries',
    (SELECT id FROM categories WHERE name = 'Beef'),
    2,
    'Tonight, the classic cheeseburger gets an easy, Southern-style lift from pimento cheese —a zesty spread made with cheddar, mayo, pickled peppers, and spices. We''re serving our burgers with sweet potato oven fries for a flavorful, seasonal twist on the usual side.',
    7,
    0,
    '10 oz Ground Beef
2 Potato Buns
1 Sweet Potato
2 oz Cheddar Cheese
1 oz Sweet Piquante Peppers
2 Tbsps Mayonnaise
1 tsp Pimento Cheese Spice Blend (Garlic Powder, Ground Yellow Mustard, & Sugar)'
),
(
    'pork-chorizo-tacos',
    'Pork Chorizo Tacos',
    'with Cheesy Roasted Potatoes',
    (SELECT id FROM categories WHERE name = 'Pork'),
    2,
    'These tacos get plenty of bold flavor from ground chorizo (a type of spiced pork sausage), cooked into a delightfully saucy filling with cabbage and fresh citrus juices. On the side, we''re livening up roasted potatoes with garlic and Cotija cheese.',
    10,
    0,
    '6 Flour Tortillas
½ lb Green Cabbage
1 Orange
1 Lime
3 oz Radishes
1 clove Garlic
¾ lb Yukon Gold Potatoes
10 oz Ground Pork Chorizo
2 Tbsps Crème Fraîche
2 Tbsps Grated Cotija Cheese'
),
(
    'roasted-broccoli-fregola-sarda-salad',
    'Roasted Broccoli & Fregola Sarda Salad',
    'with Hard-Boiled Eggs & Tahini Dressing',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'This Middle Eastern-inspired recipe is brimming with varied flavors and textures. Toasty pearls of pasta, roasted vegetables (seasoned with savory, herby za''atar), crumbled cheese, and chopped almonds all come together in a smooth, nutty dressing.',
    11,
    0,
    '2 Cage-Free Farm Eggs
½ cup Fregola Sarda Pasta
1 clove Garlic
1 lb Broccoli
1 Red Onion
1 bunch Mint
2 Tbsps Tahini
1 oz Pecorino Romano Cheese
1 Tbsp Za''atar Seasoning (Ground Sumac, Sesame Seeds, Salt, Ground Thyme, Whole Dried Oregano, & Crushed Aleppo Pepper)
3 Tbsps Roasted Almonds
1 Lemon'
),
(
    'roasted-brussels-sprout-freekeh-salad',
    'Roasted Brussels Sprout & Freekeh Salad',
    'with Lemon Yogurt & Barrel-Aged Feta',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'This Mediterranean-inspired grain salad is brimming with varied, vibrant flavors. Nutty freekeh and roasted Brussels sprouts get pops of sweetness from pickled peppers and dates, balanced by briny crumbled Feta. To dollop on top, we''re serving lemon-seasoned yogurt for extra brightness.',
    12,
    0,
    '⅔ cup Cracked Freekeh
½ cup Sheep''s Milk Yogurt
2 Carrots
2 cloves Garlic
1 Lemon
1 bunch Mint
2 Dried Medjool Dates
2 Tbsps Pickled Peruvian Peppers
1¾ oz Barrel-Aged Feta Cheese
2 Tbsps Roasted Almonds
¼ tsp Crushed Red Pepper Flakes
¾ lb Brussels Sprouts'
),
(
    'roasted-cauliflower-salad',
    'Roasted Cauliflower Salad',
    'with Caper Brown Butter & Parmesan Breadcrumbs',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'Seasonal salads don''t get much more satisfying than this. We''re bringing roasted cauliflower and sautéed kale together with cheesy toasted breadcrumbs and a briny caper-studded dressing. Served on top, soft-boiled eggs add extra richness.',
    10,
    0,
    '1 bunch Kale
2 Cage-Free Farm Eggs
2 cloves Garlic
1 head Cauliflower
1 Lemon
2 Tbsps Butter
1 Shallot
1 Tbsp Capers
3 Tbsps Panko Breadcrumbs
¼ cup Grated Parmesan Cheese'
),
(
    'roasted-chicken-fall-vegetables',
    'Roasted Chicken & Fall Vegetables',
    'with Cranberry & Ginger Compote',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    4,
    'For this comforting autumn dinner, we''re seasoning half chickens with the classic flavors of garlic, onion, and smoked paprika, then roasting them along with sweet potatoes and Brussels sprouts. The rich chicken finds delicious contrast in a tart-sweet compote, made simply by cooking fresh cranberries and ginger with a bit of sugar and water.',
    9,
    0,
    '2 Half Chickens
1 lb Sweet Potatoes
4 oz Cranberries
½ lb Brussels Sprouts
2 Tbsps Apple Cider Vinegar
2 Tbsps Sugar
1 1-Inch Piece Ginger
¼ cup Roasted Walnuts
1 Tbsp Weeknight Hero Spice Blend (Garlic Powder, Onion Powder, Smoked Paprika, & Whole Dried Parsley)'
),
(
    'roasted-pork-broccoli',
    'Roasted Pork & Broccoli',
    'with Apple, Cheese Sauce, & Garlic Breadcrumbs',
    (SELECT id FROM categories WHERE name = 'Pork'),
    2,
    'To elevate the classic savory-sweet pairing, we''re topping roasted pork with sautéed apple in this crowd-pleasing recipe. The pork and a side of broccoli, roasted on the same sheet pan, come together with a rich, warming fontina cheese sauce.',
    10,
    0,
    '1 Pork Tenderloin
½ lb Broccoli
2 cloves Garlic
1 Apple
2 oz Fontina Cheese
¼ cup Milk
3 Tbsps Panko Breadcrumbs
2 Tbsps All-Purpose Flour
1 Tbsp Apple Cider Vinegar
1 Tbsp Southern Spice Blend (Onion Powder, Garlic Powder, Ground Yellow Mustard, Smoked Paprika, & Cayenne Pepper)'
),
(
    'roasted-red-pepper-pasta',
    'Roasted Red Pepper Pasta',
    'with Lemon-Parmesan Broccoli',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'In this quick-cooking recipe, whole grain pipe rigate gets pops of flavor from sweet roasted piquillo peppers and briny capers—plus a layer of exciting crunch from almonds. It all comes together in a creamy, mildly spicy sauce.',
    12,
    0,
    '½ lb Broccoli
1 Lemon
2 cloves Garlic
1 Tbsp Capers
1 Tbsp Tomato Paste
¼ cup Heavy Cream
1 Tbsp Butter
6 oz Whole Grain Pipe Rigate Pasta
2 oz Roasted Piquillo Peppers
2 Tbsps Grated Parmesan Cheese
2 Tbsps Sliced Roasted Almonds
1½ tsps Calabrian Chile Paste'
),
(
    'roasted-squash-curry',
    'Roasted Squash Curry',
    'with Crispy Mung Beans & Jasmine Rice',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'In this recipe, veggie curry gets a unique lift from spaghetti squash—oven-roasted, then broken into pasta-like strands with a fork. We''re finishing our squash and bok choy in a sauce made with fresh aromatics and two well-balanced pantry ingredients: spicy yellow curry paste and cooling coconut milk. A garnish of dried mung beans brings it all together with exciting crunch.',
    12,
    0,
    '1 Spaghetti Squash
1 Lime Leaf
½ cup Jasmine Rice
1¾ cups Light Coconut Milk
1 Lime
1 Yellow Onion
1 bunch Mint
2 Tbsps Dried Mung Beans
1½ Tbsps Yellow Curry Paste
1 1-Inch Piece Ginger
1 Tbsp Sugar
½ lb Baby Bok Choy'
),
(
    'roasted-turkey-breast-farro-endive-salad',
    'Roasted Turkey Breast & Farro-Endive Salad',
    'with Brown Butter Apple Compote',
    (SELECT id FROM categories WHERE name = 'Turkey'),
    2,
    'Fall comfort food gets a delicious lift in this recipe. A sweet, toasty compote (simply apple and shallot cooked in brown butter) balances our savory roasted turkey breast. On the side, we''re tossing warm grains with endive—first cooked with a bit of honey and lemon to brighten its mildly bitter flavor.',
    10,
    0,
    '1 Turkey Breast Roast
⅔ cup Semi-Pearled Farro
1 Apple
1 Lemon
1 Endive
1 bunch Chives
2 Tbsps Butter
1 Shallot
1 Tbsp Honey
1 Tbsp Whole Grain Dijon Mustard'
),
(
    'salmon-honey-glazed-carrots',
    'Salmon & Honey-Glazed Carrots',
    'with Lemon-Saffron Yogurt Sauce',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    2,
    'This elegant dish gets unique flavor from a prized spice, saffron, used two ways: added to the water used to boil the potatoes and stirred into a creamy yogurt sauce. The bright sauce is delicious spooned over rich salmon, potatoes, and carrots—which get another flavor-packed lift from a glaze of honey and fragrant cumin. Aleppo pepper adds just a hint of spice throughout the dish, balanced by cooling fresh mint.',
    11,
    0,
    '1 bunch Mint
2 Skin-On Salmon Fillets
2 cloves Garlic
6 oz Carrots
1 Lemon
¾ lb Yukon Gold Potatoes
1 Pinch Saffron
1 Tbsp Honey
½ cup Plain Greek Yogurt
½ tsp Crushed Aleppo Pepper
½ tsp Ground Cumin'
),
(
    'seared-chicken-mashed-potatoes',
    'Seared Chicken & Mashed Potatoes',
    'with Maple-Glazed Carrots',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'We''re giving seared chicken a lift with a rich pan sauce, made with sweet maple syrup and tangy sherry vinegar. It''s the perfect accompaniment for creamy mashed potatoes and roasted carrots, dressed with a bit more maple syrup.',
    7,
    0,
    '½ lb Carrots
2 Tbsps Maple Syrup
1 Tbsp Butter
2 Boneless, Skinless Chicken Breasts
¾ lb Yukon Gold Potatoes
2 Tbsps Crème Fraîche
1 Tbsp Sherry Vinegar'
),
(
    'seared-steaks-garlic-butter',
    'Seared Steaks & Garlic Butter',
    'with Oven Fries',
    (SELECT id FROM categories WHERE name = 'Beef'),
    4,
    'Steak frites, or steak with french fries, is classic French bistro fare. Tonight''s steaks get another layer of rich flavor from garlic butter, spooned over them as they cook. Creamy mustard sauce is a perfect match for the rich steaks and hearty oven-roasted fries, while a simple salad adds refreshing contrast. (You may receive crisp romaine or tender butter lettuce.)',
    8,
    0,
    '2 Strip Steaks
1 head Butter Lettuce
2 cloves Garlic
2 Russet Potatoes
1 bunch Chives
3 Tbsps Creamy Mustard Sauce
2 Tbsps Butter
1 Tbsp Red Wine Vinegar'
),
(
    'shiitake-hoisin-beef-burgers',
    'Shiitake & Hoisin Beef Burgers',
    'with Miso Mayonnaise & Roasted Sweet Potatoes',
    (SELECT id FROM categories WHERE name = 'Beef'),
    4,
    'These Asian-inspired burgers get their irresistible umami flavor from chopped shiitake mushrooms (mixed right into the beef) and a miso-mayo spread. Piled on top, crisp ribbons of bok choy round out the burgers, served with a side of roasted sweet potato wedges.',
    10,
    0,
    '1¼ lbs Ground Beef
4 Potato Buns
2 cloves Garlic
2 Scallions
2 Sweet Potatoes
½ lb Baby Bok Choy
2 Tbsps Hoisin Sauce
2 Tbsps Sweet White Miso Paste
½ oz Dried Shiitake Mushrooms
¼ cup Mayonnaise'
),
(
    'shrimp-fra-diavolo',
    'Shrimp Fra Diavolo',
    'with Lumaca Rigata Pasta',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    2,
    'Tonight''s variation on the beloved Italian-American dish gets its "devilish" heat from Calabrian chile paste, mixed into a tangy-sweet tomato sauce. It perfectly coats shrimp, cabbage, and lumaca rigata pasta. A garnish of sliced almonds finishes the dish with contrasting crunch.',
    9,
    0,
    '10 oz Peeled & Deveined Shrimp
½ lb Green Cabbage
6 oz Lumaca Rigata Pasta
2 cloves Garlic
1 8-Ounce Can Tomato Sauce
1½ tsps Calabrian Chile Paste
2 Tbsps Crème Fraîche
2 Tbsps Sliced Roasted Almonds
2 Tbsps Verjus Blanc'
),
(
    'smoked-gouda-mushroom-flatbread',
    'Smoked Gouda & Mushroom Flatbread',
    'with Endive & Apple Salad',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'For this rustic seasonal meal, we''re topping flatbread—made by rolling out pizza dough until extra-thin—with two kinds of cheeses, including nutty smoked Gouda. Cremini mushrooms add even more irresistibly savory flavor to the flatbread, balanced by a bright, crisp endive and apple salad.',
    11,
    0,
    '1 bunch Kale
1 Endive
2 cloves Garlic
2 oz Smoked Gouda Cheese
2 oz Fontina Or Aged Alpine Cheese
1 Red Onion
¾ lb Pizza Dough
4 oz Cremini Mushrooms
1 Apple
1 Tbsp Honey
1 Tbsp Apple Cider Vinegar'
),
(
    'spicy-chicken-quesadillas',
    'Spicy Chicken Quesadillas',
    'with Beet & Orange Salad',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'A seasonal salad of striped Chioggia beet, juicy orange, and peanuts is a fresh pairing for these zesty quesadillas. We''re seasoning the chicken filling with both jalapeño pepper and Mexican spices—balanced by a layer of melty white cheddar. Mexican crema brightened up with lime juice is perfect for dipping.',
    11,
    0,
    '2 Boneless, Skinless Chicken Breasts
4 Flour Tortillas
2 Scallions
6 oz Chioggia Beet
1 Jalapeño Pepper
1 Lime
1 Navel Orange
3 Tbsps Roasted Peanuts
2 oz White Cheddar Cheese
¼ cup Mexican Crema
1 Tbsp Mexican Spice Blend (Ancho Chile Powder, Smoked Paprika, Garlic Powder, Ground Cumin, & Dried Mexican Oregano)'
),
(
    'spicy-pork-korean-rice-cakes',
    'Spicy Pork & Korean Rice Cakes',
    'with Bok Choy',
    (SELECT id FROM categories WHERE name = 'Pork'),
    4,
    'In this crowd-pleasing recipe, a savory and spicy sauce (balanced by a touch of cooling crème fraîche) brings together ground pork, bok choy, and aromatics. We''re mixing in delightfully chewy tteok, or rice cakes—a staple of Korean cuisine.',
    10,
    0,
    '1 lb Ground Pork
1 lb Korean Rice Cakes
2 cloves Garlic
2 heads Baby Bok Choy
2 Tbsps Soy Glaze
1½ Tbsps Gochujang
1 1-Inch Piece Ginger
¼ cup Black Bean Sauce
¼ cup Crème Fraîche
1 bunch Chives'
),
(
    'sweet-sour-vegetable-stir-fry',
    'Sweet & Sour Vegetable Stir-Fry',
    'with Fried Eggs & Peanuts',
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    2,
    'Two kinds of citrus—seasonal orange and lemon—give the sauce for our stir-fried vegetables its irresistible sweet-sour balance. The carrots, celery, and bok choy perfectly contrast a rich fried egg and fluffy, radish-studded white rice.',
    14,
    0,
    '¾ cup Jasmine Rice
2 Carrots
2 stalks Celery
1 head Baby Bok Choy
1 Orange
1 Lemon
2 cloves Garlic
3 oz Radishes
1 Tbsp Sesame Oil
2 Tbsps Soy Glaze
2 Cage-Free Farm Eggs
1 1-Inch Piece Ginger
1½ Tbsps Soy Marinade
2 Tbsps Roasted Peanuts'
),
(
    'thai-curry-chicken',
    'Thai Curry Chicken',
    'with Carrots & Bok Choy',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'In tonight''s dish, the spicy and aromatic flavors of yellow curry paste—a Thai staple— shine through a lightly sweet coconut milk broth. Sautéed chicken, carrots, and bok choy give the curry plenty of hearty texture, while fluffy rice eagerly soaks up all the complex flavors. (Chefs, this curry paste packs a punch of heat, so be sure to use only as much as you''d like!)',
    9,
    0,
    '¾ cup Jasmine Rice
10 oz Chopped Chicken Breast
1¾ cups Light Coconut Milk
3 Carrots
1 Lime
1 head Baby Bok Choy
½ cup Dried Shiitake Mushrooms
2 tsps Golden Mountain Sauce
1½ Tbsps Yellow Curry Paste'
),
(
    'tilapia-black-lentil-salad',
    'Tilapia & Black Lentil Salad',
    'with Lemon Pan Sauce',
    (SELECT id FROM categories WHERE name = 'Seafood'),
    2,
    'In this dish, we''re putting a twist on Italian gremolata: adding pickled peppers to the classic parsley, garlic, and lemon condiment. The bright, tangy flavors perk up a hearty salad of black lentils and roasted broccoli. We''re also using lemon juice as the base for an easy pan sauce to serve over our seared tilapia.',
    9,
    0,
    '2 Tilapia Fillets
½ cup Black Beluga Lentils
2 cloves Garlic
1 Lemon
½ lb Broccoli
1 bunch Parsley
2 Tbsps Butter
1 oz Golden Or Red Sweet Piquante Peppers
1 Tbsp Capers'
),
(
    'togarashi-chicken-lettuce-cups',
    'Togarashi Chicken Lettuce Cups',
    'with Orange & Radishes',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'This recipe has been approved by Whole30®. To learn more about their guidelines, visit Whole30.com. We''re partnering with Whole30® to bring you the first of eight weeks of delicious recipes. These chicken lettuce cups get their dynamic flavor from togarashi seasoning—a staple of Japanese cuisine. Juicy bites of orange add more bright flavor and color.',
    15,
    0,
    '10 oz Ground Chicken
1 head Butter Lettuce
1 Navel Orange
3 oz Radishes
2 Scallions
1 1-Inch Piece Ginger
2 cloves Garlic
2 Tbsps Coconut Aminos
1 Tbsp Rice Vinegar
2 Tbsps Roasted Cashews
1 tsp Togarashi Seasoning (Chile Pepper, Orange Peel, Sesame Seeds, Ginger, & Seaweed)
4 oz Cremini Mushrooms
1 Red Onion
1 Carrot
1 Lime'
),
(
    'top-chef-ginger-marinated-grassfed-steaks',
    'Top Chef Ginger-Marinated Grassfed Steaks',
    'with Stir-Fried Vegetables & Jasmine Rice',
    (SELECT id FROM categories WHERE name = 'Beef'),
    2,
    'In this recipe—inspired by our Quickfire Challenge from Top Chef Season 15 on Bravo—we''re marinating grassfed steaks in fresh ginger, soy sauce, and citrusy ponzu sauce. The extra marinade transforms into an easy pan sauce, which adds punchy flavor to the steaks and a side of jasmine rice.',
    12,
    0,
    '2 Grassfed Strip Steaks
¾ cup Jasmine Rice
1 1-Inch Piece Ginger
2 cloves Garlic
2 Tbsps Ponzu Sauce
2 Tbsps Soy Sauce
1 tsp Sugar
4 oz Snow Peas
2 Carrots
1 head Baby Bok Choy
2 Scallions
1 Tbsp Butter'
),
(
    'top-chef-seared-grassfed-steaks',
    'Top Chef Seared Grassfed Steaks',
    'with Sweet Chili-Glazed Vegetables',
    (SELECT id FROM categories WHERE name = 'Beef'),
    4,
    'In this recipe, inspired by our Quickfire Challenge from Top Chef Season 15 on Bravo, simple grassfed steaks and rice get a sweet, tart, and spicy lift from glazed mushrooms and bok choy. Sliced radishes, softened a bit with lime juice, finish the dish off with subtle crunch.',
    12,
    0,
    '¾ cup Jasmine Rice
1 Shallot
2 heads Baby Bok Choy
1 Lime
6 oz Radishes
2 Tbsps Ponzu Sauce
1 Tbsp Soy Marinade
1 Tbsp Sugar
2 Grassfed Strip Steaks
4 oz Cremini Mushrooms
1 1-Inch Piece Ginger
2 Tbsps Sweet Chili Sauce'
),
(
    'tuscan-chicken-green-lentil-stew',
    'Tuscan Chicken & Green Lentil Stew',
    'with Goat Cheese',
    (SELECT id FROM categories WHERE name = 'Chicken'),
    2,
    'In this comforting cold-weather recipe, we''re serving Tuscan-spiced chicken over tender green lentils and vegetables cooked in a light, savory tomato broth. Capers and crushed red pepper add briny flavor and a touch of heat to cut through the rich, earthy stew. (Chefs, rinsing the lentils after cooking removes excess starch, resulting in a more delicate flavor.)',
    12,
    0,
    '2 Boneless, Skinless Chicken Breasts
2 Carrots
1 Red Onion
2 cloves Garlic
½ cup French Green Lentils
1 bunch Collard Greens
2 Tbsps Tomato Paste
¼ tsp Crushed Red Pepper Flakes
1 Tbsp Capers
1 Tbsp Apple Cider Vinegar
2 Tbsps Crumbled Goat Cheese
1 Tbsp Tuscan Spice Blend (Ground Fennel Seeds, Whole Fennel Seeds, Ground Rosemary, & Ground Sage)'
);

UPDATE recipes SET ingredients = '¾ cup Jasmine Rice
¾ lb Carrots
2 cloves Garlic
1 bunch Kale
1 Lime
1 Orange
2 Tbsps Butter
4 Boneless, Skinless Chicken Breasts
1 Tbsp Ancho Chile Paste
2 Tbsps Crème Fraîche
3 Tbsps Golden Raisins' WHERE slug = 'ancho-orange-chicken';

UPDATE recipes SET ingredients = '2 Beef Medallions
2 cloves Garlic
1 Shallot
1 bunch Kale
2 Tbsps Butter
1 Tbsp Dijon Mustard
2 Tbsps Verjus Blanc
4 oz Cremini Mushrooms
¾ lb Yukon Gold Potatoes' WHERE slug = 'beef-medallions-mushroom-sauce';

UPDATE recipes SET ingredients = '2 oz Asiago Cheese
1 Piece Focaccia Bread
1 8-Ounce Can Tomato Sauce
½ lb Fresh Mozzarella Cheese
2 Clementines
2 cloves Garlic
2 Romaine Lettuce Hearts
1 lb Broccoli
1 oz Golden Or Red Sweet Piquante Peppers
2 Tbsps Crème Fraîche
1 Tbsp Dijon Mustard
½ cup Basil & Cashew Pesto (Contains Pine Nuts)
⅓ cup Shaved Parmesan Cheese
1 Tbsp Italian Seasoning (Whole Dried Basil, Sage, Oregano, Savory, Rosemary, Thyme, & Marjoram)' WHERE slug = 'broccoli-basil-pesto-sandwiches';

UPDATE recipes SET ingredients = '2 Tbsps Mayonnaise
1½ lbs Pizza Dough
3 cloves Garlic
1 Romaine Lettuce Heart
1 lb Broccoli
1 cup Part-Skim Ricotta Cheese
1 8-Ounce Can Tomato Sauce
½ lb Fresh Mozzarella Cheese
¼ cup Grated Parmesan Cheese
2 oz Black Cerignola Olives
1 Tbsp Italian Seasoning (Whole Dried Basil, Sage, Oregano, Savory, Rosemary, Thyme, & Marjoram)
1 Lemon' WHERE slug = 'broccoli-mozzarella-calzones';

UPDATE recipes SET ingredients = '6 oz Bucatini Pasta
½ lb Broccoli
2 cloves Garlic
¼ cup Heavy Cream
2 Tbsps Verjus Blanc
2 Tbsps Crème Fraîche
¼ tsp Crushed Red Pepper Flakes
3 Tbsps All-Purpose Flour
¼ cup Grated Pecorino Cheese' WHERE slug = 'bucatini-alfredo';

UPDATE recipes SET ingredients = '6 oz Bucatini Pasta
1 14-Ounce Can Datterini Tomatoes
2 cloves Garlic
2 Tbsps Butter
1 Tbsp Capers
1 lb Broccoli
¾ oz Grana Padano Cheese
1 oz Kalamata Olives
¼ tsp Crushed Red Pepper Flakes
1 Tbsp Italian Seasoning (Whole Dried Basil, Sage, Oregano, Savory, Rosemary, Thyme, & Marjoram)' WHERE slug = 'bucatini-tomato-sauce';

UPDATE recipes SET ingredients = '1 bunch Kale
1 Lime
8 Flour Tortillas
¾ cup Jasmine Rice
1 28-Ounce Can Whole Peeled Tomatoes
4 oz Cremini Mushrooms
3 cloves Garlic
1 Yellow Onion
1 bunch Chives
2 Tbsps Ancho Chile Paste
1 Tbsp Mexican Spice Blend (Ancho Chile Powder, Sweet Paprika, Garlic Powder, Ground Cumin, & Whole Mexican Oregano)
½ lb White Cheddar Cheese
½ cup Sour Cream' WHERE slug = 'cheesy-enchiladas-rojas';

UPDATE recipes SET ingredients = '1½ lbs Sweet Potatoes
4 Potato Rolls
¼ cup Mayonnaise
21 oz Wild Alaskan Pollock Fillets
2 Cage-Free Farm Eggs
2 Tbsps Sweet Pickle Relish
1 Romaine Lettuce Heart
1 Tbsp Weeknight Hero Spice Blend (Garlic Powder, Onion Powder, Smoked Paprika, & Whole Dried Parsley)
1¼ cups Panko Breadcrumbs
¼ cup Creamy Mustard Sauce' WHERE slug = 'crispy-fish-sandwiches';

UPDATE recipes SET ingredients = '10 oz Chopped Chicken Breast
1 head Baby Bok Choy
¾ cup Jasmine Rice
2 cloves Garlic
1 Tbsp Rice Vinegar
1 1-Inch Piece Ginger
1 tsp Sriracha
1 Tbsp Honey
1 Tbsp Sesame Oil
¼ cup Cornstarch
2 Tbsps Hoisin Sauce' WHERE slug = 'general-tsos-chicken';

-- Image paths are relative to the web root; files live in images/<slug>.jpg.
UPDATE recipes SET image = CONCAT('images/', slug, '.jpg');
