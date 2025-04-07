## Folder structure

### 1. docker
* Sample `Dockerfile` addon modules required to run `crew-app` application.  
* The image  with `latest` tag is uploaded on Dockerhub `https://hub.docker.com/r/nirupamak/crew-app/tags`.
* For testing against latest vulnerabilities are present.
`docker scout dockerfile ./Dockerfile`
`docker scout image nirupamak/crew-app:latest --severity high`
* The basic container Health-check is configured in `crew-app/templates/deployment.yaml` for the POD health checks (`livenessProbe` and `readinessProbe` for app container).

#### To deploy docker image locally.
1. `cd docker`  
2. `docker build -t nirupamak/crew-app . --platform=linux/amd64` # Cause my arm64 Macbook.

### 2. minikube-local-terraform
#### Prerequisites
Install Minikube (For my macbook used follwoing plugin)
1. curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.35.0/minikube-darwin-arm64 \
   && chmod +x minikube
2. sudo mv minikube /usr/local/bin.
3. Install `kubectl` utility
4. Install `helm` utility.
5. Install terraform on laptop (In my case I used Terraform v1.5.7)
6. Using `docker` driver for `minikube`. If need to change driver please update `minikube start` command in `provider.tf` file.

#### To deploy app on minikube
1. `cd minikube-local-terraform`  
2. `terraform init`
3. `terraform apply`
4. type `yes`

5. Once apply complete. Check the status of `kubectl get pods`.
 
#### To access the application
 
1. Run command of the empty terminal

`minikube service fine-tune-app-service --url`

The output will be http://127.0.0.1:<ramdom_port>

Copy URL

#### Or 

Run following to enable port fowwarding :
`kubectl port-forward svc/fine-tune-app-service 8080:8080`

The app should be available on browser at `http://127.0.0.1:8080`.

2. Run few curl POST commands to access add few entries in application:
For example:
* `curl -X POST http://127.0.0.1:8080/user -H "Content-Type: application/json" -d '{"name": "marie"}'`
* `curl -X POST http://127.0.0.1:8080/user -H "Content-Type: application/json" -d '{"name": "tim"}'`  

For GET request open URL in web browser:
For example:
* `http://127.0.0.1:8080/user?id=2`
* `http://127.0.0.1:8080/user?id=3`
    
### 3. GCP-terraform

1. The GCP-terraform comtains terraform to deploy kubernetes cluster on Google Cloud Platform. 
2. It deploying the same `crew-task-app` helm-chart same as on minikube. 

#### To deploy app on GCP
1. `cd GCP-terraform`  
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. type `yes`

##### Notes: This soloution is un-tested. However `terraform plan` works well. The  `terraform apply` is untested cause of lack of GCP accesses. 