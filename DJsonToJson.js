let originalObj = {
  "table":[
    ["EmpNo",6,0,0,0,4,0,0,true,false,0,false,false],
    ["LastName",26,1,32,0,21,20,0,true,false,0,false,false],
    ["FirstName",26,2,32,0,16,15,0,true,false,0,false,false],
    ["PhoneExt",26,3,32,0,5,4,0,true,false,0,false,false],
    ["HireDate",24,4,0,0,16,0,0,true,false,0,false,false],
    ["Salary",7,5,0,0,8,15,0,true,false,0,false,false]
  ],
  "EmpNo":[2,4,5,8,9,11,12,14,15,20,24,28,29,34,36,37,44,45,46,52,61,65,71,72,83,85,94,105,107,109,110,113,114,118,121,127,134,136,138,141,144,145],
  "LastName":[
    "Nelson","Young","Lambert","Johnson","Forest","Weston","Lee","Hall","Young","Papadopoulos","Fisher","Bennet","De Souza","Baldwin","Reeves",
    "Stansbury","Phong","Ramanathan","Steadman","Nordstrom","Leung","O'Brien","Burbank","Sutherland","Bishop","MacDonald","Williams","Bender",
    "Cook","Brown","Ichida","Page","Parker","Yamamoto","Ferrari","Yanowski","Glon","Johnson","Green","Osborne","Montgomery","Guckenheimer"
  ],
  "FirstName":[
    "Roberto","Bruce","Kim","Leslie","Phil","K. J.","Terri","Stewart","Katherine","Chris","Pete","Ann","Roger","Janet","Roger",
    "Willie","Leslie","Ashok","Walter","Carol","Luke","Sue Anne","Jennifer M.","Claudia","Dana","Mary S.","Randy","Oliver H.","Kevin","Kelly",
    "Yuki","Mary","Bill","Takashi","Roberto","Michael","Jacques","Scott","T.J.","Pierre","John","Mark"
  ],
  "PhoneExt":[
    "250","233","22","410","229","34","256","227","231","887","888","5","288","2","6","7","216","209","210","420","3","877","289",null,"290","477",
    "892","255","894","202","22","845","247","23","145","492",null,"265","218",null,"820","221"
  ],
  "HireDate":[
    "1988-12-28T00:00:00.000+08:00","1988-12-28T00:00:00.000+08:00","1989-02-06T00:00:00.000+08:00","1989-04-05T00:00:00.000+08:00",
    "1989-04-17T00:00:00.000+08:00","1990-01-17T00:00:00.000+08:00","1990-05-01T00:00:00.000+08:00","1990-06-04T00:00:00.000+08:00",
    "1990-06-14T00:00:00.000+08:00","1990-01-01T00:00:00.000+08:00","1990-09-12T00:00:00.000+08:00","1991-02-01T00:00:00.000+08:00",
    "1991-02-18T00:00:00.000+08:00","1991-03-21T00:00:00.000+08:00","1991-04-25T00:00:00.000+08:00","1991-04-25T00:00:00.000+08:00",
    "1991-06-03T00:00:00.000+08:00","1991-08-01T00:00:00.000+08:00","1991-08-09T00:00:00.000+08:00","1991-10-02T00:00:00.000+08:00",
    "1992-02-18T00:00:00.000+08:00","1992-03-23T00:00:00.000+08:00","1992-04-15T00:00:00.000+08:00","1992-04-20T00:00:00.000+08:00",
    "1992-06-01T00:00:00.000+08:00","1992-06-01T00:00:00.000+08:00","1992-08-08T00:00:00.000+08:00","1992-10-08T00:00:00.000+08:00",
    "1993-02-01T00:00:00.000+08:00","1993-02-04T00:00:00.000+08:00","1993-02-04T00:00:00.000+08:00","1993-04-12T00:00:00.000+08:00",
    "1993-06-01T00:00:00.000+08:00","1993-07-01T00:00:00.000+08:00","1993-07-12T00:00:00.000+08:00","1993-08-09T00:00:00.000+08:00",
    "1993-08-23T00:00:00.000+08:00","1993-09-13T00:00:00.000+08:00","1993-11-01T00:00:00.000+08:00","1994-01-03T00:00:00.000+08:00",
    "1994-03-30T00:00:00.000+08:00","1994-05-02T00:00:00.000+08:00"
  ],
  "Salary":[
    40000,55500,25000,25050,25050,33292.9375,45332,34482.625,24400,25050,23040,34482.8,25500,23300,33620,39224,40350,33292.94,19599,4500,34500,
    31275,45332,35699,45000,35699,28900,36799,35500,27000,25689,48000,35000,32500,40500,44000,24855,30588.99,36000,35600,35699,32000
  ]
}



// 資料轉換器
function covData( dsJSON ) {
    let originalTable = dsJSON.table;
    // 如果 原始資料表 有效
    if( !Array.isArray( originalTable ) ) {
        return [ { err: `原始資料表不是陣列格式！ (${typeof originalTable})` } ];
    }
    else if( originalTable.length === 0 ) {
        return [ { err: `原始資料表的長度是零！` } ];
    }
    else if( originalTable[ 0 ].length === 0 ) {
        return [ { err: `原始資料表的第一個欄位是空的！` } ];
    }



    /** 物件 的 欄位 列表 */
    let columnNameList = originalTable.map( x => x[ 0 ] );

    /** 物件 數量 */
    let recordCount = ( dsJSON[ columnNameList[ 0 ] ].length || 0 ); // 要創建多少物件


    // 先檢查 各個欄位的數據 是否 存在 ，有缺的話，就報錯吧
    for( let i = 0, iMax = columnNameList.length; i < iMax; i++ ) { // 注意: 因為 forEach 不能被中斷，所以這邊不能用 forEach 只能用傳統的 for 迴圈。

        /** 欄位 名稱 */
        let colName = columnNameList[ i ];

        // 格式不對
        if( !Array.isArray( dsJSON[ colName ] ) ) {
            return [ { err: `缺少 ${colName} 欄位。` } ];
        }

        // 長度不對
        if( dsJSON[ colName ].length != recordCount ) {
            return [ { err: `欄位 ${colName} 的長度，應該是 ${recordCount} 但實際上卻是 ${dsJSON[ colName ].length} 。` } ];
        }

    }    

    /** 結果陣列 (輸出用) */
    let resultArray = [];

    // 依序 創建 需要的物件
    for( let i = 0; i < recordCount; i++ ) {

        // 臨時 創建 一個空物件
        let tmp = {};

        // 依序 給物件填入 需要的 欄位 與 數據
        for (let colPos in columnNameList)       {
          const colName = columnNameList[colPos];
          
          /** 欄位 數據 */
          let colValue = dsJSON[ colName ][ i ];

          // 如果 欄位數據是物件或函式 ，也就是 多階層的子物件 的 情況，這比較麻煩...
          if( typeof colValue == 'object' || typeof colValue == 'function' ) {
            colValue = null; // 暫時想不到好的方案，那就先用 null 代替吧
          }

          // 給物件填入 欄位名 與 數據
          tmp[ colName ] = colValue;
        }

        // 將創好的物件 放進 結果陣列
        resultArray.push( tmp );
    }


    // 輸出 結果陣列
    return resultArray;
}



// 運作看看
let results = covData( originalObj );

// 將 結果 印出來，看一下。
console.log( `轉換後的結果 (共 ${results.length} 筆) : ${JSON.stringify( results, null, 4 )}` );