// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import { TabManager } from './tabManager'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", function(event) {
  //try {
  //  const tabs = document.querySelector('nav[data-role=tabs]')

  //  if (tabs != null) {
  //    const tabManager = new TabManager(tabs)
  //    tabManager.assignEvents()
  //  }
  //} catch (error) {
  //  console.log(error)
  //  // TODO: alert on error to create tabs
  //}

  try {
    var elem = document.querySelector('.dismiss');
    elem.addEventListener('click', function() {
      var closestElement = elem.closest('.flash');
      closestElement.parentNode.removeChild(closestElement);
    })
  } catch (error) {
    console.log(error)
  }

  try {
    const element = document.querySelector("#new-newsletter");

    element.addEventListener("ajax:success", (event) => {
      const [_data, _status, xhr] = event.detail;
      var elem = document.querySelector('#subscribe-message')
      elem.innerHTML = "Thanks! You'll hear from us soon.";
    });
    element.addEventListener("ajax:error", () => {
      var elem = document.querySelector('#subscribe-message')
      elem.innerHTML = "Please enter a valid email address.";
    });
  } catch (error) {
    console.log(error)
  }
});
