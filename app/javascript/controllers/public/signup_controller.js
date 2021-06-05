export default class extends ApplicationController {
  acceptTerms (evt) {
    if (window.$(evt.target).is(":checked")) {
      this.submit.removeAttribute("disabled")
    } else {
      this.submit.setAttribute("disabled", true)
    }
  }

  get submit () {
    return this.targets.find("submit")
  }
}
