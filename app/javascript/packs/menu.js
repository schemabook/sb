function runOnStart() {
	let menu = document.querySelector("#menu")
  menu.classList.add("hidden")

  let mainMenu = document.querySelector("#main-menu")
  mainMenu.addEventListener('click', () => {
    menu.classList.remove("hidden")
  })

  let closeBtn = document.querySelector("#close-menu")
  closeBtn.addEventListener('click', () => {
    menu.classList.add("hidden")
  })
}

if(document.readyState !== 'loading') {
  runOnStart();
} else {
  document.addEventListener('DOMContentLoaded', function () {
    runOnStart()
  });
}
