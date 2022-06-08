// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start()

import "controllers"
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

window.init = function(...args) {
  const event = document.createEvent("Events");

  event.initEvent("google-maps-ready", true, true);

  event.args = args;

  window.dispatchEvent(event);
};

import TimeMe from "timeme.js";

import APIClient from "lib/APIClient";

if (!window.location.href.includes("/company/dashboard")) {
  TimeMe.initialize({
    idleTimeoutInSeconds: 30
  });

  window.addEventListener("beforeunload", function(event) {
    const authToken = document.getElementById("app-config").dataset.authToken;

    if (authToken) {
      APIClient.trackAppSession(authToken, TimeMe.getTimeOnCurrentPageInSeconds());
    };
  });
};