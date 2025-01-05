<?php
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $dropdown = $_POST['dropdown'];

    if (!empty($name) && !empty($dropdown)) {
        $sql = "INSERT INTO items (name, dropdown) VALUES ('$name', '$dropdown')";
        if ($conn->query($sql) === TRUE) {
            echo "New record created successfully";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    } else {
        echo "Fields are empty!";
    }
}

$conn->close();
?>
