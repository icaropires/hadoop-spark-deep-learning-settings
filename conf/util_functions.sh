# Reset DFS deleting all old data and recreating it
reset_dfs(){
  ./$HADOOP_HOME/sbin/stop-dfs.sh

  $HADOOP_HOME/bin/hdfs namenode -format

  ./$HADOOP_HOME/sbin/start-dfs.sh

  $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/hadoop
  $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/hadoop/logs
}

# Just reboots yarn
reset_yarn(){
  bash $HADOOP_HOME/sbin/stop-yarn.sh
  bash $HADOOP_HOME/sbin/start-yarn.sh
}

# Executes a given command at all slaves computers
# Use: broadcast [command] [arg1]... [argn]
broadcast(){
  for slave in $(cat $HADOOP_CONF_DIR/slaves)
  do
    echo "$slave says:"
    ssh $slave $@
    echo
  done;
}

# Upload all files listed on file 'common_files' from this computer to all slaves
upload_conf(){
  echo -e "Syncing spark and hadoop slaves files...\n"
  cp $SPARK_CONF_DIR/slaves $HADOOP_CONF_DIR/slaves

  for slave in $(cat $HADOOP_CONF_DIR/slaves)
  do
    echo "Copying files to $slave..."

    for file in $(cat $SPARK_HADOOP_DIR/conf/common_files)
    do
      file_path=$(eval echo $file)
      scp $file_path $slave:$file_path
    done;

    echo
  done;
}
