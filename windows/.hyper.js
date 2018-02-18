module.exports = {
  config: {
    // Default font size in pixels for all tabs.
    fontSize: 14,

    // Font family with optional fallbacks.
    fontFamily: 'Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    // Terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk).
    cursorColor: '#fa6800', // Orange

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █.
    cursorShape: 'BLOCK',

    // Color of the text.
    foregroundColor: '#c5c8c6',

    // Terminal background color.
    backgroundColor: '#1d1f21',

    // Border color (window, tabs).
    borderColor: '#161719',

    // Custom css to embed in the main window.
    css: '',

    // Custom css to embed in the terminal window.
    termCSS: '',

    // Custom padding (css format, i.e.: `top right bottom left`).
    padding: '12px 14px',
    // padding: '0px',

    // Colors from https://github.com/atom/base16-tomorrow-dark-theme/blob/master/styles/colors.less
    colors: {
      black: '#1d1f21', // black
      red: '#cc6666', // red
      green: '#b5b84d', // green
      yellow: '#f0c674', // yellow
      blue: '#81a2be', // blue
      magenta: '#b294bb', // purple
      cyan: '#8abeb7', // cyan
      white: '#e0e0e0', // almost-white
      lightBlack: '#282a2e', // very-dark-gray
      lightRed: '#cc6666', // red
      lightGreen: '#b5bd68', // green
      lightYellow: '#f0c674', // yellow
      lightBlue: '#81a2be', // blue
      lightMagenta: '#b294bb', // purple
      lightCyan: '#8abeb7', // cyan
      lightWhite: '#ffffff' // white
    },

    // The shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default.
    shell: 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',

    // For setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used.
    shellArgs: [],

    // For environment variables.
    env: {},

    // Set to false for no bell.
    bell: 'SOUND',

    // If true, selected text will automatically be copied to the clipboard.
    copyOnSelect: false

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // A list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`.
  plugins: [
    'hyperterm-tabs'
  ],

  // In development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed.
  localPlugins: []
};
