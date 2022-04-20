import "./easyui/jquery.min.js"
import "./easyui/jquery.easyui.min.js"

var url = '';

$(function(){
  bindEvents()

  //Draw components
  $('#dg').datagrid({
    //url: '/emp',
    //saveUrl: '/dept_append',
    //updateUrl: '/dept_edit',
    //destroyUrl: '/dept_destory',
    view: buildCardView(),
    //idField:"EMP_ID",
    //pagination:true,
    //rownumbers:true,
    //fitColumns:true,
    //singleSelect:true,
  });
});

function bindEvents(){
  $(window).resize(function(){
    $("#dg").edatagrid("resize")
  })

  $("#btnAdd").bind("click", ()=>{
    newUser()
  })

  $("#btnDestory").bind("click", ()=>{
    $('#dg').edatagrid('deleteRow')
  })

  $("#btnSave").bind("click", ()=>{
    $('#dg').edatagrid('saveRow')
  })

  $("#btnCancel").bind("click", ()=>{
    $('#dg').edatagrid('cancelRow')
  })
}

function buildCardView(){
  return $.extend({}, $.fn.datagrid.defaults.view, {
                renderRow: function(target, fields, frozen, rowIndex, rowData){
                    var cc = [];
                    cc.push('<td colspan=' + fields.length + ' style="padding:10px 5px;border:0;">');
                    if (!frozen && rowData.EMP_ID){
                        cc.push('<div style="float:left;margin-left:20px;">');
                        for(var i=0; i<fields.length; i++){
                            var copts = $(target).datagrid('getColumnOption', fields[i]);
                            cc.push('<p><span class="c-label">' + copts.title + ':</span> ' + rowData[fields[i]] + '</p>');
                        }
                        cc.push('</div>');
                    }
                    cc.push('</td>');
                    return cc.join('');
                }
        })
}

function newUser(){
    $('#dlg').dialog('open').dialog('center').dialog('setTitle','New User');
    $('#fm').form('clear');
    url = 'save_user.php';
}
