<?php
// Connect to the MySQL database created by schema.sql. MAMP default settings.
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db   = 'recipe_db';

// Ask MySQLi to report database problems as exceptions so they can be handled below. (Ai gave this to me)
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// Start with an empty recipe list and no error message in case the page cannot load data.
$recipes = [];
$error = '';

// Load the recipes in alphabetical order and prepare the connection for common international characters.
try {
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset('utf8mb4');
    $result = $conn->query('SELECT id, title, subtitle, category, servings, description, ingredient_count, step_count FROM recipes ORDER BY title');
    $recipes = $result->fetch_all(MYSQLI_ASSOC);
    $conn->close();
} catch (mysqli_sql_exception $e) {
    // Show a simple message on the page instead of exposing database details.
    $error = 'Could not load recipes.';
}

// Escape text before displaying it in HTML to prevent recipe content from being treated as markup.
function e(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Set up character encoding, mobile-friendly sizing, and the browser tab title. -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Cookbook</title>
</head>
<body>
    <!-- Show a database error, an empty-list message, or the recipes that were loaded. -->
    <h1>All Recipes</h1>
    <?php if ($error): ?>
        <p><?php echo e($error); ?></p>
    <?php elseif (!$recipes): ?>
        <p>No recipes found.</p>
    <?php else: ?>
        <!-- Create one article for each recipe, safely displaying its details. -->
        <?php foreach ($recipes as $r): ?>
            <article>
                <h2><?php echo e($r['title']); ?></h2>
                <!-- Only show the subtitle and category when each value is present. -->
                <?php if ($r['subtitle'] !== ''): ?>
                    <p><?php echo e($r['subtitle']); ?></p>
                <?php endif; ?>
                <?php if ($r['category'] !== ''): ?>
                    <p><strong>Category:</strong> <?php echo e($r['category']); ?></p>
                <?php endif; ?>
                <!-- Show the recipe description along with its serving, ingredient, and step counts. -->
                <p><strong>Servings:</strong> <?php echo (int) $r['servings']; ?></p>
                <p><?php echo e($r['description']); ?></p>
                <p><strong>Ingredient count:</strong> <?php echo (int) $r['ingredient_count']; ?></p>
                <p><strong>Step count:</strong> <?php echo (int) $r['step_count']; ?></p>
            </article>
        <?php endforeach; ?>
    <?php endif; ?>
</body>
</html>
