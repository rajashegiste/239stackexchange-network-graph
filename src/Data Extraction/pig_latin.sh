
// extract data for quality analysis
items = LOAD '/user/cloudera/posts.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'Id="([^"]*)"', 1) AS id:int,
REGEX_EXTRACT(row, 'PostTypeId="([^"]*)"', 1) AS postTypeId:int,
REGEX_EXTRACT(row, 'AcceptedAnswerId="([^"]*)"', 1) AS acceptedAnswerId:int,
REGEX_EXTRACT(row, 'ParentId="([^"]*)"', 1) AS parentId:int,
REGEX_EXTRACT(row, 'Score="([^"]*)"', 1) AS score:int,
REGEX_EXTRACT(row, 'ViewCount="([^"]*)"', 1) AS viewCount:int,
REGEX_EXTRACT(row, 'AnswerCount="([^"]*)"', 1) AS answerCount:int,
REGEX_EXTRACT(row, 'CommentCount="([^"]*)"', 1) AS commentCount:int,
REGEX_EXTRACT(row, 'FavoriteCount="([^"]*)"', 1) AS favoriteCount:int;

// debug
DUMP data

// store in local
STORE data INTO '/user/cloudera/reuslt_posts' USING PigStorage();

// Hcatalog: create the table manually before loading the data
STORE data INTO 'posts_table' USING org.apache.hcatalog.pig.HCatStorer();

__________________________________________________________________________________________________________
__________________________________________________________________________________________________________


// extract links in comments
items = LOAD '/user/cloudera/comment_link_data.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'PostId="([^"]*)"', 1) AS postId:int,
REGEX_EXTRACT(row, 'Text="([^"]*)"', 1) AS relatedPostId:int,
REGEX_EXTRACT(row, 'UserId="([^"]*)"', 1) AS userId:int;

__________________________________________________________________________________________________________
__________________________________________________________________________________________________________


// extract link-data
items = LOAD '/user/cloudera/postLinks.xml' USING org.apache.pig.piggybank.storage.XMLLoader('row') AS (row:chararray);

data = FOREACH items GENERATE
REGEX_EXTRACT(row, 'PostId="([^"]*)"', 1) AS postId:int,
REGEX_EXTRACT(row, 'RelatedPostId="([^"]*)"', 1) AS relatedPostId:int,
REGEX_EXTRACT(row, 'LinkTypeId="([^"]*)"', 1) AS linkTypeId:int;

__________________________________________________________________________________________________________
__________________________________________________________________________________________________________

Reference:
http://stackoverflow.com/questions/22434300/possible-to-use-hcatalog-with-xml-doing-etl-on-cloudera-vm
http://stackoverflow.com/questions/22627693/pig-not-loading-data-into-hcatalog-table-hortonworks-sandbox