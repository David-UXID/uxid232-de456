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
        <section class="results auth" aria-label="Admin">
            <h2 class="results-heading">Admin dashboard</h2>
            <p class="empty-state">Recipe upload is coming soon.</p>
            <p class="auth-switch"><a href="recipes.php">Back to recipes</a></p>
        </section>
    </main>
</body>
</html>
