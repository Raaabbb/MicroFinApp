-- ============================================================
-- FUNDLINE MULTI-TENANT DATABASE SCHEMA
-- Version 2.0 - Full Multi-Tenant Support
-- Generated: 2026-03-11
-- ============================================================
-- This schema supports 3 tenants:
--   Tenant 1: Fundline (Marilao Branch)
--   Tenant 2: PlaridelMicroFin
--   Tenant 3: Sacred Heart Coop
-- ============================================================

CREATE DATABASE IF NOT EXISTS fundline_microfinancing;
USE fundline_microfinancing;

-- ============================================================
-- TABLE 1: tenants (Master tenant registry)
-- ============================================================
CREATE TABLE IF NOT EXISTS tenants (
    tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_name VARCHAR(100) NOT NULL,
    tenant_slug VARCHAR(50) NOT NULL UNIQUE COMMENT 'URL-safe identifier e.g. fundline, plaridel, sacredheart',
    company_address TEXT,
    company_contact VARCHAR(30),
    company_email VARCHAR(100),
    logo_path VARCHAR(255) COMMENT 'Relative path to logo image',
    theme_primary_color VARCHAR(10) DEFAULT '#dc2626' COMMENT 'Hex color code',
    theme_secondary_color VARCHAR(10) DEFAULT '#991b1b',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO tenants (tenant_id, tenant_name, tenant_slug, company_address, company_contact, theme_primary_color, theme_secondary_color) VALUES
(1, 'Fundline Micro Financing', 'fundline', 'Marilao, Bulacan', '09000000000', '#dc2626', '#991b1b'),
(2, 'Plaridel MicroFin', 'plaridel', 'Plaridel, Bulacan', '09111111111', '#136dec', '#0e4fb3'),
(3, 'Sacred Heart Cooperative', 'sacredheart', 'Bulacan, Philippines', '09222222222', '#16a34a', '#15803d');

-- ============================================================
-- TABLE 2: user_roles
-- ============================================================
CREATE TABLE IF NOT EXISTS user_roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user_roles (role_name, role_description) VALUES
('Super Admin', 'Full system access with all privileges including user management and system settings'),
('Admin', 'Administrative access to manage operations, reports, and staff'),
('User', 'Standard user access for employees and clients');

-- ============================================================
-- TABLE 3: users (Shared across tenants - scoped by tenant_id)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    user_type ENUM('Employee', 'Client') NOT NULL,
    status ENUM('Active', 'Inactive', 'Suspended', 'Locked') DEFAULT 'Active',
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_token VARCHAR(255),
    reset_token_expiry DATETIME,
    last_login DATETIME,
    failed_login_attempts INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (role_id) REFERENCES user_roles(role_id),
    UNIQUE KEY uq_tenant_username (tenant_id, username),
    UNIQUE KEY uq_tenant_email (tenant_id, email),
    INDEX idx_reset_token (reset_token),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 4: user_sessions
-- ============================================================
CREATE TABLE IF NOT EXISTS user_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tenant_id INT NOT NULL,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

-- ============================================================
-- TABLE 5: audit_logs
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    tenant_id INT,
    action_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id) ON DELETE SET NULL,
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 6: employees
-- ============================================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    tenant_id INT NOT NULL,
    employee_code VARCHAR(20),
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),
    department ENUM('Admin', 'Sales and Marketing', 'Collections', 'Loan Processing') NOT NULL,
    position VARCHAR(100),
    contact_number VARCHAR(20),
    alternate_contact VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_number VARCHAR(20),
    hire_date DATE NOT NULL,
    employment_status ENUM('Active', 'On Leave', 'Resigned', 'Terminated') DEFAULT 'Active',
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    UNIQUE KEY uq_tenant_empcode (tenant_id, employee_code),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 7: clients
-- ============================================================
CREATE TABLE IF NOT EXISTS clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tenant_id INT NOT NULL,
    client_code VARCHAR(20),
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    civil_status ENUM('Single', 'Married', 'Widowed', 'Divorced', 'Separated'),
    nationality VARCHAR(50) DEFAULT 'Filipino',
    contact_number VARCHAR(20) NOT NULL,
    alternate_contact VARCHAR(20),
    email_address VARCHAR(100),
    present_house_no VARCHAR(50),
    present_street VARCHAR(100),
    present_barangay VARCHAR(100),
    present_city VARCHAR(100),
    present_province VARCHAR(100),
    present_postal_code VARCHAR(10),
    permanent_house_no VARCHAR(50),
    permanent_street VARCHAR(100),
    permanent_barangay VARCHAR(100),
    permanent_city VARCHAR(100),
    permanent_province VARCHAR(100),
    permanent_postal_code VARCHAR(10),
    same_as_present BOOLEAN DEFAULT FALSE,
    employment_status ENUM('Employed', 'Self-Employed', 'Unemployed', 'Retired'),
    occupation VARCHAR(100),
    employer_name VARCHAR(200),
    employer_address TEXT,
    employer_contact VARCHAR(20),
    monthly_income DECIMAL(12, 2),
    other_income_source VARCHAR(200),
    other_income_amount DECIMAL(12, 2),
    comaker_name VARCHAR(150),
    comaker_relationship VARCHAR(50),
    comaker_contact VARCHAR(20),
    comaker_income DECIMAL(12, 2),
    comaker_house_no VARCHAR(50),
    comaker_street VARCHAR(100),
    comaker_barangay VARCHAR(100),
    comaker_city VARCHAR(100),
    comaker_province VARCHAR(100),
    comaker_postal_code VARCHAR(10),
    id_type VARCHAR(100),
    client_status ENUM('Active', 'Inactive', 'Blacklisted', 'Deceased') DEFAULT 'Active',
    blacklist_reason TEXT,
    profile_picture VARCHAR(255),
    registration_date DATE NOT NULL,
    registered_by INT,
    document_verification_status ENUM('Unverified', 'Pending', 'Approved', 'Rejected') DEFAULT 'Unverified',
    verification_rejection_reason TEXT,
    credit_limit DECIMAL(15,2) DEFAULT 0.00,
    last_seen_credit_limit DECIMAL(15,2) DEFAULT 0.00,
    seen_approval_modal BOOLEAN DEFAULT FALSE,
    credit_limit_tier INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (registered_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    UNIQUE KEY uq_tenant_user (tenant_id, user_id),
    UNIQUE KEY uq_tenant_clientcode (tenant_id, client_code),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 8: document_types (Global - shared across tenants)
-- ============================================================
CREATE TABLE IF NOT EXISTS document_types (
    document_type_id INT PRIMARY KEY AUTO_INCREMENT,
    document_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_required BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    loan_purpose VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO document_types (document_name, description, is_required, loan_purpose) VALUES
('Valid ID Front', 'Front side of government-issued ID', TRUE, NULL),
('Valid ID Back', 'Back side of government-issued ID', TRUE, NULL),
('Proof of Income', 'Latest payslip, ITR, or bank statement', TRUE, NULL),
('Proof of Billing', 'Upload proof of address (utility bill, barangay certificate, etc.)', TRUE, NULL),
('Business Permit', 'Valid business permit or DTI/SEC registration', TRUE, 'Business'),
('Business Financial Statements', 'Latest financial statements or income records', TRUE, 'Business'),
('Business Plan', 'Business plan or proposal (for new businesses)', FALSE, 'Business'),
('School Enrollment Certificate', 'Certificate of enrollment or admission letter', TRUE, 'Education'),
('School ID', 'Valid school ID', TRUE, 'Education'),
('Tuition Fee Assessment', 'Official assessment of tuition and fees', TRUE, 'Education'),
('Land Title/Lease Agreement', 'Proof of land ownership or lease', TRUE, 'Agricultural'),
('Farm Plan', 'Detailed farm plan or proposal', TRUE, 'Agricultural'),
('Medical Certificate', 'Medical certificate or hospital bill', TRUE, 'Medical'),
('Prescription/Treatment Plan', 'Doctor''s prescription or treatment plan', FALSE, 'Medical'),
('Property Documents', 'Land title, tax declaration, or contract to sell', TRUE, 'Housing'),
('Construction Estimate', 'Detailed construction estimate or quotation', TRUE, 'Housing'),
('DTI/SEC Registration', 'Business registration documents', FALSE, 'Business'),
('Barangay Clearance', 'Clearance from local barangay', FALSE, NULL),
('Marriage Certificate', 'For married applicants', FALSE, NULL),
('Birth Certificate', 'Birth certificate copy', FALSE, NULL);

-- ============================================================
-- TABLE 9: client_documents
-- ============================================================
CREATE TABLE IF NOT EXISTS client_documents (
    client_document_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    document_type_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    document_number VARCHAR(100),
    file_size INT,
    file_type VARCHAR(50),
    verified_by INT,
    verification_date DATETIME,
    verification_status ENUM('Pending', 'Verified', 'Rejected', 'Expired') DEFAULT 'Pending',
    verification_notes TEXT,
    expiry_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (document_type_id) REFERENCES document_types(document_type_id),
    FOREIGN KEY (verified_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    INDEX idx_tenant_client (tenant_id, client_id)
);

-- ============================================================
-- TABLE 10: loan_products (Per-tenant)
-- ============================================================
CREATE TABLE IF NOT EXISTS loan_products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_type ENUM('Personal Loan', 'Business Loan', 'Emergency Loan') NOT NULL,
    description TEXT,
    min_amount DECIMAL(12, 2) NOT NULL,
    max_amount DECIMAL(12, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    interest_type ENUM('Fixed', 'Diminishing', 'Flat') DEFAULT 'Diminishing',
    min_term_months INT NOT NULL,
    max_term_months INT NOT NULL,
    processing_fee_percentage DECIMAL(5, 2) DEFAULT 0,
    service_charge DECIMAL(10, 2) DEFAULT 0,
    documentary_stamp DECIMAL(10, 2) DEFAULT 0,
    insurance_fee_percentage DECIMAL(5, 2) DEFAULT 0,
    penalty_rate DECIMAL(5, 2) DEFAULT 0,
    penalty_type ENUM('Daily', 'Monthly', 'Flat') DEFAULT 'Daily',
    grace_period_days INT DEFAULT 0,
    minimum_credit_score INT DEFAULT 50,
    required_documents TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    INDEX idx_tenant (tenant_id)
);

INSERT INTO loan_products (tenant_id, product_name, product_type, description, min_amount, max_amount, interest_rate, min_term_months, max_term_months, penalty_rate) VALUES
(1, 'Personal Loan - Standard', 'Personal Loan', 'General purpose personal loan', 5000.00, 50000.00, 2.5, 3, 24, 0.05),
(1, 'Business Loan - SME', 'Business Loan', 'Small and medium enterprise financing', 10000.00, 200000.00, 2.0, 6, 36, 0.05),
(1, 'Emergency Loan', 'Emergency Loan', 'Quick disbursement for urgent needs', 3000.00, 20000.00, 3.0, 1, 12, 0.10),
(2, 'Personal Loan - Standard', 'Personal Loan', 'General purpose personal loan', 2000.00, 30000.00, 3.0, 1, 12, 0.05),
(2, 'Business Loan', 'Business Loan', 'Business capital loan', 5000.00, 100000.00, 2.5, 3, 24, 0.05),
(3, 'Personal Loan', 'Personal Loan', 'Member personal loan', 1000.00, 20000.00, 2.0, 1, 12, 0.05),
(3, 'Emergency Loan', 'Emergency Loan', 'Emergency member loan', 500.00, 5000.00, 1.5, 1, 6, 0.05);

-- ============================================================
-- TABLE 11: loan_applications
-- ============================================================
CREATE TABLE IF NOT EXISTS loan_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    application_number VARCHAR(50) UNIQUE NOT NULL,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    product_id INT NOT NULL,
    requested_amount DECIMAL(12, 2) NOT NULL,
    approved_amount DECIMAL(12, 2),
    loan_term_months INT NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    loan_purpose TEXT,
    application_data JSON,
    application_status ENUM(
        'Draft', 'Submitted', 'Pending', 'Under Review',
        'Document Verification', 'Credit Investigation',
        'For Approval', 'Approved', 'Rejected', 'Cancelled', 'Withdrawn'
    ) DEFAULT 'Draft',
    submitted_date DATETIME,
    reviewed_by INT,
    review_date DATETIME,
    review_notes TEXT,
    approved_by INT,
    approval_date DATETIME,
    approval_notes TEXT,
    rejected_by INT,
    rejection_date DATETIME,
    rejection_reason TEXT,
    has_comaker BOOLEAN DEFAULT FALSE,
    comaker_name VARCHAR(150),
    comaker_relationship VARCHAR(50),
    comaker_contact VARCHAR(20),
    comaker_address TEXT,
    comaker_income DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (product_id) REFERENCES loan_products(product_id),
    FOREIGN KEY (reviewed_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (rejected_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 12: application_documents
-- ============================================================
CREATE TABLE IF NOT EXISTS application_documents (
    app_document_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    tenant_id INT NOT NULL,
    document_type_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES loan_applications(application_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (document_type_id) REFERENCES document_types(document_type_id),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 13: loans
-- ============================================================
CREATE TABLE IF NOT EXISTS loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_number VARCHAR(50) UNIQUE NOT NULL,
    application_id INT NOT NULL,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    product_id INT NOT NULL,
    principal_amount DECIMAL(12, 2) NOT NULL,
    interest_amount DECIMAL(12, 2) NOT NULL,
    total_loan_amount DECIMAL(12, 2) NOT NULL,
    processing_fee DECIMAL(10, 2) DEFAULT 0,
    service_charge DECIMAL(10, 2) DEFAULT 0,
    documentary_stamp DECIMAL(10, 2) DEFAULT 0,
    insurance_fee DECIMAL(10, 2) DEFAULT 0,
    other_charges DECIMAL(10, 2) DEFAULT 0,
    total_deductions DECIMAL(12, 2) DEFAULT 0,
    net_proceeds DECIMAL(12, 2) DEFAULT 0,
    interest_rate DECIMAL(5, 2) NOT NULL,
    loan_term_months INT NOT NULL,
    monthly_amortization DECIMAL(12, 2) NOT NULL,
    payment_frequency ENUM('Daily', 'Weekly', 'Bi-Weekly', 'Monthly') DEFAULT 'Monthly',
    number_of_payments INT NOT NULL,
    release_date DATE NOT NULL,
    first_payment_date DATE NOT NULL,
    maturity_date DATE NOT NULL,
    loan_status ENUM('Active', 'Fully Paid', 'Overdue', 'Restructured', 'Written Off', 'Cancelled') DEFAULT 'Active',
    released_by INT NOT NULL,
    disbursement_method ENUM('Cash', 'Check', 'Bank Transfer', 'GCash') DEFAULT 'Cash',
    disbursement_reference VARCHAR(100),
    total_paid DECIMAL(12, 2) DEFAULT 0,
    principal_paid DECIMAL(12, 2) DEFAULT 0,
    interest_paid DECIMAL(12, 2) DEFAULT 0,
    penalty_paid DECIMAL(12, 2) DEFAULT 0,
    remaining_balance DECIMAL(12, 2),
    outstanding_principal DECIMAL(12, 2),
    outstanding_interest DECIMAL(12, 2),
    outstanding_penalty DECIMAL(12, 2) DEFAULT 0,
    last_payment_date DATE,
    next_payment_due DATE,
    days_overdue INT DEFAULT 0,
    loan_agreement_file VARCHAR(255),
    promissory_note_file VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES loan_applications(application_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (product_id) REFERENCES loan_products(product_id),
    FOREIGN KEY (released_by) REFERENCES employees(employee_id),
    INDEX idx_tenant (tenant_id),
    INDEX idx_tenant_client (tenant_id, client_id)
);

-- ============================================================
-- TABLE 14: payments
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_reference VARCHAR(50) UNIQUE NOT NULL,
    loan_id INT NOT NULL,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(12, 2) NOT NULL,
    principal_paid DECIMAL(12, 2) NOT NULL,
    interest_paid DECIMAL(12, 2) NOT NULL,
    penalty_paid DECIMAL(12, 2) DEFAULT 0,
    advance_payment DECIMAL(12, 2) DEFAULT 0,
    payment_method ENUM('Cash', 'Check', 'Bank Transfer', 'GCash', 'Online Payment') NOT NULL,
    payment_reference_number VARCHAR(100),
    bank_name VARCHAR(100),
    check_number VARCHAR(50),
    check_date DATE,
    official_receipt_number VARCHAR(50),
    receipt_file VARCHAR(255),
    received_by INT NOT NULL,
    posted_by INT,
    posted_date DATETIME,
    payment_status ENUM('Pending', 'Posted', 'Verified', 'Cancelled', 'Bounced') DEFAULT 'Pending',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (received_by) REFERENCES employees(employee_id),
    FOREIGN KEY (posted_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    INDEX idx_tenant (tenant_id),
    INDEX idx_tenant_client (tenant_id, client_id)
);

-- ============================================================
-- TABLE 15: payment_transactions (Paymongo/GCash)
-- ============================================================
CREATE TABLE IF NOT EXISTS payment_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_ref VARCHAR(100) UNIQUE NOT NULL,
    client_id INT NOT NULL,
    loan_id INT NOT NULL,
    tenant_id INT NOT NULL,
    source_id VARCHAR(255) NULL COMMENT 'Payment gateway source ID',
    amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('PayMongo', 'GCash', 'Cash', 'Bank Transfer', 'Check') NOT NULL,
    payment_type ENUM('regular', 'early_settlement') DEFAULT 'regular',
    status ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'pending',
    payment_date DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    INDEX idx_transaction_ref (transaction_ref),
    INDEX idx_client_loan (client_id, loan_id),
    INDEX idx_status (status),
    INDEX idx_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE 16: notifications
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tenant_id INT NOT NULL,
    notification_type ENUM(
        'Payment Due', 'Payment Received', 'Loan Approved', 'Loan Rejected',
        'Document Required', 'Appointment Reminder', 'Message Received',
        'System Alert', 'General'
    ) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    link VARCHAR(255),
    is_read BOOLEAN DEFAULT FALSE,
    read_at DATETIME,
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 17: system_settings (Per-tenant)
-- ============================================================
CREATE TABLE IF NOT EXISTS system_settings (
    setting_id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_category VARCHAR(50),
    description TEXT,
    data_type ENUM('String', 'Number', 'Boolean', 'JSON') DEFAULT 'String',
    is_editable BOOLEAN DEFAULT TRUE,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (updated_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    UNIQUE KEY uq_tenant_key (tenant_id, setting_key),
    INDEX idx_tenant (tenant_id)
);

INSERT INTO system_settings (tenant_id, setting_key, setting_value, setting_category, description, data_type) VALUES
(1, 'company_name', 'Fundline Micro Financing - Marilao', 'Company', 'Company name', 'String'),
(1, 'company_address', 'Marilao, Bulacan', 'Company', 'Company address', 'String'),
(1, 'max_loan_amount', '500000', 'Loan', 'Maximum loan amount', 'Number'),
(2, 'company_name', 'Plaridel MicroFin', 'Company', 'Company name', 'String'),
(2, 'company_address', 'Plaridel, Bulacan', 'Company', 'Company address', 'String'),
(2, 'max_loan_amount', '100000', 'Loan', 'Maximum loan amount', 'Number'),
(3, 'company_name', 'Sacred Heart Cooperative', 'Company', 'Company name', 'String'),
(3, 'company_address', 'Bulacan, Philippines', 'Company', 'Company address', 'String'),
(3, 'max_loan_amount', '50000', 'Loan', 'Maximum loan amount', 'Number');

-- ============================================================
-- TABLE 18: credit_investigations
-- ============================================================
CREATE TABLE IF NOT EXISTS credit_investigations (
    ci_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    conducted_by INT NOT NULL,
    investigation_date DATE NOT NULL,
    business_exists BOOLEAN,
    business_location_verified BOOLEAN,
    business_operational BOOLEAN,
    business_notes TEXT,
    character_rating ENUM('Excellent', 'Good', 'Fair', 'Poor'),
    reputation_notes TEXT,
    income_verified BOOLEAN,
    assets_verified BOOLEAN,
    existing_obligations TEXT,
    references_contacted BOOLEAN,
    references_feedback TEXT,
    recommendation ENUM('Highly Recommended', 'Recommended', 'Conditional', 'Not Recommended'),
    investigation_remarks TEXT,
    ci_report_file VARCHAR(255),
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    completed_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (conducted_by) REFERENCES employees(employee_id),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 19: credit_scores
-- ============================================================
CREATE TABLE IF NOT EXISTS credit_scores (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    tenant_id INT NOT NULL,
    ci_id INT,
    income_score INT DEFAULT 0,
    employment_score INT DEFAULT 0,
    credit_history_score INT DEFAULT 0,
    collateral_score INT DEFAULT 0,
    character_score INT DEFAULT 0,
    business_score INT DEFAULT 0,
    total_score INT DEFAULT 0,
    credit_rating ENUM('Excellent', 'Good', 'Fair', 'Poor', 'High Risk'),
    max_loan_amount DECIMAL(12, 2),
    recommended_interest_rate DECIMAL(5, 2),
    computed_by INT,
    computation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (ci_id) REFERENCES credit_investigations(ci_id) ON DELETE SET NULL,
    FOREIGN KEY (computed_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 20: amortization_schedule
-- ============================================================
CREATE TABLE IF NOT EXISTS amortization_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    tenant_id INT NOT NULL,
    payment_number INT NOT NULL,
    due_date DATE NOT NULL,
    beginning_balance DECIMAL(12, 2) NOT NULL,
    principal_amount DECIMAL(12, 2) NOT NULL,
    interest_amount DECIMAL(12, 2) NOT NULL,
    total_payment DECIMAL(12, 2) NOT NULL,
    ending_balance DECIMAL(12, 2) NOT NULL,
    payment_status ENUM('Pending', 'Paid', 'Overdue', 'Partially Paid') DEFAULT 'Pending',
    amount_paid DECIMAL(12, 2) DEFAULT 0,
    payment_date DATE,
    days_late INT DEFAULT 0,
    penalty_amount DECIMAL(10, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- TABLE 21: chat_messages
-- ============================================================
CREATE TABLE IF NOT EXISTS chat_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    tenant_id INT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    INDEX idx_tenant (tenant_id)
);

-- ============================================================
-- DEFAULT ADMIN ACCOUNTS (one per tenant)
-- Password for all: 'password' (bcrypt hash)
-- ============================================================
-- Tenant 1: Fundline
INSERT INTO users (tenant_id, username, email, password_hash, role_id, user_type, status, email_verified) VALUES
(1, 'admin_fundline', 'admin@fundline.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'Employee', 'Active', TRUE);

INSERT INTO employees (user_id, tenant_id, employee_code, first_name, last_name, department, position, contact_number, hire_date) VALUES
(LAST_INSERT_ID(), 1, 'EMP-FL-001', 'Fundline', 'Administrator', 'Admin', 'System Administrator', '09000000000', CURRENT_DATE);

-- Tenant 2: PlaridelMicroFin
INSERT INTO users (tenant_id, username, email, password_hash, role_id, user_type, status, email_verified) VALUES
(2, 'admin_plaridel', 'admin@plaridel.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'Employee', 'Active', TRUE);

INSERT INTO employees (user_id, tenant_id, employee_code, first_name, last_name, department, position, contact_number, hire_date) VALUES
(LAST_INSERT_ID(), 2, 'EMP-PM-001', 'Plaridel', 'Administrator', 'Admin', 'System Administrator', '09111111111', CURRENT_DATE);

-- Tenant 3: Sacred Heart Coop
INSERT INTO users (tenant_id, username, email, password_hash, role_id, user_type, status, email_verified) VALUES
(3, 'admin_sacredheart', 'admin@sacredheart.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'Employee', 'Active', TRUE);

INSERT INTO employees (user_id, tenant_id, employee_code, first_name, last_name, department, position, contact_number, hire_date) VALUES
(LAST_INSERT_ID(), 3, 'EMP-SH-001', 'SacredHeart', 'Administrator', 'Admin', 'System Administrator', '09222222222', CURRENT_DATE);
