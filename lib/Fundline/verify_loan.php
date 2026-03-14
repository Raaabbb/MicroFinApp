<?php
require_once 'config/db.php';

$client_id = 2;
echo "Checking loans for Client ID $client_id:\n";

$sql = "SELECT loan_number, principal_amount, outstanding_penalty, loan_status, days_overdue FROM loans WHERE client_id = ? ORDER BY loan_id DESC LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $client_id);
$stmt->execute();
$res = $stmt->get_result();

if ($row = $res->fetch_assoc()) {
    print_r($row);
} else {
    echo "No loans found.";
}
?>
