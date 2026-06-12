config.load_autoconfig(False)

# rendering
c.qt.force_software_rendering = 'chromium'
c.qt.chromium.process_model = 'process-per-site'
c.qt.chromium.low_end_device_mode = 'always'

# statusbar
c.statusbar.show = 'in-mode'
c.statusbar.widgets = ['keypress', 'search_match', 'url', 'scroll', 'progress']
c.messages.timeout = 2000

# tab bar (toggleable)
c.tabs.show = 'never'
c.tabs.position = 'left'
c.tabs.width = '20%'
c.tabs.favicons.show = 'always'

# dark mode
c.colors.webpage.darkmode.enabled = True

# privacy
c.content.tls.certificate_errors = 'ask'
c.content.cookies.accept = 'no-3rdparty'
c.content.headers.do_not_track = True

# adblocking
c.content.blocking.method = 'adblock'
c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/experimental.txt'
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt',
    'https://filters.adtidy.org/extension/chromium/filters/4.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-cookies.txt'
]

# search engines
c.url.searchengines = {
    'DEFAULT': 'https://google.com/search?q={}',
    'goog': 'https://google.com/search?q={}',
    'brave': 'https://search.brave.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',

    'arch': 'https://wiki.archlinux.org/index.php?search={}',
    'pkg': 'https://archlinux.org/packages/?q={}',
    'aur': 'https://aur.archlinux.org/packages/?K={}',

    'pcgw': 'https://www.pcgamingwiki.com/w/index.php?search={}',
    'proton': 'https://www.protondb.com/search?q={}',

    'wiki': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
    'godot': 'https://docs.godotengine.org/en/stable/search.html?q={}',
    'rust': 'https://docs.rs/releases/search?query={}',
    'crates': 'https://crates.io/search?q={}',
    'godev': 'https://pkg.go.dev/search?q={}'
}

# misc
c.auto_save.session = True
c.url.start_pages = ['about:blank']
c.content.autoplay = False
c.scrolling.smooth = True


# ** keybinds **

# clear defaults
c.bindings.commands = {
    'normal': {},
    'insert': {},
    'command': {}
}

# essential
config.bind(':', 'cmd-set-text :') # opens command mode
config.bind('<Escape>', 'mode-leave', mode='insert')    # escape insert mode back to normal
config.bind('<Escape>', 'mode-leave', mode='command')   # close command bar safely

# page navigation
config.bind('[', 'back')
config.bind(']', 'forward')
config.bind('R', 'reload')

# scrolling
config.bind('<Up>', 'scroll up')
config.bind('<Down>', 'scroll down')
config.bind('<Left>', 'scroll left')
config.bind('<Right>', 'scroll right')

# bookmarks & history
config.bind('Shift-M', 'bookmark-add')
config.bind('b', 'cmd-set-text -s :bookmark-load')
config.bind('Shift-B', 'cmd-set-text -s :bookmark-load -t')
config.bind('h', 'cmd-set-text -s :history')
config.bind('Shift-h', 'cmd-set-text -s :history -t')


# tabs
config.bind('o', 'cmd-set-text -s :open')
config.bind('e', 'cmd-set-text -s :open {url:pretty}')
config.bind('<Ctrl-e>', 'cmd-set-text -s :open {url:pretty}')
config.bind('<Ctrl-t>', 'cmd-set-text -s :open -t')
config.bind('<Ctrl-Shift-p>', 'cmd-set-text -s :open -p')

config.bind('<Space><Space>', 'tab-focus last')
config.bind('<Ctrl-f>', 'cmd-set-text -s :tab-select')
config.bind('<Ctrl-`>', 'config-cycle tabs.show always never')

config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev')

config.bind('x', 'tab-close')
config.bind('<Ctrl-w>', 'tab-close')
config.bind('<Ctrl-z>', 'undo')

# windows
config.bind('<Ctrl-Shift-S>', 'window-clone')
config.bind('<Ctrl-Shift-W>', 'close')
config.bind('<Ctrl-Shift-Z>', 'undo -w')

# selection / search
config.bind('<Ctrl-a>', 'fake-key <Ctrl-a>')
config.bind('<Ctrl-d>', 'search {primary}')
config.bind('/', 'cmd-set-text /')

# clipboard
config.bind('<Ctrl-c>', 'fake-key <Ctrl-c>', mode='normal')
config.bind('<Ctrl-shift-c>', 'yank', mode='normal')

# hinting
config.bind('f', 'hint')
config.bind('Shift-F', 'hint all tab')

# insert mode
config.bind('a', 'mode-enter insert')
config.bind('s', 'mode-enter insert')

# video playback
config.bind('<Ctrl+/>', 'hint links spawn --detach mpv {hint-url}')


# ** theme **

# 🪐 colour scheme of theseus
thm_bg = '#181819'       # deep terminal bg
thm_panel = '#222427'    # menu / tab bar bg
thm_fg = '#CDCFD2'       # crisp primary foreground text
thm_muted = '#76787D'    # dark gray for inactive text / comments
thm_accent = '#EE7987'   # sharp accent pink/red
thm_green = '#82FBC6'    # selection accent green

# * statusbar *
c.colors.statusbar.normal.bg = thm_bg
c.colors.statusbar.normal.fg = thm_fg

c.colors.statusbar.insert.bg = thm_accent
c.colors.statusbar.insert.fg = thm_bg

c.colors.statusbar.command.bg = thm_panel
c.colors.statusbar.command.fg = thm_fg

# styling for https url text
c.colors.statusbar.url.success.https.fg = thm_green

# * command bar fuzzy completion *
c.colors.completion.odd.bg = thm_panel
c.colors.completion.even.bg = thm_bg

# foreground text settings
c.colors.completion.fg = thm_fg
c.colors.completion.category.fg = thm_accent
c.colors.completion.category.bg = thm_panel
c.colors.completion.item.selected.fg = thm_bg

# highlight color for the row currently hovering/fuzzing through
c.colors.completion.item.selected.bg = thm_fg
c.colors.completion.item.selected.match.fg = thm_accent
c.colors.completion.match.fg = thm_accent

# * vertical tabs *
# inactive
c.colors.tabs.bar.bg = thm_panel
c.colors.tabs.odd.bg = thm_panel
c.colors.tabs.odd.fg = thm_muted
c.colors.tabs.even.bg = thm_panel
c.colors.tabs.even.fg = thm_muted

# focused
c.colors.tabs.selected.odd.bg = thm_bg
c.colors.tabs.selected.odd.fg = thm_fg
c.colors.tabs.selected.even.bg = thm_bg
c.colors.tabs.selected.even.fg = thm_fg

# indicator line on tab edge showing page loading status
c.colors.tabs.indicator.start = thm_accent
c.colors.tabs.indicator.stop = thm_green
c.colors.tabs.indicator.error = thm_accent

# hint / link key flags
c.colors.hints.bg = thm_accent
c.colors.hints.fg = thm_bg
c.colors.hints.match.fg = thm_green
