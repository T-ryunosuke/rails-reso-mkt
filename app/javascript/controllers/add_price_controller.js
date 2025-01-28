import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemName"];

  // 入力フィールドをリセット
  clearField(event) {
    this.itemNameTarget.value = "";
  }
}
