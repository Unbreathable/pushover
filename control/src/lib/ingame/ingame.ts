import type { GameState } from "../../main";
import type { Event } from "../events";

export class IngameState implements GameState {
    start(): void {
        console.log("Ingame started");
    }

    end(): void {
        console.log("Ingame ended");
    }

    handleEvent(event: Event): void {
        console.log("event received")
    }
}