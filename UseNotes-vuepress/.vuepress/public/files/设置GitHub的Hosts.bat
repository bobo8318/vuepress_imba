1>1/* ::
:: -------------------------------------------------------------------
::                          �Զ�����GitHubHosts
::                     by https://www.bajins.com
::                   GitHub https://woytu.github.io
:: -------------------------------------------------------------------


@echo off

md "%~dp0$testAdmin$" 2>nul
if not exist "%~dp0$testAdmin$" (
    echo ���߱�����Ŀ¼��д��Ȩ��! >&2
    exit /b 1
) else rd "%~dp0$testAdmin$"

:: �����ӳٻ���������չ
:: ���for��if�в�������ʱ��ʾECHO OFF���⣬��!!ȡ����
:: �������jscript��ʾ�����������
setlocal enabledelayedexpansion

if "%~1"=="/?" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)
if "%~1"=="/help" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)

:: cscript -nologo -e:jscript "%~f0" ��һ����ִ�����������ǲ�������ɷ�ʽ��/key:value��
:: %~f0 ��ʾ��ǰ������ľ���·��,ȥ�����ŵ�����·��
cscript -nologo -e:jscript "%~f0" %~1


goto :EXIT

:EXIT
:: �����ӳٻ���������չ������ִ��
endlocal&exit /b %errorlevel%
*/

// ****************************  JavaScript  *******************************

var Argv = WScript.Arguments;
for (i = 0; i < Argv.length; i++) {
    WScript.StdOut.WriteLine("������" + Argv(i));
}

if (Argv.length > 0) {
    switch (Argv(0)) {
        case "1":
            autoStart("startup");
            break;
        case "?","help":
            help();
            break;
        default:
            help();
    }
    // �����˳�
    WScript.Quit(0);
}

var fso = new ActiveXObject("Scripting.FileSystemObject");
// ��ǰ�ļ�����Ŀ¼
var currentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder;

var hostsPath = "C:\\Windows\\System32\\drivers\\etc\\hosts";

var hostsObject = fso.OpenTextFile(hostsPath, 1);
var hosts = hostsObject.ReadAll();
hostsObject.Close();
var hostsArray = hosts.split(/[\r\n]/);

var githubDomain = [
    "assets-cdn.github.com",
    "avatars.githubusercontent.com",
    "avatars0.githubusercontent.com",
    "avatars1.githubusercontent.com",
    "codeload.github.com",
    "documentcloud.github.com",
    "gist.github.com",
    "github.com",
    "github.global.ssl.fastly.net",
    "github.io",
    "github-cloud.s3.amazonaws.com",
    "global-ssl.fastly.net",
    "help.github.com",
    "nodeload.github.com",
    "raw.github.com",
    "status.github.com",
    "training.github.com",
    "www.github.com"
]


var newHosts = [];

for (var i = 0; i < hostsArray.length; i++) {
    if (!isInArray(githubDomain, hostsArray[i])) {
        newHosts.push(hostsArray[i]);
    }
}

for (var i = 0; i < githubDomain.length; i++) {
    var data = {"qtype": 1, "host": githubDomain[i], "qmode": -1};
    var url = "https://myssl.com/api/v1/tools/dns_query";
    var json = request("GET", url, "json", data, null);
    if (json.code == 0 && (json.error == null || json.error == "")) {
        var resultData = json.data;
        var addrUs = resultData["01"][0]["answer"]["records"];
        if (addrUs == null) {
            continue;
        }
        //var addrHk = resultData["852"][0].answer.records;
        //var addrCn = resultData["86"][0].answer.records;
        for (var j = 0; j < addrUs.length; j++) {
            newHosts.push(addrUs[j]["value"] + " " + githubDomain[i]);
        }
    }
}

hostsObject = fso.OpenTextFile(hostsPath, 2, true);
hostsObject.Write(newHosts.join("\r\n"));

var shell = new ActiveXObject("WScript.shell");
shell.Run("ipconfig /flushdns");


/**
 * �ж��������Ƿ����ָ���ַ���
 *
 * @param arr
 * @param obj
 * @returns {boolean}
 */
function isInArray(arr, obj) {
    var i = arr.length;
    while (i--) {
        if (obj.match(RegExp("^.*" + arr[i] + ".*"))) {
            return true;
        }
    }
    return false;
}

function error(msg) {
    WScript.StdErr.WriteLine(msg);
}

function info(msg) {
    WScript.StdOut.WriteLine(msg);
}

function help() {
    info("�����÷�:");
    info("   " + WScript.ScriptName + " autoRun");
    info("     autoRun �Ƿ��������Զ����У�Ĭ��0������,1����");
}


/**
 * HTTP����
 *
 * @param method        GET,POST
 * @param url           �����ַ
 * @param dataType      "",text,stream,xml,json
 * @param data          ���ݣ�{key:value}��ʽ
 * @param contentType   ���͵��������ͣ�multipart/form-data��
 * application/x-www-form-urlencoded��Ĭ�ϣ���text/plain
 * @returns {string|Document|any}
 */
function request(method, url, dataType, data, contentType) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("����url����Ϊ�գ�");
    }
    if (method == "" || method == null || method.length <= 0) {
        method = "GET";
    } else {
        // ���ַ���ת��Ϊ��д
        method = method.toUpperCase();
    }
    if (contentType == "" || contentType == null || contentType.length <= 0) {
        contentType = "application/x-www-form-unlenconded;charset=utf-8";
    }
    var XMLHTTPVersions = [
        'WinHttp.WinHttpRequest.5.1',
        'WinHttp.WinHttpRequest.5.0',
        'Msxml2.ServerXMLHTTP.6.0',
        'Msxml2.ServerXMLHTTP.5.0',
        'Msxml2.ServerXMLHTTP.4.0',
        'Msxml2.ServerXMLHTTP.3.0',
        'Msxml2.ServerXMLHTTP',
        'MSXML2.XMLHTTP.6.0',
        'MSXML2.XMLHTTP.5.0',
        'MSXML2.XMLHTTP.4.0',
        'MSXML2.XMLHTTP.3.0',
        'MSXML2.XMLHTTP'
    ];
    var XMLHTTP;
    for (var i = 0; i < XMLHTTPVersions.length; i++) {
        try {
            XMLHTTP = new ActiveXObject(XMLHTTPVersions[i]);
            break;
        } catch (e) {
            WScript.StdOut.Write(XMLHTTPVersions[i]);
            WScript.StdOut.WriteLine("��" + e.message);
        }
    }

    //������ת����Ϊquerystring��ʽ
    var paramarray = [];
    for (key in data) {
        paramarray.push(key + "=" + data[key]);
    }
    var params = paramarray.join("&");

    switch (method) {
        case "POST":
            // 0�첽��1ͬ��
            XMLHTTP.Open(method, url, 0);
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send(params);
            break;
        default:
            // Ĭ��GET����
            if (params == "" || params.length == 0 || params == null) {
                // 0�첽��1ͬ��
                XMLHTTP.Open(method, url, 0);
            } else {
                XMLHTTP.Open(method, url + "?" + params, 0);
            }
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send();
    }

    // ���ַ���ת��ΪСд
    dataType = dataType.toLowerCase();
    switch (dataType) {
        case "text":
            return XMLHTTP.responseText;
            break;
        case "stream":
            return XMLHTTP.responseStream;
            break;
        case "xml":
            return XMLHTTP.responseXML;
            break;
        case "json":
            return eval("(" + XMLHTTP.responseText + ")");
            break;
        default:
            return XMLHTTP.responseBody;
    }
}

/**
 * ��������
 *
 * @param mode Ϊstartupʱ���ڿ�������Ŀ¼�д���vbs�ű���������ӿ�������ע���
 */
function autoStart(mode) {
    var fileName = WScript.ScriptName;
    fileName = fileName.substring(0, fileName.lastIndexOf('.'));
    //fileName = fileName.substring(0, fileName.length-4);
    var vbsFileName = WScript.ScriptFullName.replace(".bat", ".vbs");
    if ("startup" == mode.toLowerCase()) {
        // ��������Ŀ¼
        var runDir = "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\";
        vbsFileName = runDir + fileName + ".vbs";
    } else {
        // ��ӿ�������ע���
        var shell = new ActiveXObject("WScript.shell");
        var runRegBase = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\";
        shell.RegWrite(runRegBase + fileName, vbsFileName);
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // �����ļ�
    var vbsFile = fso.CreateTextFile(vbsFileName, true);
    // ��д���ݣ������ӻ��з�
    vbsFile.WriteLine("Set shell = WScript.CreateObject(\"WScript.Shell\")");
    vbsFile.WriteLine("shell.Run \"cmd /c " + WScript.ScriptFullName + "\", 0, false");
    // �ر��ļ�
    vbsFile.Close();
}