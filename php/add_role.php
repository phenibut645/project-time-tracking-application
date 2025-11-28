<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $roleName = trim($_POST['roleName'] ?? '');
    if ($roleName === '') die('Missing roleName');

    $xml = simplexml_load_file($xmlFile);
    $id = uniqid('r');
    $role = $xml->roles->addChild('role', htmlspecialchars($roleName));
    $role->addAttribute('id', $id);
    $xml->asXML($xmlFile);

    header('Location: ../php/transform.php?page=roles');
    exit;
}
