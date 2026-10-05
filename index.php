<?php
$greeting = "Hello, World!";
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Simple PHP Page</title>
</head>
<body>
    <h1><?php echo htmlspecialchars($greeting); ?></h1>
    <p>The current server time is: <?php echo date('Y-m-d H:i:s'); ?></p>
</body>
</html>
