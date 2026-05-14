import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switch(event) {
    const targetLocale = event.currentTarget.dataset.locale

    if (!targetLocale || this.element.classList.contains(`locale-${targetLocale}`)) return

    event.preventDefault()
    this.element.classList.remove("locale-en", "locale-uk")
    this.element.classList.add(`locale-${targetLocale}`, "is-switching")

    window.setTimeout(() => {
      if (window.Turbo) {
        window.Turbo.visit(event.currentTarget.href, { action: "replace" })
      } else {
        window.location.assign(event.currentTarget.href)
      }
    }, 260)
  }
}
