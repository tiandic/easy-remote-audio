#!/bin/bash

# The audio sender is the server, and the receiver is the client
# 音频发送方为服务端,接收方为客户端

oper="$1"
help_str="Example of use:\n    $0 init a@192.168.1.1\nParameter:"
# help_str="使用示例:\n    $0 init \nper:"
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
simple_conf_dir_path="~/.config/pipewire/pipewire.conf.d"
simple_conf_path="${simple_conf_dir_path}/my-protocol-simple.conf"

add_arg() {
    # The first is the parameter name, the second is the parameter description
    # 第一个是参数名 第二个是参数说明
    local v=$(printf '%-28s' "$1")
    help_str="$help_str\n${v}$2"
}

init() {
    # A parameter is needed, for example a@192.168.1.1
    # 需要一个参数 例如 a@192.168.1.1
    ssh "$1" "mkdir -p $simple_conf_dir_path"
    scp "${SCRIPT_PATH}/my-protocol-simple.conf" "$1:$simple_conf_path"
    ssh "$1" 'systemctl --user restart pipewire'
}

start() {
    # A parameter is needed, for example a@192.168.1.1
    # 需要一个参数 例如 a@192.168.1.1
    tmux new -d -s remote_audio0 "ssh -L 4711:localhost:4711 \"$1\""
    tmux new -d -s remote_audio1 "snapserver -c \"${SCRIPT_PATH}/snapcast_server.conf\""
    tmux new -d -s remote_audio2 "snapclient -h 127.0.0.1 --player pulse"
}

stop() {
    tmux kill-session -t remote_audio0
    tmux kill-session -t remote_audio1
    tmux kill-session -t remote_audio2
}

add_arg "init  <user@server>" "Initialization, this option must be run before running other options"
# add_arg "init" "初始化,运行其他选项前必须先运行该选项"
add_arg "start <user@server>" "Start remote audio"
# add_arg "start" "启动远程音频"
add_arg "stop" "Stop remote audio"
# add_arg "stop" "停止远程音频"


if [[ $# -lt 1 || $oper == "-h" || $oper == "--help" ]]; then
    printf "$help_str\n"
    exit 1
fi

if [[ $oper == "init" ]]; then
    if [[ $# -lt 2 ]] ; then
        echo "Missing a parameter, for example: a@192.168.1.1"
        # echo "缺少一个参数 例如: a@192.168.1.1"
        exit 1
    fi
    init "$2"
fi

if [[ $oper == "start" ]]; then
    if [[ $# -lt 2 ]] ; then
        echo "Missing a parameter, for example: a@192.168.1.1"
        # echo "缺少一个参数 例如: a@192.168.1.1"
        exit 1
    fi
    start "$2"
fi

if [[ $oper == "stop" ]]; then
    stop
fi
