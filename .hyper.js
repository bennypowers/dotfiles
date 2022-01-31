// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

const fontFamily = [
  '"Hack Nerd Font"',
  '"FiraCode Nerd Font"',
  'Recursive',
  'Hack',
  'Fira Code',
  'Menlo',
  '"DejaVu Sans Mono"',
  'Consolas',
  '"Lucida Console"',
  'monospace',
].join(', ');

const recursive = `
    .xterm {
      font-family: ${fontFamily};
      font-feature-settings:
          "ss01",
          "ss02",
          "ss03",
          "ss04",
          "ss05",
          "ss06",
          "ss07",
          "ss08",
          "ss09",
          "ss10",
          "dlig";
      font-variation-settings:
        "MONO" 1,
        "CASL" 0,
        "CRSV" 0;
    }
`;

module.exports = {
  config: {
    // Choose either "stable" for receiving highly polished,
    // or "canary" for less polished but more frequent updates
    updateChannel: 'stable',

    // default font size in pixels for all tabs
    fontSize: 12,

    // font family with optional fallbacks
    // fontFamily: '"Operator Mono", "Fira Code", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
    fontFamily,

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    // cursorColor: 'rgba(248,28,229,0.8)',
    cursorColor: '#64FFDA',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'UNDERLINE',

    // set to true for blinking cursor
    cursorBlink: true,

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor: '#111111',

    // border color (window, tabs)
    borderColor: '#EC407A',

    // custom css to embed in the main window
    css: `
    .hyper_mainRounded {
      border-radius: 10px;
    }
    `,

    // custom css to embed in the terminal window
    termCss: '',


    // set to `true` (without backticks) if you're using a Linux setup that doesn't show native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: false,

    / set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: false,

    // custom padding (css format, i.e.: `top right bottom left`)
    // padding: '0',
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#212121',
      red: '#EF5350',
      green: '#66BB6A',
      yellow: '#FFEE58',
      blue: '#42A5F5',
      magenta: '#EC407A',
      cyan: '#26C6DA',
      white: '#FAFAFA',
      lightBlack: '#424242',
      lightRed: '#EF9A9A',
      lightGreen: '#9CCC65',
      lightYellow: '#FFF59D',
      lightBlue: '#29B6F6',
      lightMagenta: '#F48FB1',
      lightCyan: '#80DEEA',
      lightWhite: '#FFFFFF',
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // Powershell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: '/usr/local/bin/fish',

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: [
      '--login',
      '--init-command=tmux'
    ],

    // for environment variables
    env: {
      NODE_ENV: ''
    },

    // set to false for no bell
    bell: 'SOUND',

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false

    // if true, on right click selected text will be copied or pasted if no
    // selection is present (true by default on Windows)
    // quickEdit: true

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  // plugins: ["verminal", "hyper-material-theme"],
  plugins: ['hyperminimal', 'hyperlinks'],
  // plugins: [],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  }
};
