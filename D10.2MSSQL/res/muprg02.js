import "./easyui/jquery.min.js"
//import "./dx21.2.6/Lib/js/dx.all.js"
import "https://cdn3.devexpress.com/jslib/21.2.6/js/dx.all.js"

$(function(){
  bindEvents()

    var customDataSource = new DevExpress.data.CustomStore({
        key: "EMP_ID",
        load: function(loadOptions) {
            var d = $.Deferred();
            var params = {};

            [
                "filter",
                "group",
                "groupSummary",
                "parentIds",
                "requireGroupCount",
                "requireTotalCount",
                "searchExpr",
                "searchOperation",
                "searchValue",
                "select",
                "sort",
                "skip",
                "take",
                "totalSummary",
                "userData"
            ].forEach(function(i) {
                if(i in loadOptions && isNotEmpty(loadOptions[i])) {
                    params[i] = JSON.stringify(loadOptions[i]);
                }
            });

            $.getJSON("/emp", params)
                .done(function(response) {
                    d.resolve(response.data, {
                        totalCount: response.totalCount,
                        summary: response.summary,
                        groupCount: response.groupCount
                    });
                })
                .fail(function() { throw "Data loading error" });
            return d.promise();
        },
        insert: function(values) {
            var deferred = $.Deferred();
            $.ajax({
                url: "/emp_append",
                method: "POST",
                data: JSON.stringify(values)
            })
            .done(deferred.resolve)
            .fail(function(e){
                deferred.reject("Insertion failed");
            });
            return deferred.promise();
        },
        remove: function(key) {
            var deferred = $.Deferred();
            $.ajax({
                url: "/emp_destory?key=" + encodeURIComponent(key),
                method: "DELETE"
            })
            .done(deferred.resolve)
            .fail(function(e){
                deferred.reject("Deletion failed");
            });
            return deferred.promise();
        },
        update: function(key, values) {
            var deferred = $.Deferred();
            $.ajax({
                url: "/emp_edit?key=" + encodeURIComponent(key),
                method: "PUT",
                data: JSON.stringify(values)
            })
            .done(deferred.resolve)
            .fail(function(e){
                deferred.reject("Update failed");
            });
            return deferred.promise();
        }
    });

  $('#gridContainer').dxDataGrid({
        dataSource: customDataSource,
        columns: [
          {
            caption:"員工編號",
            dataField: "EMP_ID"
          },{
            caption:"姓名",
            dataField: "NAME"
          },{
            caption:"性別",
            dataField: "SEX"
          },{
            caption:"身份證字號",
            dataField: "ROC_ID"
          },{
            caption:"出生日期",
            dataField: "BIR_DAT",
            dataType:"date"
          },{
            caption:"連絡地址",
            dataField: "C_ADD"
          },{
            caption:"到職日",
            dataField: "ARR_DAT",
            dataType:"date"
          },{
            caption:"離職日",
            dataField: "LEV_DAT",
            dataType:"date"
          }
        ],
        allowColumnReordering: true,
        remoteOperations: { groupPaging: true },
        editing: {
            mode: "batch",
            allowAdding: true,
            allowUpdating: true,
            allowDeleting: true
        }
    });
});

function bindEvents(){
  $(window).resize(function(){
    // todo
  })
}

function isNotEmpty(value) {
    return value !== undefined && value !== null && value !== "";
}
