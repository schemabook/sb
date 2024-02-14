// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
//import Turbolinks from "turbolinks"
import * as Turbo from "@hotwired/turbo"
import * as ActiveStorage from "@rails/activestorage"
import "./channels"
import { TabManager } from './packs/tabManager'

Rails.start()
//Turbolinks.start()
Turbo.start()
Turbo.session.drive = false
ActiveStorage.start()

console.log("Schemabook, just say hello!")

document.addEventListener("DOMContentLoaded", function(event) {
  // provides close flash message functionality
  try {
    var elem = document.querySelector('.dismiss');

    elem.addEventListener('click', function() {
      var closestElement = elem.closest('.flash');
      closestElement.parentNode.removeChild(closestElement);
    })
  } catch (error) {
    console.log(error)
  }

  // async subscribe to newsletter on public site
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

  // logic to async add new stakeholder to schema
  try {
    const element = document.querySelector("#new_stakeholder");

    element.addEventListener("ajax:success", (event) => {
      const [_data, _status, xhr] = event.detail;
      var elem = document.querySelector('#new-stakeholder')
      elem.setAttribute("disabled", null)

      var elem = document.getElementsByClassName('stakeholder-count')[0]
      var previousValue = parseInt(elem.innerText)
      elem.innerText = previousValue + 1

      var text = document.createTextNode("You are now listed as a stakeholder.");
      var tag = document.createElement("p");
      tag.setAttribute("id", "add-stakeholder-alert");
      tag.appendChild(text);

      var elem = document.getElementById('add-stakeholder');
      elem.appendChild(tag);
    });

    element.addEventListener("ajax:error", () => {
      var text = document.createTextNode("There was an error, please try again.");
      var tag = document.createElement("p");
      tag.setAttribute("id", "add-stakeholder-error");
      tag.appendChild(text);

      if (document.getElementById('add-stakeholder-error') == null) {
        var elem = document.querySelector('#add-stakeholder');
        elem.appendChild(tag);
      }
    });
  } catch (error) {
    console.log(error)
  }
});

// Stripe
// In production, this should check CSRF, and not pass the session ID.
// The customer ID for the portal should be pulled from the
// authenticated user on the server.
document.addEventListener('DOMContentLoaded', async () => {
  let searchParams = new URLSearchParams(window.location.search);
  if (searchParams.has('session_id')) {
    const session_id = searchParams.get('session_id');
    document.getElementById('session-id').setAttribute('value', session_id);
  }
});
