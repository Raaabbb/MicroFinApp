<?php
require_once 'config/db.php';

function getCreate($conn, $table) {
    $res = $conn->query("SHOW CREATE TABLE $table");
    if ($row = $res->fetch_array()) {
        echo $row[1] . ";\n\n";
    }
}

echo "-- Schema for loans table\n";
getCreate($conn, 'loans');

echo "-- Schema for loan_applications table\n";
getCreate($conn, 'loan_applications');
?>
