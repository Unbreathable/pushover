<script lang="ts">
  import { onMount } from "svelte";
  import { LobbyState } from "./lib/lobby/lobby";
  import { IngameState } from "./lib/ingame/ingame";
  import type { GameState } from "./main";

  // Current state of the page
  let currentStatus = $state("Loading all resources..");
  let currentState = $state("lobby");

  // All game states
  let states: Record<string, GameState> = {
    lobby: new LobbyState(),
    ingame: new IngameState(),
  };

  // Convert the index for a team received by the server to the name
  function getTeamName(index: number) {
    if (index == 0) {
      return "Blue";
    } else {
      return "Red";
    }
  }

  onMount(() => {
    currentStatus = "Connecting to server...";

    // Connect to the server
    const hostName = "http://localhost:8080"; // TODO: Get the actual URL in the browser
    const socket = new WebSocket(hostName + "/api/connect");

    // Send a test packet when the connection is opened
    socket.addEventListener("open", (e) => {
      // Send a test event
      const packet = JSON.stringify(["test", { hello: "world" }]);
      socket.send(packet);
      currentStatus = "Waiting for lobby...";
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
      <p id="status-message" class="animate-pulse">
        {currentStatus}
      </p>
      <div class="flex flex-col items-center justify-center gap-2">
        <div>
          <button
            class="flex items-center justify-center bg-container border-2 border-border rounded-xl text-white p-3 cursor-pointer"
          >
            <span class="material-symbols" style="font-size: 40px;"
              >arrow_upward</span
            >
          </button>
        </div>
        <div class="flex items-center justify-center gap-2">
          <button
            class="flex items-center justify-center bg-container border-2 border-border rounded-xl text-white p-3 cursor-pointer"
          >
            <span class="material-symbols" style="font-size: 40px;"
              >arrow_back</span
            >
          </button>
          <button
            class="flex items-center justify-center bg-container border-2 border-border rounded-xl text-white p-3 cursor-pointer"
          >
            <span class="material-symbols" style="font-size: 40px;"
              >arrow_downward</span
            >
          </button>
          <button
            class="flex items-center justify-center bg-container border-2 border-border rounded-xl text-white p-3 cursor-pointer"
          >
            <span class="material-symbols" style="font-size: 40px;"
              >arrow_forward</span
            >
          </button>
        </div>
      </div>
    </div>
  </div>
</main>
