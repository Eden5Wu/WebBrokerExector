import "./easyui/jquery.min.js"
import "./easyui/jquery.easyui.min.js"
import "./easyui/jquery.edatagrid.js"

$(function(){
  bindEvents()

  //Draw components
  $('#dg').edatagrid({
    url: '/dept',
    saveUrl: '/dept_append',
    updateUrl: '/dept_edit',
    destroyUrl: '/dept_destory',
    columns:[[
      {field:"DEPT_ID", title:"部門編號", width:50, editor:{type:"validatebox",options:{required:true}}},
      {field:"DEPT_NAM", title:"部門名稱", width:50, editor:{type:"validatebox",options:{required:true}}}
    ]],
    idField:"DEPT_ID",
    pagination:true,
    rownumbers:true,
    fitColumns:true,
    singleSelect:true,
  });
});

function bindEvents(){
  $(window).resize(function(){
    $("#dg").edatagrid("resize")
  })

  $("#btnAdd").bind("click", ()=>{
    $('#dg').edatagrid('addRow')
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
