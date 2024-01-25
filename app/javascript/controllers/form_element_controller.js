// Connects to data-controller="form-element"
export default class extends Controller {
  static targets = ["submitbtn"]
  connect() {
    this.submitbtnTarget.hidden = true
  }

  remotesubmit() {
    this.submitbtnTarget.click()
  }
}
