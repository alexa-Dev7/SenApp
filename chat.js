let ws = new WebSocket("ws://localhost:9001");

ws.onmessage = (event) => {
    let chatBox = document.getElementById("chat-box");
    let data = JSON.parse(event.data);
    chatBox.innerHTML += `<p>${data.sender}: ${data.message}</p>`;
};

function sendMessage() {
    let message = document.getElementById("message").value;
    let sender = "<?php echo $_SESSION['user']; ?>";

    ws.send(JSON.stringify({action: "send", sender: sender, message: message}));
    document.getElementById("message").value = "";
}
