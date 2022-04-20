object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      Name = 'IndexAction'
      PathInfo = '/index.html'
      Producer = Index
    end
    item
      Name = 'FetchMainTree'
      PathInfo = '/fetch_main_tree'
      OnAction = WebModule1FetchMainTreeAction
    end
    item
      Name = 'DeptAction'
      PathInfo = '/dept'
      OnAction = WebModule1DeptActionAction
    end
    item
      Name = 'DeptAppendAction'
      PathInfo = '/dept_append'
      OnAction = WebModule1DeptAppendActionAction
    end
    item
      Name = 'DeptEditAction'
      PathInfo = '/dept_edit'
      OnAction = WebModule1DeptEditActionAction
    end
    item
      Name = 'DetpDestoryAction'
      PathInfo = '/dept_destory'
      OnAction = WebModule1DetpDestoryActionAction
    end
    item
      Name = 'EmpAction'
      PathInfo = '/emp'
      OnAction = WebModule1EmpActionAction
    end
    item
      Name = 'EmpAppendAction'
      PathInfo = '/emp_append'
      OnAction = WebModule1EmpAppendActionAction
    end
    item
      Name = 'EmpEditAction'
      PathInfo = '/emp_edit'
      OnAction = WebModule1EmpEditActionAction
    end
    item
      Name = 'EmpDestoryAction'
      PathInfo = '/emp_destory'
      OnAction = WebModule1EmpDestoryActionAction
    end>
  Height = 230
  Width = 415
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'application/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'application/json'
        Extensions = 'json'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/png'
        Extensions = 'png'
      end
      item
        MimeType = 'application/font-woff'
        Extensions = 'woff;woff2'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    VirtualPath = '/'
    Left = 128
    Top = 88
  end
  object Index: TPageProducer
    HTMLFile = '/templates/index.html'
    OnHTMLTag = IndexHTMLTag
    Left = 288
    Top = 104
  end
end
