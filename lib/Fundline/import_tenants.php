<?php
/**
 * MULTI-TENANT DATA MIGRATION SCRIPT
 * Imports users/loans/payments from PlaridelMicroFin into fundline_microfinancing under tenant_id=2
 * And from SacredHeartCoop into fundline_microfinancing under tenant_id=3
 * 
 * Run via: http://localhost/MultiTenantWeb/Fundline/import_tenants.php?key=import2026
 * DELETE THIS FILE AFTER RUNNING!
 */

// Security check
$secret = $_GET['key'] ?? '';
if ($secret !== 'import2026') {
    http_response_code(403);
    die("<h2>403 Forbidden</h2><p>Add ?key=import2026 to the URL.</p>");
}

require_once 'config/db.php';
$target = $conn; // Target: fundline_microfinancing

$log = [];

function log_it(&$log, $msg) {
    echo $msg . "\n";
    $log[] = $msg;
    flush();
}

echo "<pre style='font-family:monospace;font-size:12px;background:#0d1117;color:#c9d1d9;padding:20px;border-radius:8px;overflow:auto;max-height:85vh;'>";
echo "=== MULTI-TENANT DATA IMPORT ===\n";
echo "Date: " . date('Y-m-d H:i:s') . "\n\n";

// =====================================================================
// PART 1: PLARIDEL MICROFINANCING → tenant_id = 2
// =====================================================================
echo "================================================================\n";
echo "IMPORTING: PlaridelMicroFin → Tenant 2\n";
echo "================================================================\n\n";

// Connect to PlaridelMicroFin database
// PlaridelMicroFin uses a REMOTE database (InfinityFree)
// We read from its db.php to get connection details
$plaridel_db_path = __DIR__ . '/../PlaridelMicroFin/db.php';
$plaridel_conf = [];

if (file_exists($plaridel_db_path)) {
    // Parse db.php to extract credentials
    $db_content = file_get_contents($plaridel_db_path);
    
    // Extract PDO DSN
    if (preg_match('/host=([^;]+);dbname=([^\']+)/i', $db_content, $m)) {
        $plaridel_conf['host'] = trim($m[1]);
        $plaridel_conf['dbname'] = trim($m[2]);
    }
    if (preg_match('/\$pdo_user\s*=\s*[\'"]([^\'"]+)[\'"]/i', $db_content, $m) || 
        preg_match('/PDO\([^,]+,\s*[\'"]([^\'"]+)[\'"]/', $db_content, $m)) {
        $plaridel_conf['user'] = trim($m[1]);
    }
    if (preg_match('/\$pdo_pass\s*=\s*[\'"]([^\'"]*)[\'"]/', $db_content, $m)) {
        $plaridel_conf['pass'] = $m[1];
    }
    
    log_it($log, "Plaridel DB config detected: host={$plaridel_conf['host']}, db={$plaridel_conf['dbname']}");
} else {
    log_it($log, "⚠️  PlaridelMicroFin db.php not found at $plaridel_db_path");
}

// Try to connect
$plaridel_pdo = null;
if (!empty($plaridel_conf['host']) && !empty($plaridel_conf['dbname'])) {
    try {
        $dsn = "mysql:host={$plaridel_conf['host']};dbname={$plaridel_conf['dbname']};charset=utf8mb4";
        $plaridel_pdo = new PDO($dsn, $plaridel_conf['user'] ?? '', $plaridel_conf['pass'] ?? '', [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_TIMEOUT => 5,
        ]);
        log_it($log, "✅ Connected to PlaridelMicroFin database");
    } catch (PDOException $e) {
        log_it($log, "❌ Cannot connect to Plaridel remote DB: " . $e->getMessage());
        log_it($log, "   → Will use MANUAL SQL export. See below for instructions.");
    }
}

if ($plaridel_pdo) {
    // Import users from PlaridelMicroFin
    $plaridel_users = $plaridel_pdo->query("SELECT * FROM users")->fetchAll(PDO::FETCH_ASSOC);
    log_it($log, "\nFound " . count($plaridel_users) . " users in PlaridelMicroFin\n");
    
    $user_id_map = []; // old plaridel user id -> new fundline user id
    $imported_users = 0;
    
    foreach ($plaridel_users as $u) {
        // Skip if email already exists in fundline for tenant 2
        $check = $target->prepare("SELECT user_id FROM users WHERE email=? AND tenant_id=2 LIMIT 1");
        $check->bind_param("s", $u['email']);
        $check->execute();
        $existing = $check->get_result()->fetch_assoc();
        $check->close();
        
        if ($existing) {
            $user_id_map[$u['id']] = $existing['user_id'];
            log_it($log, "⏭️  User exists: " . $u['email']);
            continue;
        }
        
        // Determine role_id in Fundline (1=SuperAdmin, 2=Admin, 3=User)
        $role_id = 3; // Default: User
        if (!empty($u['role_id'])) {
            // Plaridel role: 1=customer, 2=manager/admin
            $role_id = ($u['role_id'] == 1) ? 3 : 2;
        }
        $user_type = ($role_id == 3) ? 'Client' : 'Employee';
        
        // Map username
        $username = $u['email']; // Use email as username if no username field
        if (!empty($u['username'])) $username = $u['username'];
        $username = preg_replace('/[^a-zA-Z0-9_]/', '_', $username);
        
        // Try to get full name
        $full_name = $u['full_name'] ?? ($u['first_name'] ?? '') . ' ' . ($u['last_name'] ?? '');
        
        $ins = $target->prepare("
            INSERT INTO users (tenant_id, username, email, password_hash, role_id, user_type, status, email_verified, created_at)
            VALUES (2, ?, ?, ?, ?, ?, 'Active', 1, NOW())
        ");
        $ins->bind_param("ssssi", $username, $u['email'], $u['password'], $role_id, $user_type);
        if ($ins->execute()) {
            $new_user_id = $target->insert_id;
            $user_id_map[$u['id']] = $new_user_id;
            $imported_users++;
            log_it($log, "✅ Imported user: $username (new ID: $new_user_id)");
            
            // Create client record if customer
            if ($user_type === 'Client') {
                $parts = explode(' ', trim($full_name), 3);
                $fname = $parts[0] ?? 'Unknown';
                $lname = $parts[count($parts)-1] ?? 'Unknown';
                
                $cc = $target->prepare("
                    INSERT INTO clients (user_id, tenant_id, first_name, last_name, contact_number, registration_date, client_status, document_verification_status)
                    VALUES (?, 2, ?, ?, ?, CURDATE(), 'Active', 'Unverified')
                    ON DUPLICATE KEY UPDATE first_name=first_name
                ");
                $contact = $u['phone'] ?? '09000000000';
                $cc->bind_param("isss", $new_user_id, $fname, $lname, $contact);
                $cc->execute();
                $cc->close();
            }
        }
        $ins->close();
    }
    log_it($log, "\n→ Imported $imported_users new users from PlaridelMicroFin\n");
    
    // Import loans
    try {
        $plaridel_loans = $plaridel_pdo->query("
            SELECT l.*, ls.status_name 
            FROM loans l 
            LEFT JOIN loan_statuses ls ON l.status_id = ls.id
        ")->fetchAll(PDO::FETCH_ASSOC);
        log_it($log, "Found " . count($plaridel_loans) . " loans in PlaridelMicroFin");
        
        $imported_loans = 0;
        foreach ($plaridel_loans as $l) {
            $new_user_id = $user_id_map[$l['user_id']] ?? null;
            if (!$new_user_id) continue;
            
            // Get client_id in fundline
            $cq = $target->prepare("SELECT client_id FROM clients WHERE user_id=? AND tenant_id=2 LIMIT 1");
            $cq->bind_param("i", $new_user_id);
            $cq->execute();
            $client = $cq->get_result()->fetch_assoc();
            $cq->close();
            if (!$client) continue;
            $client_id = $client['client_id'];
            
            // Map loan status
            $status_map = ['active'=>'Active','released'=>'Active','approved'=>'Active','late'=>'Overdue','delinquent'=>'Overdue','paid'=>'Fully Paid'];
            $loan_status = $status_map[strtolower($l['status_name'] ?? 'active')] ?? 'Active';
            
            // Get product_id for tenant 2
            $pq = $target->query("SELECT product_id FROM loan_products WHERE tenant_id=2 LIMIT 1");
            $product = $pq->fetch_assoc();
            $product_id = $product['product_id'] ?? 1;
            
            // Get employee_id for tenant 2 (default admin)
            $eq = $target->query("SELECT e.employee_id FROM employees e WHERE e.tenant_id=2 LIMIT 1");
            $emp = $eq->fetch_assoc();
            $emp_id = $emp['employee_id'] ?? 1;
            
            $amount = $l['amount'] ?? 0;
            $interest = $amount * 0.12;
            $total = $amount + $interest;
            $monthly = $amount > 0 ? round($total / max(1, $l['term_months'] ?? 1), 2) : 0;
            
            $loan_num = 'PMIG-' . str_pad($l['id'], 6, '0', STR_PAD_LEFT);
            $release_date = $l['approved_at'] ?? $l['applied_at'] ?? date('Y-m-d');
            $first_pay = date('Y-m-d', strtotime($release_date . '+1 month'));
            $maturity = date('Y-m-d', strtotime($release_date . '+' . ($l['term_months'] ?? 12) . ' months'));
            
            // Find matching app or create one
            $app_ins = $target->prepare("
                INSERT IGNORE INTO loan_applications (application_number, client_id, tenant_id, product_id, requested_amount, approved_amount, loan_term_months, interest_rate, application_status, submitted_date)
                VALUES (?, ?, 2, ?, ?, ?, ?, 12.00, 'Approved', NOW())
            ");
            $app_num = 'APP-PL-' . str_pad($l['id'], 6, '0', STR_PAD_LEFT);
            $app_ins->bind_param("siiddi", $app_num, $client_id, $product_id, $amount, $amount, ($l['term_months'] ?? 12));
            $app_ins->execute();
            $app_id = $target->insert_id ?: 1;
            $app_ins->close();
            
            $ins = $target->prepare("
                INSERT IGNORE INTO loans (loan_number, application_id, client_id, tenant_id, product_id, principal_amount, interest_amount, total_loan_amount, interest_rate, loan_term_months, monthly_amortization, number_of_payments, release_date, first_payment_date, maturity_date, loan_status, released_by)
                VALUES (?, ?, ?, 2, ?, ?, ?, ?, 12.00, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $num_pay = $l['term_months'] ?? 12;
            $ins->bind_param("siiiddddiissssi", $loan_num, $app_id, $client_id, $product_id, $amount, $interest, $total, $num_pay, $monthly, $num_pay, $release_date, $first_pay, $maturity, $loan_status, $emp_id);
            if ($ins->execute()) {
                $imported_loans++;
                log_it($log, "  ✅ Loan imported: $loan_num (₱" . number_format($amount) . ")");
            } else {
                log_it($log, "  ⏭️  Loan $loan_num already exists or error: " . $target->error);
            }
            $ins->close();
        }
        log_it($log, "→ Imported $imported_loans loans from PlaridelMicroFin\n");
    } catch (Exception $e) {
        log_it($log, "⚠️  Could not import loans: " . $e->getMessage());
    }
}

// =====================================================================
// PART 2: SacredHeartCoop → tenant_id = 3  
// =====================================================================
echo "\n================================================================\n";
echo "IMPORTING: SacredHeartCoop → Tenant 3\n";
echo "================================================================\n\n";

// Connect to SacredHeartCoop database (local: wowers_db)
try {
    $sh_pdo = new PDO("mysql:host=localhost;dbname=wowers_db;charset=utf8mb4", "root", "root", [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_TIMEOUT => 5,
    ]);
    log_it($log, "✅ Connected to SacredHeartCoop database (wowers_db)");
    
    // Import users
    $sh_users = $sh_pdo->query("SELECT * FROM users")->fetchAll(PDO::FETCH_ASSOC);
    log_it($log, "Found " . count($sh_users) . " users in SacredHeartCoop\n");
    
    $sh_user_id_map = [];
    $sh_imported_users = 0;
    
    foreach ($sh_users as $u) {
        $email = $u['email'] ?? ($u['username'] . '@sacredheart.coop');
        
        // Skip if already exists
        $check = $target->prepare("SELECT user_id FROM users WHERE email=? AND tenant_id=3 LIMIT 1");
        $check->bind_param("s", $email);
        $check->execute();
        $existing = $check->get_result()->fetch_assoc();
        $check->close();
        
        if ($existing) {
            $sh_user_id_map[$u['id']] = $existing['user_id'];
            log_it($log, "⏭️  User exists: $email");
            continue;
        }
        
        // Determine role
        $role_id = 3;
        if (!empty($u['role'])) {
            $role_id = (str_contains(strtolower($u['role']), 'admin') || str_contains(strtolower($u['role']), 'manager')) ? 2 : 3;
        }
        $user_type = ($role_id == 3) ? 'Client' : 'Employee';
        
        $uname = $u['username'] ?? preg_replace('/[^a-z0-9_]/', '_', strtolower($email));
        
        $ins = $target->prepare("
            INSERT INTO users (tenant_id, username, email, password_hash, role_id, user_type, status, email_verified, created_at)
            VALUES (3, ?, ?, ?, ?, ?, 'Active', 1, NOW())
        ");
        $pw_hash = $u['password'] ?? $u['password_hash'] ?? password_hash('changeme123', PASSWORD_DEFAULT);
        $ins->bind_param("ssssi", $uname, $email, $pw_hash, $role_id, $user_type);
        if ($ins->execute()) {
            $new_id = $target->insert_id;
            $sh_user_id_map[$u['id']] = $new_id;
            $sh_imported_users++;
            log_it($log, "✅ Imported: $uname (new ID: $new_id)");
            
            if ($user_type === 'Client') {
                $fname = $u['first_name'] ?? explode(' ', $u['full_name'] ?? 'Unknown')[0];
                $lname = $u['last_name'] ?? (explode(' ', $u['full_name'] ?? 'Unknown Unknown')[1] ?? 'Unknown');
                $cc = $target->prepare("
                    INSERT INTO clients (user_id, tenant_id, first_name, last_name, contact_number, registration_date, client_status, document_verification_status)
                    VALUES (?, 3, ?, ?, '09000000000', CURDATE(), 'Active', 'Unverified')
                    ON DUPLICATE KEY UPDATE first_name=first_name
                ");
                $cc->bind_param("iss", $new_id, $fname, $lname);
                $cc->execute();
                $cc->close();
            }
        }
        $ins->close();
    }
    log_it($log, "\n→ Imported $sh_imported_users new users from SacredHeartCoop\n");
    
    // Import loans from SacredHeartCoop  
    try {
        $sh_loans = $sh_pdo->query("SELECT * FROM loans")->fetchAll(PDO::FETCH_ASSOC);
        log_it($log, "Found " . count($sh_loans) . " loans in SacredHeartCoop");
        
        $sh_imported_loans = 0;
        foreach ($sh_loans as $l) {
            $new_user_id = $sh_user_id_map[$l['user_id'] ?? $l['member_id'] ?? 0] ?? null;
            if (!$new_user_id) continue;
            
            $cq = $target->prepare("SELECT client_id FROM clients WHERE user_id=? AND tenant_id=3 LIMIT 1");
            $cq->bind_param("i", $new_user_id);
            $cq->execute();
            $client = $cq->get_result()->fetch_assoc();
            $cq->close();
            if (!$client) continue;
            $client_id = $client['client_id'];
            
            $pq = $target->query("SELECT product_id FROM loan_products WHERE tenant_id=3 LIMIT 1");
            $product = $pq->fetch_assoc();
            $product_id = $product['product_id'] ?? 1;
            
            $eq = $target->query("SELECT e.employee_id FROM employees e WHERE e.tenant_id=3 LIMIT 1");
            $emp = $eq->fetch_assoc();
            $emp_id = $emp['employee_id'] ?? 1;
            
            $amount = $l['amount'] ?? $l['loan_amount'] ?? 0;
            $interest = $amount * 0.12;
            $total = $amount + $interest;
            $term = $l['term_months'] ?? $l['term'] ?? 12;
            $monthly = $amount > 0 ? round($total / max(1, $term), 2) : 0;
            $status_raw = strtolower($l['status'] ?? 'active');
            $status_map2 = ['active'=>'Active','paid'=>'Fully Paid','overdue'=>'Overdue','default'=>'Overdue','closed'=>'Fully Paid'];
            $loan_status = $status_map2[$status_raw] ?? 'Active';
            
            $loan_num = 'SHCG-' . str_pad($l['id'], 6, '0', STR_PAD_LEFT);
            $release_date = $l['disbursement_date'] ?? $l['created_at'] ?? $l['start_date'] ?? date('Y-m-d');
            if (is_array($release_date)) $release_date = date('Y-m-d');
            $first_pay = date('Y-m-d', strtotime($release_date . '+1 month'));
            $maturity = date('Y-m-d', strtotime($release_date . '+' . $term . ' months'));
            
            $app_ins = $target->prepare("
                INSERT IGNORE INTO loan_applications (application_number, client_id, tenant_id, product_id, requested_amount, approved_amount, loan_term_months, interest_rate, application_status, submitted_date)
                VALUES (?, ?, 3, ?, ?, ?, ?, 12.00, 'Approved', NOW())
            ");
            $app_num = 'APP-SH-' . str_pad($l['id'], 6, '0', STR_PAD_LEFT);
            $app_ins->bind_param("siiddi", $app_num, $client_id, $product_id, $amount, $amount, $term);
            $app_ins->execute();
            $app_id = $target->insert_id ?: 1;
            $app_ins->close();
            
            $ins = $target->prepare("
                INSERT IGNORE INTO loans (loan_number, application_id, client_id, tenant_id, product_id, principal_amount, interest_amount, total_loan_amount, interest_rate, loan_term_months, monthly_amortization, number_of_payments, release_date, first_payment_date, maturity_date, loan_status, released_by)
                VALUES (?, ?, ?, 3, ?, ?, ?, ?, 12.00, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $ins->bind_param("siiiddddiissssi", $loan_num, $app_id, $client_id, $product_id, $amount, $interest, $total, $term, $monthly, $term, $release_date, $first_pay, $maturity, $loan_status, $emp_id);
            if ($ins->execute()) {
                $sh_imported_loans++;
                log_it($log, "  ✅ Loan: $loan_num (₱" . number_format($amount) . ")");
            } else {
                log_it($log, "  ⏭️  Loan $loan_num already exists");
            }
            $ins->close();
        }
        log_it($log, "→ Imported $sh_imported_loans loans from SacredHeartCoop\n");
    } catch (Exception $e) {
        log_it($log, "⚠️  Could not import SacredHeartCoop loans: " . $e->getMessage());
    }
    
} catch (PDOException $e) {
    log_it($log, "❌ Cannot connect to SacredHeartCoop DB (wowers_db): " . $e->getMessage());
    log_it($log, "   → Check: Is XAMPP running? Is the database name 'wowers_db'?");
}

// =====================================================================
// FINAL SUMMARY
// =====================================================================
echo "\n================================================================\n";
echo "CURRENT TENANT SUMMARY\n";
echo "================================================================\n";

$tenants = $target->query("SELECT t.tenant_id, t.tenant_name, t.tenant_slug, 
    (SELECT COUNT(*) FROM users u WHERE u.tenant_id=t.tenant_id) as total_users,
    (SELECT COUNT(*) FROM clients c WHERE c.tenant_id=t.tenant_id) as total_clients,
    (SELECT COUNT(*) FROM loans l WHERE l.tenant_id=t.tenant_id) as total_loans
    FROM tenants t ORDER BY t.tenant_id");
echo "\nID | Name                       | Slug        | Users | Clients | Loans\n";
echo "---|----------------------------|-------------|-------|---------|------\n";
while ($t = $tenants->fetch_assoc()) {
    echo sprintf(" %s | %-26s | %-11s | %-5s | %-7s | %s\n",
        $t['tenant_id'], $t['tenant_name'], $t['tenant_slug'],
        $t['total_users'], $t['total_clients'], $t['total_loans']
    );
}

echo "\n✅ IMPORT COMPLETE!\n";
echo "⚠️  DELETE THIS FILE: rm C:/xampp/htdocs/MultiTenantWeb/Fundline/import_tenants.php\n";
echo "</pre>";
?>
