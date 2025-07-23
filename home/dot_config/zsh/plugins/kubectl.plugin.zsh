if (( $+commands[kubectl] )); then
  alias k="kubectl"
  alias ka="kubectl apply"
  alias kaf="kubectl apply -f"
  alias kdel="kubectl delete"
  alias kdelf="kubectl delete -f"
  alias krr='kubectl rollout restart'
  alias kcuc="kubectl config use-context"
  alias kcsc="kubectl config set-context"
  alias kcdc="kubectl config delete-context"
  alias kccc="kubectl config current-context"
  alias kcgc="kubectl config get-contexts"
fi

(( $+commands[k9s] ))&& alias ks="k9s"
(( $+commands[kubectx] )) && alias kc="kubectx"
(( $+commands[kubens] )) && alias kns="kubens"
