import { UsersDatatable } from "datatables/users"
export default class UsersIndex extends ApplicationController {
  connect () {
    this.datatable = new UsersDatatable()
  }
}