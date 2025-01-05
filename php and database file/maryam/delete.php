<?php
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $ids = json_decode($_POST['ids'], true);

    if (!empty($ids)) {
        $idsString = implode(',', $ids);
        $sql = "DELETE FROM items WHERE id IN ($idsString)";
        if ($conn->query($sql) === TRUE) {
            echo "Records deleted successfully";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    } else {
        echo "No IDs provided!";
    }
}

$conn->close();
?>
