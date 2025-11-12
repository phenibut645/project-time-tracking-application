<?php
header('Content-Type: application/json');
header('Content-Disposition: attachment; filename="reports.json"');

$xmlPath = __DIR__ . '/../data/sample_reports.xml';
if (!file_exists($xmlPath)) {
    echo json_encode(['error' => 'XML file not found']);
    exit;
}

$xml = simplexml_load_file($xmlPath);
$json = json_encode($xml, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

echo $json;
exit;
?>
