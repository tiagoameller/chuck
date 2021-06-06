import { QuestionsDatatable } from "datatables/questions"
import CommonController from "controllers/shared/common_controller"
export default class QuestionsIndex extends ApplicationController {
  static targets = [
    "radioByCategory",
    "radioByWord",
    "radioByRandom",
    "textByWord",
    "selectByCategory"
  ]

  connect () {
    this.datatable = new QuestionsDatatable()
    // making a request to early raises "self.postMessage is not a function", so do some delay
    setTimeout(() => {
      this.fillCategorySelect()
    }, 500);
  }

  fillCategorySelect () {
    self = this
    const url = this.selectByCategoryTarget.getAttribute('data-categories-url')
    const request = new XMLHttpRequest()
    request.error = () => self.loadCategoriesError()
    request.onload = (result) => {
      const data = JSON.parse(request.responseText)
      if (!Array.isArray(data)) {
        self.loadCategoriesError()
        return
      }

      this.selectByCategoryTarget.length = 0
      let option
      data.forEach((category) => {
        option = document.createElement("option")
        option.text = category
        this.selectByCategoryTarget.add(option)
      })
    }
    request.open("GET", url)
    request.send()
  }

  loadCategoriesError () {
    new CommonController().toast("Error", "Failed to retrieve categories", "error")
  }

  selectByWord () {
    this.radioByWordTarget.checked = true
  }

  selectByCategory () {
    this.radioByCategoryTarget.checked = true
  }

  reset () {
    this.radioByCategoryTarget.checked = true
    this.fillCategorySelect()
    this.selectByCategoryTarget.selectedIndex = 0
    this.textByWordTarget.value = ""
  }
}