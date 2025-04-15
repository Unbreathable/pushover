import type { GameState } from "../../main";

export class LobbyState implements GameState {
  start(): void {
    console.log("Lobby started");
  }

  end(): void {
    console.log("Lobby ended");
  }

  handleEvent(event: string): void {}
}