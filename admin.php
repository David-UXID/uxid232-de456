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

$fields = ['title', 'subtitle', 'category', 'servings', 'description', 'ingredients', 'steps'];
// Uploaded images are saved as images/<slug>.<ext>, which the recipe pages already load
$allowedImageTypes = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/gif' => 'gif', 'image/webp' => 'webp'];
$maxImageBytes = 5 * 1024 * 1024;
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
        // The image is optional; when one is uploaded it must be a small, real image file
        $image = $_FILES['image'] ?? ['error' => UPLOAD_ERR_NO_FILE];
        $imageExt = null;
        if ($image['error'] !== UPLOAD_ERR_NO_FILE) {
            if ($image['error'] !== UPLOAD_ERR_OK) {
                $errors[] = 'The image could not be uploaded. Please try again.';
            } elseif ($image['size'] > $maxImageBytes) {
                $errors[] = 'Image must be 5 MB or smaller.';
            } else {
                // getimagesize() checks the file's actual content and works without the fileinfo extension
                $info = @getimagesize($image['tmp_name']);
                $imageExt = $info ? ($allowedImageTypes[$info['mime']] ?? null) : null;
                if ($imageExt === null) {
                    $errors[] = 'Image must be a JPEG, PNG, GIF, or WebP file.';
                }
            }
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

        $imagePath = '';
        if ($imageExt !== null) {
            $imagePath = 'images/' . $slug . '.' . $imageExt;
            if (file_exists(__DIR__ . '/' . $imagePath)) {
                $errors[] = 'An image file already exists for that recipe name.';
            }
        }

        if (!$errors) {
            $stmt = $conn->prepare('SELECT id FROM recipes WHERE slug = ?');
            $stmt->bind_param('s', $slug);
            $stmt->execute();
            $exists = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if ($exists) {
                $errors[] = 'A recipe with that name already exists.';
            } elseif ($imageExt !== null && !move_uploaded_file($image['tmp_name'], __DIR__ . '/' . $imagePath)) {
                $errors[] = 'The image could not be saved. Please try again.';
            } else {
                $savedImage = $imageExt !== null ? __DIR__ . '/' . $imagePath : null;
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
                $stmt->bind_param('sssiisssiis', $slug, $values['title'], $values['subtitle'], $categoryId, $servings, $values['description'], $imagePath, $ingredients, $ingredientCount, $stepCount, $stepsJson);
                $stmt->execute();
                $stmt->close();
                $savedImage = null;

                $success = 'Recipe added.';
                $values = array_fill_keys($fields, '');
            }
        }
    }
    $conn->close();
} catch (Throwable $e) {
    error_log($e);
    // Remove an image saved for a recipe that was never inserted, so the next attempt isn't blocked
    if (isset($savedImage) && is_file($savedImage)) {
        unlink($savedImage);
    }
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
            <form class="auth-form recipe-card" method="post" action="admin.php" enctype="multipart/form-data">
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
                <label for="image">Image (optional, JPEG, PNG, GIF, or WebP, 5 MB max)</label>
                <input id="image" type="file" name="image" accept="image/jpeg,image/png,image/gif,image/webp">
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
