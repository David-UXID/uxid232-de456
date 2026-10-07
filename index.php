<?php
$name = trim($_POST['name'] ?? '');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Greeting Form</title>
</head>
<body>
    <h1>Enter your name</h1>
    <form method="post">
        <label for="name">Name:</label>
        <input
            type="text"
            id="name"
            name="name"
            value="<?php echo htmlspecialchars($name, ENT_QUOTES, 'UTF-8'); ?>"
            required
        >
        <button type="submit">Submit</button>
    </form>

    <?php if ($name !== ''): ?>
        <p>Hello, <?php echo htmlspecialchars($name, ENT_QUOTES, 'UTF-8'); ?>!</p>
    <?php endif; ?>
</body>
</html>
