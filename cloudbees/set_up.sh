#! REQUIREMENTS: 
#* EFS.CSI driver
#* StorageClass connected to AWS EFS
#* Postgress DataBase 

# Pull CloudBees CD helm chart
helm repo add cloudbees https://public-charts.artifacts.cloudbees.com/repository/public/
helm repo update

# Output alues file
#! CHANGE Values:
#! Database: Name, Credentials, Port, myaqlconnector=false
#! Old ingress: Disable
#! StorageClass: Name
helm inspect values cloudbees/cloudbees-flow > cd.yaml

# Create NS for CloudBees
kubectl create ns cloudbees

# Install CloudBees chart
helm install cloudbees cloudbees/cloudbees-flow \
      -f cd.yaml \
      --namespace cludbees \
      --timeout 1800s

# Get password
# kubectl get secret --namespace cludbees cloudbees-cloudbees-flow-credentials -o jsonpath="{.data.CBF_SERVER_ADMIN_PASSWORD}" | base64 --decode; echo