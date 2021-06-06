import { QuestionsDatatable } from "datatables/questions"
export default class QuestionsIndex extends ApplicationController {
  connect () {
    this.datatable = new QuestionsDatatable()
  }
}