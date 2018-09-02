# Hadoop and Spark settings for deep learning

This repository proposes a set of configurations for working with Hadoop and Spark for processing Deep Learning tasks. For Deep Learning, this configuration integrates [Spark Deep Learning](https://github.com/databricks/spark-deep-learning) lib, that uses Keras with TensorFlow backend, so the formers are integrated too.

## Using this configuration

### Prerequisites
* You must be able to connect through ssh from all machines from to all machines without the need of password. **Including itself**.
* Fill the masters and slaves files on `HADOOP_CONF_DIR (hadoop/etc/hadoop/)` and slaves file `SPARK_CONF_DIR (spark/conf)`.

#### Hints
* **Do all steps on all machines.** _Use the functions on `util_functions.sh` to help you._
* On masters and slaves files put the machines hostnames and not slave1, slave2... etc.
* If you have a DNS server on your network, there is no need for setting up /etc/hosts files.

#### Useful functions

When setting up or configuring your cluster, you should use the bash functions on file `conf/util_functions` to facilitate the job.

If you are first configuring the cluster, you might need to source the `util_function.sh` file before any of these functions.

_For some functions to work, some part of configuration must have been done already (ssh availability for example)_

##### Functions description

###### broadcast
My favorite. Just call `broadcast [command] [arg1]... [argn]` and your command are going to be executed on all machines listed on slaves files from spark.

###### upload_conf
Upload to all slaves all files listed on `conf/common_files` file;

###### reset_dfs
Delete current DFS data and rebuild the filesystem.

###### reset_yarn
Just reboots yarn

### Minimal Configuration

#### Considerations

* All resources configurations on configuration files were set to be able to run `pneumonia.py` application at cluster deploy-mode and on a cluster with at least two machines: executor with 16GB of RAM and master with 4GB.

* For changing resources configurations you must modify `hadoop/etc/hadoop/yarn-site.xml` and `spark/conf/spark-defaults.conf`.

* Your application won't run if resource allocation doesn't reflect your hardware resources!

* If you get stuck on ACCEPTED status while submitting your application, probably your resource settings are wrong.

#### Configuring

##### Initial 
* Clone this repository and merge `spark` and `hadoop` folders with the original ones downloaded from official sources;
* Create a virtualenv named `cluster` on the same folder as `hadoop` and `spark`;
* Activate the virtualenv;
* Install all python dependencies from `requirements.txt` file.

##### Editing files
* Put the following lines on your `~/.profile` file. (Just create it if it doesn't exists).
	``` sh
 	SPARK_HADOOP_DIR=path_to_hadoop_spark_folder  # Same folder where is `hadoop` and `spark` folder
 	source SPARK_HADOOP_DIR/conf/source-me.sh
	```
* Substitute `master` hostname at `hadoop/etc/hadoop/core-site.xml` and `/hadoop/etc/hadoop/yarn-site.xml` with your master hostname;
* Set your `JAVA_HOME` at `/hadoop/etc/hadoop/hadoop-env.sh` (where your java is installed);
* Set the path for dfs data on `/hadoop/etc/hadoop/hdfs-site.xml`; _(Wherever you want)_

* `hadoop/etc/hadoop/yarn-env.sh` is here because yarn heap size was increased;
* On `spark/conf/spark-defaults.conf` substitute `<put_here_path_to_virtualenv_folder>` with what it asks and `master` with your master hostname;

* source the `~/.profile` file;
* format the dfs running the command:
```
$ reset_dfs # It is defined on util_functions.h
```
* start yarn with the command
```
$ reset_yarn # It is defined on util_functions.h
```

### Test application
The `pneumonia.py` file was the target application when setting this configuration set. It is very very simple image classificator using _Inception_ model from Google to featurizer through transfer learning and classificate using logistic regression.

#### Dataset
The dataset is available [here](https://www.kaggle.com/paultimothymooney/chest-xray-pneumonia) and must be downloaded and inserted on DFS using the command `$HADOOP_HOME/bin/hdfs dfs -put chest_xray`.

#### Running the application

For running `pneumonia.py` file on your cluster, run:
``` sh
$ $SPARK_HOME/bin/spark-submit pneumonia.py
```

If everything went ok, you should be able to see the application running on http://<master_host_name>:8088 through yarn web interface and from it access spark interface (Search ApplicationMaster link).
