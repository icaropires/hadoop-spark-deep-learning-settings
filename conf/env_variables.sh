# Add the following lines to .profile:
# 	SPARK_HADOOP_DIR=path_to_hadoop_spark_folder
# 	source SPARK_HADOOP_DIR/conf/source-me.sh

export SPARK_HOME=$SPARK_HADOOP_DIR/spark
export SPARK_CONF_DIR=$SPARK_HOME/conf

export HADOOP_HOME=$SPARK_HADOOP_DIR/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native

export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH

export PATH=$PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
