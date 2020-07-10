# Handwritten Digit Recognition

This lab is based on the [Handwritten Digit Recognition](https://github.com/intel/stacks-usecase/tree/master/handwritten_digit_recog) usecase, a handwritten digit recognition example using the Deep Learning Reference Stack, Pytorch and MNIST.

### Pre-requisites

* See pre-requisites README.

### Set up environment variables

```bash
export TYPE=oss
export REGISTRY=stacks-workshop
```

>NOTE: Before running the commands below, you should set `SWS_WORKSHOP` variable to the path where the `stacks-usecase` repository lives. For example:

```bash
export SWS_WORKSHOP='/home/myuser/stacks-usecase/'
```

### Run a make

Behind the scenes, this is running a docker build, building the docker images we pulled so that we can run them as containers.

```bash
make
```

### Train

Lets train our model to recognize handwritten digits by running the docker container.

```bash
mkdir models
docker run --rm -ti -v ${PWD}/models:/workdir/models $REGISTRY/dlrs-train-$TYPE:latest "-s train"
```

### Serving the model for live classification

Let’s test our model by having it predict some digits.

In another terminal, 

* cd into the repo again, $SWS_WORKSHOP/handwritten_digit_recog.

* Setup the TYPE and REGISTRY environment variables again.

* Run the docker container which serves the model for classification.

```bash
### IN A NEW TERMINAL
cd $SWS_WORKSHOP/handwritten_digit_recog
export TYPE=oss
export REGISTRY=stacks-workshop
docker run -p 5059:5059 -it -v ${PWD}/models:/workdir/models $REGISTRY/dlrs-serve-$TYPE:latest "-s serve"
```

### Test

In our original terminal, make a request to classify a digit.

```bash
### IN ORIGINAL TERMINAL

curl -i -X POST -d 'Classify' http://localhost:5059/digit_recognition/classify
```

We should see something like shown below.
The response to the CURL command is the digit the model we trained and served predicted.

```bash
...HTTP headers…

{“Prediction”:0}
```

### Website

We have created a simple website template for you to interact with.

```bash
### IN ORIGINAL TERMINAL
docker run --rm -p 8080:5000 -it $REGISTRY/dlrs-website:latest --website_endpoint 0.0.0.0
Open localhost:8080 on a web browser
```