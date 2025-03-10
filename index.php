<?php
session_start();
if (!isset($_SESSION['user'])) {
    header("Location: auth.php");
    exit;
}
?>
<!DOCTYPE html>
<html>
<head>
    <title><? echo 'Sender - Connect, Share, Hangout!'?></title>
    <link rel="stylesheet" href="styles.css">
    <script src="chat.js"></script>
</head>
<body>
    <div class="chat-container">
        <h2>Welcome, <?php echo htmlspecialchars($_SESSION['user']); ?></h2>
        <div id="chat-box"></div>
        <form onsubmit="sendMessage(); return false;">
            <input type="text" id="message" placeholder="Type a message...">
            <button type="submit">Send</button>
        </form>
    </div>
</body>
</html>