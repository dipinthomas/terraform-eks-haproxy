# EKS Cluster

Terraform scripts to create an EKS cluster for proof-of-concept purposes; the goal is to have an EKS cluster up and running in minutes to perform some quick validations; thus, the cluster will be deployed in the public subnet.

**change the subnet to private for production usage**

# Technology Used

* [AWS EKS](https://aws.amazon.com/eks/)
* [Kustomize](https://kustomize.io/)
* [Terraform](https://www.terraform.io/)
* [Kubernetes](https://kubernetes.io/)
# Prerequisites

* Terraform v1.1.3 
* kubectl 1.22 
* aws-cli 2.3.3

# EKS Architecture

![AWS Architecture](images/EKS_Architecture.png?raw=true "AWS Architecture")

* Each AZ will have a worker node
* HAProxy will be deployed as daemonset, to ensure high availability. This will also overcome the time delay in new pod launch.
* Incase of a failure connections will be redirected to healthy host after health check fails. 


# HAProxy Architecture

![HAProxy](images/HAProxy.png?raw=true "HAProxy")

After deployment, HAProxy will be running on each and every worker node. HAProxy service will accept traffic on three ports, 80, 5000 & 9000.

* 80 - Incoming request which will be forwarded to a backend service
* 5000 - Flask application which will fetch and return ec2-metadata when running on EKS.
* 9000 - HA proxy health & traffic stats 

### External backend/Service

In the above diagram red line is used to represent traffic to a backend which is not running on EKS cluster.

Kubernetes service supports traffic forward to external resource. This helps is avoding IP address or hostname being hardcoded in the application. This will be the recommended approach, if HAProxy is running on EKS cluster and backend is not.

[Headless service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) can also be considered for this usercase. 

# Kubernetes Kustomize HAProxy

[kustomize](https://kustomize.io/) kubernetes native configuration management tool. A template-free way to customize application configuration that simplifies the use of off-the-shelf applications.

Kustomize is used as a provider to deploy HAProxy.

# HAProxy Docker Image

A custom HAproxy docker image is built for the POC purpose, you can find the image details [here](https://github.com/dipinthomas/poc-dockerfile)

# Steps to run

## Step 1 : Clone this repository

```
git clone <repo_link>
```

## Step 2 : aws credentials

System should have login credentials configured before deploying the cluster.  Below command will request for aws *access_key* & *secret_key* 

```
aws configure
<entry access_key & secret_key>
```

## Step 3: AWS access verification

Run any AWS command to verify access.

```
aws s3 ls
<should return list of s3 buckets if any>
```

## Step 4: Terraform Deployment

Once above setps execution is successful you can deploy using below terraform commands

```
terraform init
terraform plan
terraform apply --auto-approve
```

## Step 5: Get loadbalancer url

```
kubectl get services -n default
```
### expected output
![service_output](images/service_output.png?raw=true "service_output")

### Known Issue

![known_issue](images/known_issue.png?raw=true "known_issue")

DNS propagation takes time after the loadbalancer is created. If above screen appears wait for few minutes. 


## Step 6: Validation

### Backend application

A default nginx POD has been deployment on the cluster, HAProxy will forward the request to this backend.

`URL : The loadbalancer URL obtained from previous step `

![backend_application](images/backend_application.png?raw=true "backend_application")

### AZ Details

A python flask application is running on HAProxy POD which will help us understand the AZ in which the POD is running.

`URL:  loadbalancer URL & port 5000`

![az_output](images/az_output.png?raw=true "az_output")

### HAProxy Stats

HAProxy provides statics of traffic flow.

`URL: loadbalancer URL & port 9000 `

![HAProxy_Stats](images/HAProxy_Stats.png?raw=true "HAProxy_Stats")

## Step 7 : Destroy Cluster

Assuming the state files is available on local or remote.

```
terraform destroy
```

# Improvments

Feel free to create a PR with improvements or raise a bug reuest which will be addressed immediately.
