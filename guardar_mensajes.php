<?php
// Database connection (replace with your actual credentials)
$db = mysqli_connect('localhost', 'root', '', 'chatbot_mensajes');

 // Check connection errors (optional)
 if (!$db) {
    die("Connection failed: " . mysqli_connect_error());
  }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get POST data
    $mensaje_usuario = mysqli_real_escape_string($db, $_POST['user']);
    $respuesta_chatbot = mysqli_real_escape_string($db, $_POST['bot']);

    // Prepare SQL statement
    $sql = "INSERT INTO mensajes (mensaje_usuario, respuesta_chatbot) VALUES ('$mensaje_usuario', '$respuesta_chatbot')";

    // Execute SQL query
    if (mysqli_query($db, $sql)) {
        echo json_encode(["success" => true, "message" => "Message saved successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . mysqli_error($db)]);
    }

    // Close the database connection
    mysqli_close($db);
} else {
    echo json_encode(["success" => false, "message" => "No je pudo hacer el insert"]);
}
?>
