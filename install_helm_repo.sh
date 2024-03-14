helm repo add cloudbees https://public-charts.artifacts.cloudbees.com/repository/public/
helm repo update

kubectl create ns cludbees

helm install cb_cd_demo.yaml cloudbees/cloudbees-flow \
      -f cb_cd_demo.yaml \
      --namespace cludbees \
      --timeout 10000s