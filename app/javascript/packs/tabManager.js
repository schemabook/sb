/**
 * Class for managing tabs
 */
export class TabManager {
  /**
   * Create a TabManager
   * @param {DOMElement} modalElement - The DOM Element to assign events to.
   */
  constructor(tabsElement) {
    this.tabsElement = tabsElement
  }

  /**
   * assign the event listeners
   */
  assignEvents() {
    this.tabsElement.querySelectorAll('.tab').forEach(item => {
      item.addEventListener('click', event => {
        console.log(item)
        console.log(event)
        //this.selectTab(event)
      })
    })
  }

  /**
   * renders the content for the selected tab
   */
  selectTab(event) {
    console.log(event)
    let tab = event.target.innerHTML

    console.log('selecting the tab: ' + tab)
  }
}
