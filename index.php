<?php
// Reads the submitted recipe name, or use an empty value on first load.
$recipe = trim($_POST['recipe'] ?? '');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Recipe Generator</title>
</head>
<body>
    <h1>Search for a recipe</h1>
    <!-- This form submits the search to the page. User input is escaped when displayed. -->
    <form method="post">
        <label for="recipe">What recipe would you like?</label>
        <input
            type="text"
            id="recipe"
            name="recipe"
            value="<?php echo htmlspecialchars($recipe, ENT_QUOTES, 'UTF-8'); ?>"
            required
        >
        <button type="submit">Search</button>
    </form>

    <!-- Show the recipe only after the user has submitted a non-empty search. -->
    <?php if ($recipe !== ''): ?>
        <section aria-labelledby="recipe-title">
            <h2 id="recipe-title">A recipe for <?php echo htmlspecialchars($recipe, ENT_QUOTES, 'UTF-8'); ?></h2>
            <p>This is a fake recipe, made just for fun.</p>
            <h3>Ingredients</h3>
            <ul>
                <li>1 cup of moonberry flour</li>
                <li>2 tablespoons of sparkling cloud syrup</li>
                <li>1 handful of chocolate comets</li>
                <li>A pinch of cinnamon stardust</li>
            </ul>
        </section>
    <?php endif; ?>
</body>
</html>
