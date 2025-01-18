module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      keyframes: {
        flashFade: {
          "0%": { transform: "translateY(0px)", opacity: 1 },
          "70%": { transform: "translateY(0)", opacity: 1 },
          "90%": { transform: "translateY(-8px)", opacity: 0 },
          "100%": { transform: "translateY(-30px)", opacity: 0 }
        }
      },
      animation: {
        flash: "flashFade 4.0s forwards"
      }
    }
  }
}
