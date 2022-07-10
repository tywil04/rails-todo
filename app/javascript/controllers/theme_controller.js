import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["button"];

    initialize() {
        if (localStorage.getItem("dark_theme") === "true") {
            document.documentElement.classList.add("dark");
        }
        this.set_text();
    }

    toggle() {
        document.documentElement.classList.toggle("dark");
        localStorage.setItem("dark_theme", document.documentElement.classList.contains("dark"));
        this.set_text();
    }

    set_text() {
        this.buttonTarget.innerText = document.documentElement.classList.contains("dark") ? "To Light Mode": "To Dark Mode";
    }
}