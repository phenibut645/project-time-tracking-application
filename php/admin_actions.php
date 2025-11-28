<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $aruandeId = $_POST['aruandeId'] ?? '';

    if (!$aruandeId) {
        die('Missing aruandeId');
    }

    $xml = new DOMDocument();
    $xml->load($xmlFile);

    $xpath = new DOMXPath($xml);
    $report = $xpath->query("/database/reports/report[@id='$aruandeId']")->item(0);

    if (!$report) {
        die('Report not found');
    }

    if ($action === 'approve') {
        $statuses = $xpath->query("/database/statuses/status");
        $found = null;
        foreach ($statuses as $s) {
            if (trim($s->nodeValue) === 'confirmed') {
                $found = $s->getAttribute('id');
                break;
            }
        }
        if (!$found) {
            // создать новый статус
            $statusesParent = $xpath->query("/database/statuses")->item(0);
            $new = $xml->createElement('status', 'confirmed');
            $newId = 's_' . uniqid();
            $new->setAttribute('id', $newId);
            $statusesParent->appendChild($new);
            $found = $newId;
        }
        $report->setAttribute('statusRef', $found);
    } elseif ($action === 'reject') {
        $statuses = $xpath->query("/database/statuses/status");
        $found = null;
        foreach ($statuses as $s) {
            if (trim($s->nodeValue) === 'rejected') {
                $found = $s->getAttribute('id');
                break;
            }
        }
        if (!$found) {
            $statusesParent = $xpath->query("/database/statuses")->item(0);
            $new = $xml->createElement('status', 'rejected');
            $newId = 's_' . uniqid();
            $new->setAttribute('id', $newId);
            $statusesParent->appendChild($new);
            $found = $newId;
        }
        $report->setAttribute('statusRef', $found);
    } elseif ($action === 'delete') {
        $report->parentNode->removeChild($report);
    }

    $xml->save($xmlFile);

    header('Location: ../php/transform.php?page=reports');
    exit;
}
