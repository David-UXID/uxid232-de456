<?php
session_start();
// Load centralized database configuration
require_once 'config.php';

// Start with an empty recipe list and no error message in case the page cannot load data.
$recipes = [];
$error = '';
$search = trim((string) ($_GET['searchbox'] ?? ''));

// Load the recipes in alphabetical order and prepare the connection for common international characters.
// Recipes stay hidden until the user submits a search.
$searched = $search !== '';
try {
    if (!$searched) {
        throw new RuntimeException('skip');
    }
    
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    $conn->set_charset('utf8mb4');
    // Use a prepared statement so the search text is never inserted into the SQL directly.
    $sql = 'SELECT recipes.id, recipes.title, recipes.subtitle, COALESCE(categories.name, \'\') AS category, recipes.servings, recipes.description, recipes.image, recipes.ingredients, recipes.ingredient_count, recipes.step_count FROM recipes LEFT JOIN categories ON categories.id = recipes.category_id';
    if ($search !== '') {
        $sql .= ' WHERE recipes.title LIKE ? OR recipes.subtitle LIKE ? OR recipes.description LIKE ? OR categories.name LIKE ?';
    }
    $sql .= ' ORDER BY recipes.title';
    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        throw new Exception('Prepare failed: ' . $conn->error);
    }
    if ($search !== '') {
        $like = '%' . addcslashes($search, '%_\\') . '%';
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

// Start with an empty recipe list and no error message in case the page cannot load data.
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
        <p class="user-bar">
            <?php if (isset($_SESSION['username'])): ?>
                Signed in as <strong><?php echo e((string) $_SESSION['username']); ?></strong> &middot; <a href="logout.php">Log out</a>
            <?php else: ?>
                <a href="login.php">Log in</a> &middot; <a href="login.php?mode=register">Create account</a>
            <?php endif; ?>
        </p>
        <header class="hero">
            <p class="eyebrow">A little inspiration for your table</p>
            <h1>G's Cookbook</h1>
            <p class="intro">Find something delicious to make. Search recipes by name, ingredient, or category.</p>
            <form class="search" method="get" action="recipes.php" role="search">
                <label class="sr-only" for="recipe-search">Search recipes</label>
                <input id="recipe-search" type="search" name="searchbox" value="<?php echo e($search); ?>" placeholder="Try “pasta” or “vegetarian”">
                <button type="submit">Find a recipe</button>
                <?php if ($search !== ''): ?>
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
                <p class="empty-state">No recipes found<?php echo $search !== '' ? ' for "' . e($search) . '"' : ''; ?>. Try another search.</p>
            <?php else: ?>
                <h2 class="results-heading">Recipes to try</h2>
                <div class="recipe-grid">
                    <?php foreach ($recipes as $r): ?>
                        <article class="recipe-card">
                            <?php if ($r['image'] !== ''): ?>
                                <img class="recipe-image" src="<?php echo e($r['image']); ?>" alt="<?php echo e($r['title']); ?>" loading="lazy">
                            <?php endif; ?>
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
                                <?php if ((int) $r['step_count'] > 0): ?>
                                    <li><strong><?php echo (int) $r['step_count']; ?></strong> steps</li>
                                <?php endif; ?>
                            </ul>
                            <?php $ingredients = array_filter(array_map('trim', explode("\n", (string) $r['ingredients']))); ?>
                            <?php if ($ingredients): ?>
                                <details class="ingredients">
                                    <summary>Ingredients</summary>
                                    <ul>
                                        <?php foreach ($ingredients as $item): ?>
                                            <li><?php echo e($item); ?></li>
                                        <?php endforeach; ?>
                                    </ul>
                                </details>
                            <?php endif; ?>
                        </article>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </section>
    </main>
</body>
</html>
