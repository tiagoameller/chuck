import { QuestionsDatatable } from "datatables/questions"
export default class QuestionsIndex extends ApplicationController {
  connect () {
    this.datatable = new QuestionsDatatable()
    // console.log('connecting questions')
  }
}