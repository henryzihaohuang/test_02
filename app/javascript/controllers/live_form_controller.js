import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("liveFormController.apply", () => {
      this.apply();
    });
  };

  apply() {
    this.element.requestSubmit();
  };

  clearFilter(event) {
    const $checkboxes = event.currentTarget.parentElement.parentElement.querySelectorAll("input[type=\"checkbox\"]");
    const $textInputs = event.currentTarget.parentElement.parentElement.querySelectorAll("input[type=\"text\"]");

    $checkboxes.forEach($checkbox => $checkbox.checked = false);
    $textInputs.forEach($textInput => $textInput.value = "");

    this.apply();
  };

  clearAllFilters() {
    const $checkboxes = document.querySelectorAll("input[type=\"checkbox\"]");
    const $textInputs = document.querySelectorAll("input[type=\"text\"]");
    const $hiddenInputs = document.querySelectorAll("input[type=\"hidden\"]");

    $checkboxes.forEach($checkbox => $checkbox.checked = false);
    $textInputs.forEach(($textInput) => {
      if ($textInput.id !== "query") {
        $textInput.value = null;
      };
    });
    $hiddenInputs.forEach($hiddenInput => $hiddenInput.remove());

    this.apply();
  };
};