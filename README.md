# Running Notebooks on ACI

This repo demonstrates how you can run Jupyter(lab) on Azure Container Instance (ACI). The key idea here is the interactive session is being run in a container, thus aiding:

* Reproducibility
* Smoothing the path to running a job

## Create an Azure Resource Group

Using the Azure CLI, create a new resource group:

```bash
RG=notebooks-on-aci-rg
az group create -l westus2 -n $RG
```

## Simple example
To begin, you are going to start with a 'simple example' that runs the [tensorflow/tensorflow:latest-jupyter](https://hub.docker.com/r/tensorflow/tensorflow/) image from dockerhub on ACI.

### ACI config file
The configuration (`aci-configs/simple.yaml`) for running this container is as follows:

```yaml
additional_properties: {}
apiVersion: '2019-12-01'
name: cpucontainergroup
location: westus2
properties:
  containers:
  - name: cpucontainer
    properties:
      image: tensorflow/tensorflow:latest-jupyter
      resources:
        requests:
          cpu: 4
          memoryInGB: 14
      volumeMounts:
      - name: azuremlexamples
        mountPath: /tf/repos
      ports:
      - port: 8888
  osType: Linux
  volumes:
  - name: azuremlexamples
    gitRepo:
      repository: https://github.com/Azure/azureml-examples
  ipAddress:
    type: Public
    ports:
    - protocol: tcp
      port: 8888
  restartPolicy: OnFailure
```

Note in this config we are asking ACI to 'mount' a GH repo (this clones the GH repo into a folder path).

### Run container on ACI
Create the ACI:

```bash
az container create --resource-group $RG --file ./aci-configs/simple.yaml
```

It should take around 2-3minutes for the container to be provisioned.

### Get the Jupyter URL

This repo has a small bash utility script that extracts the URL to access jupyter, run this to access jupyter:

```bash
./utils/show-jupyter-url.sh $RG cpucontainergroup cpucontainer
```

When you access jupyter, you will notice that there is a directory called `repos`, which contains `azureml-examples` cloned from GitHub:

<img src="./media/simple-example.png" width="800" />

### Stop the container

To stop the container run:

```bash
az container stop --resource-group $RG --name cpucontainergroup
```
