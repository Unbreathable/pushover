import type { GameState } from "../../main";

export class IngameState implements GameState {
start(): void {
    console.log("Ingame started");
}

end(): void {
    console.log("Ingame ended");
}

handleEvent(event: string): void {}
}