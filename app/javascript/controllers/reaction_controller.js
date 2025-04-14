import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["emoji", "count"]

  connect() {
    // Initialize any necessary state
  }

  // Called when the reaction button is clicked
  animate() {
    // Add a burst animation class
    this.emojiTarget.classList.add("animate-burst")
    
    // Remove the animation class after it completes
    setTimeout(() => {
      this.emojiTarget.classList.remove("animate-burst")
    }, 500)
  }
} 