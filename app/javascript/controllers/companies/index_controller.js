import { CompaniesDatatable } from "datatables/companies"
export default class CompaniesIndex extends ApplicationController {
  connect () {
    this.datatable = new CompaniesDatatable()
  }
}