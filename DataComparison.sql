****************************************************
** --- Clean up of the Excel Source Data File --- **
**---- Fund Duplicate Values ------------------**
**---- Perform Additonal Research if need it --**
****************************************************

 USE [User_FT]
 GO


 ---1.  ***Import Data Source File into database. Update to correct File name. Ruun DELETE query to delete an empty rows in the file. 
 --------- Run UPDATE query below to clean every field and delete extra spaces***

DELETE FROM [dbo].[Graphics]
WHERE [SYS] is null

UPDATE AN
SET 
 [SYS]= CASE WHEN [SYS]= '' THEN  NULL ELSE LTRIM(RTRIM(RIGHT('0000' + CAST([sys] as varchar(4)), 4))) END
,PRIN = CASE WHEN [PRIN]= '' THEN  NULL ELSE LTRIM(RTRIM(RIGHT('0000' + CAST([PRIN] as varchar(4)), 4))) END
,AGNT = CASE WHEN [AGNT]= '' THEN  NULL ELSE  LTRIM(RTRIM(RIGHT('0000' + CAST([AGNT] as varchar(4)), 4))) END
,[GraphicID1] = CASE WHEN [GraphicID1]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID1])) END
,[GraphicID2] = CASE WHEN [GraphicID2]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID2])) END
,[GraphicID3] = CASE WHEN [GraphicID3]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID3])) END
,[GraphicID4] = CASE WHEN [GraphicID4]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID4])) END
,[GraphicID5] = CASE WHEN [GraphicID5]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID5])) END
,[GraphicID6] = CASE WHEN [GraphicID6]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID6])) END
,[GraphicID7] = CASE WHEN [GraphicID7]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID7])) END
,[GraphicID8] = CASE WHEN [GraphicID8]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID8])) END
,[GraphicID9] = CASE WHEN [GraphicID9]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID9])) END
,[GraphicID10] = CASE WHEN [GraphicID10]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID10])) END
,[GraphicID11] = CASE WHEN [GraphicID11]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID11])) END
,[GraphicID12] = CASE WHEN [GraphicID12]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID12])) END
,[GraphicID13] = CASE WHEN [GraphicID13]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID13])) END
,[GraphicID14] = CASE WHEN [GraphicID14]= '' THEN  NULL ELSE LTRIM(RTRIM([GraphicID14])) END

--select *
FROM  [dbo].[Graphics] as AN


---2.  ***Run UPDATE query to make update in Fields Graphics values if value exists*** 

UPDATE AN
  SET [GraphicID1] = CASE WHEN [GraphicID1]=NULL THEN [GraphicID2] ELSE [GraphicID1] END
     ,[GraphicID2] = CASE WHEN [GraphicID2]=NULL THEN [GraphicID3] ELSE [GraphicID2] END
	 ,[GraphicID3] = CASE WHEN [GraphicID3]=NULL THEN [GraphicID4] ELSE [GraphicID3] END
	 ,[GraphicID4] = CASE WHEN [GraphicID4]=NULL THEN [GraphicID5] ELSE [GraphicID4] END
	 ,[GraphicID5] = CASE WHEN [GraphicID5]=NULL THEN [GraphicID6] ELSE [GraphicID5] END
	 ,[GraphicID6] = CASE WHEN [GraphicID6]=NULL THEN [GraphicID7] ELSE [GraphicID6] END
	 ,[GraphicID7] = CASE WHEN [GraphicID7]=NULL THEN [GraphicID8] ELSE [GraphicID7] END
	 ,[GraphicID8] = CASE WHEN [GraphicID8]=NULL THEN [GraphicID9] ELSE [GraphicID8] END
	 ,[GraphicID9] = CASE WHEN [GraphicID9]=NULL THEN [GraphicID10] ELSE [GraphicID9] END
	 ,[GraphicID10] = CASE WHEN [GraphicID10]=NULL THEN [GraphicID11] ELSE [GraphicID10] END
	 ,[GraphicID11] = CASE WHEN [GraphicID11]=NULL THEN [GraphicID12] ELSE [GraphicID11] END
	 ,[GraphicID12] = CASE WHEN [GraphicID12]=NULL THEN [GraphicID13] ELSE [GraphicID12] END
	 ,[GraphicID13]= CASE WHEN [GraphicID13]=NULL THEN [GraphicID14] ELSE [GraphicID13] END
	 
---select *
     FROM [dbo].[Graphics] as AN
	
  

 ---3.  ***Insert extra column to concatinate SYS, PRIN, AGNT. Run ALTER queries below ***

ALTER TABLE [dbo].[Graphics] ADD SPA nvarchar(255)


 ---4.  ***Run UPDATE query to update field SPA and look for duplicate values***

UPDATE AN
SET SPA = LTRIM(RTRIM(RIGHT('0000' + CAST([sys] as varchar(4)), 4))) +  LTRIM(RTRIM(RIGHT('0000' + CAST(prin as varchar(4)), 4))) +  LTRIM(RTRIM(RIGHT('0000' + CAST(AGNT as varchar(4)),4)))
FROM [dbo].[Graphics] as AN

UPDATE AN
SET SPA =LTRIM(RTRIM(SPA))
FROM [dbo].[Graphics] as AN


SELECT SPA, COUNT(SPA) AS SPA_COUNT
FROM [dbo].[Graphics]
GROUP BY SPA
HAVING COUNT(SPA) > 1

 ---5.  ***Run UPDATE query to Compare Fields GraphicID1,GraphicID2,GraphicID3,GraphicID4,GraphicID5,GraphicID6,GraphicID7,GraphicID8,GraphicID9,GraphicID10,GraphicID11,GraphicID12,GraphicID13,GraphicID14***


SELECT SYS
      ,PRIN
      ,AGNT
	   ,GRAPHICVALUE
FROM (
      SELECT SYS
            ,PRIN
            ,AGNT
			,GRAPHICVALUE
            ,ROW_NUMBER() OVER (
                  PARTITION BY SYS
                  ,PRIN
                  ,AGNT
				  ,GRAPHICVALUE ORDER BY PVT.GRAPHICVALUE
                  ) AS SEQ
      FROM (
            SELECT SYS
                  ,PRIN
                  ,AGNT 
				  ,COALESCE(GraphicID1,'') GraphicID1
                  ,COALESCE(GraphicID2,'') GraphicID2
                  ,COALESCE(GraphicID3,'') GraphicID3
                  ,COALESCE(GraphicID4,'') GraphicID4
                  ,COALESCE(GraphicID5,'') GraphicID5
                  ,COALESCE(GraphicID6,'') GraphicID6
                  ,COALESCE(GraphicID7,'') GraphicID7
                  ,COALESCE(GraphicID8,'') GraphicID8
				  ,COALESCE(GraphicID9,'') GraphicID9
				  ,COALESCE(GraphicID10,'') GraphicID10
				  ,COALESCE(GraphicID11,'') GraphicID11
				  ,COALESCE(GraphicID12,'') GraphicID12
				  ,COALESCE(GraphicID13,'') GraphicID13
				  ,COALESCE(GraphicID14,'') GraphicID14
																															          
            FROM [dbo].[Graphics]
            ) P
      UNPIVOT(GRAPHICVALUE FOR GRAPHIC IN (GraphicID1,GraphicID2
	  ,GraphicID3,GraphicID4,GraphicID5,GraphicID6,GraphicID7,GraphicID8,GraphicID9,GraphicID10,GraphicID11,GraphicID12,GraphicID13,GraphicID14
	  )) PVT
	  WHERE GRAPHICVALUE <> '' 
      ) FIN
WHERE SEQ > 1


 ---7.  ***Create Temp Table and run INSERT query below to add only dustinct Images.*** 

  CREATE TABLE #TEMP
  (TOTAL_PAGES NVARCHAR(255) )

  INSERT INTO #TEMP (TOTAL_PAGES)
  SELECT ([GraphicID1]) 
  FROM [dbo].[Graphics]
  UNION 
  SELECT ([GraphicID2]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID3]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID4]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID5]) 
  FROM [dbo].[Graphics]
  UNION
  SELECT ([GraphicID6]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID7]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID8]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID9]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID10]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID11]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID12]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID13]) 
  FROM [dbo].[Graphics] 
  UNION
  SELECT ([GraphicID14]) 
  FROM [dbo].[Graphics]

DELETE FROM #TEMP
WHERE TOTAL_PAGES IS NULL

SELECT DISTINCT*
FROM #TEMP

 ---8.  ***Run SELECT query to see all all IMAGES. RESULTS COPY and PASTE to EXCEL to continue comparison. After Images are copied in EXCEL,  Run DROP TABLE query, to Clean up your database*** 

  SELECT DISTINCT TOTAL_PAGES, [ImageName] 
  FROM #TEMP
  left join  [dbo].[verify png]
  on TOTAL_PAGES = [ImageName]
  where TOTAL_PAGES is null or  [ImageName] is null


  SELECT DISTINCT TOTAL_PAGES, [ImageName] 
  FROM #TEMP
  left join  [dbo].[verify tif]
  on TOTAL_PAGES = [ImageName]
  where TOTAL_PAGES is null or  [ImageName] is null

  DROP TABLE #TEMP



   ALTER TABLE [dbo].[Graphics] DROP COLUMN  [F19]
  
   DROP TABLE [dbo].[Graphics]