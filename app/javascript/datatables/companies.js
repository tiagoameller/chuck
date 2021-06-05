import { DatatableInit } from "./init"
import { DEFAULT_OPTIONS as custom_options } from "./init"
import { DEFAULT_COLUMNDEFS as custom_columndefs } from "./init"

export class CompaniesDatatable extends DatatableInit {
  // customize datatables for companies dataset
  constructor () {
    custom_options.order = [[0, "asc"]]
    custom_options.rowID = (data) => data[data.length - 1].row_id

    custom_columndefs.push(
      {
        targets: [-1, -2, 5],
        orderable: false,
        searchable: false,
        className: "text-center"
      },
      {
        targets: [4],
        className: "text-center"
      }
    )

    super("companies_table")
  }
}

