import "./easyui/jquery.min.js"
import "./easyui/jquery.easyui.min.js"

const fakeTree = [
  {"id":"1111","text":"基本資料",
    "children":[
      {"text":"部門代碼維護","attributes":{"url":"./subforms/muprg01.html"}},
      {"text":"員工基本資料維護","attributes":{"url":"./subforms/muprg02.html"}}
    ]
  },
  {"id":"2222","text":"參數設定",
    "children":[
      {"text":"薪資參數設定","attributes":{"url":"./subforms/muprg03.html"}},
      {"text":"員工基本資料維護","attributes":{"url":"./subforms/muprg04.html"}}
    ]
  },
  {"id":"3333","text":"交易作業",
    "children":[
      {"text":"出勤資料輸入","attributes":{"url":"./subforms/muprg05.html"}},
      {"text":"員工薪資管理","attributes":{"url":"./subforms/muprg06.html"}}
    ]
  },
  {"id":"4444","text":"報表列印",
    "children":[
      {"text":"員工基本資料表","attributes":{"url":"./subforms/muprg13.html"}},
      {"text":"員工缺勤資料表","attributes":{"url":"./subforms/muprg14.html"}},
      {"text":"員工出勤月報表","attributes":{"url":"./subforms/muprg15.html"}},
      {"text":"員工流動率統計表","attributes":{"url":"./subforms/muprg16.html"}},
      {"text":"員工薪資明細表","attributes":{"url":"./subforms/muprg17.html"}},
      {"text":"薪資發放明細表","attributes":{"url":"./subforms/muprg18.html"}},
      {"text":"薪資項目統計表","attributes":{"url":"./subforms/muprg19.html"}},
      {"text":"使用者基本資料表","attributes":{"url":"./subforms/muprg20.html"}}
    ]
  },
  {"id":"5555","text":"系統管理",
    "children":[
      {"text":"使用者維護","attributes":{"url":"./subforms/muprg07.html"}},
      {"text":"密碼變更","attributes":{"url":"./subforms/muprg08.html"}},
      {"text":"程式使用權限設定","attributes":{"url":"./subforms/muprg09.html"}},
      {"text":"作業區間設定","attributes":{"url":"./subforms/muprg10.html"}},
      {"text":"薪資結轉作業","attributes":{"url":"./subforms/muprg11.html"}}
    ]
  }
]

$(function(){
  document.getElementById("banner_title").innerHTML = "Eden 的人事薪資系統"
  document.getElementById("banner_user").innerHTML = "使用人：Eden (登出)"

  console.log(connectionInfo);

  $.messager.show({title:"title",msg:"你好，世界",showType:"show"})

  //$("#mainTree").tree({url:"/fetch_main_tree"})
  $("#mainTree").tree({data:fakeTree,onClick: function(node){
      if (node.attributes){
        addTab(node.text, node.attributes.url);
      }
    }})
})


function addTab(title, url){
  var tabsControl=$("#tabs");
  if (tabsControl.tabs("exists",title)) {
    tabsControl.tabs("select",title);
  }
  else {
    var urlHref = "<iframe width='100%' height='95%' frameborder='0' scrolling='auto' src='" + url + "'></iframe>";
    tabsControl.tabs("add",{
      title:title,
      content:urlHref,
      closable:true
    });
  }
}
