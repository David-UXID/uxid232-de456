<?php
session_start();
// Load centralized database configuration
require_once 'config.php';

$slug = trim((string) ($_GET['slug'] ?? ''));
$recipe = null;
$error = '';

if ($slug !== '') {
    try {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset('utf8mb4');
        $stmt = $conn->prepare('SELECT recipes.title, recipes.subtitle, COALESCE(categories.name, \'\') AS category, recipes.servings, recipes.description, recipes.image, recipes.ingredients, recipes.steps FROM recipes LEFT JOIN categories ON categories.id = recipes.category_id WHERE recipes.slug = ? LIMIT 1');
        $stmt->bind_param('s', $slug);
        $stmt->execute();
        $recipe = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        $conn->close();
    } catch (mysqli_sql_exception $e) {
        // Show a simple message on the page instead of exposing database details.
        $error = 'Could not load this recipe.';
    }
}

if ($recipe === null && $error === '') {
    http_response_code(404);
}

$ingredients = [];
$steps = [];
if ($recipe !== null) {
    $ingredients = array_filter(array_map('trim', explode("\n", (string) $recipe['ingredients'])));
    $steps = json_decode((string) ($recipe['steps'] ?? '[]'), true);
    if (!is_array($steps)) {
        $steps = [];
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Set up character encoding, mobile-friendly sizing, and the browser tab title. -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo e($recipe['title'] ?? 'Recipe'); ?> | My Cookbook</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main class="cookbook">
        <p class="user-bar">
            <a href="recipes.php">&larr; Back to recipes</a>
        </p>
        <?php if ($error !== ''): ?>
            <p class="notice"><?php echo e($error); ?></p>
        <?php elseif ($recipe === null): ?>
            <p class="notice">Recipe not found.</p>
        <?php else: ?>
            <article class="recipe-detail">
                <header class="recipe-detail-header">
                    <?php if ($recipe['category'] !== ''): ?>
                        <p class="category"><?php echo e($recipe['category']); ?></p>
                    <?php endif; ?>
                    <h1><?php echo e($recipe['title']); ?></h1>
                    <?php if ($recipe['subtitle'] !== ''): ?>
                        <p class="subtitle"><?php echo e($recipe['subtitle']); ?></p>
                    <?php endif; ?>
                    <?php if ($recipe['image'] !== ''): ?>
                        <img class="recipe-detail-image" src="<?php echo e($recipe['image']); ?>" alt="<?php echo e($recipe['title']); ?>">
                    <?php endif; ?>
                    <p class="description"><?php echo e($recipe['description']); ?></p>
                    <p class="recipe-details"><strong><?php echo (int) $recipe['servings']; ?></strong> servings</p>
                </header>

                <?php if ($ingredients): ?>
                    <section class="recipe-section" aria-labelledby="ingredients-heading">
                        <h2 id="ingredients-heading">Ingredients</h2>
                        <ul class="ingredient-list">
                            <?php foreach ($ingredients as $item): ?>
                                <li><?php echo e($item); ?></li>
                            <?php endforeach; ?>
                        </ul>
                    </section>
                <?php endif; ?>

                <?php if ($steps): ?>
                    <section class="recipe-section" aria-labelledby="steps-heading">
                        <h2 id="steps-heading">Instructions</h2>
                        <ol class="step-list">
                            <?php foreach ($steps as $step): ?>
                                <li class="step">
                                    <h3><?php echo e((string) ($step['title'] ?? '')); ?></h3>
                                    <?php if (!empty($step['image'])): ?>
                                        <img class="step-image" src="<?php echo e((string) $step['image']); ?>" alt="<?php echo e('Step ' . (int) ($step['step'] ?? 0) . ': ' . (string) ($step['title'] ?? '')); ?>" loading="lazy">
                                    <?php endif; ?>
                                    <p><?php echo e((string) ($step['instruction'] ?? '')); ?></p>
                                </li>
                            <?php endforeach; ?>
                        </ol>
                    </section>
                <?php endif; ?>
            </article>
        <?php endif; ?>
    </main>
</body>
</html>
