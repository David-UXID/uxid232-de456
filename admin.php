<?php
// Initialize session to track login state across pages
session_start();

// Only logged-in accounts can view the admin area; everyone else goes to the login page
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

// Load centralized helpers (e() escapes output)
require_once 'config.php';

// Token that ties recipe form submissions to this logged-in session
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$fields = ['title', 'subtitle', 'category', 'servings', 'description', 'image', 'ingredients', 'steps'];
$values = array_fill_keys($fields, '');
$errors = [];
$success = '';
$categories = [];

try {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    $conn->set_charset('utf8mb4');
    $categories = $conn->query('SELECT id, name FROM categories ORDER BY name')->fetch_all(MYSQLI_ASSOC);
    $categoryIds = array_column($categories, 'id', 'name');

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        foreach ($fields as $field) {
            $values[$field] = trim((string) ($_POST[$field] ?? ''));
        }

        if (!hash_equals($_SESSION['csrf_token'], (string) ($_POST['csrf_token'] ?? ''))) {
            $errors[] = 'Your session expired. Please submit the form again.';
        }
        if ($values['title'] === '' || mb_strlen($values['title']) > 100) {
            $errors[] = 'Recipe name is required and must be 100 characters or fewer.';
        }
        if (mb_strlen($values['subtitle']) > 255) {
            $errors[] = 'Subtitle must be 255 characters or fewer.';
        }
        if (!isset($categoryIds[$values['category']])) {
            $errors[] = 'Choose a category.';
        }
        $servings = filter_var($values['servings'], FILTER_VALIDATE_INT, ['options' => ['min_range' => 1, 'max_range' => 65535]]);
        if ($servings === false) {
            $errors[] = 'Servings must be a whole number from 1 to 65535.';
        }
        if ($values['description'] === '' || mb_strlen($values['description']) > 1000) {
            $errors[] = 'Description is required and must be 1000 characters or fewer.';
        }
        if (mb_strlen($values['image']) > 255) {
            $errors[] = 'Image path must be 255 characters or fewer.';
        }
        // Ingredients and steps are entered one per line; blank lines are ignored
        $ingredientLines = array_values(array_filter(array_map('trim', preg_split('/\R/', $values['ingredients']))));
        $stepLines = array_values(array_filter(array_map('trim', preg_split('/\R/', $values['steps']))));
        if (!$ingredientLines) {
            $errors[] = 'Add at least one ingredient.';
        }

        // The URL slug is built from the recipe name, so it must contain at least one letter or number
        $slug = trim((string) preg_replace('/[^a-z0-9]+/', '-', strtolower($values['title'])), '-');
        if ($slug === '' && $values['title'] !== '') {
            $errors[] = 'Recipe name must include letters or numbers.';
        }

        if (!$errors) {
            $stmt = $conn->prepare('SELECT id FROM recipes WHERE slug = ?');
            $stmt->bind_param('s', $slug);
            $stmt->execute();
            $exists = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if ($exists) {
                $errors[] = 'A recipe with that name already exists.';
            } else {
                $steps = [];
                foreach ($stepLines as $i => $line) {
                    $steps[] = ['step' => $i + 1, 'title' => 'Step ' . ($i + 1), 'instruction' => $line];
                }
                $stepsJson = $steps ? json_encode($steps, JSON_UNESCAPED_UNICODE) : null;
                $ingredients = implode("\n", $ingredientLines);
                $categoryId = (int) $categoryIds[$values['category']];
                $ingredientCount = count($ingredientLines);
                $stepCount = count($steps);

                $stmt = $conn->prepare('INSERT INTO recipes (slug, title, subtitle, category_id, servings, description, image, ingredients, ingredient_count, step_count, steps) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
                $stmt->bind_param('sssiisssiis', $slug, $values['title'], $values['subtitle'], $categoryId, $servings, $values['description'], $values['image'], $ingredients, $ingredientCount, $stepCount, $stepsJson);
                $stmt->execute();
                $stmt->close();

                $success = 'Recipe added.';
                $values = array_fill_keys($fields, '');
            }
        }
    }
    $conn->close();
} catch (mysqli_sql_exception $e) {
    $errors[] = 'Something went wrong. Please try again.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin - G's Cookbook</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main class="cookbook">
        <p class="user-bar">
            Signed in as <strong><?php echo e((string) $_SESSION['username']); ?></strong> &middot; <a href="logout.php">Log out</a>
        </p>
        <header class="hero">
            <p class="eyebrow">Admin area</p>
            <h1>G's Cookbook</h1>
            <p class="intro">Manage the cookbook.</p>
        </header>
        <section class="results auth" aria-label="Add a recipe">
            <h2 class="results-heading">Add a recipe</h2>
            <?php if ($errors): ?>
                <?php foreach ($errors as $error): ?>
                    <p class="notice error" role="alert"><?php echo e($error); ?></p>
                <?php endforeach; ?>
            <?php elseif ($success !== ''): ?>
                <p class="notice" role="status"><?php echo e($success); ?></p>
            <?php endif; ?>
            <form class="auth-form recipe-card" method="post" action="admin.php">
                <input type="hidden" name="csrf_token" value="<?php echo e($_SESSION['csrf_token']); ?>">
                <label for="title">Recipe name (required)</label>
                <input id="title" type="text" name="title" value="<?php echo e($values['title']); ?>" maxlength="100" required>
                <label for="subtitle">Subtitle (optional)</label>
                <input id="subtitle" type="text" name="subtitle" value="<?php echo e($values['subtitle']); ?>" maxlength="255">
                <label for="category">Category (required)</label>
                <select id="category" name="category" required>
                    <option value="">Choose a category</option>
                    <?php foreach ($categories as $cat): ?>
                        <option value="<?php echo e($cat['name']); ?>"<?php echo $values['category'] === $cat['name'] ? ' selected' : ''; ?>><?php echo e($cat['name']); ?></option>
                    <?php endforeach; ?>
                </select>
                <label for="servings">Servings (required)</label>
                <input id="servings" type="number" name="servings" value="<?php echo e($values['servings']); ?>" min="1" max="65535" required>
                <label for="description">Description (required, 1000 characters max)</label>
                <textarea id="description" name="description" rows="4" maxlength="1000" required><?php echo e($values['description']); ?></textarea>
                <label for="image">Image path or URL (optional)</label>
                <input id="image" type="text" name="image" value="<?php echo e($values['image']); ?>" maxlength="255">
                <label for="ingredients">Ingredients (required, one per line)</label>
                <textarea id="ingredients" name="ingredients" rows="8" required><?php echo e($values['ingredients']); ?></textarea>
                <label for="steps">Steps (optional, one per line)</label>
                <textarea id="steps" name="steps" rows="8"><?php echo e($values['steps']); ?></textarea>
                <button type="submit">Add recipe</button>
            </form>
            <p class="auth-switch"><a href="recipes.php">Back to recipes</a></p>
        </section>
    </main>
</body>
</html>
