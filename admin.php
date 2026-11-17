<?php
// Initialize session to track admin login state across requests
session_start();

// Load centralized database configuration and helpers
require_once 'config.php';

$error = '';
$username = '';
$isAdmin = false;
$isLoggedIn = isset($_SESSION['user_id']);

try {
    // Handle admin login submissions from visitors who are not logged in yet
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && !$isLoggedIn) {
        $username = trim((string) ($_POST['username'] ?? ''));
        $password = (string) ($_POST['password'] ?? '');

        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset('utf8mb4');

        $stmt = $conn->prepare('SELECT id, username, password_hash, is_admin FROM users WHERE username = ?');
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        $conn->close();

        if ($row && password_verify($password, $row['password_hash'])) {
            if ($row['is_admin']) {
                // Create new session ID and store user information, then reload this page
                session_regenerate_id(true);
                $_SESSION['user_id'] = (int) $row['id'];
                $_SESSION['username'] = $row['username'];
                header('Location: admin.php');
                exit;
            }
            $error = 'This account does not have admin access.';
        } else {
            $error = 'Incorrect username or password.';
        }
    }

    // Re-check admin status on every request so revoking admin access takes effect immediately
    if ($isLoggedIn) {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset('utf8mb4');
        $stmt = $conn->prepare('SELECT is_admin FROM users WHERE id = ?');
        $stmt->bind_param('i', $_SESSION['user_id']);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        $conn->close();
        $isAdmin = $row !== null && (bool) $row['is_admin'];
    }
} catch (mysqli_sql_exception $e) {
    // Handle any database errors gracefully without exposing technical details
    $error = 'Something went wrong. Please try again.';
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
        <?php if ($isLoggedIn): ?>
            <p class="user-bar">
                Signed in as <strong><?php echo e((string) $_SESSION['username']); ?></strong> &middot; <a href="logout.php">Log out</a>
            </p>
        <?php endif; ?>
        <header class="hero">
            <p class="eyebrow">Admin area</p>
            <h1>G's Cookbook</h1>
            <p class="intro"><?php echo $isAdmin ? 'Manage the cookbook.' : 'Log in with an admin account to continue.'; ?></p>
        </header>
        <section class="results auth" aria-label="Admin">
            <?php if ($error): ?>
                <p class="notice error" role="alert"><?php echo e($error); ?></p>
            <?php endif; ?>
            <?php if ($isAdmin): ?>
                <h2 class="results-heading">Admin dashboard</h2>
                <p class="empty-state">Recipe upload is coming soon.</p>
                <p class="auth-switch"><a href="recipes.php">Back to recipes</a></p>
            <?php elseif ($isLoggedIn): ?>
                <h2 class="results-heading">Access denied</h2>
                <p class="notice error" role="alert">Your account does not have admin access.</p>
                <p class="auth-switch"><a href="recipes.php">Back to recipes</a></p>
            <?php else: ?>
                <h2 class="results-heading">Admin log in</h2>
                <form class="auth-form recipe-card" method="post" action="admin.php">
                    <label for="username">Username</label>
                    <input id="username" type="text" name="username" value="<?php echo e($username); ?>" maxlength="50" autocomplete="username" required>
                    <label for="password">Password</label>
                    <input id="password" type="password" name="password" autocomplete="current-password" required>
                    <button type="submit">Log in</button>
                </form>
                <p class="auth-switch"><a href="recipes.php">Back to recipes</a></p>
            <?php endif; ?>
        </section>
    </main>
</body>
</html>
