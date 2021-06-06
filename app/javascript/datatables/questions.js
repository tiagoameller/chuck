import { DatatableInit } from "./init"
import { DEFAULT_OPTIONS } from "./init"
// import { DEFAULT_COLUMNDEFS } from "./init"

export class QuestionsDatatable extends DatatableInit {
  // customize datatables for questions dataset
  constructor () {
    let columndefs = [
      {
        targets: [2],
        className: "text-center",
      },
      {
        targets: [-1],
        className: "text-right"
      }
    ]
    let options = Object.assign({}, DEFAULT_OPTIONS)
    options.order = [[2, "desc"]]
    super("questions_table", columndefs, options)
  }
}

