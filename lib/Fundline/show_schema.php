<?php
require_once 'config/db.php';

function showTable($conn, $table) {
    echo "Schema for table '$table':\n";
    $result = $conn->query("DESCRIBE $table");
    if ($result) {
        echo str_pad("Field", 25) . str_pad("Type", 25) . "Null\n";
        echo str_repeat("-", 60) . "\n";
        while ($row = $result->fetch_assoc()) {
            echo str_pad($row['Field'], 25) . str_pad($row['Type'], 25) . $row['Null'] . "\n";
        }
    } else {
        echo "Table '$table' not found or error: " . $conn->error . "\n";
    }
    echo "\n";
}

showTable($conn, 'loans');
showTable($conn, 'loan_products');
?>
