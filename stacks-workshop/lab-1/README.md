# Data pre-preocessing for Deep Learning training

This lab is based in the [Github Issue Classification](https://github.com/intel/stacks-usecase/tree/master/github-issue-classification) usecase for auto-classifying and tagging Github* issues. This usecase can be seen as a pipeline in which the first stage, data is ingested and processed so it can be consumed by the Github Issue Classification [model](https://github.com/intel/stacks-usecase/blob/master/github-issue-classification/python/train.py) in the training stage.

### Pre-requisites

* See pre-requisites file for lab-1

## Data ingestion and processing

Data comes in a big multiline JSON file containing actual Github* issues with various attributes like submitter, issue description, issue label and date, just to name a few.

The following is a trimmed example of how the data looks like.

```bash
  {
      "url": "https://api.github.com/repos/clearlinux/distribution/issues/1515",
      "repository_url": "https://api.github.com/repos/clearlinux/distribution",
      ...
      labels": [
      {
            ...
            "name": "package-request",
"body": "With the official release of Brave 1.0, can you please add a package for this browser\r\n\r\nMore info: https://brave.com/"
  }
```

These data files often contain several attributes that are needed by the deep leraning model. Since this is a classification example, we want to match labes with the interpretation of the issue description, which can be obtained just by matching issue labels and the issue description.
As seen in the example above, we know by the `body` that the user filing that issue is requestig a package addition, so the label for that is `package-request`.

### Instructions

1. Run and log into a DARS container

```bash
cd stacks-usecase/github-issue-classification/

docker run -ti --ulimit nofile=1000000:1000000 \
-v ${PWD}:/workdir clearlinux/stacks-dars-openblas bash
```

2. Prepare the spark environment once inside the container

```bash
cd /workdir
mkdir -p data/raw
```

3. Fetch data

```bash
cd /workdir/scripts
chmod u+x get-data.sh
./get-data.sh
cd /workdir
```

This script will fetch several JSON files and merge them into just one big multiline file inside /workdir/scripts.

4. Run the `spark-shell`

```bash
spark-shell
```

### Processing the data

1. Import session and instantiate a spark context

```bash
import org.apache.spark.sql.SparkSession
val spark = SparkSession.builder.appName("github-issue-classification").getOrCreate()
import spark.implicits._
```
2. Load the data to a spark dataframe
```bash
var df = spark.read.option("multiline", true).json("file:///workdir/data/raw/*.json")
```

3. Select the labels, name, body, and id columns
```bash
df = df.select(col("body"), col("id"), col("labels.name"))
```

>NOTE: You can see how data is being processed using the `show()` method. For example:

```bash

scala> df.show()
+--------------------+---------+--------------------+
|                body|       id|                name|
+--------------------+---------+--------------------+
|I want to test ho...|501669062|       [enhancement]|
|Per the documenta...|501187985|[documentation, e...|
|The last two days...|498881243|[bug, desktop, hi...|
|In debian and Arc...|498215003|  [enhancement, new]|
|Would be great if...|498213403|[new, package-req...|
|Per [k8s setup do...|497651967| [bug, cloud-native]|
|I use workrave on...|497211770|[new, package-req...|
```

4. Explode the labels column to prepare for filtering the top labels
```bash
var df2 = df.select(col("id"),explode(col("name")).as("labels"))
```
5. Order the Labels by frequency
```bash
var df3 = df2.select("labels").groupBy("labels").count().orderBy(col("count").desc).limit(10).select("labels")
```
6. Turn the top labels into a list (to put into the next step)
```bash
var list = df3.select("labels").map(r => r.getString(0)).collect.toList
```
7. Filter the top labels
```bash
df2 = df2.filter($"labels".isin(list:_*))
```
8. Recombine the top labels
```bash
df2 = df2.groupBy("id").agg(collect_set("labels").alias("labels"))
```
9. Take intersection of label ids and body ids to get final list
```bash
df = df.join(df2, "id").select("body","labels")
```
10. Save the data
```bash
df.write.json("file:///workdir/data/tidy/")
```
