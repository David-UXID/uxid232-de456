<?php
// Centralized database configuration
// Database connection credentials (MAMP localhost configuration)
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASS = 'root';
const DB_NAME = 'recipe_db';

// Enable strict error reporting for database connections
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// Helper function to safely escape HTML characters and prevent XSS attacks
function e(string $s): string {
    return htmlspecialchars($s, ENT_QUOTES, 'UTF-8');
}
