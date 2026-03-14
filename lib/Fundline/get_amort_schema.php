<?php
require_once 'config/db.php';
function showTable($conn, $table) {
    echo "Schema for table '$table':\n";
    $result = $conn->query("DESCRIBE $table");
    if ($result) {
        while ($row = $result->fetch_assoc()) echo $row['Field'] . " (" . $row['Type'] . ")\n";
    } else {
        echo "Table error: " . $conn->error . "\n";
    }
}
showTable($conn, 'amortization_schedule');
?>
