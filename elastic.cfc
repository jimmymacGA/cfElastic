/**
*
* @file elastic.cfc
* @author  James Mccullough
* @description a set of utilities for handling Elasticsearch results with Coldfusion
*
*/

component output="false" displayname="Elastic"  {
    public function init(){
        return this;
    }
    public string function convertQueryToJson(q){
      if(q.recordCount eq 0 ){

          return [];
      }
        var columnListArray = getMetaData(q);
        var dataArray = [];
        for (row in q) {
            var emptyData = [];
                    for (col in    columnListArray) {
                        if(listFindNoCase(this.numberTypesList, col.TypeName)){

                            if(Trim(row[col.name])  eq '' or Trim(row[col.name])  eq 'null'   ) {

                                ArrayAppend(emptyData, '"' & col.name & '":null');

                            }
                            else {
                             ArrayAppend(emptyData, '"' & col.name & '":' &   JsStringFormat(row[col.name])  );
                            }

                            
                        }
                        else {
                            if(Trim(row[col.name])  eq '' or Trim(row[col.name])  eq 'null') {

                                ArrayAppend(emptyData, '"' & col.name & '":null');

                            }
                            else {
                            ArrayAppend(emptyData, '"' & col.name & '":"'  & Replace(JsStringFormat(row[col.name]),"\'", "'",  "ALL" ) & '"');
                            }
                        }
                    }
          tempStr = "{"  & ArrayToList(emptyData) & "}";
        
            arrayAppend(dataArray, tempStr);
        }
      return "[" &  ArrayToList(dataArray) & "]";
      }
    public query function convertElasticToQuery(jsonStr) {

          var results     = deserializeJson(jsonStr).hits;
          var totalResults  = results.total;
          var numRows     = ArrayLen(results.hits) ;
          var structKeys    = StructKeyList(results.hits[1]._source);

          var localQuery    = QueryNew(structKeys);
          for (hit  in results.hits) {
            queryAddRow(localQuery, 1);
                for(var i = 1 ; i <= ListLen(structKeys); i ++){
                    if(structKeyExists(structKeys, i)){
                        querySetCell(localQuery, ListGetAt(structKeys, i), hit._source[ListGetAt(structKeys, i)], localQuery.recordcount);
                    } else {
                        querySetCell(localQuery, ListGetAt(structKeys, i), "", localQuery.recordcount);
                    }
                }
            }
        
        return localQuery;
      }

}
