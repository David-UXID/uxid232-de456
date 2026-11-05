<?php
session_start();

// Same MAMP connection settings as recipes.php.
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db   = 'recipe_db';

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function e(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }

if (isset($_SESSION['user_id'])) {
    header('Location: recipes.php');
    exit;
}

$mode = ($_POST['mode'] ?? $_GET['mode'] ?? 'login') === 'register' ? 'register' : 'login';
$username = '';
$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim((string) ($_POST['username'] ?? ''));
    $password = (string) ($_POST['password'] ?? '');

    try {
        $conn = new mysqli($host, $user, $pass, $db);
        $conn->set_charset('utf8mb4');

        if ($mode === 'register') {
            $confirm = (string) ($_POST['confirm'] ?? '');
            if (!preg_match('/^[A-Za-z0-9_]{3,50}$/', $username)) {
                $error = 'Username must be 3-50 letters, numbers, or underscores.';
            } elseif (strlen($password) < 8) {
                $error = 'Password must be at least 8 characters.';
            } elseif ($password !== $confirm) {
                $error = 'Passwords do not match.';
            } else {
                $stmt = $conn->prepare('SELECT id FROM users WHERE username = ?');
                $stmt->bind_param('s', $username);
                $stmt->execute();
                $exists = $stmt->get_result()->fetch_assoc();
                $stmt->close();

                if ($exists) {
                    $error = 'That username is already taken.';
                } else {
                    $hash = password_hash($password, PASSWORD_DEFAULT);
                    $stmt = $conn->prepare('INSERT INTO users (username, password_hash) VALUES (?, ?)');
                    $stmt->bind_param('ss', $username, $hash);
                    $stmt->execute();
                    $stmt->close();
                    $success = 'Account created. You can log in now.';
                    $mode = 'login';
                }
            }
        } else {
            $stmt = $conn->prepare('SELECT id, username, password_hash FROM users WHERE username = ?');
            $stmt->bind_param('s', $username);
            $stmt->execute();
            $row = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if ($row && password_verify($password, $row['password_hash'])) {
                session_regenerate_id(true);
                $_SESSION['user_id'] = (int) $row['id'];
                $_SESSION['username'] = $row['username'];
                $conn->close();
                header('Location: recipes.php');
                exit;
            }
            $error = 'Incorrect username or password.';
        }
        $conn->close();
    } catch (mysqli_sql_exception $e) {
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
