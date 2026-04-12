package controllers

import (
	"html/template"
	"net/http"
)

// respondText writes a plain-text HTTP response with a status code.
func respondText(w http.ResponseWriter, status int, body string) {
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(status)
	_, _ = w.Write([]byte(body))
}

// respondBuggedOverride routes the HTMX response into the modal body and
// reopens the modal showing the "override_bugged_notice" partial.
// overrideName is a human-readable label, e.g. "Geth Juggernaut Heavy Melee".
// message is the body text shown in the popup; when empty a generic fallback is used.
// confirmURL is the endpoint the "Assign Anyway" button will POST to.
// spectreCardID is the HTML element ID of the card to swap on confirm.
func respondBuggedOverride(w http.ResponseWriter, tmpl *template.Template, overrideName, message, confirmURL, spectreCardID string) {
	if message == "" {
		message = overrideName + " has a known issue and will likely not work when assigned."
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Header().Set("HX-Retarget", "#modal-body")
	w.Header().Set("HX-Reswap", "innerHTML")
	w.Header().Set("HX-Trigger-After-Settle", "sp-reopen-modal")
	_ = tmpl.ExecuteTemplate(w, "override_bugged_notice", map[string]any{
		"OverrideName":    overrideName,
		"OverrideMessage": message,
		"ConfirmURL":      confirmURL,
		"SpectreCardID":   spectreCardID,
	})
}
