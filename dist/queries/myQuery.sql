SELECT table1.firstName, table1.lastName,
join_name1.obj, join_name2.obj2, join_name3.obj3
FROM table1
LEFT JOIN
	(
		SELECT table2.table2column1 AS table2column1,
		concat('[',
			group_concat('{', '\"JSONkey\":', table2.table2column2, ', \"JSONkey\": [', subJoinObj.subData,
			']}'),
		']') AS obj
		FROM table2
		LEFT JOIN
			(
				SELECT table3.table3column1 AS subJoinAlias,
				group_concat(
					'{','\"JSONkey\":',table3.table3column2, ', \"JSONkey\":',table4.table4column1,',\"JSONkey\":\"',table3.table3column3,'\", \"JSONkey\":\"',table3.table3column4,'\", \"JSONkey\":\"',table3.table3column5,'\", \"JSONkey\":\"',table3.table3column6,'\"}'
				) AS subData
				FROM table3
				INNER JOIN table4 ON table4.table4column2=table3.table4column3
				GROUP BY table3.table3column1
			)
		AS subJoinObj ON subJoinObj.subJoinAlias=table2.table2column2
		GROUP BY table2.table2column1
	)
AS join_name1 ON join_name1.table2column1=table1.userID
LEFT JOIN
	(
		SELECT columnName1,
		concat(
			'{','\"JSONkey\":', table2.table2column2,',\"JSONkey\":', table2.table2column3, ',\"JSONkey\":', '[',
			group_concat('{','\"JSONkey\":', table3.table3column3,',\"JSONkey\":\"',table4.table4column3,'\"}'),
			']','}') AS obj2
		FROM table2
		LEFT JOIN table3 ON table3.table3column1=table2.loadNumber
		LEFT JOIN table4 ON table4.table4column1=table3.table3column2
		WHERE table2.table2column3=2
		GROUP BY table2.table2column1
	)
AS join_name2 ON join_name2.columnName1=table1.userID
LEFT JOIN
	(
		SELECT table5column1 AS drID,
		concat('{','\"JSONkey\":', updateID,',\"JSONkey\":', IFNULL(loadNumber, 0),',\"JSONkey\":', lat,',\"JSONkey\":', lon,',\"JSONkey\":\"', `time`,'\",\"JSONkey\":\"', `date`,'\"}') AS obj3
		FROM locationUpdates
		ORDER BY updateID DESC
		LIMIT 1
	)
AS join_name3 ON join_name3.drID=table1.userID
INNER JOIN table5 ON table5.table5column1=table1.userID
WHERE table5.table5column2={{ nodeVariable }}
GROUP BY table1.firstName, table1.lastName, join_name1.obj, join_name2.obj2, join_name3.obj3
