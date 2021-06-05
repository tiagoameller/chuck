import { DatatableInit } from "./init"
import { DEFAULT_OPTIONS as custom_options } from "./init"
import { DEFAULT_COLUMNDEFS as custom_columndefs } from "./init"

export class UsersDatatable extends DatatableInit {
  // customize datatables for users dataset
  constructor () {
    custom_options.order = [[0, "asc"]]
    custom_options.rowID = (data) => data[data.length - 1].row_id

    custom_columndefs.push(
      {
        targets: [4],
        className: "text-center"
      },
      {
        targets: [-1, -2],
        orderable: false,
        searchable: false,
        className: "text-center"
      },
      {
        targets: [-3],
        searchable: false
      }
    )
    super("users_table")
  }
}

