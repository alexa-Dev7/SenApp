<?php
session_start();
$data = json_decode(file_get_contents("database.json"), true);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $username = $_POST["username"];
    $password = password_hash($_POST["password"], PASSWORD_BCRYPT);

    if ($_POST["action"] === "register") {
        $data["users"][$username] = $password;
        file_put_contents("database.json", json_encode($data, JSON_PRETTY_PRINT));
        $_SESSION["user"] = $username;
        header("Location: index.php");
    } elseif ($_POST["action"] === "login") {
        if (isset($data["users"][$username]) && password_verify($_POST["password"], $data["users"][$username])) {
            $_SESSION["user"] = $username;
            header("Location: index.php");
        } else {
            echo "Invalid credentials!";
        }
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <form method="POST">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit" name="action" value="login">Login</button>
        <button type="submit" name="action" value="register">Register</button>
    </form>
</body>
</html>
