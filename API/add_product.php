<?php
include 'functions.php';

$result = array("success" => 0, "error" => 0);

if (
    isset($_POST['ProductName']) && 
    isset($_POST['Descriptions']) && 
    isset($_POST['CategoryID']) && 
    isset($_POST['Barcode']) && 
    isset($_POST['ExpiredDate']) && 
    isset($_POST['Qty']) && 
    isset($_POST['UnitPriceIn']) && 
    isset($_POST['UnitPriceOut'])
) {
    $productName = $_POST['ProductName'];
    $description = $_POST['Descriptions'];
    $categoryId = $_POST['CategoryID'];
    $barcode = $_POST['Barcode'];
    $expiredDate = $_POST['ExpiredDate'];
    $qty = $_POST['Qty'];
    $unitPriceIn = $_POST['UnitPriceIn'];
    $unitPriceOut = $_POST['UnitPriceOut'];

    // Fields and values for the insertion
    $fields = array("ProductName", "Descriptions", "CategoryID", "Barcode", "ExpiredDate", "Qty", "UnitPriceIn", "UnitPriceOut");
    $values = array($productName, $description, $categoryId, $barcode, $expiredDate, $qty, $unitPriceIn, $unitPriceOut);

    $func = new functions();
    $insert = $func->insert_data('tblproduct', $fields, $values);

    if ($insert == true) {
        $result["success"] = 1;
        $result["msg_success"] = "Product added successfully.";
        print json_encode($result);
    } else {
        $result["error"] = 2;
        $result["msg_error"] = "Failed to add the product. Please try again.";
        print json_encode($result);
    }
} else {
    $result["error"] = 1;
    $result["msg_error"] = "Access denied..";
    print json_encode($result);
}