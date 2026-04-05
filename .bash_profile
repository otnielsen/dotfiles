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
export PAGER="less -RFM"
export BAT_PAGER="$PAGER"
export MANPAGER="bat --strip-ansi=always -plman"
export FZF_DEFAULT_OPTS='--reverse --list-border --cycle --no-scrollbar --height=~100% --no-mouse'

export CC=clang
export CXX=clang++
export CFLAGS='-march=native -mtune=native -O3 -flto=thin -DNDEBUG'
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS -fuse-ld=mold -s -Wl,--as-needed"
export CMAKE_GENERATOR=Ninja

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

vk_file='/usr/local/share/vulkan/icd.d/radeon_icd.x86_64.json'
if [ -f "$vk_file" ]; then
    export AMD_DEBUG=useaco # remove this line when mesa 26.0 is available as that will use aco for radeonsi by default

    export VK_DRIVER_FILES="$vk_file:/usr/share/vulkan/icd.d/radeon_icd.i686.json"

    if ! [[ "$LD_LIBRARY_PATH" =~ /usr/local/lib64 ]]; then
        export LD_LIBRARY_PATH="/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    fi

    export LIBVA_DRIVERS_PATH=/usr/local/lib64/dri
    export LIBVA_DRIVER_NAME=radeonsi
fi
unset vk_file

# Make uinput virtual xbox 360 controller use dualshock 3 mappings in sdl
# applications, so square and triangle (x and y) aren't swapped
export SDL_GAMECONTROLLERCONFIG='0300c5085e0400008e02000011810000,Xbox 360 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:a5,rightx:a3,righty:a4,start:b9,x:b3,y:b2,platform:Linux,'

# shellcheck source=/dev/null
[ -f ~/.bashrc ] && source ~/.bashrc
