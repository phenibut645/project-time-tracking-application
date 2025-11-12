<?php
$xmlFile = "../data/sample_reports.xml";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $aruandeId = $_POST['aruandeId'];
    $xml = simplexml_load_file($xmlFile);

    $index = 0;
    foreach ($xml->report as $report) {
        if ((string)$report['aruandeId'] === $aruandeId) {
            unset($xml->report[$index]);
            break;
        }
        $index++;
    }

    $xml->asXML($xmlFile);
    header("Location: ../php/transform.php");
    exit;
}
?>
