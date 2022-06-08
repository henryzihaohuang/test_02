import { Controller } from "stimulus";
import $ from "jquery";
import "moment";
import "daterangepicker";

export default class extends Controller {
  connect() {
    $("input[name=\"custom_date_range\"]").daterangepicker({
      opens: "left"
    }, function(start, end, label) {
      console.log("A new date selection was made: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
    });

    $("input[name=\"custom_date_range\"]").on("apply.daterangepicker", function() {
      const event = new Event("liveFormController.apply");

      document.dispatchEvent(event);
    });
  };
};