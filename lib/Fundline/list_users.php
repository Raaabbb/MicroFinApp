<?php
require_once 'config/db.php';

echo "Listing all users:\n";
$res = $conn->query("SELECT user_id, username, user_type FROM users LIMIT 50");
while ($row = $res->fetch_assoc()) {
    echo "ID: " . $row['user_id'] . " | " . $row['username'] . " (" . $row['user_type'] . ")\n";
}

echo "\nListing all clients:\n";
$res = $conn->query("SELECT client_id, user_id, first_name, last_name, email_address FROM clients LIMIT 50");
while ($row = $res->fetch_assoc()) {
    echo "Client ID: " . $row['client_id'] . " | User ID: " . $row['user_id'] . " | Name: " . $row['first_name'] . " " . $row['last_name'] . "\n";
}
?>
