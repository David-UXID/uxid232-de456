<?php
// Adjust credentials for your MAMP setup (import schema.sql first).
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db   = 'recipe_db';

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$recipes = [];
$error = '';
try {
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset('utf8mb4');
    $result = $conn->query('SELECT id, name, description, ingredients, instructions, prep_minutes FROM recipes ORDER BY name');
    $recipes = $result->fetch_all(MYSQLI_ASSOC);
    $conn->close();
} catch (mysqli_sql_exception $e) {
    $error = 'Could not load recipes.';
}

function e(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>All Recipes</title>
</head>
<body>
    <h1>All Recipes</h1>
    <?php if ($error): ?>
        <p><?php echo e($error); ?></p>
    <?php elseif (!$recipes): ?>
        <p>No recipes found.</p>
    <?php else: ?>
        <?php foreach ($recipes as $r): ?>
            <article>
                <h2><?php echo e($r['name']); ?> (<?php echo (int) $r['prep_minutes']; ?> min)</h2>
                <p><?php echo e($r['description']); ?></p>
                <p><strong>Ingredients:</strong> <?php echo e($r['ingredients']); ?></p>
                <p><strong>Instructions:</strong> <?php echo e($r['instructions']); ?></p>
            </article>
        <?php endforeach; ?>
    <?php endif; ?>
</body>
</html>
