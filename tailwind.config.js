const colors = require('tailwindcss/colors')

module.exports = {
  theme: {
    extend: {
      colors: {
        teal: colors.teal,
        cyan: colors.cyan,
        nord0: '#2E3440',
        nord6: '#ECEFF4',
      }
    },
    gradientColorStops: theme => ({
       'primary': '#2E3440',
       'secondary': '#ffed4a',
       'danger': '#e3342f',
    })
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
  ]
}

