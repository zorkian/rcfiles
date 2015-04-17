if status --is-login
    alias psa 'ps aufx'

    set -xg SOCK "/tmp/ssh-agent-$USER-screen"
    if test $SSH_AUTH_SOCK != $SOCK
        echo "resetting"
        rm -f /tmp/ssh-agent-$USER-screen
        ln -sf $SSH_AUTH_SOCK $SOCK
        set -xg SSH_AUTH_SOCK $SOCK
    end

    set -xg GOPATH $HOME/dev/go
    set -xg PATH $HOME/dev/arcanist/arcanist/bin /usr/local/Cellar/go/1.2/libexec/bin $HOME/bin /usr/local/go/bin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin /usr/local/munki
    set -xg PYTHONPATH /usr/local/lib/python2.7/site-packages
    set -xg EDITOR /usr/bin/vim

    set -xg fish_git_dirty_color red
end
