<?php
require_once 'config/db.php';

// 1. Search for user
echo "Searching for 'Client user number 2'...\n";
// Try to find in users or clients
$search = "%Client user number 2%";
$queries = [
    "SELECT * FROM users WHERE username LIKE ? OR email LIKE ?",
    "SELECT * FROM clients WHERE first_name LIKE ? OR last_name LIKE ?"
];

// Check users table columns first to avoid error if columns differ
$user_cols = [];
$res = $conn->query("DESCRIBE users");
while($r = $res->fetch_assoc()) $user_cols[] = $r['Field'];

// Check clients table columns
$client_cols = [];
$res = $conn->query("DESCRIBE clients");
while($r = $res->fetch_assoc()) $client_cols[] = $r['Field'];

echo "Users columns: " . implode(", ", $user_cols) . "\n";
echo "Clients columns: " . implode(", ", $client_cols) . "\n";


$sql = "SELECT * FROM users"; 
$res = $conn->query($sql);
echo "Users found: " . $res->num_rows . "\n";
while ($row = $res->fetch_assoc()) {
    echo "User: " . $row['user_id'] . " - " . $row['username'] . " (" . $row['user_type'] . ")\n";
}

// 2. Describe loans table
echo "\nLOANS Table Structure:\n";
$res = $conn->query("DESCRIBE loans");
while ($row = $res->fetch_assoc()) {
    echo $row['Field'] . " - " . $row['Type'] . "\n";
}

// 3. Describe loan_products (to get a valid product_id)
echo "\nLOAN_PRODUCTS:\n";
$res = $conn->query("SELECT product_id, product_name, interest_rate, penalty_rate FROM loan_products");
while ($row = $res->fetch_assoc()) {
    echo "ID: " . $row['product_id'] . " - " . $row['product_name'] . " (Int: " . $row['interest_rate'] . "%, Pen: " . $row['penalty_rate'] . "%)\n";
}
?>
