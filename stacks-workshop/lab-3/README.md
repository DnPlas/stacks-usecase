# Media Analytics for face detection and classification

This lab is based in the [Media Analytics](https://docs.01.org/clearlinux/latest/guides/stacks/mers.html#media-analytics) example. This example shows how to perform analytics and inferences with GStreamer on CPU.

### Pre-requisites

* See pre-requisites file for lab-3

## Media analytics

In this lab we will demonstrate how to build and use a video analytics pipeline using the built-in GStreamer* package on the Media Analytics Reference Stack.
Tipically, the pipeline starts with data coming from a file or camera, which is then decoded and after that any type of inference can be run on it. Multiple inference elements can be chained together, in this example we are detecting and classifying faces.

### Instructions

>NOTE: Before running the commands below, you should set `SWS_WORKSHOP` variable to the path where the `stacks-usecase` repository lives. For example:

```bash
export SWS_WORKSHOP='/home/myuser/stacks-usecase/stacks-workshop/'
```

1. Download pre-trained models from [Open Model Zoo](https://github.com/opencv/open_model_zoo.git)

```bash
cd $SWS_WORKSHOP/lab-3/gva/open_model_zoo/tools/downloader

python3 downloader.py --list $SWS_WORKSHOP/lab-3/gva/gst-video-analytics/samples/model_downloader_configs/intel_models_for_samples.LST -o $SWS_WORKSHOP/lab-3/gva/data/models/intel
```
2. Export env variables. These variables are paths to the local resources inside $SWS_WORKSHOP/lab-3

```bash
export DATA_PATH=$SWS_WORKSHOP/lab-3/gva/data
export GVA_PATH=$SWS_WORKSHOP/lab-3/gva/gst-video-analytics
export MODELS_PATH=$SWS_WORKSHOP/lab-3/gva/data/models
export INTEL_MODELS_PATH=$SWS_WORKSHOP/lab-3/gva/data/models/intel
export VIDEO_EXAMPLES_PATH=$SWS_WORKSHOP/lab-3/gva/data/video
```

3. Run a MeRS container

```bash
docker run -it --runtime=runc --net=host \
-e HTTP_PROXY=$HTTP_PROXY \
-e HTTPS_PROXY=$HTTPS_PROXY \
-e http_proxy=$http_proxy \
-e https_proxy=$https_proxy \
-v $GVA_PATH:/home/mers-user/gst-video-analytics \
-v $INTEL_MODELS_PATH:/home/mers-user/intel_models \
-v $MODELS_PATH:/home/mers-user/models \
-v $VIDEO_EXAMPLES_PATH:/home/mers-user/video-examples \
-e MODELS_PATH=/home/mers-user/intel_models:/home/mers-user/models \
-e VIDEO_EXAMPLES_DIR=/home/mers-user/video-examples \
sysstacks/mers-clearlinux:latest
```

4. Run face dection and clasiffication script

```bash
./gst-video-analytics/samples/shell/face_detection_and_classification.sh $VIDEO_EXAMPLES_DIR/face-demographics-walking-and-pause.mp4
```
