export default class extends ApplicationController {
  setActive (evt) {
    window.jQuery.ajax({
      url: evt.target.getAttribute("data-url"),
      dataType: "json",
      type: "PATCH",
      data: { "user[active]": evt.target.checked == true ? "1" : "0" },
      success: (resultData) => {
        if (resultData.status === "error") {
          document.getElementById(`active_user_${resultData.id}`).checked = resultData.was
        }
        App.common_controller.toast(
          window.I18n.t("frontend.company.user_activation"),
          resultData.message,
          resultData.status
        )
      }
    })
  }
}
