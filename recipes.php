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
$q = trim((string) ($_GET['q'] ?? ''));

// Load the recipes in alphabetical order and prepare the connection for common international characters.
// Recipes stay hidden until the user submits a search.
$searched = $q !== '';
try {
    if (!$searched) {
        throw new RuntimeException('skip');
    }
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset('utf8mb4');
    // Use a prepared statement so the search text is never inserted into the SQL directly.
    $sql = 'SELECT recipes.id, recipes.title, recipes.subtitle, COALESCE(categories.name, \'\') AS category, recipes.servings, recipes.description, recipes.ingredient_count, recipes.step_count FROM recipes LEFT JOIN categories ON categories.id = recipes.category_id';
    if ($q !== '') {
        $sql .= ' WHERE recipes.title LIKE ? OR recipes.subtitle LIKE ? OR recipes.description LIKE ? OR categories.name LIKE ?';
    }
    $sql .= ' ORDER BY recipes.title';
    $stmt = $conn->prepare($sql);
    if ($q !== '') {
        $like = '%' . addcslashes($q, '%_\\') . '%';
        $stmt->bind_param('ssss', $like, $like, $like, $like);
    }
    $stmt->execute();
    $recipes = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
} catch (RuntimeException $e) {
    // No search yet; nothing to load.
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
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main class="cookbook">
        <header class="hero">
            <p class="eyebrow">A little inspiration for your table</p>
            <h1>G's Cookbook</h1>
            <p class="intro">Find something delicious to make. Search recipes by name, ingredient, or category.</p>
            <form class="search" method="get" action="recipes.php" role="search">
                <label class="sr-only" for="recipe-search">Search recipes</label>
                <input id="recipe-search" type="search" name="q" value="<?php echo e($q); ?>" placeholder="Try “pasta” or “vegetarian”">
                <button type="submit">Find a recipe</button>
                <?php if ($q !== ''): ?>
                    <a class="clear-search" href="recipes.php">Clear</a>
                <?php endif; ?>
            </form>
        </header>
        <section class="results" aria-label="Recipe results">
            <?php if ($error): ?>
                <p class="notice"><?php echo e($error); ?></p>
            <?php elseif (!$searched): ?>
                <p class="empty-state">Your next favorite recipe is just a search away.</p>
            <?php elseif (!$recipes): ?>
                <p class="empty-state">No recipes found<?php echo $q !== '' ? ' for "' . e($q) . '"' : ''; ?>. Try another search.</p>
            <?php else: ?>
                <h2 class="results-heading">Recipes to try</h2>
                <div class="recipe-grid">
                    <?php foreach ($recipes as $r): ?>
                        <article class="recipe-card">
                            <?php if ($r['category'] !== ''): ?>
                                <p class="category"><?php echo e($r['category']); ?></p>
                            <?php endif; ?>
                            <h3><?php echo e($r['title']); ?></h3>
                            <?php if ($r['subtitle'] !== ''): ?>
                                <p class="subtitle"><?php echo e($r['subtitle']); ?></p>
                            <?php endif; ?>
                            <p class="description"><?php echo e($r['description']); ?></p>
                            <ul class="recipe-details" aria-label="Recipe details">
                                <li><strong><?php echo (int) $r['servings']; ?></strong> servings</li>
                                <li><strong><?php echo (int) $r['ingredient_count']; ?></strong> ingredients</li>
                                <li><strong><?php echo (int) $r['step_count']; ?></strong> steps</li>
                            </ul>
                        </article>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </section>
    </main>
</body>
</html>
