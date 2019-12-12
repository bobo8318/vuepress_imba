1>1/* ::
:: -------------------------------------------------------------------
::                          �Զ�����Bing��ֽ
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

var fso = new ActiveXObject("Scripting.FileSystemObject");
// ��ǰ�ļ�����Ŀ¼
var currentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder;

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

var json = request("GET", "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1", "json");

var imageUrl = "https://cn.bing.com" + json.images[0].url.split("&")[0];
var imageDir = currentDirectory + "\\images";
var imageName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
imageName = imageName.split("=")[1];

var imagePath = imageDir + "\\" + imageName.replace(/(.+)\.[^\.]+$/, "$1") + ".bmp";
// ���ת�����ļ�������
if (!fso.FileExists(imagePath)) {
    var imagePath = download(imageUrl, imageDir, imageName);
    imagePath = imageTransform(imagePath, "bmp");
    if (imagePath == "") {
        info("ͼƬ��ʽתΪBMPʧ��");
        WScript.Quit(0);
    }
}


if (fso.FileExists(imagePath)) {
    setWallpaper(imagePath);

    info("���ñ�ֽ�ɹ���" + imagePath);
    WScript.Quit(0);
} else {
    error("���ر�ֽʧ�ܣ�");
    WScript.Quit(1);
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
 * �����ļ�
 *
 * @param url
 * @param directory �ļ��洢Ŀ¼
 * @param filename  �ļ�����Ϊ��Ĭ�Ͻ�ȡurl�е��ļ���
 * @returns {string}
 */
function download(url, directory, filename) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("����url����Ϊ�գ�");
    }
    if (directory == "" || directory == null || directory.length <= 0) {
        throw new Error("�ļ��洢Ŀ¼����Ϊ�գ�");
    }

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ���Ŀ¼������
    if (!fso.FolderExists(directory)) {
        // ����Ŀ¼
        var strFolderName = fso.CreateFolder(directory);
    }

    if (filename == "" || filename == null || filename.length <= 0) {
        filename = url.substring(url.lastIndexOf("/") + 1);
        // ȥ���ļ�����������ţ�����֮ǰ�ģ��ַ�
        filename = filename.replace(/^.*(\&|\=|\?|\/)/ig, "");
    }
    var path = directory + "\\" + filename;

    var ADO = new ActiveXObject("ADODB.Stream");
    ADO.Mode = 3;
    ADO.Type = 1;
    ADO.Open();
    ADO.Write(request("GET", url, ""));
    ADO.SaveToFile(path, 2);
    ADO.Close();

    // ����ļ�������
    if (!fso.FileExists(path)) {
        return "";
    }
    return path;
}

/**
 * ͼƬ��ʽת��
 *
 * @param imagePath ԭʼͼƬȫ·��
 * @param format    Ҫת���ĸ�ʽ����׺��
 * @returns {string}
 */
function imageTransform(imagePath, format) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ����ļ�������,��˵��û��ת���ɹ�
    if (!fso.FileExists(imagePath)) {
        throw new Error("ͼƬ�����ڻ�·������");
    }
    // ת�����ʽ�ļ�ȫ·��
    var formatPath = imagePath.replace(/(.+)\.[^\.]+$/, "$1") + "." + format;
    // ���ת�����ļ��Ѵ���
    if (fso.FileExists(formatPath)) {
        throw new Error("Ҫת���ĸ�ʽ�ļ��Ѿ����ڣ�");
    }

    // תСд
    format = format.toLowerCase();

    var wiaFormat = "";
    switch (format) {
        case "bmp":
            wiaFormat = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "png":
            wiaFormat = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "gif":
            wiaFormat = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "tiff":
            wiaFormat = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}";
            break;
        default:
            // Ĭ��JPEG
            wiaFormat = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}";
    }


    var img = new ActiveXObject("WIA.ImageFile");
    img.LoadFile(imagePath);

    var imgps = new ActiveXObject("WIA.ImageProcess");
    imgps.Filters.Add(imgps.FilterInfos("Convert").FilterID);
    // ת����ʽ
    imgps.Filters(1).Properties("FormatID").Value = wiaFormat;
    // ͼƬ����
    //imgps.Filters(1).Properties("Quality").Value = 5
    var img = imgps.Apply(img);


    img.SaveFile(formatPath);

    // ����ļ�������,��˵��û��ת���ɹ�
    if (!fso.FileExists(formatPath)) {
        return "";
    }

    return formatPath;
}

/**
 * ���������ֽ
 *
 * @param imagesPath ͼƬȫ·��
 */
function setWallpaper(imagesPath) {
    var shell = new ActiveXObject("WScript.shell");
    // HKEY_CURRENT_USER
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\TileWallpaper", "0");
    // ���ñ�ֽȫ·��
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\Wallpaper", imagesPath);
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\WallpaperStyle", "2", "REG_DWORD");

    var shadowReg = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion";
    shadowReg = shadowReg + "\\Explorer\\Advanced\\ListviewShadow";
    shell.RegWrite(shadowReg, "1", "REG_DWORD");

    // �������ͼ��δ͸������Ҫˢ�������
    //shell.Run("gpupdate /force", 0);

    // �����Ѿ�ͨ��ע��������˱�ֽ�Ĳ���������Windows api SystemParametersInfoˢ������
    var spi = "RunDll32 USER32,SystemParametersInfo SPI_SETDESKWALLPAPER 0 \"";
    spi = spi + imagesPath + "\" SPIF_SENDWININICHANGE+SPIF_UPDATEINIFILE";
    shell.Run(spi);

    // ������Դ����������
    //shell.Run("taskkill /f /im explorer.exe");

    for (var i = 0; i < 10; i++) {
        // ʵʱˢ������
        shell.Run("RunDll32 USER32,UpdatePerUserSystemParameters");
    }

    // ������Դ������
    //shell.Run("start explorer.exe");
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