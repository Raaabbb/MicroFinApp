<?php
$dir = 'c:/xampp/htdocs/MultiTenantWeb/Fundline/includes';
$files = scandir($dir);
$php_files = [];
foreach($files as $file) {
    if(pathinfo($file, PATHINFO_EXTENSION) == 'php') {
        $php_files[] = $file;
    }
}
echo "Found " . count($php_files) . " PHP files in $dir\n";

// Let's create a more targeted search for queries to fix manually or semi-automatically
$query_patterns = ['SELECT', 'UPDATE', 'DELETE', 'INSERT'];
$files_with_queries = [];

foreach($php_files as $file) {
    $content = file_get_contents("$dir/$file");
    $has_query = false;
    foreach($query_patterns as $pattern) {
        if(stripos($content, $pattern) !== false && (stripos($content, 'prepare(') !== false || stripos($content, 'query(') !== false)) {
            $has_query = true;
            break;
        }
    }
    if($has_query) {
        $files_with_queries[] = $file;
    }
}

echo "Files with potential DB queries: " . count($files_with_queries) . "\n";
print_r($files_with_queries);
?>
