import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { message: String }

  disable(event) {
    event.submitter.disabled = true
    event.submitter.textContent = this.messageValue
  }
}
