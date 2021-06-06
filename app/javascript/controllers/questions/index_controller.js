import { cibTheMighty } from "@coreui/icons"
import { QuestionsDatatable } from "datatables/questions"
export default class QuestionsIndex extends ApplicationController {
  static targets = ["radioByCategory", "radioByWord", "radioByRandom", "textByWord"]

  connect () {
    this.datatable = new QuestionsDatatable()
  }

  selectByWord () {
    this.radioByWordTarget.checked = true
  }

  selectByCategory () {
    this.radioByCategoryTarget.checked = true
  }

  reset () {
    this.radioByCategoryTarget.checked = true
    this.textByWordTarget.value = ""
  }
}