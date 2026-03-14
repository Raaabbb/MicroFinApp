<?php
/**
 * Semi-automated script to inject get_tenant_id() and add tenant_id filters.
 * Note: regex replacement of SQL is risky, so this mostly just adds the $current_tenant_id = get_tenant_id(); 
 * to the tops of files and logs files that need manual query updates.
 */
$dir = 'c:/xampp/htdocs/MultiTenantWeb/Fundline/includes';
$files_with_queries = [
    'admin_applications.php', 'admin_audit_trail.php', 'admin_loans.php', 'admin_manage_admins.php', 
    'admin_messages.php', 'apply_loan.php', 'calculate_credit_limit.php', 'calculate_score_now.php', 
    'check_my_loans.php', 'check_payment_transactions.php', 'client_header.php', 'clients.php', 
    'create_admin.php', 'dashboard.php', 'disbursement.php', 'forgot_password.php', 
    'get_client_documents.php', 'get_purpose_documents.php', 'loan_helper.php', 
    'make_payment.php', 'manage_profile.php', 'my_applications.php', 'my_loans.php', 'my_payments.php', 
    'notification_helper.php', 'notifications.php', 'payment.php', 'payment_history.php', 
    'payment_success.php', 'paymongo_webhook.php', 'process_application.php', 'process_credit_update.php', 
    'register.php', 'relax_requirements.php', 'report.php', 'reset_password.php', 'settings.php', 
    'submit_documents.php', 'super_admin_dashboard.php', 'super_admin_operations.php', 
    'super_admin_settings.php', 'support_api.php', 'verify_documents.php', 'view_application.php', 
    'view_client.php', 'view_loan.php', 'view_payment.php'
];

foreach ($files_with_queries as $file) {
    $path = "$dir/$file";
    if (!file_exists($path)) continue;
    
    $content = file_get_contents($path);
    
    // Inject get_tenant_id() after session_start or db inclusion
    if (strpos($content, '$current_tenant_id = get_tenant_id();') === false) {
        // Find a good insertion point: after require_once '../config/db.php';
        $insert_after = "require_once '../config/db.php';";
        $insert_text = "\n\n// Get current tenant_id\n\$current_tenant_id = get_tenant_id();";
        
        if (strpos($content, $insert_after) !== false) {
            $content = str_replace($insert_after, $insert_after . $insert_text, $content);
            file_put_contents($path, $content);
            echo "Injected get_tenant_id() into $file\n";
        } else {
            // Try after session_start
            $insert_after = "session_start();";
            if (strpos($content, $insert_after) !== false) {
                // assume db might not be included? We should probably include it too if we need get_tenant_id.
                // Let's just log it for manual review if db.php isn't there.
                echo "Warning: No config/db.php found in $file. Review manually.\n";
            }
        }
    }
}
echo "Injection phase 1 complete. Now manual SQL updating is required for safety.\n";
?>
