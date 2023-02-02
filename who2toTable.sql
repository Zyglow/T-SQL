CREATE DATABASE DBA
GO
     
USE DBA;

CREATE TABLE spwho2
    (
      SPID INT,
      Status VARCHAR (1000) NULL,
      Login SYSNAME NULL,
      HostName SYSNAME NULL,
      BlkBy SYSNAME NULL,
      DBName SYSNAME NULL,
      Command VARCHAR(1000 ) NULL,
      CPUTime INT NULL,
      DiskIO INT NULL,
      LastBatch VARCHAR(1000 ) NULL,
      ProgramName VARCHAR(1000 ) NULL,
      SPID2 INT
      , rEQUESTID INT NULL --comment out for SQL 2000 databases

    )

        insert into spwho2
        exec sp_who2


       select *
        from spwho2
