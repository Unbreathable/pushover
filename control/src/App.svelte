<script lang="ts">
  import { onMount } from "svelte";

  let statusMessage: HTMLElement;

  // Convert the index for a team received by the server to the name
  function getTeamName(index: number) {
    if (index == 0) {
      return "Blue";
    } else {
      return "Red";
    }
  }

  onMount(() => {
    console.log("Connected");
    statusMessage.innerHTML = "Connecting to Push Over..";

    // Connect to the server
    const hostName = "http://localhost:8080"; // TODO: Get the actual URL in the browser
    const socket = new WebSocket(hostName + "/api/connect");

    // Send a test packet when the connection is opened
    socket.addEventListener("open", (e) => {
      // Send a test event
      const packet = JSON.stringify(["test", { hello: "world" }]);
      socket.send(packet);
    });

    // Listen for future events
    socket.addEventListener("message", (msg) => {
      console.log(msg);
    });
  });
</script>

<main>
  <div class="w-screen h-screen">
    <div
      class="flex justify-center items-center w-full h-full bg-background text-white text-xl leading-normal"
    >
      <p id="status-message" class="animate-pulse" bind:this={statusMessage}>
        Loading all resources..
      </p>
      <div class="flex flex-col items-center justify-center gap-2">
        <div>
          <button
            class="bg-container border-2 border-border text-white rounded-2xl p-2 cursor-pointer"
          >
            <span class="material-symbols text-6xl">arrow_upward</span>
          </button>
        </div>
        <div class="flex items-center justify-center gap-2">
          <button
            class="bg-container border-2 border-border text-white rounded-2xl p-2 cursor-pointer"
          >
            <span class="material-symbols text-6xl">arrow_back</span>
          </button>
          <button
            class="bg-container border-2 border-border text-white rounded-2xl p-2 cursor-pointer"
          >
            <span class="material-symbols text-6xl">arrow_downward</span>
          </button>
          <button
            class="bg-container border-2 border-border text-white rounded-2xl p-2 cursor-pointer"
          >
            <span class="material-symbols text-6xl">arrow_forward</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</main>
