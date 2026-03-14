<?php
/**
 * Login Page - Fundline Web Application
 * Handles user authentication and session management
 */

// Start session
session_start();

// Include database connection
require_once '../config/db.php';

// Initialize variables
$error_message = '';
$username = '';

// Check if user is already logged in - redirect based on user type
if (isset($_SESSION['user_id'])) {
    if ($_SESSION['user_type'] === 'Employee') {
        header("Location: admin_dashboard.php");
    } else {
        header("Location: dashboard.php");
    }
    exit();
}

// Process login form submission
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $is_ajax = !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest';

    // Get and sanitize input
    $username = trim($_POST['username']);
    $password = $_POST['password'];
    $remember_me = isset($_POST['rememberMe']);
    
    // Validate inputs
    if (empty($username) || empty($password)) {
        $error_message = "Please enter both username and password";
    } else {
        // Prepare SQL statement - Updated to match new schema with tenant_id
        $stmt = $conn->prepare("
            SELECT u.user_id, u.username, u.email, u.password_hash, u.role_id, 
                   u.user_type, u.status, u.failed_login_attempts, ur.role_name, u.tenant_id
            FROM users u
            LEFT JOIN user_roles ur ON u.role_id = ur.role_id
            WHERE (u.username = ? OR u.email = ?) AND u.email_verified = TRUE
        ");
        $stmt->bind_param("ss", $username, $username);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            
            // Check account status
            if ($user['status'] === 'Locked') {
                $error_message = "Account is locked. Please contact administrator.";
            } elseif ($user['status'] === 'Suspended') {
                $error_message = "Account is suspended. Please contact administrator.";
            } elseif ($user['status'] === 'Inactive') {
                $error_message = "Account is inactive. Please contact administrator.";
            } else {
                // Verify password
                if (password_verify($password, $user['password_hash'])) {
                    // Password is correct, reset failed attempts
                    $update_stmt = $conn->prepare("
                        UPDATE users 
                        SET failed_login_attempts = 0, 
                            last_login = NOW() 
                        WHERE user_id = ?
                    ");
                    $update_stmt->bind_param("i", $user['user_id']);
                    $update_stmt->execute();
                    $update_stmt->close();
                    
                    // Start session
                    $_SESSION['user_id'] = $user['user_id'];
                    $_SESSION['username'] = $user['username'];
                    $_SESSION['email'] = $user['email'];
                    $_SESSION['role_id'] = $user['role_id'];
                    $_SESSION['tenant_id'] = $user['tenant_id'] ?? 1;
                    $_SESSION['role_name'] = $user['role_name'];
                    $_SESSION['user_type'] = $user['user_type'];
                    $_SESSION['tenant_id'] = $user['tenant_id'];
                    
                    // Create session token
                    $session_token = bin2hex(random_bytes(32));
                    $expires_at = date('Y-m-d H:i:s', strtotime('+2 hours'));
                    
                    $session_stmt = $conn->prepare("
                        INSERT INTO user_sessions (user_id, session_token, ip_address, user_agent, expires_at, tenant_id)
                        VALUES (?, ?, ?, ?, ?, ?)
                    ");
                    $ip_address = $_SERVER['REMOTE_ADDR'];
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    $session_stmt->bind_param("issssi", $user['user_id'], $session_token, $ip_address, $user_agent, $expires_at, $user['tenant_id']);
                    $session_stmt->execute();
                    $session_stmt->close();
                    
                    $_SESSION['session_token'] = $session_token;
                    
                    // Log audit
                    $audit_stmt = $conn->prepare("
                        INSERT INTO audit_logs (user_id, action_type, description, ip_address, tenant_id)
                        VALUES (?, 'LOGIN', 'User logged in successfully', ?, ?)
                    ");
                    $audit_stmt->bind_param("isi", $user['user_id'], $ip_address, $user['tenant_id']);
                    $audit_stmt->execute();
                    $audit_stmt->close();
                    
                    // Set remember me cookie if checked
                    if ($remember_me) {
                        setcookie('fundline_user', $user['username'], time() + (86400 * 30), "/"); // 30 days
                    }
                    
                    // Determine redirect URL
                    $redirect_url = "dashboard.php";
                    if ($user['role_name'] === 'Super Admin') {
                        $redirect_url = "super_admin_dashboard.php";
                    } elseif ($user['user_type'] === 'Employee') {
                        $redirect_url = "admin_dashboard.php";
                    }

                    if ($is_ajax) {
                        header('Content-Type: application/json');
                        echo json_encode(['success' => true, 'redirect' => $redirect_url]);
                        exit();
                    } else {
                        header("Location: " . $redirect_url);
                        exit();
                    }
                } else {
                    // Invalid password - increment failed attempts
                    $failed_attempts = $user['failed_login_attempts'] + 1;
                    $status = ($failed_attempts >= 5) ? 'Locked' : $user['status'];
                    
                    $update_stmt = $conn->prepare("
                        UPDATE users 
                        SET failed_login_attempts = ?,
                            status = ?
                        WHERE user_id = ?
                    ");
                    $update_stmt->bind_param("isi", $failed_attempts, $status, $user['user_id']);
                    $update_stmt->execute();
                    $update_stmt->close();
                    
                    if ($status === 'Locked') {
                        $error_message = "Account locked due to multiple failed login attempts.";
                    } else {
                        $error_message = "Invalid username or password";
                    }
                }
            }
        } else {
            $error_message = "Invalid username or password";
        }
        
        $stmt->close();
    }

    if ($is_ajax && !empty($error_message)) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => $error_message]);
        exit();
    }
}

// Redirect non-POST requests to index
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit();
}

$conn->close();
?>

