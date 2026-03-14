<?php
/**
 * Tenant Branding Helper
 * Loads the current tenant's branding (logo, colors, name) from the database.
 * Call this after db.php is loaded and session is started.
 *
 * Usage:
 *   require_once '../config/db.php';
 *   require_once 'tenant_branding.php';
 *   // Then use $tenant_brand['name'], $tenant_brand['primary_color'], etc.
 */

function get_tenant_branding($conn, $tenant_id) {
    static $cache = [];
    if (isset($cache[$tenant_id])) return $cache[$tenant_id];

    $stmt = $conn->prepare("
        SELECT tenant_name, tenant_slug, logo_path, theme_primary_color, theme_secondary_color,
               company_address, company_contact, company_email
        FROM tenants WHERE tenant_id = ? AND is_active = 1
    ");
    $stmt->bind_param("i", $tenant_id);
    $stmt->execute();
    $result = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$result) {
        // Fallback to Fundline defaults
        $result = [
            'tenant_name'          => 'Fundline Micro Financing',
            'tenant_slug'          => 'fundline',
            'logo_path'            => null,
            'theme_primary_color'  => '#dc2626',
            'theme_secondary_color'=> '#991b1b',
            'company_address'      => 'Marilao, Bulacan',
            'company_contact'      => '',
            'company_email'        => '',
        ];
    }

    $cache[$tenant_id] = $result;
    return $result;
}

function get_tenant_css_vars($branding) {
    $primary   = htmlspecialchars($branding['theme_primary_color']);
    $secondary = htmlspecialchars($branding['theme_secondary_color']);
    return "
    <style>
        :root {
            --tenant-primary:   {$primary};
            --tenant-secondary: {$secondary};
            --color-primary:    {$primary} !important;
        }
        .tenant-primary-bg   { background-color: {$primary} !important; }
        .tenant-primary-text { color: {$primary} !important; }
        .tenant-primary-border { border-color: {$primary} !important; }
        .btn-primary, .stat-card.card-red {
            background: linear-gradient(135deg, {$primary} 0%, {$secondary} 100%) !important;
        }
        a.active-nav, .nav-link.active { color: {$primary} !important; }
    </style>
    ";
}

function render_tenant_logo($branding, $class = '') {
    $name = htmlspecialchars($branding['tenant_name']);
    if (!empty($branding['logo_path']) && file_exists('../' . $branding['logo_path'])) {
        return "<img src='../{$branding['logo_path']}' alt='" . $name . " Logo' class='{$class}' style='max-height:40px;'>";
    }
    // Fallback: text initials avatar
    $initials = strtoupper(substr($branding['tenant_name'], 0, 2));
    $color = htmlspecialchars($branding['theme_primary_color']);
    return "<div style='width:40px;height:40px;background:{$color};border-radius:8px;display:flex;align-items:center;justify-content:center;color:white;font-weight:bold;font-size:14px;flex-shrink:0;' title='{$name}'>{$initials}</div>";
}

// Auto-load branding for the current session tenant
$current_tenant_id = get_tenant_id();
$tenant_brand = get_tenant_branding($conn, $current_tenant_id);
$tenant_css   = get_tenant_css_vars($tenant_brand);
