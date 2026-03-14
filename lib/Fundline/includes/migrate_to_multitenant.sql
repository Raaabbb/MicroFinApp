-- ============================================================
-- MULTI-TENANT MIGRATION SCRIPT v2
-- Compatible with MySQL 8.0 on XAMPP
-- Run via: http://localhost/MultiTenantWeb/Fundline/run_migration.php?key=migrate2026
-- ============================================================

USE fundline_microfinancing;

-- ============================================================
-- STEP 1: Create tenants table
-- ============================================================
CREATE TABLE IF NOT EXISTS tenants (
    tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_name VARCHAR(100) NOT NULL,
    tenant_slug VARCHAR(50) NOT NULL UNIQUE,
    company_address TEXT,
    company_contact VARCHAR(30),
    company_email VARCHAR(100),
    logo_path VARCHAR(255),
    theme_primary_color VARCHAR(10) DEFAULT '#dc2626',
    theme_secondary_color VARCHAR(10) DEFAULT '#991b1b',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT IGNORE INTO tenants (tenant_id, tenant_name, tenant_slug, company_address, company_contact, theme_primary_color, theme_secondary_color) VALUES
(1, 'Fundline Micro Financing', 'fundline', 'Marilao, Bulacan', '09000000000', '#dc2626', '#991b1b'),
(2, 'Plaridel MicroFin', 'plaridel', 'Plaridel, Bulacan', '09111111111', '#136dec', '#0e4fb3'),
(3, 'Sacred Heart Cooperative', 'sacredheart', 'Bulacan, Philippines', '09222222222', '#16a34a', '#15803d');

-- ============================================================
-- STEP 2: Add tenant_id column to all tables
-- ============================================================

-- users
ALTER TABLE users ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE users ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE users SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- employees
ALTER TABLE employees ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE employees ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE employees SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- clients
ALTER TABLE clients ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_house_no VARCHAR(50) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_street VARCHAR(100) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_barangay VARCHAR(100) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_city VARCHAR(100) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_province VARCHAR(100) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS comaker_postal_code VARCHAR(10) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS id_type VARCHAR(100) NULL;
ALTER TABLE clients ADD COLUMN IF NOT EXISTS last_seen_credit_limit DECIMAL(15,2) DEFAULT 0.00;
ALTER TABLE clients ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE clients SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- client_documents
ALTER TABLE client_documents ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE client_documents ADD INDEX IF NOT EXISTS idx_tenant_client (tenant_id, client_id);
UPDATE client_documents SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- loan_products
ALTER TABLE loan_products ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE loan_products ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE loan_products SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- loan_applications
ALTER TABLE loan_applications ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE loan_applications ADD COLUMN IF NOT EXISTS application_data JSON NULL;
ALTER TABLE loan_applications ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE loan_applications SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- application_documents
ALTER TABLE application_documents ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE application_documents ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE application_documents SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- loans
ALTER TABLE loans ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE loans ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
ALTER TABLE loans ADD INDEX IF NOT EXISTS idx_tenant_client (tenant_id, client_id);
UPDATE loans SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- payments
ALTER TABLE payments ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE payments ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
ALTER TABLE payments ADD INDEX IF NOT EXISTS idx_tenant_client (tenant_id, client_id);
UPDATE payments SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- payment_transactions
ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE payment_transactions ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE payment_transactions SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- notifications
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE notifications ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE notifications SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- audit_logs
ALTER TABLE audit_logs ADD COLUMN IF NOT EXISTS tenant_id INT NULL DEFAULT NULL;
ALTER TABLE audit_logs ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE audit_logs SET tenant_id = 1 WHERE tenant_id IS NULL;

-- system_settings
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
UPDATE system_settings SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- credit_investigations
ALTER TABLE credit_investigations ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE credit_investigations ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE credit_investigations SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- credit_scores
ALTER TABLE credit_scores ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE credit_scores ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE credit_scores SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- amortization_schedule
ALTER TABLE amortization_schedule ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE amortization_schedule ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE amortization_schedule SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- chat_messages
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1;
ALTER TABLE chat_messages ADD INDEX IF NOT EXISTS idx_tenant (tenant_id);
UPDATE chat_messages SET tenant_id = 1 WHERE tenant_id IS NULL OR tenant_id = 0;

-- ============================================================
-- STEP 3: Seed loan products for tenants 2 and 3
-- ============================================================
INSERT IGNORE INTO loan_products (tenant_id, product_name, product_type, min_amount, max_amount, interest_rate, min_term_months, max_term_months, penalty_rate) VALUES
(2, 'Personal Loan - Standard', 'Personal Loan', 2000.00, 30000.00, 3.0, 1, 12, 0.05),
(2, 'Business Loan', 'Business Loan', 5000.00, 100000.00, 2.5, 3, 24, 0.05),
(3, 'Personal Loan', 'Personal Loan', 1000.00, 20000.00, 2.0, 1, 12, 0.05),
(3, 'Emergency Loan', 'Emergency Loan', 500.00, 5000.00, 1.5, 1, 6, 0.05);

-- ============================================================
-- STEP 4: Add system settings for tenants 2 and 3
-- ============================================================
INSERT IGNORE INTO system_settings (tenant_id, setting_key, setting_value, setting_category, data_type) VALUES
(2, 'company_name', 'Plaridel MicroFin', 'Company', 'String'),
(2, 'company_address', 'Plaridel, Bulacan', 'Company', 'String'),
(3, 'company_name', 'Sacred Heart Cooperative', 'Company', 'String'),
(3, 'company_address', 'Bulacan, Philippines', 'Company', 'String');

-- ============================================================
-- DONE! Verify: SELECT tenant_id, COUNT(*) as c FROM users GROUP BY tenant_id;
-- ============================================================
