# ~/.bash_aliases

# colors
if [ "$TERM" != "dumb" ]; then
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  if [ "$(uname)" == "Darwin" ]; then
    export LSCOLORS=dxfxcxdxbxegedabagacad
    alias ls='ls -CG'
  else
    alias ls='ls --color=auto -C'
  fi
fi

if [ "$(uname)" == "Darwin" ]; then
  alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder && echo DNS flushed'
fi

# docker related
if [ -n $(which docker) ]; then

  # Kill all running containers.
  alias dockerkillall='docker kill $(docker ps -q)'

  # Delete all stopped containers.
  alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

  # Delete all untagged images.
  alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

  # Delete all stopped containers and untagged images.
  alias dockerclean='dockercleanc || true && dockercleani'

  if [ "$(uname)" == "Darwin" ]; then
    # Start docker on Mac
    alias dockermachine='eval $(docker-machine env)'
  fi
fi

