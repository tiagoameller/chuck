import { DatatableInit } from "./init"
import { DEFAULT_OPTIONS } from "./init"
// import { DEFAULT_COLUMNDEFS } from "./init"

export class AnswersDatatable extends DatatableInit {
  // customize datatables for questions dataset
  constructor () {
    let columndefs = [
      {
        targets: [0],
        orderable: false
      }
    ]
    let options = Object.assign({}, DEFAULT_OPTIONS)
    options.ordering = false
    options.pageLength = 4
    options.lengthMenu = [[options.pageLength, -1], [options.pageLength, 'todas']]
    super("answers_table", columndefs, options)
  }
}

