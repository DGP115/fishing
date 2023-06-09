import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

// Connects to data-controller="catches-filter-form"
export default class extends Controller {
  connect() {
    console.log("connected", this.element);
  }

  initialize() {
    console.log("initialize", this.element);
    //  debounce works on a function we give it.
    //  In this case, we want to debounce the submit() action, so this.submit.bind(this)
    //  The second argument is the number of milli-seconds to wait before allowing
    //  the action to proceed.
    this.submit = debounce(this.submit.bind(this), 300)
  }

  disconnect() {
    console.log("disconnected", this.element);
  }

  submit() {
    // We want this controller to submit the filter/sort form contents
    // Since it is attached to the form, simply submit this element
    console.log("submit", this.element);
    this.element.requestSubmit();
  }
}
