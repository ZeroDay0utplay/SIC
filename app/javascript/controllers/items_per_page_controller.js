import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    const url = new URL(window.location.href)
    url.searchParams.set('items', event.target.value)
    Turbo.visit(url.toString())
  }
}
