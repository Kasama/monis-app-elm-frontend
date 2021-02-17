const colors = require('tailwindcss/colors')

module.exports = {
  theme: {
    colors: {
      primary: colors.warmGray[800],
      'primaryshade': colors.warmGray,
      complement: colors.blueGray[700],
      'complementshade': colors.blueGray,
      accent: colors.orange[400],
      'accentshade': colors.orange,
      bright: colors.gray[200],
      'brightshade': colors.gray,
      highlight: colors.fuchsia[600],
      'highlightshade': colors.fuchsia,
      ...colors
    },
    extend: {
      spacing: {
        '128': '32rem',
        '144': '36rem',
      },
      borderRadius: {
        '4xl': '2rem',
      },
      animation: {
        'spin-slow': 'attention 3s linear 1',
        attention: 'attention 0.8s ease-out 1'
      },
      keyframes: {
        attention: {
          '0%, 100%': {},
          '50%': {
            'background-color': colors.red[500]
          }
        }
      }
    }
  },
  variants: {
    extend: {
      borderColor: ['focus-visible'],
      opacity: ['disabled'],
    }
  }
}
