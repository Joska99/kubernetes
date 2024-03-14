# Pull CloudBees CD helm chart
helm repo add cloudbees https://public-charts.artifacts.cloudbees.com/repository/public/
helm repo update

# Create NS for CloudBees
kubectl create ns cludbees

# Install CloudBees chart
helm install cb_cd_demo cloudbees/cloudbees-flow \
      -f cb_cd_demo.yaml \
      --namespace cludbees \
      --timeout 1800s