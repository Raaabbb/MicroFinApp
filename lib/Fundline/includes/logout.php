<?php
/**
 * Logout Page - Fundline Web Application
 * Destroys session and redirects to login
 */

// Start session
session_start();

// Include database connection
require_once '../config/db.php';

// Log audit before destroying session
if (isset($_SESSION['user_id'])) {
    $user_id = $_SESSION['user_id'];
    $ip_address = $_SERVER['REMOTE_ADDR'];
    
    // Log logout activity
    $stmt = $conn->prepare("
        INSERT INTO audit_logs (user_id, action_type, description, ip_address)
        VALUES (?, 'LOGOUT', 'User logged out', ?)
    ");
    $stmt->bind_param("is", $user_id, $ip_address);
    $stmt->execute();
    $stmt->close();
    
    // Delete session token from database
    if (isset($_SESSION['session_token'])) {
        $stmt = $conn->prepare("DELETE FROM user_sessions WHERE session_token = ?");
        $stmt->bind_param("s", $_SESSION['session_token']);
        $stmt->execute();
        $stmt->close();
    }
}

$conn->close();

// Unset all session variables
$_SESSION = array();

// Destroy the session cookie
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// Destroy the session
session_destroy();

// Delete remember me cookie if it exists
if (isset($_COOKIE['fundline_user'])) {
    setcookie('fundline_user', '', time() - 3600, '/');
}

// Redirect to login page
header("Location: login.php?logout=success");
exit();
?>
