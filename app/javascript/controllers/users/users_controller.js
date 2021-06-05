/* eslint-disable camelcase */
import { Controller } from "stimulus"

export default class extends Controller {

  close_modal () {
    $(this.modal).modal("hide")
  }

  get modal () {
    return this.targets.find("modal")
  }
}
