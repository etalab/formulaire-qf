import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reload(event) {
    if (event.persisted) window.location.reload()
  }
}
