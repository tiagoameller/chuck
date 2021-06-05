import { Controller } from "stimulus"
import { ClassWatcher } from "libraries/class-watcher"
import { activateTooltips, activatePopovers } from "libraries/data-toggles"
import Rails from "@rails/ujs"

export default class extends Controller {
  connect () {
    // data-target not working here?
    new ClassWatcher(
      document.getElementById("audit-sidebar"),
      "c-sidebar-show",
      this.lastAudits,
      this.lastAudits
    )
  }

  lastAudits () {
    if (this.righ_panel_showing) {
      this.righ_panel_showing = false
      return
    }

    Rails.ajax({
      url: $("#last_audits_list").data("url"),
      type: "get",
      dataType: "json",
      error: (_jqXHR, textStatus, errorThrown) => App.common_controller.toast(`AJAX Error: ${textStatus}`, errorThrown || "Lost connection to server", "error"),
      success: (data, _textStatus, _jqXHR) => {
        var result = "<div>"

        if (data.audits.data.length === 0) {
          result += `
           <div class='list-group-item list-group-item-accent-danger list-group-item-divider'>
           ${data.audits.literals.no_actitiy}
           </div>
        `
        } else {
          data.audits.data.forEach(audit => {
            // TODO: better display of audited_changes
            const changes = App.common_controller.syntaxHighlight(audit.audited_changes).replace(/"/g, "&quot;")
            result += `
            <div class='list-group-item list-group-item-accent-${audit.action_class} list-group-item-divider'>
            <div class='d-block'>${audit.auditable_full_name}</div>
            <small class='text-muted'>${audit.action}</small>
            <p class='mb-0'>
            <button type="button" class="btn btn-secondary btn-sm"
              data-toggle="popover"
              title="${window.I18n.t("frontend.common.summary")}"
              data-html="true"
              data-content="<pre>${changes}</pre>"
              data-placement="left"
              data-trigger="focus"
              >${window.I18n.t("frontend.common.summary")}</button>
            <small class='text-muted float-right' data-toggle='c-tooltip' data-placement='top' title='${audit.when}'>
             ${audit.time_ago}</small>
            </p>
            </div>
           `
          })
        }
        result += "</div>"
        $("#last_audits_parent").html(result)
        activatePopovers()
        activateTooltips()
        this.righ_panel_showing = !this.righ_panel_showing
      }
    })
  }
}