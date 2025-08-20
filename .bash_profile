PATH=$HOME/.local/bin${PATH:+:$PATH}

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER="less -RFM"
export MANPAGER="bat --strip-ansi=always -plman"

export CC=clang
export CXX=clang++
export CC_LD=mold
export CXX_LD=mold

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export AMD_DEBUG=useaco

export VK_DRIVER_FILES=/usr/local/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/radeon_icd.i686.json
export LD_LIBRARY_PATH="/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

export LIBVA_DRIVERS_PATH=/usr/local/lib64/dri
export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER_PATH=/usr/local/lib64/vdpau
export VDPAU_DRIVER=radeonsi
