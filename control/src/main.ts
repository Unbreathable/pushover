import { mount } from 'svelte'
import './app.css'
import App from './App.svelte'

export interface GameState {
  start(): void
  end(): void
  handleEvent(event: string): void
}

const app = mount(App, {
  target: document.getElementById('app')!,
})

export default app
