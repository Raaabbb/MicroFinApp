<?php
require_once 'config/db.php';

$res = $conn->query("SHOW TABLES");
$tables = [];
while ($row = $res->fetch_array()) {
    $tables[] = $row[0];
}

foreach($tables as $table) {
    echo "TABLE: $table\n";
    $desc = $conn->query("DESCRIBE $table");
    while($r = $desc->fetch_assoc()) {
        echo "  " . $r['Field'] . " - " . $r['Type'] . "\n";
    }
}
