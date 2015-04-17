setenv PATH '/Users/zorkian/.pyenv/shims' $PATH
setenv PYENV_SHELL fish
. '/usr/local/Cellar/pyenv/20140110.1/libexec/../completions/pyenv.fish'
pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case activate deactivate rehash shell
    eval (pyenv "sh-$command" $argv)
  case '*'
    command pyenv "$command" $argv
  end
end
