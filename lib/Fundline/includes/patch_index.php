<?php
// patch_index.php - adds ?tenant= slug detection to index.php
// Run via CLI: php includes/patch_index.php

$f = file_get_contents('index.php');

// Add tenant detection to the PHP section at the top (after session_start)
$old_php = 'session_start();

// Redirect to dashboard if already logged in
if (isset($_SESSION[\'user_id\'])) {';

$new_php = 'session_start();

// =====================================================================
// TENANT DETECTION from ?tenant=slug URL parameter
// This allows PlaridelMicroFin and SacredHeartCoop to redirect here
// =====================================================================
require_once \'../config/db.php\';

$incoming_tenant_slug = trim(strip_tags($_GET[\'tenant\'] ?? \'\'));
$login_tenant_id = 1; // default Fundline
$login_tenant_name = \'Fundline Micro Financing\';
$login_tenant_color = \'#dc2626\';

if (!empty($incoming_tenant_slug)) {
    $ts = $conn->prepare("SELECT tenant_id, tenant_name, theme_primary_color FROM tenants WHERE tenant_slug = ? AND is_active = 1 LIMIT 1");
    $ts->bind_param("s", $incoming_tenant_slug);
    $ts->execute();
    $ts_row = $ts->get_result()->fetch_assoc();
    $ts->close();
    if ($ts_row) {
        $login_tenant_id = $ts_row[\'tenant_id\'];
        $login_tenant_name = $ts_row[\'tenant_name\'];
        $login_tenant_color = $ts_row[\'theme_primary_color\'];
        $_SESSION[\'pending_tenant_id\'] = $login_tenant_id;
    }
}

// Auto-open the login modal if coming from a tenant redirect
$auto_open_login = !empty($incoming_tenant_slug);
// =====================================================================

// Redirect to dashboard if already logged in
if (isset($_SESSION[\'user_id\'])) {';

$f = str_replace($old_php, $new_php, $f);

// 2. Add tenant color CSS variable injection to <head>
$css_insert = '<style id="tenant-override">
    :root { --color-primary: <?php echo htmlspecialchars($login_tenant_color); ?>; }
    .btn-primary, .text-primary, a.text-primary { color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; }
    .btn-primary { background-color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; border-color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; }
    .btn-outline-primary { color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; border-color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; }
    .btn-outline-primary:hover { background-color: <?php echo htmlspecialchars($login_tenant_color); ?> !important; color: white !important; }
</style>';

$f = str_replace("</head>\n<body>", $css_insert . "\n</head>\n<body>", $f);
$f = str_replace("</style>\n</head>\n<body>", "</style>\n" . $css_insert . "\n</head>\n<body>", $f);

// Actually insert it just before </head>
$f = str_replace(
    "    <!-- Fundline Design System -->\n    <link href=\"../assets/css/main_style.css\" rel=\"stylesheet\">",
    "    <!-- Fundline Design System -->\n    <link href=\"../assets/css/main_style.css\" rel=\"stylesheet\">\n    <?php if (\$login_tenant_id !== 1): ?>\n    <style>:root { --color-primary: <?php echo htmlspecialchars(\$login_tenant_color); ?>; }\n    .btn-primary { background-color: <?php echo htmlspecialchars(\$login_tenant_color); ?> !important; border-color: <?php echo htmlspecialchars(\$login_tenant_color); ?> !important; }\n    .btn-outline-primary { color: <?php echo htmlspecialchars(\$login_tenant_color); ?> !important; border-color: <?php echo htmlspecialchars(\$login_tenant_color); ?> !important; }\n    </style>\n    <?php endif; ?>",
    $f
);

// 3. Update the login modal title to show tenant name
$f = str_replace(
    '<h3 class="fw-bold mb-0 text-main">Welcome Back! 👋</h3>',
    '<h3 class="fw-bold mb-0 text-main">Welcome to <?php echo htmlspecialchars($login_tenant_name); ?> 👋</h3>' . "\n" .
    '                    <?php if ($login_tenant_id !== 1): ?><p class="text-muted small mb-0">You were redirected from the <?php echo htmlspecialchars($login_tenant_name); ?> portal</p><?php endif; ?>',
    $f
);

// 4. Inject hidden tenant_id field into the AJAX login form
$f = str_replace(
    '<form id="ajaxLoginForm" novalidate>',
    '<form id="ajaxLoginForm" novalidate>' . "\n" .
    '                        <input type="hidden" name="tenant_id" id="login_tenant_id_field" value="<?php echo $login_tenant_id; ?>">',
    $f
);

// 5. Add auto-open login modal script if coming from tenant redirect
$f = str_replace(
    "<!-- Bootstrap 5 JS -->",
    "<!-- Bootstrap 5 JS -->\n    <?php if (\$auto_open_login): ?>\n    <script>document.addEventListener('DOMContentLoaded', function() { setTimeout(function() { var loginModal = new bootstrap.Modal(document.getElementById('loginModal')); loginModal.show(); }, 400); }); </script>\n    <?php endif; ?>",
    $f
);

$ok = file_put_contents('index.php', $f);
echo $ok ? "✅ index.php patched successfully ($ok bytes written)\n" : "❌ Failed to write index.php\n";
