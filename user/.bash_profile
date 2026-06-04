if ! [[ "$PATH" =~ $HOME/.local/bin ]]; then
    export PATH=$HOME/.local/bin${PATH:+:$PATH}
fi

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export EDITOR=nvim
export VISUAL=$EDITOR
export TERMINAL=alacritty
export BROWSER=firefox
export LESS='-RFM'
export PAGER="less"
export BAT_PAGER="$PAGER"
export MANPAGER="bat --strip-ansi=always -plman"
export FZF_DEFAULT_OPTS='--tmux --reverse --cycle --no-scrollbar --no-mouse'

export CC=clang
export CXX=clang++
export CFLAGS='-march=native -mtune=native -O3 -flto=thin -DNDEBUG'
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS -fuse-ld=mold -s -Wl,--as-needed"
export CMAKE_GENERATOR=Ninja

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite_history

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

if [ -d ~/.local/state/nix/profile/lib ]; then
    export LD_LIBRARY_PATH=~/.local/state/nix/profile/lib
    export LIBVA_DRIVERS_PATH=$LD_LIBRARY_PATH/dri
fi

if [ -d ~/.local/state/nix/profile/share/vulkan/icd.d ]; then
    export VK_DRIVER_FILES=~/.local/state/nix/profile/share/vulkan/icd.d
fi

# Make uinput virtual xbox 360 controller use dualshock 3 mappings in sdl
# applications, so square and triangle (x and y) aren't swapped
export SDL_GAMECONTROLLERCONFIG='0300c5085e0400008e02000011810000,Xbox 360 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:a5,rightx:a3,righty:a4,start:b9,x:b3,y:b2,platform:Linux,'

# shellcheck source=/dev/null
[ -f ~/.bashrc ] && source ~/.bashrc
