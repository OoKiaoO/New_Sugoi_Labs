import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-in-list"
export default class extends Controller {
  static targets = ["amounts", "form"]
  
  
  connect() {
    console.log("hello from insert-in-list controller")
    console.log(this.amountsTarget)
    console.log(this.formTarget)
  }

  send(event) {
    event.preventDefault();

    fetch(this.formTarget.action, {
      method: "POST",
      headers: { "Accept": "application/json" },
      body: new FormData(this.formTarget)
    })
    .then(response => response.json())
    .then((data) => {
      console.log(data)
    })
  }
}
