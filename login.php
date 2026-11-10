<?php
// Initialize session to track user login state across pages
session_start();

// Load centralized database configuration
require_once 'config.php';

// If user is already logged in, redirect to recipes page
if (isset($_SESSION['user_id'])) {
    header('Location: recipes.php');
    exit;
}

// Determine whether to show login or registration form (defaults to login)
$mode = ($_POST['mode'] ?? $_GET['mode'] ?? 'login') === 'register' ? 'register' : 'login';
// Initialize variables to display form values and status messages
$username = '';
$error = '';
$success = '';

// Process form submission (login or registration)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve and sanitize form inputs
    $username = trim((string) ($_POST['username'] ?? ''));
    $password = (string) ($_POST['password'] ?? '');

    try {
        // Establish database connection
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset('utf8mb4');

        // REGISTRATION MODE: Create new user account
        if ($mode === 'register') {
            $confirm = (string) ($_POST['confirm'] ?? '');
            
            // Validate username format (3-50 alphanumeric characters or underscores)
            if (!preg_match('/^[A-Za-z0-9_]{3,50}$/', $username)) {
                $error = 'Username must be 3-50 letters, numbers, or underscores.';
            }
            // Validate password length (minimum 8 characters)
            elseif (strlen($password) < 8) {
                $error = 'Password must be at least 8 characters.';
            }
            // Verify password confirmation matches password
            elseif ($password !== $confirm) {
                $error = 'Passwords do not match.';
            } else {
                // Check if username already exists in database
                $stmt = $conn->prepare('SELECT id FROM users WHERE username = ?');
                $stmt->bind_param('s', $username);
                $stmt->execute();
                $exists = $stmt->get_result()->fetch_assoc();
                $stmt->close();

                if ($exists) {
                    $error = 'That username is already taken.';
                } else {
                    // Hash password securely and insert new user into database
                    $hash = password_hash($password, PASSWORD_DEFAULT);
                    $stmt = $conn->prepare('INSERT INTO users (username, password_hash) VALUES (?, ?)');
                    $stmt->bind_param('ss', $username, $hash);
                    $stmt->execute();
                    $stmt->close();
                    $success = 'Account created. You can log in now.';
                    $mode = 'login';
                }
            }
        } 
        // LOGIN MODE: Verify user credentials
        else {
            // Look up user by username
            $stmt = $conn->prepare('SELECT id, username, password_hash FROM users WHERE username = ?');
            $stmt->bind_param('s', $username);
            $stmt->execute();
            $row = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            // Verify username exists and password matches
            if ($row && password_verify($password, $row['password_hash'])) {
                // Create new session ID and store user information
                session_regenerate_id(true);
                $_SESSION['user_id'] = (int) $row['id'];
                $_SESSION['username'] = $row['username'];
                $conn->close();
                // Redirect to recipes page after successful login
                header('Location: recipes.php');
                exit;
            }
            $error = 'Incorrect username or password.';
        }
        // Close database connection
        $conn->close();
    } catch (mysqli_sql_exception $e) {
        // Handle any database errors gracefully without exposing technical details
        $error = 'Something went wrong. Please try again.';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo $mode === 'register' ? 'Create Account' : 'Log In'; ?> - G's Cookbook</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main class="cookbook">
        <header class="hero">
            <p class="eyebrow">Welcome back to the kitchen</p>
            <h1>G's Cookbook</h1>
            <p class="intro"><?php echo $mode === 'register' ? 'Create an account to join the cookbook.' : 'Log in to your account.'; ?></p>
        </header>
        <section class="results auth" aria-label="<?php echo $mode === 'register' ? 'Create account' : 'Log in'; ?>">
            <h2 class="results-heading"><?php echo $mode === 'register' ? 'Create an account' : 'Log in'; ?></h2>
            <?php if ($error): ?>
                <p class="notice error" role="alert"><?php echo e($error); ?></p>
            <?php elseif ($success): ?>
                <p class="notice" role="status"><?php echo e($success); ?></p>
            <?php endif; ?>
            <form class="auth-form recipe-card" method="post" action="login.php">
                <input type="hidden" name="mode" value="<?php echo e($mode); ?>">
                <label for="username">Username</label>
                <input id="username" type="text" name="username" value="<?php echo e($username); ?>" maxlength="50" autocomplete="username" required>
                <label for="password">Password</label>
                <input id="password" type="password" name="password" autocomplete="<?php echo $mode === 'register' ? 'new-password' : 'current-password'; ?>" required>
                <?php if ($mode === 'register'): ?>
                    <label for="confirm">Confirm password</label>
                    <input id="confirm" type="password" name="confirm" autocomplete="new-password" required>
                <?php endif; ?>
                <button type="submit"><?php echo $mode === 'register' ? 'Create account' : 'Log in'; ?></button>
            </form>
            <p class="auth-switch">
                <?php if ($mode === 'register'): ?>
                    Already have an account? <a href="login.php">Log in</a>
                <?php else: ?>
                    New here? <a href="login.php?mode=register">Create an account</a>
                <?php endif; ?>
                &middot; <a href="recipes.php">Back to recipes</a>
            </p>
        </section>
    </main>
</body>
</html>
