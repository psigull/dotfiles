# pyright: reportUndefinedVariable=false
config.load_autoconfig(False)

# rendering
#c.content.user_stylesheets = ["~/.config/qutebrowser/styles.css"]
c.qt.args = [
    'enable-gpu-rasterization', # hw accel pages
    'enable-zero-copy', # cpu doesn't need to know what the page renders like
    'disable-background-timer-throttling', # prevents background JS from matching foreground priority
    'enable-features=ResourceLoadScheduler', # throttles request batches in background tabs
    'enable-accelerated-video-decode', # Offloads video to GPU instead of software
    'ignore-gpu-blocklist',            # Forces GPU features even if Qt reports minor driver mismatches
    'enable-features=DailyRefresh,ResourceSaverDailyRefresh', # disable background tabs
    'enable-features=PageLifecycle', # make sure background tabs dont continuously paint
    'enable-oop-rasterization', # pushes ajax/dom layouts to separate async gpu thread
    'enable-skia-graphite', # vulkan rendering
    'enable-quic', # udp > tcp
    'autoplay-policy=no-user-gesture-required', # force disable autoplay
]

# statusbar
c.statusbar.show = 'always'
c.statusbar.widgets = ['keypress', 'search_match', 'url', 'scroll', 'progress']
c.messages.timeout = 2000

# tab bar (toggleable)
c.tabs.show = 'never'
c.tabs.position = 'left'
c.tabs.width = '15%'
c.tabs.favicons.show = 'always'
c.tabs.mousewheel_switching = False

# appearance
c.completion.height = '25%'
c.colors.webpage.darkmode.enabled = True
c.fonts.default_family = 'Wired Propo'
c.fonts.web.family.standard = 'Wired Propo'
c.fonts.web.family.fixed = 'Wired Mono'
c.fonts.web.family.sans_serif = 'Wired Propo'
c.fonts.web.family.serif = 'Wired Propo'
c.fonts.default_size = '11px'

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
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/experimental.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt',
    'https://filters.adtidy.org/extension/chromium/filters/4.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-cookies.txt'
]

# search engines
c.url.searchengines = {
    'DEFAULT': 'https://google.com/search?q={}',

    'google': 'https://google.com/search?q={}',
    'youtube': 'https://youtube.com/results?search_query={}',
    'brave': 'https://search.brave.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',

    'archwiki': 'https://wiki.archlinux.org/index.php?search={}',
    'pkg': 'https://archlinux.org/packages/?q={}',
    'aur': 'https://aur.archlinux.org/packages/?K={}',

    'pcgw': 'https://www.pcgamingwiki.com/w/index.php?search={}',
    'protondb': 'https://www.protondb.com/search?q={}',

    'wikipedia': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
    'godot-docs': 'https://docs.godotengine.org/en/stable/search.html?q={}',
    'rust-docs': 'https://docs.rs/releases/search?query={}',
    'crates': 'https://crates.io/search?q={}',
    'godev': 'https://pkg.go.dev/search?q={}'
}

# misc
c.auto_save.session = True
c.url.start_pages = ['about:blank']
c.scrolling.smooth = True
c.input.media_keys = False

c.content.autoplay = False
c.content.prefers_reduced_motion = True

c.input.mode_override = None
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True

# file picker
c.fileselect.handler = "external"
c.fileselect.single_file.command = ['yazipicker.sh']
c.fileselect.multiple_files.command = ['yazipicker.sh']


# ** keybinds **

# unbind defaults so we aren't floating in space like otousan
# no hitting random keys by accident
c.bindings.default['normal'] = {}
c.hints.chars = 'asdfghjkl'

# essential
config.bind(':', 'cmd-set-text :') # opens command mode
config.bind('<Escape>', 'mode-leave', mode='insert')    # escape insert mode back to normal
config.bind('<Escape>', 'mode-leave', mode='command')   # close command bar safely

# page navigation
config.bind('<Ctrl-[>', 'back')
config.bind('<Ctrl-]>', 'forward')
config.bind('<Ctrl-R>', 'reload')

# scrolling
config.bind('<Up>', 'scroll up', mode='normal')
config.bind('<Down>', 'scroll down', mode='normal')
config.bind('<Left>', 'scroll left', mode='normal')
config.bind('<Right>', 'scroll right', mode='normal')

# bookmarks & history
config.bind('<Ctrl-Shift-D>', 'bookmark-add')
config.bind('<Ctrl-b>', 'cmd-set-text -s :bookmark-load')
config.bind('<Ctrl-Shift-B>', 'cmd-set-text -s :bookmark-load -t')
config.bind('<Ctrl-h>', 'cmd-set-text -s :history -t')

# tabs
config.bind('<Ctrl-o>', 'cmd-set-text -s :open')
config.bind('<Ctrl-e>', 'cmd-set-text -s :open {url:pretty}')
config.bind('<Ctrl-t>', 'cmd-set-text -s :open -t')
config.bind('<Ctrl-Shift-p>', 'cmd-set-text -s :open -p')

config.bind('<Space><Space>', 'tab-focus last', mode='normal')
config.bind('<Ctrl-f>', 'cmd-set-text -s :tab-select')
config.bind('<Ctrl-`>', 'config-cycle tabs.show always never')

config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev')

config.bind('<Ctrl-w>', 'tab-close')
config.bind('<Ctrl-z>', 'undo', mode='normal')

# windows
config.bind('<Ctrl-Shift-S>', 'tab-give', mode='normal')
config.bind('<Ctrl-Shift-Z>', 'undo -w', mode='normal')

# selection / search
config.bind('<Ctrl-a>', 'fake-key <Ctrl-a>')
config.bind('<Ctrl-d>', 'search {primary}')
config.bind('/', 'cmd-set-text /', mode='normal')
config.bind('n', 'search-next', mode='normal')
config.bind('N', 'search-prev', mode='normal')

# clipboard
config.bind('<Ctrl-c>', 'fake-key <Ctrl-c>')
config.bind('<Ctrl-shift-c>', 'yank', mode='normal')

# hinting
config.bind('<Ctrl-n>', 'hint', mode='normal')
config.bind('<Ctrl-Shift-n>', 'hint all tab', mode='normal')

# insert mode -- these are the only alpha-keys not gated by a modifier.
config.bind('a', 'mode-enter insert', mode='normal')
config.bind('s', 'mode-enter insert', mode='normal')

# video playback
config.bind('<Ctrl-M>', 'spawn -d mpv {url}', mode='normal')
config.bind('<Ctrl-Shift-M>', 'hint links spawn -d mpv {hint-url}', mode='normal')


# ** theme **
# 🪐 colour scheme of theseus
thm_bg = '#181819'       # deep terminal bg
thm_panel = '#222427'    # menu / tab bar bg
thm_fg = '#CDCFD2'       # crisp primary foreground text
thm_muted = '#76787D'    # inactive text / comments
thm_accent = '#eE7987'   # sharp accent
thm_select = '#82FBC6'   # selection accent
thm_purp = '#1b162a'     # yes

# * statusbar *
c.colors.statusbar.normal.bg = thm_bg
c.colors.statusbar.normal.fg = thm_fg

c.colors.statusbar.insert.bg = thm_purp
c.colors.statusbar.insert.fg = thm_fg

c.colors.statusbar.command.bg = thm_panel
c.colors.statusbar.command.fg = thm_fg

# styling for https url text
c.colors.statusbar.url.success.https.fg = thm_select

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
c.colors.tabs.indicator.stop = thm_select
c.colors.tabs.indicator.error = thm_accent

# hint / link key flags
c.colors.hints.bg = thm_accent
c.colors.hints.fg = thm_bg
c.colors.hints.match.fg = thm_select
