import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  hide(event) {
    event.preventDefault();
    this.element.remove();
  }

  hideOnSubmit(event) {
    if (event.detail.success) {
      this.element.remove();
    }
  }

  // disconnect() {
  //   this.#modalTurboFrame.src = null;
  // }

  // private

  // get #modalTurboFrame() {
  //   return document.querySelector("turbo-frame[id='modal']");
  // }
}
