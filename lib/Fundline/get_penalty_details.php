<?php
require_once 'config/db.php';

$sql = "SELECT product_id, product_name, penalty_rate, penalty_type FROM loan_products WHERE product_id = 1";
$res = $conn->query($sql);
if ($row = $res->fetch_assoc()) {
    echo "Product: " . $row['product_name'] . "\n";
    echo "Penalty Rate: " . $row['penalty_rate'] . "\n";
    echo "Penalty Type: " . $row['penalty_type'] . "\n";
} else {
    echo "Product 1 not found.\n";
}
?>
