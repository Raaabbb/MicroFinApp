<?php
// CLI import runner — bypasses the secret key check
$_GET['key'] = 'import2026';
require 'import_tenants.php';
