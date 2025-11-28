<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $aruandeId = $_POST['aruandeId'] ?? '';
    if (!$aruandeId) die('Missing aruandeId');

    $xml = simplexml_load_file($xmlFile);

    $index = 0;
    foreach ($xml->reports->report as $report) {
        if ((string)$report['id'] === $aruandeId) {
            unset($xml->reports->report[$index]);
            break;
        }
        $index++;
    }

    $xml->asXML($xmlFile);
    header("Location: ../php/transform.php?page=reports");
    exit;
}
