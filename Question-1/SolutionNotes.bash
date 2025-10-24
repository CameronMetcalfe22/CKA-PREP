# Step one add the repo
helm repo add argocd https://argoproj.github.io/argo-helm
# Check the repo is there
helm repo list

# Step two get the template using the parameters given
helm template argocd argo/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd > /root/argo-helm.yaml

#Step three verfiy
cat /root/argo-helm.yaml
# You should see the template there