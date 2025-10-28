echo "===== Starting Practical 6: HBase, Zookeeper, and Oozie ====="

# --------------------------------------------------------------
# Step 1: Start Hadoop and Zookeeper services
# --------------------------------------------------------------
echo ">>> Starting Hadoop and Zookeeper..."
start-dfs.sh
start-yarn.sh
zkServer.sh start

# --------------------------------------------------------------
# Step 2: Check HBase installation and version
# --------------------------------------------------------------
echo ">>> Checking HBase version..."
hbase version

# --------------------------------------------------------------
# Step 3: Start HBase services
# --------------------------------------------------------------
echo ">>> Starting HBase..."
start-hbase.sh

# --------------------------------------------------------------
# Step 4: Create and manage an HBase table using shell commands
# --------------------------------------------------------------
echo ">>> Launching HBase shell to create and modify a table..."

hbase shell <<EOF
create 'student', 'info'
put 'student', '1', 'info:name', 'Nancy'
put 'student', '1', 'info:course', 'Big Data'
put 'student', '1', 'info:marks', '90'
scan 'student'
get 'student', '1'
delete 'student', '1', 'info:marks'
scan 'student'
EOF

# --------------------------------------------------------------
# Step 5: Configure and verify Zookeeper status
# --------------------------------------------------------------
echo ">>> Checking Zookeeper status..."
zkServer.sh status

# --------------------------------------------------------------
# Step 6: Demonstrate Oozie workflow (Hive or Pig automation)
# --------------------------------------------------------------
echo ">>> Demonstrating Oozie Workflow setup..."

# Define directories (example paths)
mkdir -p /home/nancy/oozie_workflow
cd /home/nancy/oozie_workflow

# Sample Oozie workflow XML
cat > workflow.xml <<OOZIE
<workflow-app name="sample-wf" xmlns="uri:oozie:workflow:0.5">
    <start to="run-pig"/>
    <action name="run-pig">
        <pig>
            <script>sample_script.pig</script>
        </pig>
        <ok to="end"/>
        <error to="fail"/>
    </action>
    <kill name="fail">
        <message>Workflow failed!</message>
    </kill>
    <end name="end"/>
</workflow-app>
OOZIE

# Sample Pig script for Oozie
cat > sample_script.pig <<PIG
A = LOAD '/user/nancy/input/data.csv' USING PigStorage(',') AS (id:int, name:chararray, marks:int);
B = FILTER A BY marks > 60;
STORE B INTO '/user/nancy/output/high_scorers' USING PigStorage(',');
PIG

echo ">>> Oozie workflow files created successfully!"

# --------------------------------------------------------------
# Step 7: Stop all services
# --------------------------------------------------------------
echo ">>> Stopping all services..."
stop-hbase.sh
zkServer.sh stop
stop-yarn.sh
stop-dfs.sh

echo "===== Practical 6 Completed Successfully ====="
