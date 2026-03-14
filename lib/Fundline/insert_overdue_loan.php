<?php
require_once 'config/db.php';

// Target Client: ID 2 (Jana User)
$client_id = 2; 

// 1. Insert Dummy Application
$app_num = 'APP-' . date('Ymd') . '-' . rand(1000, 9999);
$stmt_app = $conn->prepare("INSERT INTO loan_applications (application_number, client_id, product_id, requested_amount, loan_term_months, interest_rate, loan_purpose, application_status, submitted_date) VALUES (?, ?, 1, 5000, 6, 3.0, 'Historical Data', 'Approved', NOW())");
$stmt_app->bind_param("si", $app_num, $client_id);
if (!$stmt_app->execute()) {
    die("App Insert Failed: " . $stmt_app->error);
}
$application_id = $stmt_app->insert_id;
$stmt_app->close();

echo "Created Application ID: $application_id\n";

// 2. Insert Loan
$product_id = 1;
$principal = 5000.00;
$interest_rate = 3.00;
$term_months = 6;
$release_date = date('Y-m-d', strtotime('-45 days'));
$maturity_date = date('Y-m-d', strtotime('+135 days'));
$first_payment = date('Y-m-d', strtotime('-15 days'));
$next_payment = date('Y-m-d', strtotime('-15 days')); // Past due by 15 days

$interest_total = $principal * ($interest_rate / 100) * $term_months;
$total_loan = $principal + $interest_total;
$monthly_amort = $total_loan / $term_months;

$outstanding_principal = $principal;
$outstanding_interest = $interest_total;
$remaining_balance = $total_loan;
$penalty = $principal * 0.10; // 500.00

$loan_number = 'LN-' . date('Ymd') . '-' . rand(1000, 9999);

$sql = "INSERT INTO loans (
    loan_number, application_id, client_id, product_id,
    principal_amount, interest_amount, total_loan_amount,
    interest_rate, loan_term_months, monthly_amortization,
    payment_frequency, number_of_payments,
    release_date, first_payment_date, maturity_date,
    loan_status, released_by, disbursement_method,
    outstanding_principal, outstanding_interest, outstanding_penalty,
    remaining_balance, days_overdue, next_payment_due,
    created_at, updated_at
) VALUES (
    ?, ?, ?, ?,
    ?, ?, ?,
    ?, ?, ?,
    'Monthly', ?,
    ?, ?, ?,
    'Overdue', 1, 'Cash',
    ?, ?, ?,
    ?, 15, ?,
    NOW(), NOW()
)";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    die("Prepare failed: " . $conn->error);
}

// Bind: s i i i d d d d i d i s s s d d d d s
// 1 s loan_number
// 2 i application_id
// 3 i client_id
// 4 i product_id
// 5 d principal
// 6 d interest
// 7 d total
// 8 d rate
// 9 i term
// 10 d amort
// 11 i number_payments
// 12 s release
// 13 s first
// 14 s maturity
// 15 d out_principal
// 16 d out_interest
// 17 d penalty
// 18 d remaining
// 19 s next_payment

// Note: I added application_id at pos 2.
// Count: 19 params.

$stmt->bind_param("siiiddddidisssdddds", 
    $loan_number, $application_id, $client_id, $product_id,
    $principal, $interest_total, $total_loan,
    $interest_rate, $term_months, $monthly_amort,
    $term_months,
    $release_date, $first_payment, $maturity_date,
    $outstanding_principal, $outstanding_interest, $penalty,
    $remaining_balance, $next_payment
);

if ($stmt->execute()) {
    echo "Successfully inserted Past Due Loan for Client ID $client_id.\n";
    echo "Loan Number: $loan_number\n";
    echo "Penalty: $penalty\n";
} else {
    echo "Insert failed: " . $stmt->error . "\n";
}
?>
