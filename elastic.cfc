    String function convertQueryToJson(q){
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
