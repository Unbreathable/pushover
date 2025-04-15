<script lang="ts">
  import { onMount, type Component } from "svelte";
  import { LobbyState } from "./lib/lobby/lobby";
  import { IngameState } from "./lib/ingame/ingame";
  import type { GameState } from "./main";
  import Lobby from "./lib/lobby/Lobby.svelte";
  import Ingame from "./lib/ingame/Ingame.svelte";
  import { Event } from "./lib/events";

  // Current state of the page
  let showStatus = $state(true);
  let finished = $state(false);
  let currentStatus = $state("Loading all resources..");
  let currentState = $state("");

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
      currentStatus = "Waiting for the server...";
      showStatus = true;
    });

    // Show a rejoin message when the connection closes
    socket.addEventListener("close", () => {
      showStatus = true;
      finished = true;
      currentStatus =
        "Connection failed. Please try again when the game is in the Lobby state.";
    });

    // Show an error
    socket.addEventListener("error", (e) => {
      showStatus = true;
      finished = true;
      currentStatus =
        "Connection failed. Please try again when the game is in the Lobby state.";
    });

    // Listen for future events
    socket.addEventListener("message", (msg) => {
      if (msg.data) {
        console.log(msg.data);
        try {
          const event = Event.fromJson(msg.data);
          console.log("Parsed event:", event.name);

          // Handle state change in case it is one
          switch (event.name) {
            case "state_change":
              currentState = event.data;
              showStatus = false;
              return;

            case "init":
              return;
          }

          // Let the event be handled by a state in case there is one
          if (states[currentState]) {
            states[currentState].handleEvent(event);
          }
        } catch (error) {
          console.error("Failed to parse event:", error);
        }
      }
    });
  });
</script>

<main>
  <div class="w-screen h-screen">
    <div
      class="flex justify-center items-center w-full h-full bg-background text-white text-xl leading-normal"
    >
      <!-- Mount a status message notifying the user about the current status -->
      {#if !finished && showStatus}
        <p id="status-message" class="animate-pulse">
          {currentStatus}
        </p>
      {:else if showStatus}
        <p id="status-message" class="text-text">
          {currentStatus}
        </p>
      {/if}

      <!-- Mount the current component for the game state -->
      {#if currentState == "lobby"}
        <Lobby />
      {:else if currentState == "ingame"}
        <Ingame />
      {/if}
    </div>
  </div>
</main>
