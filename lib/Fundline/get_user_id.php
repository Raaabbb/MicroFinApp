<?php
require_once 'config/db.php';

$search = "Client user number 2"; // Using exact string from prompt if possible, or parts
echo "Searching for '$search'...\n";

// Search in users
$sql = "SELECT user_id, username, user_type FROM users WHERE username LIKE '%Client%' OR username LIKE '%user%' OR username LIKE '%2%'";
$res = $conn->query($sql);
echo "Users matches:\n";
while ($row = $res->fetch_assoc()) {
    echo "User ID: " . $row['user_id'] . ", Username: " . $row['username'] . "\n";
}

// Search in clients
$sql = "SELECT client_id, user_id, first_name, last_name FROM clients WHERE first_name LIKE '%Client%' OR last_name LIKE '%Client%' OR first_name LIKE '%2%'";
$res = $conn->query($sql);
echo "Clients matches:\n";
while ($row = $res->fetch_assoc()) {
    echo "Client ID: " . $row['client_id'] . ", User ID: " . $row['user_id'] . ", Name: " . $row['first_name'] . " " . $row['last_name'] . "\n";
}
?>
