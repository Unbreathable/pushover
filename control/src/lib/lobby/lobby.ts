import type { GameState } from "../../main";
import type { Event } from "../events";

export class LobbyState implements GameState {
  start(): void {
    console.log("Lobby started");
  }

  end(): void {
    console.log("Lobby ended");
  }

  handleEvent(event: Event): void {}
}