const statusMessage = document.querySelector("#status-message")

// Convert the index for a team received by the server to the name
function getTeamName(index) {
    if (index == 0) {
        return "Blue"
    } else {
        return "Red"
    }
}

window.addEventListener("DOMContentLoaded", (_) => {
    console.log("Connected")
    statusMessage.innerHTML = "Connecting to Push Over.."

    // Connect to the server
    const hostName = "http://localhost:8080" // TODO: Get the actual URL in the browser
    const socket = new WebSocket(hostName + "/api/connect")

    // Send a test packet when the connection is opened
    socket.addEventListener("open", (e) => {
        // Send a test event
        const packet = JSON.stringify(["test", { "hello": "world", }])
        socket.send(packet)
    });

    // Listten for future events
    socket.addEventListener("message", (msg) => {
        console.log(msg)
    })
})