<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
$jsonFile = __DIR__ . '/../data/reports.json';

$xml = simplexml_load_file($xmlFile);
$json = [];

foreach ($xml->report as $report) {
    $entry = [
        'aruandeId' => (string)$report['aruandeId'],
        'status' => (string)$report['kinnitusstaatus'],
        'user' => [
            'nimi' => (string)$report->kasutaja->nimi,
            'perekonnanimi' => (string)$report->kasutaja->perekonnanimi,
            'roll' => (string)$report->kasutaja['roll']
        ],
        'totalHours' => (float)array_sum((array)$report->xpath('.//hours'))
    ];
    $json[] = $entry;
}

file_put_contents($jsonFile, json_encode($json, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
echo "Andmed eksporditi edukalt faili reports.json";
