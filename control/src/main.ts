import { mount } from 'svelte'
import './app.css'
import App from './App.svelte'
import type { Event } from './lib/events'

export interface GameState {
  start(): void
  end(): void
  handleEvent(event: Event): void
}

const app = mount(App, {
  target: document.getElementById('app')!,
})

export default app
