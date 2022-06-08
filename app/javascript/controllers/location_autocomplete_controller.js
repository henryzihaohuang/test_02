import { Controller } from "stimulus";

// From https://github.com/facebook/react/issues/10135#issuecomment-500929024
function setReactInputValue(input, value) {
  const previousValue = input.value;

  input.value = value;

  const tracker = input._valueTracker;
  if (tracker) {
    tracker.setValue(previousValue);
  };

  input.dispatchEvent(new Event("change", { bubbles: true }));
}

export default class extends Controller {
  static targets = ["input"];

  connect() {
    // connect() should be called before google is defined aka Google Maps
    // finished loading. If google is defined at this point, it means that connect()
    // was called AFTER Google Maps finished loading which means the callback aka initMap
    // was already called with no one listening. Thus we have to call it manually.
    if (typeof (google) !== "undefined") {
      this.init();
    };
  };

  init() {
    const options = {
      types: ["(regions)"]
    };

    this.autocomplete = new google.maps.places.Autocomplete(this.inputTarget, options);

    google.maps.event.addListener(this.autocomplete, "place_changed", () => {
      const locationSelectedEvent = new Event("location-selected", { bubbles: true, cancelable: true });

      setReactInputValue(this.inputTarget, this.inputTarget.value.replace(", USA", ""));
      this.inputTarget.value = this.inputTarget.value.replace(", USA", "");

      this.inputTarget.dispatchEvent(locationSelectedEvent);
    });
  };
};