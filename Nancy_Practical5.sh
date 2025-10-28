# Step 1: Check Hadoop and Sqoop Installation
hadoop version
sqoop version

# Step 2: Import Data from MySQL to HDFS using Sqoop
# (Replace username, password, and database/table name with your actual details)
sqoop import \
--connect jdbc:mysql://localhost:3306/studentdb \
--username root \
--password root123 \
--table students \
--target-dir /user/nancy/sqoop_import_students \
--m 1

# Step 3: Verify imported data in HDFS
hdfs dfs -ls /user/nancy/sqoop_import_students
hdfs dfs -cat /user/nancy/sqoop_import_students/part-m-00000

# Step 4: Export processed data from HDFS back to MySQL
# (Assume we processed it and stored in /user/nancy/sqoop_export_students)
sqoop export \
--connect jdbc:mysql://localhost:3306/studentdb \
--username root \
--password root123 \
--table students_processed \
--export-dir /user/nancy/sqoop_export_students \
--input-fields-terminated-by ','

# Step 5: Configure Apache Flume to collect log/streaming data
# Create a Flume configuration file (flume.conf)
echo "
agent1.sources = src1
agent1.sinks = sink1
agent1.channels = ch1

agent1.sources.src1.type = exec
agent1.sources.src1.command = tail -F /home/cloudera/logs/app.log

agent1.sinks.sink1.type = hdfs
agent1.sinks.sink1.hdfs.path = hdfs://localhost:9000/user/nancy/flume_logs/
agent1.sinks.sink1.hdfs.fileType = DataStream

agent1.channels.ch1.type = memory
agent1.channels.ch1.capacity = 1000
agent1.channels.ch1.transactionCapacity = 100

agent1.sources.src1.channels = ch1
agent1.sinks.sink1.channel = ch1
" > flume.conf

# Step 6: Start Flume Agent
flume-ng agent --conf . --conf-file flume.conf --name agent1 -Dflume.root.logger=INFO,console

# Step 7: Verify data ingestion in HDFS
hdfs dfs -ls /user/nancy/flume_logs/
hdfs dfs -cat /user/nancy/flume_logs/*

