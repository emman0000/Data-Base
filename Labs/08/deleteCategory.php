<?php
include("php/query.php");

if (isset($_GET['cId'])) {
    $id = $_GET['cId'];

    // delete image if needed
    $stmt = $pdo->prepare("SELECT image FROM categories WHERE id = ?");
    $stmt->execute([$id]);
    $category = $stmt->fetch();

    if ($category && file_exists("images/" . $category['image'])) {
        unlink("images/" . $category['image']); // deletes the image file
    }

    // delete record from database
    $stmt = $pdo->prepare("DELETE FROM categories WHERE id = ?");
    $stmt->execute([$id]);
}

header("Location: index.php"); // go back to main page
exit;
?>
