<?php
$xmlFile = '../data/sample_reports.xml';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $aruandeId = $_POST['aruandeId'] ?? '';

    if (!$aruandeId) {
        die('Missing aruandeId');
    }

    $xml = new DOMDocument();
    $xml->load($xmlFile);

    $xpath = new DOMXPath($xml);
    $report = $xpath->query("/reports/report[@aruandeId='$aruandeId']")->item(0);

    if (!$report) {
        die('Report not found');
    }

    if ($action === 'approve') {
        $report->setAttribute('kinnitusstaatus', 'confirmed');
    } elseif ($action === 'reject') {
        $report->setAttribute('kinnitusstaatus', 'rejected');
    } elseif ($action === 'delete') {
        $report->parentNode->removeChild($report);
    }

    $xml->save($xmlFile);

    header('Location: ../php/transform.php');
    exit;
}
