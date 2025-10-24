<?php 
include("php/query.php");
?>
<!doctype html>
<html lang="en">
  <head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  </head>
  <body>
        <div class="container">
            <a href="add.php" class="mb-2">Add category</a>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Image</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $query = $pdo->query("select * from categories");
                        $allCategories = $query->fetchAll(PDO::FETCH_ASSOC);
                        foreach($allCategories as $category){
                        ?>
                        <tr>
                            <td ><?php echo $category['id'] ?></td>
                            <td><?php echo $category['name'] ?></td>
                            <td><?php echo $category['des'] ?></td>
                            <td><img height="100px" src="images/<?php echo $category['image'] ?>" alt=""></td>
                            <td><td>
    <a href="editCategory.php?cId=<?php echo $category['id']?>" class="btn btn-primary btn-sm">Edit</a>
    <a href="deleteCategory.php?cId=<?php echo $category['id']?>" 
       class="btn btn-danger btn-sm"
       onclick="return confirm('Are you sure you want to delete this category?');">
       Delete
    </a>
</td>

                        </tr>
                        <?php
                        }
                        ?>
                    </tbody>
                </table>
        </div>
  </body>
</html>