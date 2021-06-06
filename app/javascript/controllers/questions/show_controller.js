import { AnswersDatatable } from "datatables/answers"
export default class AnswersShow extends ApplicationController {

  connect () {
    setTimeout(() => {
      this.datatable = new AnswersDatatable()
    }, 500);
  }
}
