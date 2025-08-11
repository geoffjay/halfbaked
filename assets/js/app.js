// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
// Sidenav toggle for main layout
window.addEventListener("DOMContentLoaded", () => {
  const toggleButtons = [
    document.getElementById("sidenav-toggle"),
    document.getElementById("sidenav-toggle-bottom")
  ].filter(Boolean)

  const toggle = () => {
    document.body.classList.toggle("sidenav-collapsed")
  }

  toggleButtons.forEach(btn => btn.addEventListener("click", toggle))

  // AI actions
  const csrftoken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
  const postJson = async (url, body) => {
    const res = await fetch(url, {
      method: "POST",
      headers: {"content-type": "application/json", "x-csrf-token": csrftoken},
      body: body ? JSON.stringify(body) : undefined
    })
    if (!res.ok) throw new Error("request failed")
    return res.json()
  }

  document.querySelectorAll("a[href*='/ai/summarize']").forEach(el => {
    el.addEventListener("click", async (e) => {
      e.preventDefault()
      try {
        const data = await postJson(el.getAttribute("href"))
        alert(`Summary:\n\n${data.summary}`)
      } catch (err) {
        alert("Pro plan required or request failed")
      }
    })
  })

  document.querySelectorAll("a[href*='/ai/complete']").forEach(el => {
    el.addEventListener("click", async (e) => {
      e.preventDefault()
      const promptText = prompt("Enter prompt text to complete:")
      if (!promptText) return
      const href = el.getAttribute("href")
      try {
        const data = await postJson(href, {prompt: promptText})
        alert(`Completion:\n\n${data.completion}`)
      } catch (err) {
        alert("Pro plan required or request failed")
      }
    })
  })
})
