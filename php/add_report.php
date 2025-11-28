<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $reportId = trim($_POST['reportId'] ?? '');
    $userRef = $_POST['userRef'] ?? '';
    $statusRef = $_POST['statusRef'] ?? '';
    $departmentRef = $_POST['departmentRef'] ?? '';
    $projectRef = $_POST['projectRef'] ?? '';
    $featureRef = trim($_POST['featureRef'] ?? '');
    $taskRef = trim($_POST['taskRef'] ?? '');
    $hours = $_POST['hours'] ?? '';
    $date = $_POST['date'] ?? date('Y-m-d');
    $comment = $_POST['comment'] ?? '';

    if ($reportId === '' || $userRef === '' || $statusRef === '' || $projectRef === '' || $hours === '') {
        die('Missing required fields');
    }

    $xml = simplexml_load_file($xmlFile);

    foreach ($xml->reports->report as $r) {
        if ((string)$r['id'] === $reportId) {
            die('Report with this ID already exists');
        }
    }

    $report = $xml->reports->addChild('report');
    $report->addAttribute('id', $reportId);
    $report->addAttribute('userRef', $userRef);
    $report->addAttribute('statusRef', $statusRef);
    if ($departmentRef) $report->addAttribute('departmentRef', $departmentRef);
    $report->addAttribute('created', date('c'));

    $entries = $report->addChild('entries');
    $entry = $entries->addChild('entry');
    $entry->addAttribute('projectRef', $projectRef);
    if ($featureRef) $entry->addAttribute('featureRef', $featureRef);
    if ($taskRef) $entry->addAttribute('taskRef', $taskRef);

    $entry->addChild('hours', $hours);
    $entry->addChild('date', $date);
    $entry->addChild('comment', htmlspecialchars($comment));

    $xml->asXML($xmlFile);

    header('Location: ../php/transform.php?page=reports');
    exit;
}
