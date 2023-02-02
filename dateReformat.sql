--This function will re-format DATETIME into different date formats
/* ================================================================================================= 
USAGE EXAMPLES
SELECT dbo.fnDateConvert (getdate(), ‘MM/DD/YYYY’)           — 01/03/2012
SELECT dbo.fnDateConvert (getdate(), ‘DD/MM/YYYY’)           — 03/01/2012
SELECT dbo.fnDateConvert (getdate(), ‘M/DD/YYYY’)            — 1/03/2012
SELECT dbo.fnDateConvert (getdate(), ‘M/D/YYYY’)             — 1/3/2012
SELECT dbo.fnDateConvert (getdate(), ‘M/D/YY’)               — 1/3/12
SELECT dbo.fnDateConvert (getdate(), ‘MM/DD/YY’)             — 01/03/12
SELECT dbo.fnDateConvert (getdate(), ‘MON DD, YYYY’)         — JAN 03, 2012
SELECT dbo.fnDateConvert (getdate(), ‘Mon DD, YYYY’)         — Jan 03, 2012
SELECT dbo.fnDateConvert (getdate(), ‘Month DD, YYYY’)       — January 03, 2012
SELECT dbo.fnDateConvert (getdate(), ‘YYYY/MM/DD’)           — 2012/01/03
SELECT dbo.fnDateConvert (getdate(), ‘YYYYMMDD’)             — 20120103
SELECT dbo.fnDateConvert (getdate(), ‘YYYY-MM-DD’)           — 2012-01-03
— CURRENT_TIMESTAMP returns current system date and time in standard internal format
SELECT dbo.fnDateConvert (CURRENT_TIMESTAMP,‘YY.MM.DD’)      — 12.01.03
==================================================================================================== */
CREATE FUNCTION dbo.fnDateConvert (@Datetime DATETIME, @FormatMask VARCHAR(32))
RETURNS VARCHAR(32)
AS
BEGIN
    DECLARE @StringDate VARCHAR(32)
    SET @StringDate = @FormatMask
    IF (CHARINDEX ('YYYY',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'YYYY',
                         DATENAME(YY, @Datetime))
    IF (CHARINDEX ('YY',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'YY',
                         RIGHT(DATENAME(YY, @Datetime),2))
    IF (CHARINDEX ('Month',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'Month',
                         DATENAME(MM, @Datetime))
    IF (CHARINDEX ('MON',@StringDate COLLATE SQL_Latin1_General_CP1_CS_AS)>0)
       SET @StringDate = REPLACE(@StringDate, 'MON',
                         LEFT(UPPER(DATENAME(MM, @Datetime)),3))
    IF (CHARINDEX ('Mon',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'Mon',
                                     LEFT(DATENAME(MM, @Datetime),3))
    IF (CHARINDEX ('MM',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'MM',
                  RIGHT('0'+CONVERT(VARCHAR,DATEPART(MM, @Datetime)),2))
    IF (CHARINDEX ('M',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'M',
                         CONVERT(VARCHAR,DATEPART(MM, @Datetime)))
    IF (CHARINDEX ('DD',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'DD',
                         RIGHT('0'+DATENAME(DD, @Datetime),2))
    IF (CHARINDEX ('D',@StringDate) > 0)
       SET @StringDate = REPLACE(@StringDate, 'D',
                                     DATENAME(DD, @Datetime))  
RETURN @StringDate
END
GO
