<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $projectName = trim($_POST['projectName'] ?? '');
    $featureName = trim($_POST['featureName'] ?? '');
    $taskName = trim($_POST['taskName'] ?? '');

    if ($projectName === '' || $featureName === '' || $taskName === '') die('Missing fields');

    $xml = simplexml_load_file($xmlFile);

    $projectId = uniqid('p');
    $featureId = uniqid('f');
    $taskId = uniqid('t');

    $project = $xml->projects->addChild('project');
    $project->addAttribute('id', $projectId);
    $project->addAttribute('name', $projectName);

    $feature = $project->addChild('feature');
    $feature->addAttribute('id', $featureId);
    $feature->addAttribute('name', $featureName);

    $task = $feature->addChild('task');
    $task->addAttribute('id', $taskId);
    $task->addAttribute('name', $taskName);

    $xml->asXML($xmlFile);

    header('Location: ../php/transform.php?page=projects');
    exit;
}
