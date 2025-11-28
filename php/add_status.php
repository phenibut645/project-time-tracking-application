<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $statusName = trim($_POST['statusName'] ?? '');
    if ($statusName === '') die('Missing statusName');

    $xml = simplexml_load_file($xmlFile);
    $id = 's_' . uniqid();
    $status = $xml->statuses->addChild('status', htmlspecialchars($statusName));
    $status->addAttribute('id', $id);
    $xml->asXML($xmlFile);

    header('Location: ../php/transform.php?page=statuses');
    exit;
}
