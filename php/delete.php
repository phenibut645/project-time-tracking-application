<?php
$type = $_GET['type'] ?? null;
$id = $_GET['id'] ?? null;

if (!$type || !$id) die("Missing parameters");

$xmlPath = __DIR__ . '/../data/sample_reports.xml';
$xml = simplexml_load_file($xmlPath);
if (!$xml) die("Failed to load XML file at: $xmlPath");

switch ($type) {

    case "user":
        // Проверяем, есть ли отчёты с этим пользователем
        $links = $xml->xpath("//reports/report[@userRef='$id']");
        if ($links && count($links) > 0) die("Cannot delete user: user is referenced by reports.");
        $nodes = $xml->xpath("//users/user[@id='$id']");
        break;

    case "role":
        $links = $xml->xpath("//users/user[@roleRef='$id']");
        if ($links && count($links) > 0) die("Cannot delete role: role is used by users.");
        $nodes = $xml->xpath("//roles/role[@id='$id']");
        break;

    case "status":
        $links = $xml->xpath("//reports/report[@statusRef='$id']");
        if ($links && count($links) > 0) die("Cannot delete status: status is used in reports.");
        $nodes = $xml->xpath("//statuses/status[@id='$id']");
        break;

    case "project":
        $links = $xml->xpath("//reports/report[@projectRef='$id']");
        if ($links && count($links) > 0) die("Cannot delete project: project has related reports.");
        $nodes = $xml->xpath("//projects/project[@id='$id']");
        break;

    default:
        die("Unknown type");
}

if ($nodes && count($nodes) > 0) {
    $node = $nodes[0];
    $domNode = dom_import_simplexml($node);
    $domNode->parentNode->removeChild($domNode);
}

$dom = dom_import_simplexml($xml)->ownerDocument;
$dom->formatOutput = true;
$dom->save($xmlPath);

header("Location: ../php/transform.php");
exit;
?>
