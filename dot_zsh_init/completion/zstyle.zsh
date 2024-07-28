# zstyle ':completion:*' auto-description 'specify: %d.'
# zstyle ':completion:*' cache-path /Users/ykksd/.cache/shell/zsh
# zstyle :completion::complete:-command-:: cache-policy _path_commands_caching_policy
# zstyle :completion::complete:docker:argument-1: cache-policy __docker_caching_policy
# zstyle :completion::complete:docker-compose:argument-1: cache-policy __docker-compose_caching_policy
# zstyle ':completion:*:*:*:*:processes' command 'ps ax -o pid,user,command -w -w'
# zstyle ':completion:*:*:(cd|pushd|chdir):*' complete-options true
# zstyle ':completion::prefix:*' completer _complete
# zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _ignored
# zstyle ':completion:*' expand prefix suffix
# zstyle ':completion:*' extra-verbose true
# zstyle ':completion::complete:choosenim:*' fetch-remote true
# zstyle ':completion:*:*:zcompile:*:*' file-patterns '((*.)#(ba|z|)sh(*)|.(z|)(profile|log(in|out))|abbreviations|((site-|)functions)|_*)~*zwc:shell-script' '*(N-/):directories' %p:all-files
# zstyle ':completion:*:*:(mdcat|glow):*:*' file-patterns '*.md:markdown'
# zstyle ':completion:*:descriptions' format '[%d]'
# zstyle ':completion:*:warings' format ' %F{red}-- no match --%f'
# zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
# zstyle ':completion:*:messages' format ' %F{blue} -- %d --%f'
# zstyle ':completion::expand:*' glob true
# zstyle ':completion:*:*:zinit:*' group-name ''
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*:*:pathof:*:(parameters|builtins|reserved-words|aliases)' ignored-patterns '*'
# zstyle ':completion:*:*:*:*:options-single-letter' ignored-patterns '???*'
# zstyle ':completion:*:*:*:*:options-long' ignored-patterns '[-+](|-|[^-]*)'
# zstyle ':completion:*:*:*:*:options-short' ignored-patterns '--*' '[-+]?'
# zstyle ':completion:*:*:(bat|cat|(nvim|vim|vi|view)|zca):*:*' ignored-patterns '*.zwc' '.*.zwc'
zstyle ':completion:*:zinit:argument-rest:plugins' list-colors '=(#b)(*)/(*)==1;35=1;33'
zstyle ':completion:*:zman:argument-rest:plugins' list-colors '=(#b)(*)/(*)==1;35=1;33'
zstyle ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==36=36}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*' list-colors \
  'no=00' \
  'fi=00' \
  'rs=0' \
  'di=01;34' \
  'ln=target' \
  'mh=00' \
  'pi=40;33' \
  'so=35' \
  'do=35' \
  'bd=40;33;01' \
  'cd=40;33;01' \
  'or=40;31;01' \
  'mi=00' \
  'su=30;41;01' \
  'sg=30;43;01' \
  'ca=30;41;01' \
  'tw=30;42;01' \
  'ow=30;46;01' \
  'st=30;44;01' \
  'ex=33;01' \
  '*.cmd=33' \
  '*.exe=33' \
  '*.com=33' \
  '*.btm=33' \
  '*.bat=33' \
  '*.sh=33' \
  '*.bash=33' \
  '*.csh=33' \
  '*.zsh=33' \
  '*.zsh-theme=33' \
  '*.fish=33' \
  '*.dll=34' \
  '*.class=34' \
  '*.node=34' \
  '*.pyc=34' \
  '*.so=34' \
  '*.pyo=34' \
  '*.tar=32' \
  '*.tgz=32' \
  '*.arc=32' \
  '*.arj=32' \
  '*.taz=32' \
  '*.lha=32' \
  '*.lz4=32' \
  '*.lzh=32' \
  '*.lzma=32' \
  '*.tlz=32' \
  '*.txz=32' \
  '*.tzo=32' \
  '*.t7z=32' \
  '*.zip=32' \
  '*.z=32' \
  '*.Z=32' \
  '*.dz=32' \
  '*.gz=32' \
  '*.lrz=32' \
  '*.lz=32' \
  '*.lzo=32' \
  '*.xz=32' \
  '*.zst=32' \
  '*.tzst=32' \
  '*.bz2=32' \
  '*.bz=32' \
  '*.tbz=32' \
  '*.tbz2=32' \
  '*.tz=32' \
  '*.ear=32' \
  '*.sar=32' \
  '*.rar=32' \
  '*.alz=32' \
  '*.ace=32' \
  '*.zoo=32' \
  '*.cpio=32' \
  '*.7z=32' \
  '*.rz=32' \
  '*.cab=32' \
  '*.wim=32' \
  '*.swm=32' \
  '*.dwm=32' \
  '*.esd=32' \
  '*.apk=32' \
  '*.gem=32' \
  '*.xpi=32' \
  '*.crx=32' \
  '*.apk=33' \
  '*.deb=33' \
  '*.rpm=33' \
  '*.jad=33' \
  '*.jar=33' \
  '*.war=33' \
  '*.cab=33' \
  '*.pak=33' \
  '*.pk3=33' \
  '*.vdf=33' \
  '*.vpk=33' \
  '*.bsp=33' \
  '*.dmg=33' \
  '*.msi=33' \
  '*.dmg=31' \
  '*.iso=31' \
  '*.bin=31' \
  '*.nrg=31' \
  '*.qcow=31' \
  '*.sparseimage=31' \
  '*.toast=31' \
  '*.vcd=31' \
  '*.vmdk=31' \
  '*.jpg=35' \
  '*.jpeg=35' \
  '*.gif=35' \
  '*.webp=35' \
  '*.wma=35' \
  '*.bmp=35' \
  '*.pbm=35' \
  '*.pgm=35' \
  '*.ppm=35' \
  '*.tga=35' \
  '*.xbm=35' \
  '*.xpm=35' \
  '*.tif=35' \
  '*.tiff=35' \
  '*.png=35' \
  '*.svg=35' \
  '*.svgz=35' \
  '*.mng=35' \
  '*.pcx=35' \
  '*.ico=35' \
  '*.eps=35' \
  '*.mov=34' \
  '*.movie=34' \
  '*.mpg=34' \
  '*.mpeg=34' \
  '*.m2v=34' \
  '*.mkv=34' \
  '*.webm=34' \
  '*.ogm=34' \
  '*.mp4=34' \
  '*.m4v=34' \
  '*.mp4v=34' \
  '*.vob=34' \
  '*.qt=34' \
  '*.nuv=34' \
  '*.wmv=34' \
  '*.asf=34' \
  '*.rm=34' \
  '*.rmvb=34' \
  '*.avi=34' \
  '*.flv=34' \
  '*.gl=34' \
  '*.dl=34' \
  '*.xcf=34' \
  '*.xwd=34' \
  '*.yuv=34' \
  '*.emf=34' \
  '*.ogv=34' \
  '*.ogx=34' \
  '*.3g2=34' \
  '*.3gp=34' \
  '*.3gp2=34' \
  '*.3gpp=34' \
  '*.aac=36' \
  '*.au=36' \
  '*.flac=36' \
  '*.m4a=36' \
  '*.mid=36' \
  '*.midi=36' \
  '*.mka=36' \
  '*.mp3=36' \
  '*.mpc=36' \
  '*.ogg=36' \
  '*.ra=36' \
  '*.wav=36' \
  '*.oga=36' \
  '*.opus=36' \
  '*.spx=36' \
  '*.xspf=36' \
  '*.doc=36' \
  '*.docx=36' \
  '*.odt=36' \
  '*.ppt=33' \
  '*.pptx=33' \
  '*.odp=33' \
  '*.xlsx=34' \
  '*.xls=34' \
  '*.ods=34' \
  '*.csv=34' \
  '*.tsv=34' \
  '*.pdf=31' \
  '*.djvu=36' \
  '*.epub=36' \
  '*.c=34' \
  '*.h=34' \
  '*.hpp=34' \
  '*.cc=34' \
  '*.cpp=34' \
  '*.cs=32' \
  '*.go=34' \
  '*.rs=33' \
  '*.java=31' \
  '*.pas=35' \
  '*.py=34' \
  '*.ipynb=34' \
  '*.rb=31' \
  '*.erb=31' \
  '*.gemspec=31' \
  '*.ru=31' \
  '*.lua=35' \
  '*.xlt=32' \
  '*.sql=34' \
  '*.groovy=36' \
  '*.dsl=36' \
  '*.js=33' \
  '*.jsx=33' \
  '*.ts=33' \
  '*.tsx=33' \
  '*.coffee=33' \
  '*.php=34' \
  '*.css=32' \
  '*.sss=32' \
  '*.less=32' \
  '*.scss=32' \
  '*.sass=32' \
  '*.stylus=32' \
  '*.html=34' \
  '*.xhtml=34' \
  '*.htm=34' \
  '*.hjs=34' \
  '*.haml=34' \
  '*.slim=34' \
  '*.jade=34' \
  '*.pug=34' \
  '*.vue=32' \
  '*.scala=31' \
  '*.json=34' \
  '*.toml=34' \
  '*.cson=34' \
  '*.yml=35' \
  '*.yaml=35' \
  '*.xml=35' \
  '*.md=31' \
  '*.markdown=31' \
  '*.tex=35' \
  '*.latex=35' \
  '*.pl=33' \
  '*.hs=34' \
  '*.lhs=34' \
  '*.map=36' \
  '*.vim=32' \
  '*.txt=0' \
  '*package.json=4;35' \
  '*bower.json=4;35' \
  '*Gemfile=4;35' \
  '*Rakefile=4;35' \
  '*Makefile=4;35' \
  '*Cargo.toml=4;33' \
  '*Vagrantfile=4;34' \
  '*node_modules=32' \
  '*tsconfig.json=2;34' \
  '*tsconfig.*.json=2;34' \
  '*jsdoc.json=2;34' \
  '*.babelrc=2;33' \
  '*.babel.js=2;33' \
  '*.babelrc.js=2;33' \
  '*.babel.json=2;33' \
  '*.babelrc.json=2;33' \
  '*babelrc=2;33' \
  '*babel.js=2;33' \
  '*babelrc.js=2;33' \
  '*babel.json=2;33' \
  '*babelrc.json=2;33' \
  '*babel.json=2;33' \
  '*babel.*.js=2;33' \
  '*rollup.*.json=2;33' \
  '*rollup.*.js=2;33' \
  '*.eslintrc=2;35' \
  '*.eslintrc.js=2;35' \
  '*.eslintrc.json=2;35' \
  '*package-lock.json=2;35' \
  '*known_hosts=36' \
  '*config=36' \
  '*authorized_keys=36' \
  '*.xinitrc=34' \
  '*.xbindkeysrc=34' \
  '*.Xresources=34' \
  '*.profile=33' \
  '*.bashrc=33' \
  '*.bash_profile=33' \
  '*.bashrc.aliases=33' \
  '*.bash_logout=33' \
  '*.bashrc=33' \
  '*.bashrc=33' \
  '*.zprofile=33' \
  '*.zshrc=33' \
  '*.zshrc.local=33' \
  '*.vimrc=32' \
  '*.db=35' \
  '*.sqlite3=35' \
  '*.sqlite=35' \
  '*.sqlite-wal=35' \
  '*.ttf=33' \
  '*.woff=33' \
  '*.woff2=33' \
  '*.afm=33' \
  '*.fon=33' \
  '*.fnt=33' \
  '*.pfb=33' \
  '*.pfm=33' \
  '*.otf=33' \
  '*.diff=30;41' \
  '*.patch=30;41' \
  '*LICENSE=4;33' \
  '*README=4;33' \
  '*README.md=4;31' \
  '*.cfg=36' \
  '*.conf=36' \
  '*.ini=36' \
  '*.asc=31' \
  '*.enc=31' \
  '*.gpg=31' \
  '*.signature=31' \
  '*.sig=31' \
  '*.p12=31' \
  '*.pem=31' \
  '*.pgp=31' \
  '*.asc=31' \
  '*.enc=31' \
  '*.sig=31' \
  '*.p7s=31' \
  '*id_dsa=31' \
  '*id_rsa=31' \
  '*id_ecdsa=31' \
  '*id_ed25519=31' \
  '*.gitignore=2;34' \
  '*.allow=32' \
  '*.deny=31' \
  '*.service=34' \
  '*@.service=34' \
  '*.socket=34' \
  '*.swap=34' \
  '*.device=34' \
  '*.mount=34' \
  '*.automount=34' \
  '*.target=34' \
  '*.path=34' \
  '*.timer=34' \
  '*.snapshot=34' \
  '*.slice=34' \
  '*.torrent=32' \
  '*.directory=34' \
  '*.desktop=34' \
  '*.kml=35' \
  '*.kmz=35' \
  '*.log=2;37' \
  '*.zwc=2;37' \
  '*.log=2;37' \
  '*.lock=2;37' \
  '*.old=2;37' \
  '*.o=2;37' \
  '*~=2;37' \
  '*tmp=2;37' \
  '*out=2;37' \
  '*bak=2;37' \
  '*swp=2;37' \
  '*cache=2;37' \
  '*part=2;37' \
  '*.zsh_history=2;37' \
  '*.zcompdump=2;37' \
  '*.bash_history=2;37' \
  '*.viminfo=2;37' \
  'ma=7;33'

# zstyle ':completion:*' list-dirs-first true
# zstyle ':completion:*' list-grouped false
# zstyle ':completion:*' list-separator '   . 〭oO'
zstyle ':completion:*:zinit:argument-rest:plugins' matcher 'r:|=** l:|=*'
zstyle ':completion:*:zman:argument-rest:plugins' matcher 'r:|=** l:|=*'
# zstyle ':completion:*' matcher-list 'l:|=** r:|=** m:{[:lower:]}={[:upper:]} r:|[-,_./]=*'
# zstyle -e ':completion:*:(correct|approximate):*' max-errors 'reply=($(((${#PREFIX} + ${#SUFFIX}) / 2 > 10 ? 7 : (${#PREFIX} + ${#SUFFIX})/ 3)) numeric)'
# zstyle ':completion:*:*:cdr:*:*' menu selection
# zstyle ':completion:*:default' menu 'select=2'
# zstyle ':completion:*:*:-command-:*:functions' prefix-needed true
# zstyle ':completion:*:*:cdr:*' recent-dirs-insert both
# zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# zstyle ':completion:*' show-completer true
# zstyle ':completion:*:zpm:*' sort false
# zstyle ':completion:*' sort false
# zstyle -e ':completion:*' special-dirs '[[ ${PREFIX} = (../)#(.|..) ]] && reply=(..)'
# zstyle ':completion::expand:*' substitute true
# zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# zstyle ':completion:*:*:' tag-order '!options' $'options:-single-letter:single\\ letter\\ options\n           options:-short:short\\ options\n           options:-long:long\\ options'
# zstyle ':completion:*' urls /Users/ykksd/.urls
# zstyle ':completion:*' use-cache true

zstyle ':completion:*:*:(git|g|hub):*' user-commands \
  'alias:define, search and show aliases' \
  'archive-file:export the current head of the git repository to an archive' \
  'authors:generate authors report' \
  'back:undo and stage latest commits' \
  'browse:open repo website in browser' \
  'bug:create bug branch' \
  'bulk:run bulk commands' \
  'brv:list branches sorted by their last commit date' \
  'changelog:generate a changelog report' \
  'chore:create chore branch' \
  'clear-soft:soft clean up a repository' \
  'clear:rigorously clean up a repository' \
  'coauthor:add a co-author to the last commit' \
  'commits-since:show commit logs since some date' \
  'contrib:show user contributions' \
  'count:show commit count' \
  'create-branch:create branches' \
  'delete-branch:delete branches' \
  'delete-merged-branches:delete merged branches' \
  'delete-submodule:delete submodules' \
  'delete-tag:delete tags' \
  'delta:lists changed files' \
  'effort:show effort statistics on file(s)' \
  'extras:awesome git utilities' \
  'feature:create/merge feature branch' \
  'force-clone:overwrite local repositories with clone' \
  'fork:fork a repo on github' \
  'fresh-branch:create fresh branches' \
  'gh-pages:create the github pages branch' \
  'graft:merge and destroy a given branch' \
  'guilt:calculate change between two revisions' \
  'ignore-io:get sample gitignore file' \
  'ignore:add .gitignore patterns' \
  'info:returns information on current repository' \
  'local-commits:list local commits' \
  'lock:lock a file excluded from version control' \
  'locked:ls files that have been locked' \
  'merge-into:merge one branch into another' \
  'merge-repo:merge two repo histories' \
  'missing:show commits missing from another branch' \
  'mr:checks out a merge request locally' \
  'obliterate:rewrite past commits to remove some files' \
  'paste:send patches to pastebin sites' \
  'pr:checks out a pull request locally' \
  'psykorebase:rebase a branch with a merge commit' \
  'pull-request:create pull request to GitHub project' \
  'reauthor:replace the author and/or committer identities in commits and tags' \
  'rebase-patch:rebases a patch' \
  'refactor:create refactor branch' \
  'release:commit, tag and push changes to the repository' \
  'rename-branch:rename a branch' \
  'rename-tag:rename a tag' \
  'rename-remote:rename a remote' \
  'repl:git read-eval-print-loop' \
  'reset-file:reset one file' \
  'root:show path of root' \
  'scp:copy files to ssh compatible `git-remote`' \
  'secrets:Prevents you from committing passwords and other sensitive information to a git repository.' \
  'sed:replace patterns in git-controlled files' \
  'setup:set up a git repository' \
  'show-merged-branches:show merged branches' \
  'show-tree:show branch tree of commit history' \
  'show-unmerged-branches:show unmerged branches' \
  'squash:import changes from a branch' \
  'stamp:stamp the last commit message' \
  'standup:recall the commit history' \
  'summary:show repository summary' \
  'sync:sync local branch with remote branch' \
  'touch:touch and add file to the index' \
  'undo:remove latest commits' \
  'unlock:unlock a file excluded from version control' \
  'cal:visualize the git commit history in github''s contribution calendar style.' \
  'clang-format:run clang-format on all lines that differ between the working directory and <commit>, which defaults to HEAD.' \
  'cp:Copy a file keeping its history' \
  'cvsserver:A CVS server emulator for Git' \
  'dsf:Good-lookin'' diffs. Actually… nah… The best-lookin'' diffs.' \
  'file-history:Quickly browse the history of a file from any git repository.' \
  'flow:Extensions to follow Vincent Driessen''s branching model' \
  'get:Get Captain Pellaeon.' \
  'history:Quickly browse the history of a file from any git repository.' \
  'icdiff:Improved colored diff.' \
  'now:A temporary commit tool for git.' \
  'stats:Local git statistics including GitHub-like contributions calendars.' \
  'stats-importer:imports the commits from the current repository' \
  'trim:Automatically trims your tracking branches whose upstream branches are merged or stray.' \
  'pork:Pork it.' \
  'quick-stats:simple and efficient way to access various statistics in a git repository.' \
  'recent:See your latest local git branches, formatted real fancy' \
  'rscp: Copies specific files from the working directory of a remote repository to the current working directory.' \
  'secrets:Prevents you from committing passwords and other sensitive information to a git repository.' \
  'xpull:Execute commands for multiple repositories in xargs manner.' \
  'repositories:Recursively search for repositories under the given directory.'

