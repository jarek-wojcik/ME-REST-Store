package controllers

import "net/http"

// respondText writes a plain-text HTTP response with a status code.
func respondText(w http.ResponseWriter, status int, body string) {
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(status)
	_, _ = w.Write([]byte(body))
}
