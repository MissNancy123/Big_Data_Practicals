# Step 1: Check Hadoop version
hadoop version

# Step 2: Format NameNode (only first time)
hdfs namenode -format

# Step 3: Start HDFS and YARN services
start-dfs.sh
start-yarn.sh

# Step 4: Verify running daemons
jps
# Expected: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager

# Step 5: Create directories in HDFS
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/nancy

# Step 6: List HDFS directories
hdfs dfs -ls /user

# Step 7: Create a sample text file locally
echo "Welcome to Hadoop Practical 1" > sample.txt

# Step 8: Upload file to HDFS
hdfs dfs -put sample.txt /user/nancy/

# Step 9: List files in HDFS directory
hdfs dfs -ls /user/nancy/

# Step 10: Display file content from HDFS
hdfs dfs -cat /user/nancy/sample.txt

# Step 11: Verify block replication details
hdfs fsck /user/nancy/sample.txt -files -blocks -locations

# Step 12: Check overall cluster health report
hdfs dfsadmin -report

# Step 13: Stop all Hadoop services after completion
stop-dfs.sh
stop-yarn.sh
