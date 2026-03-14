<?php
require_once 'config/db.php';

// Disable foreign key checks for migration
$conn->query("SET FOREIGN_KEY_CHECKS=0");

echo "Creating tenants table...\n";
$sql = "CREATE TABLE IF NOT EXISTS tenants (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    domain_or_slug VARCHAR(50) UNIQUE NOT NULL,
    logo_path VARCHAR(255),
    theme_color VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
if(!$conn->query($sql)) {
    die("Error creating tenants table: " . $conn->error . "\n");
}

echo "Inserting default tenants...\n";
$tenants = [
    [1, 'FundLine Microfinancing', 'fundline', '#0d6efd'],
    [2, 'Plaridel Microfinancing', 'plaridel', '#198754'],
    [3, 'Sacred Heart Savings Coop', 'sacredheart', '#dc3545']
];

foreach ($tenants as $t) {
    if (!$conn->query("INSERT IGNORE INTO tenants (tenant_id, name, domain_or_slug, theme_color) VALUES ($t[0], '$t[1]', '$t[2]', '$t[3]')")) {
         echo "Error inserting tenant $t[1]: " . $conn->error . "\n";
    }
}

// List of tables to add tenant_id to
$tables = [
    'amortization_schedule', 'application_documents', 'appointments', 'audit_logs',
    'client_documents', 'client_references', 'clients', 'collection_activities',
    'collection_assignments', 'credit_investigations', 'credit_scores', 'daily_cash_position',
    'document_types', 'email_reminders', 'employees', 'feedback', 'kyc_documents',
    'loan_applications', 'loan_products', 'loans', 'messages', 'notifications',
    'payment_reversals', 'payment_transactions', 'payments', 'portfolio_summary',
    'system_settings', 'user_sessions', 'users'
];

foreach ($tables as $table) {
    echo "Adding tenant_id to $table...\n";
    
    // Check if column already exists
    $check = $conn->query("SHOW COLUMNS FROM `$table` LIKE 'tenant_id'");
    if ($check->num_rows == 0) {
        $alter = "ALTER TABLE `$table` ADD COLUMN tenant_id INT NOT NULL DEFAULT 1";
        if (!$conn->query($alter)) {
            echo "Error adding tenant_id to $table: " . $conn->error . "\n";
        } else {
            // Add foreign key constraint
            $fk_name = "fk_tenant_$table";
            $fk_alter = "ALTER TABLE `$table` ADD CONSTRAINT `$fk_name` FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id) ON DELETE CASCADE";
            if (!$conn->query($fk_alter)) {
                echo "Error adding FK to $table: " . $conn->error . "\n";
            }
        }
    } else {
        echo "Column tenant_id already exists in $table.\n";
    }
}

// Ensure uniqueness of username per tenant, removing global username uniqueness if exists
// Wait, 'username' field is in users table. Let's make (tenant_id, username) unique.
$check_idx = $conn->query("SHOW INDEX FROM users WHERE Key_name = 'username'");
if ($check_idx && $check_idx->num_rows > 0) {
    echo "Dropping unique index on username...\n";
    if(!$conn->query("ALTER TABLE users DROP INDEX username")) {
         echo "Error dropping unique index on username: " . $conn->error . "\n";
    }
}
$check_tenant_idx = $conn->query("SHOW INDEX FROM users WHERE Key_name = 'unique_tenant_username'");
if ($check_tenant_idx->num_rows == 0) {
    echo "Creating unique index on (tenant_id, username)...\n";
    if(!$conn->query("ALTER TABLE users ADD UNIQUE INDEX unique_tenant_username (tenant_id, username)")) {
         echo "Error creating unique index on users: " . $conn->error . "\n";
    }
}

$conn->query("SET FOREIGN_KEY_CHECKS=1");
echo "Migration completed.\n";
?>
