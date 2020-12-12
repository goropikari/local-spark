```
$ docker-compose build
$ docker-compose up -d
$ docker-compose exec spark bash
# aws s3 mb s3://hoge --endpoint-url http://localstack:4566
```

ローカルに parquet を出力することはできるけど、localstack の s3 に出力しようとすると失敗する。

```
scala> val seq = Seq((1, "hoge"), (2,"piyo"))
seq: Seq[(Int, String)] = List((1,hoge), (2,piyo))

scala> val df = seq.toDF()
df: org.apache.spark.sql.DataFrame = [_1: int, _2: string]

scala> df.write.mode("overwrite").format("parquet").save("s3://hoge/")
20/12/12 05:10:15 WARN MetricsConfig: Cannot locate configuration: tried hadoop-metrics2-s3a-file-system.properties,hadoop-metrics2.properties
java.lang.IllegalArgumentException: Can not create a Path from an empty string
  at org.apache.hadoop.fs.Path.checkPathArg(Path.java:168)
  at org.apache.hadoop.fs.Path.<init>(Path.java:180)
  at org.apache.hadoop.fs.Path.<init>(Path.java:125)
  at org.apache.hadoop.fs.Path.suffix(Path.java:446)
  at org.apache.spark.sql.execution.datasources.InsertIntoHadoopFsRelationCommand.deleteMatchingPartitions(InsertIntoHadoopFsRelationCommand.scala:230)
  at org.apache.spark.sql.execution.datasources.InsertIntoHadoopFsRelationCommand.run(InsertIntoHadoopFsRelationCommand.scala:129)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.sideEffectResult$lzycompute(commands.scala:108)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.sideEffectResult(commands.scala:106)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.doExecute(commands.scala:131)
  at org.apache.spark.sql.execution.SparkPlan.$anonfun$execute$1(SparkPlan.scala:175)
  at org.apache.spark.sql.execution.SparkPlan.$anonfun$executeQuery$1(SparkPlan.scala:213)
  at org.apache.spark.rdd.RDDOperationScope$.withScope(RDDOperationScope.scala:151)
  at org.apache.spark.sql.execution.SparkPlan.executeQuery(SparkPlan.scala:210)
  at org.apache.spark.sql.execution.SparkPlan.execute(SparkPlan.scala:171)
  at org.apache.spark.sql.execution.QueryExecution.toRdd$lzycompute(QueryExecution.scala:122)
  at org.apache.spark.sql.execution.QueryExecution.toRdd(QueryExecution.scala:121)
  at org.apache.spark.sql.DataFrameWriter.$anonfun$runCommand$1(DataFrameWriter.scala:963)
  at org.apache.spark.sql.execution.SQLExecution$.$anonfun$withNewExecutionId$5(SQLExecution.scala:100)
  at org.apache.spark.sql.execution.SQLExecution$.withSQLConfPropagated(SQLExecution.scala:160)
  at org.apache.spark.sql.execution.SQLExecution$.$anonfun$withNewExecutionId$1(SQLExecution.scala:87)
  at org.apache.spark.sql.SparkSession.withActive(SparkSession.scala:764)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:64)
  at org.apache.spark.sql.DataFrameWriter.runCommand(DataFrameWriter.scala:963)
  at org.apache.spark.sql.DataFrameWriter.saveToV1Source(DataFrameWriter.scala:415)
  at org.apache.spark.sql.DataFrameWriter.save(DataFrameWriter.scala:399)
  at org.apache.spark.sql.DataFrameWriter.save(DataFrameWriter.scala:288)
  ... 47 elided
```
