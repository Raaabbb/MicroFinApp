<?php
require_once 'config/db.php';

// Configuration
$client_id = 2; // Target Client
$principal = 5000.00;
$interest_rate_monthly = 3.00; // 3%
$term_months = 3;
$days_late = 6;
$product_id = 1; // Personal Loan

// Penalty Calculation (Method: 5% Monthly Pro-rated)
// 5% / 30 * 6 days = 1%
$penalty_rate_monthly = 0.05; // 5%
$daily_penalty_rate = $penalty_rate_monthly / 30;
$penalty_amount = $principal * $daily_penalty_rate * $days_late; // 5000 * 0.001666 * 6 = 50.00

echo "Calculated Penalty: " . $penalty_amount . "\n";

// Dates
$release_date = date('Y-m-d', strtotime("-".(90 + $days_late)." days")); // Released 3 months + 6 days ago
$maturity_date = date('Y-m-d', strtotime("-$days_late days")); // Matured 6 days ago

// 1. Insert Application
$app_num = 'APP-' . time() . '-' . rand(100,999);
$stmt = $conn->prepare("INSERT INTO loan_applications (application_number, client_id, product_id, requested_amount, loan_term_months, interest_rate, loan_purpose, application_status, submitted_date) VALUES (?, ?, ?, ?, ?, ?, 'Insertion Test', 'Approved', NOW())");
$stmt->bind_param("siiddd", $app_num, $client_id, $product_id, $principal, $term_months, $interest_rate_monthly);
if (!$stmt->execute()) die("App Insert Failed: " . $stmt->error);
$app_id = $stmt->insert_id;
$stmt->close();
echo "Application created: ID $app_id\n";

// 2. Insert Loan
$loan_num = 'LN-' . time() . '-' . rand(100,999);
$monthly_interest = $principal * ($interest_rate_monthly / 100);
$total_interest = $monthly_interest * $term_months;
$total_loan = $principal + $total_interest;
$monthly_amort = $total_loan / $term_months;

// Status
$outstanding_principal = $principal;
$outstanding_interest = $total_interest;
$remaining_balance = $total_loan + $penalty_amount;
$next_payment_due = date('Y-m-d', strtotime("-$days_late days")); // Due 6 days ago

$stmt = $conn->prepare("INSERT INTO loans (
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
    ?, ?, ?,
    NOW(), NOW()
)");

$first_payment_date = date('Y-m-d', strtotime($release_date . ' +1 month'));

$stmt->bind_param("siiiddddidisssddddis", 
    $loan_num, $app_id, $client_id, $product_id,
    $principal, $total_interest, $total_loan,
    $interest_rate_monthly, $term_months, $monthly_amort,
    $term_months,
    $release_date, $first_payment_date, $maturity_date,
    $outstanding_principal, $outstanding_interest, $penalty_amount,
    $remaining_balance, $days_late, $next_payment_due
);

if (!$stmt->execute()) die("Loan Insert Failed: " . $stmt->error);
$loan_id = $stmt->insert_id;
$stmt->close();
echo "Loan created: ID $loan_id ($loan_num)\n";

// 3. Insert Amortization Schedules
// Since it's overdue, all past schedules should likely be unpaid or overdue.
// We'll generate 3 schedules.
for ($i = 1; $i <= $term_months; $i++) {
    $due_date = date('Y-m-d', strtotime($release_date . " +$i month"));
    
    // Determine status of this schedule
    $status = 'Pending';
    $days_late_sched = 0;
    $penalty_sched = 0;
    
    // If due date is in the past
    if (strtotime($due_date) < time()) {
        $status = 'Overdue';
        // Only the last one or accumulated?
        // Let's set the last one as the one carrying the penalty or days late
        if ($i == $term_months) { // Matured one
             $days_late_sched = $days_late;
             $penalty_sched = $penalty_amount;
        }
    }
    
    $beg_bal = $total_loan - (($i-1) * $monthly_amort);
    $end_bal = $total_loan - ($i * $monthly_amort);
    
    $stmt = $conn->prepare("INSERT INTO amortization_schedule (
        loan_id, payment_number, due_date, 
        beginning_balance, principal_amount, interest_amount, total_payment, 
        ending_balance, payment_status, days_late, penalty_amount, created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
    
    $principal_part = $monthly_amort - $monthly_interest; // simplified equal amortization
    
    $stmt->bind_param("iisddddssid", 
        $loan_id, $i, $due_date,
        $beg_bal, $principal_part, $monthly_interest, $monthly_amort,
        $end_bal, $status, $days_late_sched, $penalty_sched
    );
    $stmt->execute();
    $stmt->close();
    echo "Schedule $i inserted ($status)\n";
}

echo "Done.\n";
?>
