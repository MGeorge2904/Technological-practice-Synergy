unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdCustomHTTPServer,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdHTTPServer, Vcl.StdCtrls,
  Data.DB, Data.SqlExpr, System.JSON, DBXMySQL;

type
  TForm1 = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    SQLConnection1: TSQLConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetProjectsJSON: string;
    function GetAssignmentsJSON: string;
    function AddProject(const ProjectName, Description, StartDate: string; Budget: Double): Boolean;
    procedure Log(const Msg: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  IdHTTPServer1.Active := True;
  Log('✅ Сервер запущен на порту 8080');
  Log('📱 Откройте браузер: http://localhost:8080');
  Button1.Enabled := False;
  Button2.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IdHTTPServer1.Active := False;
  Log('🛑 Сервер остановлен');
  Button1.Enabled := True;
  Button2.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Log('🚀 Сервер управления проектами готов к запуску');
  Button2.Enabled := False;

  // Настройка подключения к MySQL
  SQLConnection1.DriverName := 'MYSQL';
  SQLConnection1.Params.Values['HostName'] := 'localhost';
  SQLConnection1.Params.Values['Database'] := 'CompanyProjects';
  SQLConnection1.Params.Values['User_Name'] := 'root';
  SQLConnection1.Params.Values['Password'] := 'ваш_пароль';
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  ResponseContent: string;
begin
  Log('📨 Запрос: ' + ARequestInfo.URI);

  try
    // Главная страница
    if ARequestInfo.URI = '/' then
    begin
      ResponseContent :=
        '<!DOCTYPE html>' +
        '<html><head><title>Project Manager</title>' +
        '<meta charset="UTF-8">' +
        '<style>' +
        'body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }' +
        '.container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }' +
        '.header { background: #2c3e50; color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; }' +
        '.table { width: 100%; border-collapse: collapse; margin: 20px 0; }' +
        '.table th, .table td { border: 1px solid #ddd; padding: 12px; text-align: left; }' +
        '.table th { background: #34495e; color: white; }' +
        '.btn { background: #3498db; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; margin: 5px; }' +
        '.btn:hover { background: #2980b9; }' +
        '.form-group { margin: 15px 0; }' +
        '.form-control { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }' +
        '.status-active { color: green; font-weight: bold; }' +
        '.status-planning { color: orange; font-weight: bold; }' +
        '.message { padding: 10px; margin: 10px 0; border-radius: 4px; }' +
        '.success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }' +
        '.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }' +
        '</style>' +
        '</head>' +
        '<body>' +
        '<div class="container">' +
        '<div class="header">' +
        '<h1>🚀 Система управления проектами</h1>' +
        '<p>Delphi Standalone Server + MySQL</p>' +
        '</div>' +

        '<button class="btn" onclick="loadProjects()">📊 Загрузить проекты</button>' +
        '<button class="btn" onclick="loadAssignments()">👥 Загрузить назначения</button>' +

        '<h2>Список проектов</h2>' +
        '<div id="projects"></div>' +

        '<h2>Назначения сотрудников</h2>' +
        '<div id="assignments"></div>' +

        '<h2>Добавить новый проект</h2>' +
        '<div class="form-group">' +
        '<input type="text" id="projectName" class="form-control" placeholder="Название проекта">' +
        '</div>' +
        '<div class="form-group">' +
        '<textarea id="projectDesc" class="form-control" placeholder="Описание" rows="3"></textarea>' +
        '</div>' +
        '<div class="form-group">' +
        '<input type="date" id="projectDate" class="form-control">' +
        '</div>' +
        '<div class="form-group">' +
        '<input type="number" id="projectBudget" class="form-control" placeholder="Бюджет" step="0.01">' +
        '</div>' +
        '<button class="btn" onclick="addProject()">➕ Добавить проект</button>' +
        '<div id="message"></div>' +
        '</div>' +

        '<script>' +
        'function showMessage(text, isError = false) {' +
        '  const msgDiv = document.getElementById("message");' +
        '  const color = isError ? "error" : "success";' +
        '  msgDiv.innerHTML = `<div class="message ${color}">${text}</div>`;' +
        '}' +

        'async function loadProjects() {' +
        '  try {' +
        '    const response = await fetch("/projects");' +
        '    const data = await response.json();' +
        '    ' +
        '    let html = "<table class=\"table\"><tr><th>ID</th><th>Название</th><th>Описание</th><th>Дата начала</th><th>Бюджет</th><th>Статус</th></tr>";' +
        '    ' +
        '    data.forEach(project => {' +
        '      const statusClass = "status-" + project.Status.toLowerCase();' +
        '      html += `<tr>' +
        '        <td>${project.ProjectID}</td>' +
        '        <td><strong>${project.ProjectName}</strong></td>' +
        '        <td>${project.Description}</td>' +
        '        <td>${project.StartDate}</td>' +
        '        <td>${project.Budget} ₽</td>' +
        '        <td><span class="${statusClass}">${project.Status}</span></td>' +
        '      </tr>`;' +
        '    });' +
        '    ' +
        '    html += "</table>";' +
        '    document.getElementById("projects").innerHTML = html;' +
        '    showMessage("Проекты успешно загружены");' +
        '  } catch (error) {' +
        '    showMessage("Ошибка при загрузке проектов: " + error, true);' +
        '  }' +
        '}' +

        'async function loadAssignments() {' +
        '  try {' +
        '    const response = await fetch("/assignments");' +
        '    const data = await response.json();' +
        '    ' +
        '    let html = "<table class=\"table\"><tr><th>Проект</th><th>Сотрудник</th><th>Роль</th><th>Часы</th></tr>";' +
        '    ' +
        '    data.forEach(assignment => {' +
        '      html += `<tr>' +
        '        <td>${assignment.ProjectName}</td>' +
        '        <td>${assignment.EmployeeName}</td>' +
        '        <td>${assignment.Role}</td>' +
        '        <td>${assignment.HoursAllocated} ч</td>' +
        '      </tr>`;' +
        '    });' +
        '    ' +
        '    html += "</table>";' +
        '    document.getElementById("assignments").innerHTML = html;' +
        '    showMessage("Назначения успешно загружены");' +
        '  } catch (error) {' +
        '    showMessage("Ошибка при загрузке назначений: " + error, true);' +
        '  }' +
        '}' +

        'async function addProject() {' +
        '  const name = document.getElementById("projectName").value;' +
        '  const desc = document.getElementById("projectDesc").value;' +
        '  const date = document.getElementById("projectDate").value;' +
        '  const budget = document.getElementById("projectBudget").value;' +
        '  ' +
        '  if (!name || !date) {' +
        '    showMessage("Заполните название и дату", true);' +
        '    return;' +
        '  }' +
        '  ' +
        '  try {' +
        '    const formData = new FormData();' +
        '    formData.append("name", name);' +
        '    formData.append("desc", desc);' +
        '    formData.append("date", date);' +
        '    formData.append("budget", budget);' +
        '    ' +
        '    const response = await fetch("/addproject", {' +
        '      method: "POST",' +
        '      body: formData' +
        '    });' +
        '    ' +
        '    const result = await response.text();' +
        '    if (result === "success") {' +
        '      showMessage("Проект успешно добавлен!");' +
        '      document.getElementById("projectName").value = "";' +
        '      document.getElementById("projectDesc").value = "";' +
        '      document.getElementById("projectBudget").value = "";' +
        '      loadProjects();' +
        '    } else {' +
        '      showMessage("Ошибка при добавлении проекта", true);' +
        '    }' +
        '  } catch (error) {' +
        '    showMessage("Ошибка: " + error, true);' +
        '  }' +
        '}' +

        '// Автозагрузка при старте' +
        'loadProjects();' +
        'loadAssignments();' +
        '</script>' +
        '</body>' +
        '</html>';

      AResponseInfo.ContentType := 'text/html; charset=utf-8';
    end
    else if ARequestInfo.URI = '/projects' then
    begin
      // API для получения проектов
      ResponseContent := GetProjectsJSON;
      AResponseInfo.ContentType := 'application/json';
    end
    else if ARequestInfo.URI = '/assignments' then
    begin
      // API для получения назначений
      ResponseContent := GetAssignmentsJSON;
      AResponseInfo.ContentType := 'application/json';
    end
    else if (ARequestInfo.URI = '/addproject') and (ARequestInfo.Command = 'POST') then
    begin
      // API для добавления проекта
      if AddProject(
        ARequestInfo.Params.Values['name'],
        ARequestInfo.Params.Values['desc'],
        ARequestInfo.Params.Values['date'],
        StrToFloatDef(ARequestInfo.Params.Values['budget'], 0)
      ) then
        ResponseContent := 'success'
      else
        ResponseContent := 'error';
    end
    else
    begin
      ResponseContent := '404 - Page Not Found';
      AResponseInfo.ResponseNo := 404;
    end;

    AResponseInfo.ContentText := ResponseContent;
    Log('✅ Ответ отправлен');

  except
    on E: Exception do
    begin
      AResponseInfo.ContentText := 'Error: ' + E.Message;
      Log('❌ Ошибка: ' + E.Message);
    end;
  end;
end;

function TForm1.GetProjectsJSON: string;
var
  Query: TSQLQuery;
  jsonArray: TJSONArray;
  jsonObject: TJSONObject;
begin
  try
    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := SQLConnection1;

      if not SQLConnection1.Connected then
        SQLConnection1.Connected := True;

      Query.SQL.Text := 'SELECT * FROM Projects ORDER BY StartDate DESC';
      Query.Open;

      jsonArray := TJSONArray.Create;

      Query.First;
      while not Query.Eof do
      begin
        jsonObject := TJSONObject.Create;
        jsonObject.AddPair('ProjectID', TJSONNumber.Create(Query.FieldByName('ProjectID').AsInteger));
        jsonObject.AddPair('ProjectName', Query.FieldByName('ProjectName').AsString);
        jsonObject.AddPair('Description', Query.FieldByName('Description').AsString);
        jsonObject.AddPair('StartDate', FormatDateTime('yyyy-mm-dd', Query.FieldByName('StartDate').AsDateTime));
        jsonObject.AddPair('Budget', TJSONNumber.Create(Query.FieldByName('Budget').AsFloat));
        jsonObject.AddPair('Status', Query.FieldByName('Status').AsString);

        jsonArray.AddElement(jsonObject);
        Query.Next;
      end;

      Result := jsonArray.ToString;
      Log('📊 Загружено проектов: ' + IntToStr(jsonArray.Count));
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Result := '{"error":"' + E.Message + '"}';
      Log('❌ Ошибка БД: ' + E.Message);
    end;
  end;
end;

function TForm1.GetAssignmentsJSON: string;
var
  Query: TSQLQuery;
  jsonArray: TJSONArray;
  jsonObject: TJSONObject;
begin
  try
    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := SQLConnection1;

      if not SQLConnection1.Connected then
        SQLConnection1.Connected := True;

      Query.SQL.Text :=
        'SELECT p.ProjectName, CONCAT(e.FirstName, " ", e.LastName) as EmployeeName, ' +
        'pa.Role, pa.HoursAllocated ' +
        'FROM ProjectAssignments pa ' +
        'JOIN Projects p ON pa.ProjectID = p.ProjectID ' +
        'JOIN Employees e ON pa.EmployeeID = e.EmployeeID ' +
        'ORDER BY p.ProjectName';
      Query.Open;

      jsonArray := TJSONArray.Create;

      Query.First;
      while not Query.Eof do
      begin
        jsonObject := TJSONObject.Create;
        jsonObject.AddPair('ProjectName', Query.FieldByName('ProjectName').AsString);
        jsonObject.AddPair('EmployeeName', Query.FieldByName('EmployeeName').AsString);
        jsonObject.AddPair('Role', Query.FieldByName('Role').AsString);
        jsonObject.AddPair('HoursAllocated', TJSONNumber.Create(Query.FieldByName('HoursAllocated').AsInteger));

        jsonArray.AddElement(jsonObject);
        Query.Next;
      end;

      Result := jsonArray.ToString;
      Log('👥 Загружено назначений: ' + IntToStr(jsonArray.Count));
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Result := '{"error":"' + E.Message + '"}';
      Log('❌ Ошибка БД: ' + E.Message);
    end;
  end;
end;

function TForm1.AddProject(const ProjectName, Description, StartDate: string; Budget: Double): Boolean;
var
  Query: TSQLQuery;
begin
  Result := False;
  try
    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := SQLConnection1;

      if not SQLConnection1.Connected then
        SQLConnection1.Connected := True;

      Query.SQL.Text :=
        'INSERT INTO Projects (ProjectName, Description, StartDate, Budget) ' +
        'VALUES (:ProjectName, :Description, :StartDate, :Budget)';

      Query.ParamByName('ProjectName').AsString := ProjectName;
      Query.ParamByName('Description').AsString := Description;
      Query.ParamByName('StartDate').AsString := StartDate;
      Query.ParamByName('Budget').AsFloat := Budget;

      Query.ExecSQL;
      Result := True;
      Log('✅ Добавлен проект: ' + ProjectName);
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Log('❌ Ошибка добавления проекта: ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TForm1.Log(const Msg: string);
begin
  Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + Msg);
end;

end.
