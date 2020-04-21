<?php

//   -------------------------------------------------------------------------------
//  |                  net2ftp: a web based FTP client                              |
//  |              Copyright (c) 2003-2013 by David Gartner                         |
//  |                                                                               |
//  | This program is free software; you can redistribute it and/or                 |
//  | modify it under the terms of the GNU General Public License                   |
//  | as published by the Free Software Foundation; either version 2                |
//  | of the License, or (at your option) any later version.                        |
//  |                                                                               |
//   -------------------------------------------------------------------------------

//   -------------------------------------------------------------------------------
//  | For credits, see the credits.txt file                                         |
//   -------------------------------------------------------------------------------
//  |                                                                               |
//  |                              INSTRUCTIONS                                     |
//  |                                                                               |
//  |  The messages to translate are listed below.                                  |
//  |  The structure of each line is like this:                                     |
//  |     $message["Hello world!"] = "Hello world!";                                |
//  |                                                                               |
//  |  Keep the text between square brackets [] as it is.                           |
//  |  Translate the 2nd part, keeping the same punctuation and HTML tags.          |
//  |                                                                               |
//  |  The English message, for example                                             |
//  |     $message["net2ftp is written in PHP!"] = "net2ftp is written in PHP!";    |
//  |  should become after translation:                                             |
//  |     $message["net2ftp is written in PHP!"] = "net2ftp est ecrit en PHP!";     |
//  |     $message["net2ftp is written in PHP!"] = "net2ftp is geschreven in PHP!"; |
//  |                                                                               |
//  |  Note that the variable starts with a dollar sign $, that the value is        |
//  |  enclosed in double quotes " and that the line ends with a semi-colon ;       |
//  |  Be careful when editing this file, do not erase those special characters.    |
//  |                                                                               |
//  |  Some messages also contain one or more variables which start with a percent  |
//  |  sign, for example %1\$s or %2\$s. The English message, for example           |
//  |     $messages[...] = ["The file %1\$s was copied to %2\$s "]                  |
//  |  should becomes after translation:                                            |
//  |     $messages[...] = ["Le fichier %1\$s a 彋 copi vers %2\$s "]             |
//  |                                                                               |
//  |  When a real percent sign % is needed in the text it is entered as %%         |
//  |  otherwise it is interpreted as a variable. So no, it's not a mistake.        |
//  |                                                                               |
//  |  Between the messages to translate there is additional PHP code, for example: |
//  |      if ($net2ftp_globals["state2"] == "rename") {           // <-- PHP code  |
//  |          $net2ftp_messages["Rename file"] = "Rename file";   // <-- message   |
//  |      }                                                       // <-- PHP code  |
//  |  This code is needed to load the messages only when they are actually needed. |
//  |  There is no need to change or delete any of that PHP code; translate only    |
//  |  the message.                                                                 |
//  |                                                                               |
//  |  Thanks in advance to all the translators!                                    |
//  |  David.                                                                       |
//  |                                                                               |
//   -------------------------------------------------------------------------------


// -------------------------------------------------------------------------
// Language settings
// -------------------------------------------------------------------------

// HTML lang attribute
$net2ftp_messages["en"] = "zh-TW";

// HTML dir attribute: left-to-right (LTR) or right-to-left (RTL)
$net2ftp_messages["ltr"] = "ltr";

// CSS style: align left or right (use in combination with LTR or RTL)
$net2ftp_messages["left"] = "left";
$net2ftp_messages["right"] = "right";

// Encoding
$net2ftp_messages["iso-8859-1"] = "big5";


// -------------------------------------------------------------------------
// Status messages
// -------------------------------------------------------------------------

// When translating these messages, keep in mind that the text should not be too long
// It should fit in the status textbox

$net2ftp_messages["Connecting to the FTP server"] = "連接到 FTP 伺服器";
$net2ftp_messages["Logging into the FTP server"] = "Logging into the FTP server";
$net2ftp_messages["Setting the passive mode"] = "Setting the passive mode";
$net2ftp_messages["Getting the FTP system type"] = "Getting the FTP system type";
$net2ftp_messages["Changing the directory"] = "Changing the directory";
$net2ftp_messages["Getting the current directory"] = "Getting the current directory";
$net2ftp_messages["Getting the list of directories and files"] = "取得資料夾及檔案列表...";
$net2ftp_messages["Parsing the list of directories and files"] = "Parsing the list of directories and files";
$net2ftp_messages["Logging out of the FTP server"] = "Logging out of the FTP server";
$net2ftp_messages["Getting the list of directories and files"] = "取得資料夾及檔案列表...";
$net2ftp_messages["Printing the list of directories and files"] = "列出資料夾及檔案列表...";
$net2ftp_messages["Processing the entries"] = "處理輸入項目...";
$net2ftp_messages["Processing entry %1\$s"] = "Processing entry %1\$s";
$net2ftp_messages["Checking files"] = "檢查檔案...";
$net2ftp_messages["Transferring files to the FTP server"] = "傳送到 FTP 伺服器...";
$net2ftp_messages["Decompressing archives and transferring files"] = "解壓及傳送檔案...";
$net2ftp_messages["Searching the files..."] = "搜索檔案...";
$net2ftp_messages["Uploading new file"] = "上傳新檔案...";
$net2ftp_messages["Reading the file"] = "Reading the file";
$net2ftp_messages["Parsing the file"] = "Parsing the file";
$net2ftp_messages["Reading the new file"] = "讀取新檔案...";
$net2ftp_messages["Reading the old file"] = "讀取舊檔案...";
$net2ftp_messages["Comparing the 2 files"] = "比較 2 個檔案...";
$net2ftp_messages["Printing the comparison"] = "列出比較結果...";
$net2ftp_messages["Sending FTP command %1\$s of %2\$s"] = "Sending FTP command %1\$s of %2\$s";
$net2ftp_messages["Getting archive %1\$s of %2\$s from the FTP server"] = "Getting archive %1\$s of %2\$s from the FTP server";
$net2ftp_messages["Creating a temporary directory on the FTP server"] = "Creating a temporary directory on the FTP server";
$net2ftp_messages["Setting the permissions of the temporary directory"] = "Setting the permissions of the temporary directory";
$net2ftp_messages["Copying the net2ftp installer script to the FTP server"] = "Copying the net2ftp installer script to the FTP server";
$net2ftp_messages["Script finished in %1\$s seconds"] = "運行時間: %1\$s 秒";
$net2ftp_messages["Script halted"] = "運行中止";

// Used on various screens
$net2ftp_messages["Please wait..."] = "請稍侯...";


// -------------------------------------------------------------------------
// index.php
// -------------------------------------------------------------------------
$net2ftp_messages["Unexpected state string: %1\$s. Exiting."] = "Unexpected state string: %1\$s. Exiting.";
$net2ftp_messages["This beta function is not activated on this server."] = "本伺服器尚未啟用此 BETA 功能.";
$net2ftp_messages["This function has been disabled by the Administrator of this website."] = "This function has been disabled by the Administrator of this website.";


// -------------------------------------------------------------------------
// /includes/browse.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["The directory <b>%1\$s</b> does not exist or could not be selected, so the directory <b>%2\$s</b> is shown instead."] = "The directory <b>%1\$s</b> does not exist or could not be selected, so the directory <b>%2\$s</b> is shown instead.";
$net2ftp_messages["Your root directory <b>%1\$s</b> does not exist or could not be selected."] = "Your root directory <b>%1\$s</b> does not exist or could not be selected.";
$net2ftp_messages["The directory <b>%1\$s</b> could not be selected - you may not have sufficient rights to view this directory, or it may not exist."] = "The directory <b>%1\$s</b> could not be selected - you may not have sufficient rights to view this directory, or it may not exist.";
$net2ftp_messages["Entries which contain banned keywords can't be managed using net2ftp. This is to avoid Paypal or Ebay scams from being uploaded through net2ftp."] = "Entries which contain banned keywords can't be managed using net2ftp. This is to avoid Paypal or Ebay scams from being uploaded through net2ftp.";
$net2ftp_messages["Files which are too big can't be downloaded, uploaded, copied, moved, searched, zipped, unzipped, viewed or edited; they can only be renamed, chmodded or deleted."] = "Files which are too big can't be downloaded, uploaded, copied, moved, searched, zipped, unzipped, viewed or edited; they can only be renamed, chmodded or deleted.";
$net2ftp_messages["Execute %1\$s in a new window"] = "在新視窗開啟 %1\$s";


// -------------------------------------------------------------------------
// /includes/main.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["Please select at least one directory or file!"] = "請選擇最少一個資料夾或檔案!";


// -------------------------------------------------------------------------
// /includes/authorizations.inc.php
// -------------------------------------------------------------------------

// checkAuthorization()
$net2ftp_messages["The FTP server <b>%1\$s</b> is not in the list of allowed FTP servers."] = "FTP 伺服器 <b>%1\$s</b> 不在允許連線列表中.";
$net2ftp_messages["The FTP server <b>%1\$s</b> is in the list of banned FTP servers."] = "FTP 伺服器 <b>%1\$s</b> 在被禁連線列表中.";
$net2ftp_messages["The FTP server port %1\$s may not be used."] = "FTP 伺服器連接埠 %1\$s 可能未使用.";
$net2ftp_messages["Your IP address (%1\$s) is not in the list of allowed IP addresses."] = "Your IP address (%1\$s) is not in the list of allowed IP addresses.";
$net2ftp_messages["Your IP address (%1\$s) is in the list of banned IP addresses."] = "你的 IP (%1\$s) 在被禁連線列表中.";

// isAuthorizedDirectory()
$net2ftp_messages["Table net2ftp_users contains duplicate rows."] = "Table net2ftp_users contains duplicate rows.";

// checkAdminUsernamePassword()
$net2ftp_messages["You did not enter your Administrator username or password."] = "You did not enter your Administrator username or password.";
$net2ftp_messages["Wrong username or password. Please try again."] = "Wrong username or password. Please try again.";

// -------------------------------------------------------------------------
// /includes/consumption.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["Unable to determine your IP address."] = "Unable to determine your IP address.";
$net2ftp_messages["Table net2ftp_log_consumption_ipaddress contains duplicate rows."] = "Table net2ftp_log_consumption_ipaddress contains duplicate rows.";
$net2ftp_messages["Table net2ftp_log_consumption_ftpserver contains duplicate rows."] = "Table net2ftp_log_consumption_ftpserver contains duplicate rows.";
$net2ftp_messages["The variable <b>consumption_ipaddress_datatransfer</b> is not numeric."] = "The variable <b>consumption_ipaddress_datatransfer</b> is not numeric.";
$net2ftp_messages["Table net2ftp_log_consumption_ipaddress could not be updated."] = "Table net2ftp_log_consumption_ipaddress could not be updated.";
$net2ftp_messages["Table net2ftp_log_consumption_ipaddress contains duplicate entries."] = "Table net2ftp_log_consumption_ipaddress contains duplicate entries.";
$net2ftp_messages["Table net2ftp_log_consumption_ftpserver could not be updated."] = "Table net2ftp_log_consumption_ftpserver could not be updated.";
$net2ftp_messages["Table net2ftp_log_consumption_ftpserver contains duplicate entries."] = "Table net2ftp_log_consumption_ftpserver contains duplicate entries.";
$net2ftp_messages["Table net2ftp_log_access could not be updated."] = "Table net2ftp_log_access could not be updated.";
$net2ftp_messages["Table net2ftp_log_access contains duplicate entries."] = "Table net2ftp_log_access contains duplicate entries.";


// -------------------------------------------------------------------------
// /includes/database.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["Unable to connect to the MySQL database. Please check your MySQL database settings in net2ftp's configuration file settings.inc.php."] = "Unable to connect to the MySQL database. Please check your MySQL database settings in net2ftp's configuration file settings.inc.php.";
$net2ftp_messages["Unable to select the MySQL database. Please check your MySQL database settings in net2ftp's configuration file settings.inc.php."] = "Unable to select the MySQL database. Please check your MySQL database settings in net2ftp's configuration file settings.inc.php.";


// -------------------------------------------------------------------------
// /includes/errorhandling.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["An error has occured"] = "錯誤";
$net2ftp_messages["Go back"] = "返回";
$net2ftp_messages["Go to the login page"] = "轉到登入頁面";


// -------------------------------------------------------------------------
// /includes/filesystem.inc.php
// -------------------------------------------------------------------------

// ftp_openconnection()
$net2ftp_messages["The <a href=\"http://www.php.net/manual/en/ref.ftp.php\" target=\"_blank\">FTP module of PHP</a> is not installed.<br /><br /> The administrator of this website should install this module. Installation instructions are given on <a href=\"http://www.php.net/manual/en/ftp.installation.php\" target=\"_blank\">php.net</a><br />"] = "The <a href=\"http://www.php.net/manual/en/ref.ftp.php\" target=\"_blank\">FTP module of PHP</a> is not installed.<br /><br /> The administrator of this website should install this module. Installation instructions are given on <a href=\"http://www.php.net/manual/en/ftp.installation.php\" target=\"_blank\">php.net</a><br />";
$net2ftp_messages["The <a href=\"http://www.php.net/manual/en/function.ftp-ssl-connect.php\" target=\"_blank\">FTP and/or OpenSSL modules of PHP</a> is not installed.<br /><br /> The administrator of this website should install these modules. Installation instructions are given on php.net: <a href=\"http://www.php.net/manual/en/ftp.installation.php\" target=\"_blank\">here for FTP</a>, and <a href=\"http://www.php.net/manual/en/openssl.installation.php\" target=\"_blank\">here for OpenSSL</a><br />"] = "The <a href=\"http://www.php.net/manual/en/function.ftp-ssl-connect.php\" target=\"_blank\">FTP and/or OpenSSL modules of PHP</a> is not installed.<br /><br /> The administrator of this website should install these modules. Installation instructions are given on php.net: <a href=\"http://www.php.net/manual/en/ftp.installation.php\" target=\"_blank\">here for FTP</a>, and <a href=\"http://www.php.net/manual/en/openssl.installation.php\" target=\"_blank\">here for OpenSSL</a><br />";
$net2ftp_messages["The <a href=\"http://www.php.net/manual/en/function.ssh2-sftp.php\" target=\"_blank\">SSH2 module of PHP</a> is not installed.<br /><br /> The administrator of this website should install this module. Installation instructions are given on <a href=\"http://www.php.net/manual/en/ssh2.installation.php\" target=\"_blank\">php.net</a><br />"] = "The <a href=\"http://www.php.net/manual/en/function.ssh2-sftp.php\" target=\"_blank\">SSH2 module of PHP</a> is not installed.<br /><br /> The administrator of this website should install this module. Installation instructions are given on <a href=\"http://www.php.net/manual/en/ssh2.installation.php\" target=\"_blank\">php.net</a><br />";
$net2ftp_messages["Unable to connect to FTP server <b>%1\$s</b> on port <b>%2\$s</b>.<br /><br />Are you sure this is the address of the FTP server? This is often different from that of the HTTP (web) server. Please contact your ISP helpdesk or system administrator for help.<br />"] = "未能連接 FTP 伺服器 <b>%1\$s</b>, 連接埠 <b>%2\$s</b>.<br /><br />請確定 FTP 伺服器地址正確. 大部份與 HTTP (web) 伺服器不同. 請聯絡伺服器管理員得知詳細資料.<br />";
$net2ftp_messages["Unable to login to FTP server <b>%1\$s</b> with username <b>%2\$s</b>.<br /><br />Are you sure your username and password are correct? Please contact your ISP helpdesk or system administrator for help.<br />"] = "未能登入 FTP 伺服器 <b>%1\$s</b> 此用戶名稱 <b>%2\$s</b> 可能錯誤.<br /><br />請確定用戶名稱及密碼正確. 請聯絡伺服器管理員得知詳細資料.<br />";
$net2ftp_messages["Unable to switch to the passive mode on FTP server <b>%1\$s</b>."] = "無法使用被動連線方式(PASV MODE)連接到 <b>%1\$s</b>.";

// ftp_openconnection2()
$net2ftp_messages["Unable to connect to the second (target) FTP server <b>%1\$s</b> on port <b>%2\$s</b>.<br /><br />Are you sure this is the address of the second (target) FTP server? This is often different from that of the HTTP (web) server. Please contact your ISP helpdesk or system administrator for help.<br />"] = "未能連接目標 FTP 伺服器 <b>%1\$s</b>, 連接埠 <b>%2\$s</b>.<br /><br />請確定目標 FTP 伺服器地址正確. 大部份與 HTTP (web) 伺服器不同. 請聯絡伺服器管理員得知詳細資料.<br />";
$net2ftp_messages["Unable to login to the second (target) FTP server <b>%1\$s</b> with username <b>%2\$s</b>.<br /><br />Are you sure your username and password are correct? Please contact your ISP helpdesk or system administrator for help.<br />"] = "未能登入目標 FTP 伺服器 <b>%1\$s</b> 此用戶名稱 <b>%2\$s</b> 可能錯誤.<br /><br />請確定用戶名稱及密碼正確. 請聯絡伺服器管理員得知詳細資料.<br />";
$net2ftp_messages["Unable to switch to the passive mode on the second (target) FTP server <b>%1\$s</b>."] = "無法使用被動連線方式(PASV MODE)連接到 <b>%1\$s</b>.";

// ftp_myrename()
$net2ftp_messages["Unable to rename directory or file <b>%1\$s</b> into <b>%2\$s</b>"] = "無法在資料夾 <b>%2\$s</b> 更改資料夾 <b>%1\$s</b> 的名稱";

// ftp_mychmod()
$net2ftp_messages["Unable to execute site command <b>%1\$s</b>. Note that the CHMOD command is only available on Unix FTP servers, not on Windows FTP servers."] = "無法執行命令行 <b>%1\$s</b>. 注意: 屬性(CHMOD) 指令只適用於 Unix FTP 伺服器, 不適用於 WINDOWS FTP 伺服器.";
$net2ftp_messages["Directory <b>%1\$s</b> successfully chmodded to <b>%2\$s</b>"] = "資料夾 <b>%1\$s</b> 成功更改屬性到 <b>%2\$s</b>";
$net2ftp_messages["Processing entries within directory <b>%1\$s</b>:"] = "Processing entries within directory <b>%1\$s</b>:";
$net2ftp_messages["File <b>%1\$s</b> was successfully chmodded to <b>%2\$s</b>"] = "檔案 <b>%1\$s</b> 成功更改屬性到 <b>%2\$s</b>";
$net2ftp_messages["All the selected directories and files have been processed."] = "全部選取的資料夾及檔案已經處理.";

// ftp_rmdir2()
$net2ftp_messages["Unable to delete the directory <b>%1\$s</b>"] = "無法刪除資料夾 <b>%1\$s</b>";

// ftp_delete2()
$net2ftp_messages["Unable to delete the file <b>%1\$s</b>"] = "Unable to delete the file <b>%1\$s</b>";

// ftp_newdirectory()
$net2ftp_messages["Unable to create the directory <b>%1\$s</b>"] = "無法建立資料夾 <b>%1\$s</b>";

// ftp_readfile()
$net2ftp_messages["Unable to create the temporary file"] = "無法建立暫存檔案";
$net2ftp_messages["Unable to get the file <b>%1\$s</b> from the FTP server and to save it as temporary file <b>%2\$s</b>.<br />Check the permissions of the %3\$s directory.<br />"] = "無法從 FTP 伺服器取得檔案 <b>%1\$s</b> 並儲存為暫存檔案 <b>%2\$s</b>.<br />請檢查資料夾 %3\$s 的屬性 .<br />";
$net2ftp_messages["Unable to open the temporary file. Check the permissions of the %1\$s directory."] = "無法開啟暫存檔案. 請檢查資料夾 %1\$s 的屬性.";
$net2ftp_messages["Unable to read the temporary file"] = "無法讀取暫存檔案";
$net2ftp_messages["Unable to close the handle of the temporary file"] = "無法關閉暫存檔案的處理";
$net2ftp_messages["Unable to delete the temporary file"] = "無法刪除暫存檔案";

// ftp_writefile()
$net2ftp_messages["Unable to create the temporary file. Check the permissions of the %1\$s directory."] = "無法建立暫存檔案. 請檢查資料夾 %1\$s 的屬性.";
$net2ftp_messages["Unable to open the temporary file. Check the permissions of the %1\$s directory."] = "無法開啟暫存檔案. 請檢查資料夾 %1\$s 的屬性.";
$net2ftp_messages["Unable to write the string to the temporary file <b>%1\$s</b>.<br />Check the permissions of the %2\$s directory."] = "無法寫入字串到暫存檔案 <b>%1\$s</b>.<br />請檢查資料夾 %2\$s 的屬性.";
$net2ftp_messages["Unable to close the handle of the temporary file"] = "無法關閉暫存檔案的處理";
$net2ftp_messages["Unable to put the file <b>%1\$s</b> on the FTP server.<br />You may not have write permissions on the directory."] = "無法上傳檔案到資料夾 <b>%1\$s</b>.<br />你可能沒有此權限.";
$net2ftp_messages["Unable to delete the temporary file"] = "無法刪除暫存檔案";

// ftp_copymovedelete()
$net2ftp_messages["Processing directory <b>%1\$s</b>"] = "處理資料夾 <b>%1\$s</b>";
$net2ftp_messages["The target directory <b>%1\$s</b> is the same as or a subdirectory of the source directory <b>%2\$s</b>, so this directory will be skipped"] = "目標資料夾 <b>%1\$s</b> 和子資料夾或原資料夾 <b>%2\$s</b> 一樣, 所以將會跳過";
$net2ftp_messages["The directory <b>%1\$s</b> contains a banned keyword, so this directory will be skipped"] = "The directory <b>%1\$s</b> contains a banned keyword, so this directory will be skipped";
$net2ftp_messages["The directory <b>%1\$s</b> contains a banned keyword, aborting the move"] = "The directory <b>%1\$s</b> contains a banned keyword, aborting the move";
$net2ftp_messages["Unable to create the subdirectory <b>%1\$s</b>. It may already exist. Continuing the copy/move process..."] = "無法建立資料夾 <b>%1\$s</b>. 可能已存在. 繼續複製/移動操作...";
$net2ftp_messages["Created target subdirectory <b>%1\$s</b>"] = "Created target subdirectory <b>%1\$s</b>";
$net2ftp_messages["The directory <b>%1\$s</b> could not be selected, so this directory will be skipped"] = "The directory <b>%1\$s</b> could not be selected, so this directory will be skipped";
$net2ftp_messages["Unable to delete the subdirectory <b>%1\$s</b> - it may not be empty"] = "無法刪除資料夾 <b>%1\$s</b> - 可能資料夾為空";
$net2ftp_messages["Deleted subdirectory <b>%1\$s</b>"] = "已刪除資料夾 <b>%1\$s</b>";
$net2ftp_messages["Deleted subdirectory <b>%1\$s</b>"] = "已刪除資料夾 <b>%1\$s</b>";
$net2ftp_messages["Unable to move the directory <b>%1\$s</b>"] = "Unable to move the directory <b>%1\$s</b>";
$net2ftp_messages["Moved directory <b>%1\$s</b>"] = "Moved directory <b>%1\$s</b>";
$net2ftp_messages["Processing of directory <b>%1\$s</b> completed"] = "資料夾 <b>%1\$s</b> 操作完成";
$net2ftp_messages["The target for file <b>%1\$s</b> is the same as the source, so this file will be skipped"] = "目標資料夾 <b>%1\$s</b> 和原資料夾一樣, 此檔案將跳過";
$net2ftp_messages["The file <b>%1\$s</b> contains a banned keyword, so this file will be skipped"] = "The file <b>%1\$s</b> contains a banned keyword, so this file will be skipped";
$net2ftp_messages["The file <b>%1\$s</b> contains a banned keyword, aborting the move"] = "The file <b>%1\$s</b> contains a banned keyword, aborting the move";
$net2ftp_messages["The file <b>%1\$s</b> is too big to be copied, so this file will be skipped"] = "The file <b>%1\$s</b> is too big to be copied, so this file will be skipped";
$net2ftp_messages["The file <b>%1\$s</b> is too big to be moved, aborting the move"] = "The file <b>%1\$s</b> is too big to be moved, aborting the move";
$net2ftp_messages["Unable to copy the file <b>%1\$s</b>"] = "無法複製檔案 <b>%1\$s</b>";
$net2ftp_messages["Copied file <b>%1\$s</b>"] = "Copied file <b>%1\$s</b>";
$net2ftp_messages["Unable to move the file <b>%1\$s</b>, aborting the move"] = "Unable to move the file <b>%1\$s</b>, aborting the move";
$net2ftp_messages["Unable to move the file <b>%1\$s</b>"] = "Unable to move the file <b>%1\$s</b>";
$net2ftp_messages["Moved file <b>%1\$s</b>"] = "已移動檔案 <b>%1\$s</b>";
$net2ftp_messages["Unable to delete the file <b>%1\$s</b>"] = "Unable to delete the file <b>%1\$s</b>";
$net2ftp_messages["Deleted file <b>%1\$s</b>"] = "已刪除檔案 <b>%1\$s</b>";
$net2ftp_messages["All the selected directories and files have been processed."] = "全部選取的資料夾及檔案已經處理.";

// ftp_processfiles()

// ftp_getfile()
$net2ftp_messages["Unable to copy the remote file <b>%1\$s</b> to the local file using FTP mode <b>%2\$s</b>"] = "無法使用 FTP 模式 <b>%2\$s</b> 複製遠端檔案 <b>%1\$s</b> 到本地檔案";
$net2ftp_messages["Unable to delete file <b>%1\$s</b>"] = "無法刪除檔案 <b>%1\$s</b>";

// ftp_putfile()
$net2ftp_messages["The file is too big to be transferred"] = "The file is too big to be transferred";
$net2ftp_messages["Daily limit reached: the file <b>%1\$s</b> will not be transferred"] = "Daily limit reached: the file <b>%1\$s</b> will not be transferred";
$net2ftp_messages["Unable to copy the local file to the remote file <b>%1\$s</b> using FTP mode <b>%2\$s</b>"] = "無法使用 FTP 模式 <b>%2\$s</b> 複製本地檔案 <b>%1\$s</b> 到遠端檔案";
$net2ftp_messages["Unable to delete the local file"] = "無法刪除本地檔案";

// ftp_downloadfile()
$net2ftp_messages["Unable to delete the temporary file"] = "無法刪除暫存檔案";
$net2ftp_messages["Unable to send the file to the browser"] = "Unable to send the file to the browser";

// ftp_zip()
$net2ftp_messages["Unable to create the temporary file"] = "無法建立暫存檔案";
$net2ftp_messages["The zip file has been saved on the FTP server as <b>%1\$s</b>"] = "壓縮檔案 <b>%1\$s</b> 已經在 FTP 伺服器建立";
$net2ftp_messages["Requested files"] = "被請求檔案";

$net2ftp_messages["Dear,"] = "親愛的,";
$net2ftp_messages["Someone has requested the files in attachment to be sent to this email account (%1\$s)."] = "有人要求把附件檔案傳送到 email 帳戶 (%1\$s).";
$net2ftp_messages["If you know nothing about this or if you don't trust that person, please delete this email without opening the Zip file in attachment."] = "如果你不相信這個人或不知道檔案內容, 不要開啟附檔及立即刪除此郵件.";
$net2ftp_messages["Note that if you don't open the Zip file, the files inside cannot harm your computer."] = "注意: 如果你沒有開啟附檔, 對你的電腦是沒有損害的.";
$net2ftp_messages["Information about the sender: "] = "傳送者資料: ";
$net2ftp_messages["IP address: "] = "IP 地址: ";
$net2ftp_messages["Time of sending: "] = "傳送時間: ";
$net2ftp_messages["Sent via the net2ftp application installed on this website: "] = "經 的 net2ftp 程式傳送: ";
$net2ftp_messages["Webmaster's email: "] = "站長電郵: ";
$net2ftp_messages["Message of the sender: "] = "傳送者附加訊息: ";
$net2ftp_messages["net2ftp is free software, released under the GNU/GPL license. For more information, go to http://www.net2ftp.com."] = "net2ftp is free software, released under the GNU/GPL license. For more information, go to http://www.net2ftp.com.";

$net2ftp_messages["The zip file has been sent to <b>%1\$s</b>."] = "此壓縮檔案已經傳送到 <b>%1\$s</b>.";

// acceptFiles()
$net2ftp_messages["File <b>%1\$s</b> is too big. This file will not be uploaded."] = "檔案 <b>%1\$s</b> 太大. 將不會被上傳.";
$net2ftp_messages["File <b>%1\$s</b> is contains a banned keyword. This file will not be uploaded."] = "File <b>%1\$s</b> is contains a banned keyword. This file will not be uploaded.";
$net2ftp_messages["Could not generate a temporary file."] = "無法產生暫存檔案.";
$net2ftp_messages["File <b>%1\$s</b> could not be moved"] = "檔案 <b>%1\$s</b> 無法移動";
$net2ftp_messages["File <b>%1\$s</b> is OK"] = "檔案 <b>%1\$s</b> 沒有問題";
$net2ftp_messages["Unable to move the uploaded file to the temp directory.<br /><br />The administrator of this website has to <b>chmod 777</b> the /temp directory of net2ftp."] = "無法移動上傳的檔案到暫存資料夾.<br /><br />本網站的管理員需要 <b>chmod 777</b> net2ftp 的 資料夾 /temp.";
$net2ftp_messages["You did not provide any file to upload."] = "你沒有提供任何上傳的檔案.";

// ftp_transferfiles()
$net2ftp_messages["File <b>%1\$s</b> could not be transferred to the FTP server"] = "檔案 <b>%1\$s</b> 無法傳送到 FTP 伺服器";
$net2ftp_messages["File <b>%1\$s</b> has been transferred to the FTP server using FTP mode <b>%2\$s</b>"] = "檔案 <b>%1\$s</b> 已經成功使用 FTP mode <b>%2\$s</b> 上傳到 FTP 伺服器. ";
$net2ftp_messages["Transferring files to the FTP server"] = "傳送到 FTP 伺服器...";

// ftp_unziptransferfiles()
$net2ftp_messages["Processing archive nr %1\$s: <b>%2\$s</b>"] = "處理壓縮檔案 nr %1\$s: <b>%2\$s</b>";
$net2ftp_messages["Archive <b>%1\$s</b> was not processed because its filename extension was not recognized. Only zip, tar, tgz and gz archives are supported at the moment."] = "由於副檔名不明, 壓縮檔案 <b>%1\$s</b> 未能處理. 現階段只接受 zip, tar, tgz and gz 格式.";
$net2ftp_messages["Unable to extract the files and directories from the archive"] = "Unable to extract the files and directories from the archive";
$net2ftp_messages["Archive contains filenames with ../ or ..\\ - aborting the extraction"] = "Archive contains filenames with ../ or ..\\ - aborting the extraction";
$net2ftp_messages["Could not unzip entry %1\$s (error code %2\$s)"] = "Could not unzip entry %1\$s (error code %2\$s)";
$net2ftp_messages["Created directory %1\$s"] = "Created directory %1\$s";
$net2ftp_messages["Could not create directory %1\$s"] = "Could not create directory %1\$s";
$net2ftp_messages["Copied file %1\$s"] = "Copied file %1\$s";
$net2ftp_messages["Could not copy file %1\$s"] = "Could not copy file %1\$s";
$net2ftp_messages["Unable to delete the temporary directory"] = "Unable to delete the temporary directory";
$net2ftp_messages["Unable to delete the temporary file %1\$s"] = "Unable to delete the temporary file %1\$s";

// ftp_mysite()
$net2ftp_messages["Unable to execute site command <b>%1\$s</b>"] = "無法執行命令行 <b>%1\$s</b>";

// shutdown()
$net2ftp_messages["Your task was stopped"] = "工作停止";
$net2ftp_messages["The task you wanted to perform with net2ftp took more time than the allowed %1\$s seconds, and therefor that task was stopped."] = "工作時間超過了限定的 %1\$s 秒, 所以工作停止.";
$net2ftp_messages["This time limit guarantees the fair use of the web server for everyone."] = "此限制維護各使用者的公平原則.";
$net2ftp_messages["Try to split your task in smaller tasks: restrict your selection of files, and omit the biggest files."] = "嘗試把工作拆分為更小的工作: 減少選取的檔案, 或省略體積比較大的檔案.";
$net2ftp_messages["If you really need net2ftp to be able to handle big tasks which take a long time, consider installing net2ftp on your own server."] = "如果你希望 net2ftp 可處理大型工作, 可把 net2ftp 安裝到你的電腦.";

// SendMail()
$net2ftp_messages["You did not provide any text to send by email!"] = "你沒有在 email 提供任何文字!";
$net2ftp_messages["You did not supply a From address."] = "你沒有提供 From 地址.";
$net2ftp_messages["You did not supply a To address."] = "你沒有提供 To 地址.";
$net2ftp_messages["Due to technical problems the email to <b>%1\$s</b> could not be sent."] = "由於技術性問題, 電郵 <b>%1\$s</b> 無法送出.";

// tempdir2()
$net2ftp_messages["Unable to create a temporary directory because (unvalid parent directory)"] = "Unable to create a temporary directory because (unvalid parent directory)";
$net2ftp_messages["Unable to create a temporary directory because (parent directory is not writeable)"] = "Unable to create a temporary directory because (parent directory is not writeable)";
$net2ftp_messages["Unable to create a temporary directory (too many tries)"] = "Unable to create a temporary directory (too many tries)";

// -------------------------------------------------------------------------
// /includes/logging.inc.php
// -------------------------------------------------------------------------
// logAccess(), logLogin(), logError()
$net2ftp_messages["Unable to execute the SQL query."] = "Unable to execute the SQL query.";
$net2ftp_messages["Unable to open the system log."] = "Unable to open the system log.";
$net2ftp_messages["Unable to write a message to the system log."] = "Unable to write a message to the system log.";

// getLogStatus(), putLogStatus()
$net2ftp_messages["Table net2ftp_log_status contains duplicate entries."] = "Table net2ftp_log_status contains duplicate entries.";
$net2ftp_messages["Table net2ftp_log_status could not be updated."] = "Table net2ftp_log_status could not be updated.";

// rotateLogs()
$net2ftp_messages["The log tables were renamed successfully."] = "The log tables were renamed successfully.";
$net2ftp_messages["The log tables could not be renamed."] = "The log tables could not be renamed.";
$net2ftp_messages["The log tables were copied successfully."] = "The log tables were copied successfully.";
$net2ftp_messages["The log tables could not be copied."] = "The log tables could not be copied.";
$net2ftp_messages["The oldest log table was dropped successfully."] = "The oldest log table was dropped successfully.";
$net2ftp_messages["The oldest log table could not be dropped."] = "The oldest log table could not be dropped.";


// -------------------------------------------------------------------------
// /includes/registerglobals.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["Please enter your username and password for FTP server "] = "Please enter your username and password for FTP server ";
$net2ftp_messages["You did not fill in your login information in the popup window.<br />Click on \"Go to the login page\" below."] = "You did not fill in your login information in the popup window.<br />Click on \"Go to the login page\" below.";
$net2ftp_messages["Access to the net2ftp Admin panel is disabled, because no password has been set in the file settings.inc.php. Enter a password in that file, and reload this page."] = "Access to the net2ftp Admin panel is disabled, because no password has been set in the file settings.inc.php. Enter a password in that file, and reload this page.";
$net2ftp_messages["Please enter your Admin username and password"] = "Please enter your Admin username and password"; 
$net2ftp_messages["You did not fill in your login information in the popup window.<br />Click on \"Go to the login page\" below."] = "You did not fill in your login information in the popup window.<br />Click on \"Go to the login page\" below.";
$net2ftp_messages["Wrong username or password for the net2ftp Admin panel. The username and password can be set in the file settings.inc.php."] = "Wrong username or password for the net2ftp Admin panel. The username and password can be set in the file settings.inc.php.";


// -------------------------------------------------------------------------
// /skins/skins.inc.php
// -------------------------------------------------------------------------
$net2ftp_messages["Blue"] = "藍色模版";
$net2ftp_messages["Grey"] = "灰色模版";
$net2ftp_messages["Black"] = "黑色模版";
$net2ftp_messages["Yellow"] = "黃色模版";
$net2ftp_messages["Pastel"] = "Pastel";

// getMime()
$net2ftp_messages["Directory"] = "資料夾";
$net2ftp_messages["Symlink"] = "Symlink";
$net2ftp_messages["ASP script"] = "ASP 檔案";
$net2ftp_messages["Cascading Style Sheet"] = "CSS 範本檔案";
$net2ftp_messages["HTML file"] = "HTML 檔案";
$net2ftp_messages["Java source file"] = "Java source 檔案";
$net2ftp_messages["JavaScript file"] = "JavaScript 檔案";
$net2ftp_messages["PHP Source"] = "PHP source 檔案";
$net2ftp_messages["PHP script"] = "PHP script 檔案";
$net2ftp_messages["Text file"] = "文字檔案";
$net2ftp_messages["Bitmap file"] = "Bitmap 圖片檔";
$net2ftp_messages["GIF file"] = "GIF 圖片檔";
$net2ftp_messages["JPEG file"] = "JPEG 圖片檔";
$net2ftp_messages["PNG file"] = "PNG 圖片檔";
$net2ftp_messages["TIF file"] = "TIF 圖片檔";
$net2ftp_messages["GIMP file"] = "GIMP 圖片檔";
$net2ftp_messages["Executable"] = "可執行檔案";
$net2ftp_messages["Shell script"] = "Shell script";
$net2ftp_messages["MS Office - Word document"] = "MS Office - Word 文件";
$net2ftp_messages["MS Office - Excel spreadsheet"] = "MS Office - Excel 表格";
$net2ftp_messages["MS Office - PowerPoint presentation"] = "MS Office - PowerPoint 文件";
$net2ftp_messages["MS Office - Access database"] = "MS Office - Access 數據庫";
$net2ftp_messages["MS Office - Visio drawing"] = "MS Office - Visio drawing";
$net2ftp_messages["MS Office - Project file"] = "MS Office - Project 文件";
$net2ftp_messages["OpenOffice - Writer 6.0 document"] = "OpenOffice - Writer 6.0 文件";
$net2ftp_messages["OpenOffice - Writer 6.0 template"] = "OpenOffice - Writer 6.0 模版文件";
$net2ftp_messages["OpenOffice - Calc 6.0 spreadsheet"] = "OpenOffice - Calc 6.0 表格";
$net2ftp_messages["OpenOffice - Calc 6.0 template"] = "OpenOffice - Calc 6.0 模版文件";
$net2ftp_messages["OpenOffice - Draw 6.0 document"] = "OpenOffice - Draw 6.0 文件";
$net2ftp_messages["OpenOffice - Draw 6.0 template"] = "OpenOffice - Draw 6.0 模版文件";
$net2ftp_messages["OpenOffice - Impress 6.0 presentation"] = "OpenOffice - Impress 6.0 文件";
$net2ftp_messages["OpenOffice - Impress 6.0 template"] = "OpenOffice - Impress 6.0 模版文件";
$net2ftp_messages["OpenOffice - Writer 6.0 global document"] = "OpenOffice - Writer 6.0 global 文件";
$net2ftp_messages["OpenOffice - Math 6.0 document"] = "OpenOffice - Math 6.0 文件";
$net2ftp_messages["StarOffice - StarWriter 5.x document"] = "StarOffice - StarWriter 5.x 文件";
$net2ftp_messages["StarOffice - StarWriter 5.x global document"] = "StarOffice - StarWriter 5.x global 文件";
$net2ftp_messages["StarOffice - StarCalc 5.x spreadsheet"] = "StarOffice - StarCalc 5.x 表格";
$net2ftp_messages["StarOffice - StarDraw 5.x document"] = "StarOffice - StarDraw 5.x 文件";
$net2ftp_messages["StarOffice - StarImpress 5.x presentation"] = "StarOffice - StarImpress 5.x 文件";
$net2ftp_messages["StarOffice - StarImpress Packed 5.x file"] = "StarOffice - StarImpress Packed 5.x 檔案";
$net2ftp_messages["StarOffice - StarMath 5.x document"] = "StarOffice - StarMath 5.x 文件";
$net2ftp_messages["StarOffice - StarChart 5.x document"] = "StarOffice - StarChart 5.x 文件";
$net2ftp_messages["StarOffice - StarMail 5.x mail file"] = "StarOffice - StarMail 5.x mail 檔案";
$net2ftp_messages["Adobe Acrobat document"] = "Adobe Acrobat 文件";
$net2ftp_messages["ARC archive"] = "ARC 壓縮檔";
$net2ftp_messages["ARJ archive"] = "ARJ 壓縮檔";
$net2ftp_messages["RPM"] = "RPM";
$net2ftp_messages["GZ archive"] = "GZ 壓縮檔";
$net2ftp_messages["TAR archive"] = "TAR 壓縮檔";
$net2ftp_messages["Zip archive"] = "Zip 壓縮檔";
$net2ftp_messages["MOV movie file"] = "MOV 影像檔";
$net2ftp_messages["MPEG movie file"] = "MPEG 影像檔";
$net2ftp_messages["Real movie file"] = "Real 影像檔";
$net2ftp_messages["Quicktime movie file"] = "Quicktime 影像檔";
$net2ftp_messages["Shockwave flash file"] = "Shockwave flash 檔案";
$net2ftp_messages["Shockwave file"] = "Shockwave 檔案";
$net2ftp_messages["WAV sound file"] = "WAV 音效檔";
$net2ftp_messages["Font file"] = "Font 檔案";
$net2ftp_messages["%1\$s File"] = "%1\$s 檔案";
$net2ftp_messages["File"] = "檔案";

// getAction()
$net2ftp_messages["Back"] = "Back";
$net2ftp_messages["Submit"] = "Submit";
$net2ftp_messages["Refresh"] = "Refresh";
$net2ftp_messages["Details"] = "Details";
$net2ftp_messages["Icons"] = "Icons";
$net2ftp_messages["List"] = "List";
$net2ftp_messages["Logout"] = "Logout";
$net2ftp_messages["Help"] = "Help";
$net2ftp_messages["Bookmark"] = "Bookmark";
$net2ftp_messages["Save"] = "Save";
$net2ftp_messages["Default"] = "Default";


// -------------------------------------------------------------------------
// /skins/[skin]/header.template.php and footer.template.php
// -------------------------------------------------------------------------
$net2ftp_messages["Help Guide"] = "Help Guide";
$net2ftp_messages["Forums"] = "Forums";
$net2ftp_messages["License"] = "License";
$net2ftp_messages["Powered by"] = "Powered by";
$net2ftp_messages["You are now taken to the net2ftp forums. These forums are for net2ftp related topics only - not for generic webhosting questions."] = "You are now taken to the net2ftp forums. These forums are for net2ftp related topics only - not for generic webhosting questions.";
$net2ftp_messages["Standard"] = "Standard";
$net2ftp_messages["Mobile"] = "Mobile";

// -------------------------------------------------------------------------
// Admin module
if ($net2ftp_globals["state"] == "admin") {
// -------------------------------------------------------------------------

// /modules/admin/admin.inc.php
$net2ftp_messages["Admin functions"] = "Admin functions";

// /skins/[skin]/admin1.template.php
$net2ftp_messages["Version information"] = "Version information";
$net2ftp_messages["This version of net2ftp is up-to-date."] = "This version of net2ftp is up-to-date.";
$net2ftp_messages["The latest version information could not be retrieved from the net2ftp.com server. Check the security settings of your browser, which may prevent the loading of a small file from the net2ftp.com server."] = "The latest version information could not be retrieved from the net2ftp.com server. Check the security settings of your browser, which may prevent the loading of a small file from the net2ftp.com server.";
$net2ftp_messages["Logging"] = "Logging";
$net2ftp_messages["Date from:"] = "Date from:";
$net2ftp_messages["to:"] = "to:";
$net2ftp_messages["Empty logs"] = "Empty";
$net2ftp_messages["View logs"] = "View logs";
$net2ftp_messages["Go"] = "Go";
$net2ftp_messages["Setup MySQL tables"] = "Setup MySQL tables";
$net2ftp_messages["Create the MySQL database tables"] = "Create the MySQL database tables";

} // end admin

// -------------------------------------------------------------------------
// Admin_createtables module
if ($net2ftp_globals["state"] == "admin_createtables") {
// -------------------------------------------------------------------------

// /modules/admin_createtables/admin_createtables.inc.php
$net2ftp_messages["Admin functions"] = "Admin functions";
$net2ftp_messages["The handle of file %1\$s could not be opened."] = "The handle of file %1\$s could not be opened.";
$net2ftp_messages["The file %1\$s could not be opened."] = "The file %1\$s could not be opened.";
$net2ftp_messages["The handle of file %1\$s could not be closed."] = "The handle of file %1\$s could not be closed.";
$net2ftp_messages["The connection to the server <b>%1\$s</b> could not be set up. Please check the database settings you've entered."] = "The connection to the server <b>%1\$s</b> could not be set up. Please check the database settings you've entered.";
$net2ftp_messages["Unable to select the database <b>%1\$s</b>."] = "Unable to select the database <b>%1\$s</b>.";
$net2ftp_messages["The SQL query nr <b>%1\$s</b> could not be executed."] = "The SQL query nr <b>%1\$s</b> could not be executed.";
$net2ftp_messages["The SQL query nr <b>%1\$s</b> was executed successfully."] = "The SQL query nr <b>%1\$s</b> was executed successfully.";

// /skins/[skin]/admin_createtables1.template.php
$net2ftp_messages["Please enter your MySQL settings:"] = "Please enter your MySQL settings:";
$net2ftp_messages["MySQL username"] = "MySQL username";
$net2ftp_messages["MySQL password"] = "MySQL password";
$net2ftp_messages["MySQL database"] = "MySQL database";
$net2ftp_messages["MySQL server"] = "MySQL server";
$net2ftp_messages["This SQL query is going to be executed:"] = "This SQL query is going to be executed:";
$net2ftp_messages["Execute"] = "執行";

// /skins/[skin]/admin_createtables2.template.php
$net2ftp_messages["Settings used:"] = "Settings used:";
$net2ftp_messages["MySQL password length"] = "MySQL password length";
$net2ftp_messages["Results:"] = "Results:";

} // end admin_createtables


// -------------------------------------------------------------------------
// Admin_viewlogs module
if ($net2ftp_globals["state"] == "admin_viewlogs") {
// -------------------------------------------------------------------------

// /modules/admin_createtables/admin_viewlogs.inc.php
$net2ftp_messages["Admin functions"] = "Admin functions";
$net2ftp_messages["Unable to execute the SQL query <b>%1\$s</b>."] = "Unable to execute the SQL query <b>%1\$s</b>.";
$net2ftp_messages["No data"] = "No data";

} // end admin_viewlogs


// -------------------------------------------------------------------------
// Admin_emptylogs module
if ($net2ftp_globals["state"] == "admin_emptylogs") {
// -------------------------------------------------------------------------

// /modules/admin_createtables/admin_emptylogs.inc.php
$net2ftp_messages["Admin functions"] = "Admin functions";
$net2ftp_messages["The table <b>%1\$s</b> was emptied successfully."] = "The table <b>%1\$s</b> was emptied successfully.";
$net2ftp_messages["The table <b>%1\$s</b> could not be emptied."] = "The table <b>%1\$s</b> could not be emptied.";
$net2ftp_messages["The table <b>%1\$s</b> was optimized successfully."] = "The table <b>%1\$s</b> was optimized successfully.";
$net2ftp_messages["The table <b>%1\$s</b> could not be optimized."] = "The table <b>%1\$s</b> could not be optimized.";

} // end admin_emptylogs


// -------------------------------------------------------------------------
// Advanced module
if ($net2ftp_globals["state"] == "advanced") {
// -------------------------------------------------------------------------

// /modules/advanced/advanced.inc.php
$net2ftp_messages["Advanced functions"] = "進階功能";

// /skins/[skin]/advanced1.template.php
$net2ftp_messages["Go"] = "Go";
$net2ftp_messages["Disabled"] = "Disabled";
$net2ftp_messages["Advanced FTP functions"] = "Advanced FTP functions";
$net2ftp_messages["Send arbitrary FTP commands to the FTP server"] = "Send arbitrary FTP commands to the FTP server";
$net2ftp_messages["This function is available on PHP 5 only"] = "This function is available on PHP 5 only";
$net2ftp_messages["Troubleshooting functions"] = "Troubleshooting functions";
$net2ftp_messages["Troubleshoot net2ftp on this webserver"] = "伺服器的 net2ftp 疑難排解";
$net2ftp_messages["Troubleshoot an FTP server"] = "FTP 伺服器疑難排解";
$net2ftp_messages["Test the net2ftp list parsing rules"] = "Test the net2ftp list parsing rules";
$net2ftp_messages["Translation functions"] = "Translation functions";
$net2ftp_messages["Introduction to the translation functions"] = "Introduction to the translation functions";
$net2ftp_messages["Extract messages to translate from code files"] = "Extract messages to translate from code files";
$net2ftp_messages["Check if there are new or obsolete messages"] = "Check if there are new or obsolete messages";

$net2ftp_messages["Beta functions"] = "Beta functions";
$net2ftp_messages["Send a site command to the FTP server"] = "Send a site command to the FTP server";
$net2ftp_messages["Apache: password-protect a directory, create custom error pages"] = "Apache: password-protect a directory, create custom error pages";
$net2ftp_messages["MySQL: execute an SQL query"] = "MySQL: execute an SQL query";


// advanced()
$net2ftp_messages["The site command functions are not available on this webserver."] = "伺服器不支援運行功能.";
$net2ftp_messages["The Apache functions are not available on this webserver."] = "伺服器不支援此 Apache 功能.";
$net2ftp_messages["The MySQL functions are not available on this webserver."] = "伺服器不支援此 MYSQL 功能.";
$net2ftp_messages["Unexpected state2 string. Exiting."] = "不可預計的狀態 2 字串. 程式結束中...";

} // end advanced


// -------------------------------------------------------------------------
// Advanced_ftpserver module
if ($net2ftp_globals["state"] == "advanced_ftpserver") {
// -------------------------------------------------------------------------

// /modules/advanced_ftpserver/advanced_ftpserver.inc.php
$net2ftp_messages["Troubleshoot an FTP server"] = "FTP 伺服器疑難排解";

// /skins/[skin]/advanced_ftpserver1.template.php
$net2ftp_messages["Connection settings:"] = "連線設定:";
$net2ftp_messages["FTP server"] = "FTP 伺服器";
$net2ftp_messages["FTP server port"] = "FTP 伺服器連接埠";
$net2ftp_messages["Username"] = "用戶名稱";
$net2ftp_messages["Password"] = "用戶密碼";
$net2ftp_messages["Password length"] = "密碼長度";
$net2ftp_messages["Passive mode"] = "被動連線(Passive mode)";
$net2ftp_messages["Directory"] = "資料夾";
$net2ftp_messages["Printing the result"] = "Printing the result";

// /skins/[skin]/advanced_ftpserver2.template.php
$net2ftp_messages["Connecting to the FTP server: "] = "連接 FTP 伺服器: ";
$net2ftp_messages["Logging into the FTP server: "] = "登入到 FTP 伺服器: ";
$net2ftp_messages["Setting the passive mode: "] = "設定被動連接模式(PASV):";
$net2ftp_messages["Getting the FTP server system type: "] = "Getting the FTP server system type: ";
$net2ftp_messages["Changing to the directory %1\$s: "] = "變更資料夾到 %1\$s: ";
$net2ftp_messages["The directory from the FTP server is: %1\$s "] = "FTP 伺服器的資料夾是: %1\$s ";
$net2ftp_messages["Getting the raw list of directories and files: "] = "取得原始資料夾及檔案列表: ";
$net2ftp_messages["Trying a second time to get the raw list of directories and files: "] = "重試取得原始資料夾及檔案列表: ";
$net2ftp_messages["Closing the connection: "] = "關閉連線: ";
$net2ftp_messages["Raw list of directories and files:"] = "原始資料夾及檔案列表:";
$net2ftp_messages["Parsed list of directories and files:"] = "分析資料夾及檔案列表:";

$net2ftp_messages["OK"] = "OK";
$net2ftp_messages["not OK"] = "not OK";

} // end advanced_ftpserver


// -------------------------------------------------------------------------
// Advanced_parsing module
if ($net2ftp_globals["state"] == "advanced_parsing") {
// -------------------------------------------------------------------------

$net2ftp_messages["Test the net2ftp list parsing rules"] = "Test the net2ftp list parsing rules";
$net2ftp_messages["Sample input"] = "Sample input";
$net2ftp_messages["Parsed output"] = "Parsed output";

} // end advanced_parsing


// -------------------------------------------------------------------------
// Advanced_webserver module
if ($net2ftp_globals["state"] == "advanced_webserver") {
// -------------------------------------------------------------------------

$net2ftp_messages["Troubleshoot your net2ftp installation"] = "net2ftp 安裝程式疑難排解";
$net2ftp_messages["Printing the result"] = "Printing the result";

$net2ftp_messages["Checking if the FTP module of PHP is installed: "] = "檢查是否正確安裝了 PHP 的 FTP 模組: ";
$net2ftp_messages["yes"] = "是";
$net2ftp_messages["no - please install it!"] = "否 - 請先安裝!";

$net2ftp_messages["Checking the permissions of the directory on the web server: a small file will be written to the /temp folder and then deleted."] = "檢查資料夾的屬性: 一個小檔案會寫入 /TEMP 資料夾然後刪除.";
$net2ftp_messages["Creating filename: "] = "建立檔案名稱: ";
$net2ftp_messages["OK. Filename: %1\$s"] = "成功\. 檔案名稱: %tempfilename";
$net2ftp_messages["not OK"] = "not OK";
$net2ftp_messages["OK"] = "OK";
$net2ftp_messages["not OK. Check the permissions of the %1\$s directory"] = "失敗. 請檢查 %1\$s 資料夾的屬性";
$net2ftp_messages["Opening the file in write mode: "] = "Opening the file in write mode: ";
$net2ftp_messages["Writing some text to the file: "] = "寫入文字到: ";
$net2ftp_messages["Closing the file: "] = "關閉檔案: ";
$net2ftp_messages["Deleting the file: "] = "刪除檔案: ";

$net2ftp_messages["Testing the FTP functions"] = "Testing the FTP functions";
$net2ftp_messages["Connecting to a test FTP server: "] = "Connecting to a test FTP server: ";
$net2ftp_messages["Connecting to the FTP server: "] = "連接 FTP 伺服器: ";
$net2ftp_messages["Logging into the FTP server: "] = "登入到 FTP 伺服器: ";
$net2ftp_messages["Setting the passive mode: "] = "設定被動連接模式(PASV):";
$net2ftp_messages["Getting the FTP server system type: "] = "Getting the FTP server system type: ";
$net2ftp_messages["Changing to the directory %1\$s: "] = "變更資料夾到 %1\$s: ";
$net2ftp_messages["The directory from the FTP server is: %1\$s "] = "FTP 伺服器的資料夾是: %1\$s ";
$net2ftp_messages["Getting the raw list of directories and files: "] = "取得原始資料夾及檔案列表: ";
$net2ftp_messages["Trying a second time to get the raw list of directories and files: "] = "重試取得原始資料夾及檔案列表: ";
$net2ftp_messages["Closing the connection: "] = "關閉連線: ";
$net2ftp_messages["Raw list of directories and files:"] = "原始資料夾及檔案列表:";
$net2ftp_messages["Parsed list of directories and files:"] = "分析資料夾及檔案列表:";
$net2ftp_messages["OK"] = "OK";
$net2ftp_messages["not OK"] = "not OK";

} // end advanced_webserver


// -------------------------------------------------------------------------
// Bookmark module
if ($net2ftp_globals["state"] == "bookmark") {
// -------------------------------------------------------------------------

$net2ftp_messages["Drag and drop one of the links below to the bookmarks bar"] = "Drag and drop one of the links below to the bookmarks bar";
$net2ftp_messages["Right-click on one of the links below and choose \"Add to Favorites...\""] = "Right-click on one of the links below and choose \"Add to Favorites...\"";
$net2ftp_messages["Right-click on one the links below and choose \"Add Link to Bookmarks...\""] = "Right-click on one the links below and choose \"Add Link to Bookmarks...\"";
$net2ftp_messages["Right-click on one of the links below and choose \"Bookmark link...\""] = "Right-click on one of the links below and choose \"Bookmark link...\"";
$net2ftp_messages["Right-click on one of the links below and choose \"Bookmark This Link...\""] = "Right-click on one of the links below and choose \"Bookmark This Link...\"";
$net2ftp_messages["One click access (net2ftp won't ask for a password - less safe)"] = "One click access (net2ftp won't ask for a password - less safe)";
$net2ftp_messages["Two click access (net2ftp will ask for a password - safer)"] = "Two click access (net2ftp will ask for a password - safer)";
$net2ftp_messages["Note: when you will use this bookmark, a popup window will ask you for your username and password."] = "注意: 當你使用此書籤時, 將會有一個彈出視窗詢問你的密碼.";

} // end bookmark


// -------------------------------------------------------------------------
// Browse module
if ($net2ftp_globals["state"] == "browse") {
// -------------------------------------------------------------------------

// /modules/browse/browse.inc.php
$net2ftp_messages["Choose a directory"] = "請選擇資料夾";
$net2ftp_messages["Please wait..."] = "請稍侯...";

// browse()
$net2ftp_messages["Directories with names containing \' cannot be displayed correctly. They can only be deleted. Please go back and select another subdirectory."] = "資料夾名稱包含 \' 將無法正確顯示. 只可刪除. 請返回選取另一個子資料夾.";

$net2ftp_messages["Daily limit reached: you will not be able to transfer data"] = "Daily limit reached: you will not be able to transfer data";
$net2ftp_messages["In order to guarantee the fair use of the web server for everyone, the data transfer volume and script execution time are limited per user, and per day. Once this limit is reached, you can still browse the FTP server but not transfer data to/from it."] = "In order to guarantee the fair use of the web server for everyone, the data transfer volume and script execution time are limited per user, and per day. Once this limit is reached, you can still browse the FTP server but not transfer data to/from it.";
$net2ftp_messages["If you need unlimited usage, please install net2ftp on your own web server."] = "If you need unlimited usage, please install net2ftp on your own web server.";

// printdirfilelist()
// Keep this short, it must fit in a small button!
$net2ftp_messages["New dir"] = "加入新資料夾";
$net2ftp_messages["New file"] = "加入新檔案";
$net2ftp_messages["HTML templates"] = "HTML templates";
$net2ftp_messages["Upload"] = "上傳檔案";
$net2ftp_messages["Java Upload"] = "Java 上傳檔案";
$net2ftp_messages["Flash Upload"] = "Flash Upload";
$net2ftp_messages["Install"] = "Install";
$net2ftp_messages["Advanced"] = "進階選項";
$net2ftp_messages["Copy"] = "複製";
$net2ftp_messages["Move"] = "移動";
$net2ftp_messages["Delete"] = "刪除";
$net2ftp_messages["Rename"] = "重新命名";
$net2ftp_messages["Chmod"] = "屬性(CHOMD)";
$net2ftp_messages["Download"] = "下載";
$net2ftp_messages["Unzip"] = "Unzip";
$net2ftp_messages["Zip"] = "壓縮";
$net2ftp_messages["Size"] = "計算大小";
$net2ftp_messages["Search"] = "搜索";
$net2ftp_messages["Go to the parent directory"] = "Go to the parent directory";
$net2ftp_messages["Go"] = "Go";
$net2ftp_messages["Transform selected entries: "] = "操作選項: ";
$net2ftp_messages["Transform selected entry: "] = "Transform selected entry: ";
$net2ftp_messages["Make a new subdirectory in directory %1\$s"] = "在 %1\$s 建立一個新子資料夾";
$net2ftp_messages["Create a new file in directory %1\$s"] = "在 %1\$s 資料夾建立一個新檔案";
$net2ftp_messages["Create a website easily using ready-made templates"] = "Create a website easily using ready-made templates";
$net2ftp_messages["Upload new files in directory %1\$s"] = "在 %1\$s 資料夾上傳新檔案";
$net2ftp_messages["Upload directories and files using a Java applet"] = "Upload directories and files using a Java applet";
$net2ftp_messages["Upload files using a Flash applet"] = "Upload files using a Flash applet";
$net2ftp_messages["Install software packages (requires PHP on web server)"] = "Install software packages (requires PHP on web server)";
$net2ftp_messages["Go to the advanced functions"] = "使用進階功能";
$net2ftp_messages["Copy the selected entries"] = "複製選取的資料夾或檔案";
$net2ftp_messages["Move the selected entries"] = "移動選取的資料夾或檔案";
$net2ftp_messages["Delete the selected entries"] = "刪除選取的資料夾或檔案";
$net2ftp_messages["Rename the selected entries"] = "重新命名選取的資料夾或檔案";
$net2ftp_messages["Chmod the selected entries (only works on Unix/Linux/BSD servers)"] = "改變選取的資料夾或檔案的屬性 (只適用於 Unix/Linux/BSD 伺服器)";
$net2ftp_messages["Download a zip file containing all selected entries"] = "壓縮下載選取的資料夾或檔案";
$net2ftp_messages["Unzip the selected archives on the FTP server"] = "Unzip the selected archives on the FTP server";
$net2ftp_messages["Zip the selected entries to save or email them"] = "壓縮選取的資料夾或檔案作儲存或傳送郵件";
$net2ftp_messages["Calculate the size of the selected entries"] = "計算選取的資料夾或檔案的大小";
$net2ftp_messages["Find files which contain a particular word"] = "使用關鍵字搜索檔案";
$net2ftp_messages["Click to sort by %1\$s in descending order"] = "%1\$s 降序排列";
$net2ftp_messages["Click to sort by %1\$s in ascending order"] = "%1\$s 升序排列";
$net2ftp_messages["Ascending order"] = "升序排列";
$net2ftp_messages["Descending order"] = "降序排列";
$net2ftp_messages["Upload files"] = "Upload files";
$net2ftp_messages["Up"] = "上級資料夾";
$net2ftp_messages["Click to check or uncheck all rows"] = "Click to check or uncheck all rows";
$net2ftp_messages["All"] = "All";
$net2ftp_messages["Name"] = "名稱";
$net2ftp_messages["Type"] = "類型";
//$net2ftp_messages["Size"] = "Size";
$net2ftp_messages["Owner"] = "擁有者";
$net2ftp_messages["Group"] = "群組";
$net2ftp_messages["Perms"] = "屬性";
$net2ftp_messages["Mod Time"] = "最後修改時間";
$net2ftp_messages["Actions"] = "動作";
$net2ftp_messages["Select the directory %1\$s"] = "Select the directory %1\$s";
$net2ftp_messages["Select the file %1\$s"] = "Select the file %1\$s";
$net2ftp_messages["Select the symlink %1\$s"] = "Select the symlink %1\$s";
$net2ftp_messages["Go to the subdirectory %1\$s"] = "Go to the subdirectory %1\$s";
$net2ftp_messages["Download the file %1\$s"] = "Download the file %1\$s";
$net2ftp_messages["Follow symlink %1\$s"] = "Follow symlink %1\$s";
$net2ftp_messages["View"] = "查看";
$net2ftp_messages["Edit"] = "編輯";
$net2ftp_messages["Update"] = "更新";
$net2ftp_messages["Open"] = "開啟";
$net2ftp_messages["View the highlighted source code of file %1\$s"] = "高亮顯示 %1\$s 檔案的原始碼";
$net2ftp_messages["Edit the source code of file %1\$s"] = "編輯 %1\$s 檔案的原始碼";
$net2ftp_messages["Upload a new version of the file %1\$s and merge the changes"] = "上傳更新版本的 %1\$s 及合併更改";
$net2ftp_messages["View image %1\$s"] = "查看圖片 %1\$s";
$net2ftp_messages["View the file %1\$s from your HTTP web server"] = "從 HTTP 伺服器查看檔案 %1\$s";
$net2ftp_messages["(Note: This link may not work if you don't have your own domain name.)"] = "(注意: 如果你沒有自己的域名, 此連結可能錯誤.)";
$net2ftp_messages["This folder is empty"] = "此資料夾是空的";

// printSeparatorRow()
$net2ftp_messages["Directories"] = "資料夾";
$net2ftp_messages["Files"] = "檔案";
$net2ftp_messages["Symlinks"] = "連結";
$net2ftp_messages["Unrecognized FTP output"] = "無法確認的 FTP 輸出";
$net2ftp_messages["Number"] = "Number";
$net2ftp_messages["Size"] = "計算大小";
$net2ftp_messages["Skipped"] = "Skipped";
$net2ftp_messages["Data transferred from this IP address today"] = "Data transferred from this IP address today";
$net2ftp_messages["Data transferred to this FTP server today"] = "Data transferred to this FTP server today";

// printLocationActions()
$net2ftp_messages["Language:"] = "語言:";
$net2ftp_messages["Skin:"] = "模版:";
$net2ftp_messages["View mode:"] = "版面模式:";
$net2ftp_messages["Directory Tree"] = "資料夾位置";

// ftp2http()
$net2ftp_messages["Execute %1\$s in a new window"] = "在新視窗開啟 %1\$s";
$net2ftp_messages["This file is not accessible from the web"] = "This file is not accessible from the web";

// printDirectorySelect()
$net2ftp_messages["Double-click to go to a subdirectory:"] = "雙按滑鼠進入子資料夾:";
$net2ftp_messages["Choose"] = "選取";
$net2ftp_messages["Up"] = "上級資料夾";

} // end browse


// -------------------------------------------------------------------------
// Calculate size module
if ($net2ftp_globals["state"] == "calculatesize") {
// -------------------------------------------------------------------------
$net2ftp_messages["Size of selected directories and files"] = "選取資料夾及檔案的大小";
$net2ftp_messages["The total size taken by the selected directories and files is:"] = "選取資料夾及檔案的總大小為:";
$net2ftp_messages["The number of files which were skipped is:"] = "The number of files which were skipped is:";

} // end calculatesize


// -------------------------------------------------------------------------
// Chmod module
if ($net2ftp_globals["state"] == "chmod") {
// -------------------------------------------------------------------------
$net2ftp_messages["Chmod directories and files"] = "更改資料夾及檔案的屬性";
$net2ftp_messages["Set all permissions"] = "所有權限";
$net2ftp_messages["Read"] = "讀取";
$net2ftp_messages["Write"] = "寫入";
$net2ftp_messages["Execute"] = "執行";
$net2ftp_messages["Owner"] = "擁有者";
$net2ftp_messages["Group"] = "群組";
$net2ftp_messages["Everyone"] = "所有人";
$net2ftp_messages["To set all permissions to the same values, enter those permissions and click on the button \"Set all permissions\""] = "如要設定所有權限一樣, 在上面輸入權限並選 \"所有權限\"";
$net2ftp_messages["Set the permissions of directory <b>%1\$s</b> to: "] = "設定資料夾 <b>%1\$s</b> 的屬性為: ";
$net2ftp_messages["Set the permissions of file <b>%1\$s</b> to: "] = "設定檔案 <b>%1\$s</b> 的屬性為: ";
$net2ftp_messages["Set the permissions of symlink <b>%1\$s</b> to: "] = "設定 symlink <b>%1\$s</b> 的屬性為: ";
$net2ftp_messages["Chmod value"] = "Chmod 數值";
$net2ftp_messages["Chmod also the subdirectories within this directory"] = "並設定此資料夾內含的所有子資料夾";
$net2ftp_messages["Chmod also the files within this directory"] = "並設定此資料夾內含的所有檔案";
$net2ftp_messages["The chmod nr <b>%1\$s</b> is out of the range 000-777. Please try again."] = "屬性數值 <b>%1\$s</b> 必須在 0-777 之間.";

} // end chmod


// -------------------------------------------------------------------------
// Clear cookies module
// -------------------------------------------------------------------------
// No messages


// -------------------------------------------------------------------------
// Copy/Move/Delete module
if ($net2ftp_globals["state"] == "copymovedelete") {
// -------------------------------------------------------------------------
$net2ftp_messages["Choose a directory"] = "請選擇資料夾";
$net2ftp_messages["Copy directories and files"] = "複製資料夾及檔案";
$net2ftp_messages["Move directories and files"] = "移動資料夾及檔案";
$net2ftp_messages["Delete directories and files"] = "刪除資料夾及檔案";
$net2ftp_messages["Are you sure you want to delete these directories and files?"] = "是否確定要刪除選取的資料夾及檔案?";
$net2ftp_messages["All the subdirectories and files of the selected directories will also be deleted!"] = "所有內含的子資料夾及檔案都會一併刪除!";
$net2ftp_messages["Set all targetdirectories"] = "設定共同目標資料夾";
$net2ftp_messages["To set a common target directory, enter that target directory in the textbox above and click on the button \"Set all targetdirectories\"."] = "設定共同的目標資料夾, 請在上面的文字框填寫目標資料夾名稱並按 \"設定共同目標資料夾\".";
$net2ftp_messages["Note: the target directory must already exist before anything can be copied into it."] = "注意: 複製檔案前, 請確定目標資料夾必須存在.";
$net2ftp_messages["Different target FTP server:"] = "目標 FTP 伺服器:";
$net2ftp_messages["Username"] = "用戶名稱";
$net2ftp_messages["Password"] = "用戶密碼";
$net2ftp_messages["Leave empty if you want to copy the files to the same FTP server."] = "如果複製到原本 FTP 伺服器, 不用填寫.";
$net2ftp_messages["If you want to copy the files to another FTP server, enter your login data."] = "如果你希望複製檔案到另一個 FTP 伺服器, 請填寫登入資料.";
$net2ftp_messages["Leave empty if you want to move the files to the same FTP server."] = "如果移動到原本 FTP 伺服器, 不用填寫.";
$net2ftp_messages["If you want to move the files to another FTP server, enter your login data."] = "如果你希望移動檔案到另一個 FTP 伺服器, 請填寫登入資料.";
$net2ftp_messages["Copy directory <b>%1\$s</b> to:"] = "複製資料夾 <b>%1\$s</b> 到:";
$net2ftp_messages["Move directory <b>%1\$s</b> to:"] = "移動資料夾 <b>%1\$s</b> 到:";
$net2ftp_messages["Directory <b>%1\$s</b>"] = "資料夾 <b>%1\$s</b>";
$net2ftp_messages["Copy file <b>%1\$s</b> to:"] = "複製檔案 <b>%1\$s</b> 到:";
$net2ftp_messages["Move file <b>%1\$s</b> to:"] = "移動檔案 <b>%1\$s</b> 到:";
$net2ftp_messages["File <b>%1\$s</b>"] = "檔案 <b>%1\$s</b>";
$net2ftp_messages["Copy symlink <b>%1\$s</b> to:"] = "複製 symlink <b>%1\$s</b> 到:";
$net2ftp_messages["Move symlink <b>%1\$s</b> to:"] = "移動 symlink <b>%1\$s</b> 到:";
$net2ftp_messages["Symlink <b>%1\$s</b>"] = "Symlink <b>%1\$s</b>";
$net2ftp_messages["Target directory:"] = "目標資料夾:";
$net2ftp_messages["Target name:"] = "目標名稱:";
$net2ftp_messages["Processing the entries:"] = "處理項目:";

} // end copymovedelete


// -------------------------------------------------------------------------
// Download file module
// -------------------------------------------------------------------------
// No messages


// -------------------------------------------------------------------------
// EasyWebsite module
if ($net2ftp_globals["state"] == "easyWebsite") {
// -------------------------------------------------------------------------
$net2ftp_messages["Create a website in 4 easy steps"] = "Create a website in 4 easy steps";
$net2ftp_messages["Template overview"] = "Template overview";
$net2ftp_messages["Template details"] = "Template details";
$net2ftp_messages["Files are copied"] = "Files are copied";
$net2ftp_messages["Edit your pages"] = "Edit your pages";

// Screen 1 - printTemplateOverview
$net2ftp_messages["Click on the image to view the details of a template."] = "Click on the image to view the details of a template.";
$net2ftp_messages["Back to the Browse screen"] = "Back to the Browse screen";
$net2ftp_messages["Template"] = "Template";
$net2ftp_messages["Copyright"] = "Copyright";
$net2ftp_messages["Click on the image to view the details of this template"] = "Click on the image to view the details of this template";

// Screen 2 - printTemplateDetails
$net2ftp_messages["The template files will be copied to your FTP server. Existing files with the same filename will be overwritten. Do you want to continue?"] = "The template files will be copied to your FTP server. Existing files with the same filename will be overwritten. Do you want to continue?";
$net2ftp_messages["Install template to directory: "] = "Install template to directory: ";
$net2ftp_messages["Install"] = "Install";
$net2ftp_messages["Size"] = "計算大小";
$net2ftp_messages["Preview page"] = "Preview page";
$net2ftp_messages["opens in a new window"] = "opens in a new window";

// Screen 3
$net2ftp_messages["Please wait while the template files are being transferred to your server: "] = "Please wait while the template files are being transferred to your server: ";
$net2ftp_messages["Done."] = "Done.";
$net2ftp_messages["Continue"] = "Continue";

// Screen 4 - printEasyAdminPanel
$net2ftp_messages["Edit page"] = "Edit page";
$net2ftp_messages["Browse the FTP server"] = "Browse the FTP server";
$net2ftp_messages["Add this link to your favorites to return to this page later on!"] = "Add this link to your favorites to return to this page later on!";
$net2ftp_messages["Edit website at %1\$s"] = "Edit website at %1\$s";
$net2ftp_messages["Internet Explorer: right-click on the link and choose \"Add to Favorites...\""] = "Internet Explorer: 在連結上按滑鼠右鍵並選擇 \"加到我的最愛...\"";
$net2ftp_messages["Netscape, Mozilla, Firefox: right-click on the link and choose \"Bookmark This Link...\""] = "Netscape, Mozilla, Firefox: 在連結上按滑鼠右鍵並選擇 \"Bookmark This Link...\"";

// ftp_copy_local2ftp
$net2ftp_messages["WARNING: Unable to create the subdirectory <b>%1\$s</b>. It may already exist. Continuing..."] = "WARNING: Unable to create the subdirectory <b>%1\$s</b>. It may already exist. Continuing...";
$net2ftp_messages["Created target subdirectory <b>%1\$s</b>"] = "Created target subdirectory <b>%1\$s</b>";
$net2ftp_messages["WARNING: Unable to copy the file <b>%1\$s</b>. Continuing..."] = "WARNING: Unable to copy the file <b>%1\$s</b>. Continuing...";
$net2ftp_messages["Copied file <b>%1\$s</b>"] = "Copied file <b>%1\$s</b>";
}


// -------------------------------------------------------------------------
// Edit module
if ($net2ftp_globals["state"] == "edit") {
// -------------------------------------------------------------------------

// /modules/edit/edit.inc.php
$net2ftp_messages["Unable to open the template file"] = "無法開啟模版檔案";
$net2ftp_messages["Unable to read the template file"] = "無法讀取模版檔案";
$net2ftp_messages["Please specify a filename"] = "請指定檔案名稱";
$net2ftp_messages["Status: This file has not yet been saved"] = "狀態: 此檔案並未儲存";
$net2ftp_messages["Status: Saved on <b>%1\$s</b> using mode %2\$s"] = "狀態: 於 <b>%1\$s</b> 使用 %2\$s 模式儲存";
$net2ftp_messages["Status: <b>This file could not be saved</b>"] = "狀態: <b>此檔案無法儲存</b>";
$net2ftp_messages["Not yet saved"] = "Not yet saved";
$net2ftp_messages["Could not be saved"] = "Could not be saved";
$net2ftp_messages["Saved at %1\$s"] = "Saved at %1\$s";

// /skins/[skin]/edit.template.php
$net2ftp_messages["Directory: "] = "資料夾: ";
$net2ftp_messages["File: "] = "檔案名稱: ";
$net2ftp_messages["New file name: "] = "新檔案名稱: ";
$net2ftp_messages["Character encoding: "] = "Character encoding: ";
$net2ftp_messages["Note: changing the textarea type will save the changes"] = "注意: 改變文字方格會儲存更改";
$net2ftp_messages["Copy up"] = "Copy up";
$net2ftp_messages["Copy down"] = "Copy down";

} // end if edit


// -------------------------------------------------------------------------
// Find string module
if ($net2ftp_globals["state"] == "findstring") {
// -------------------------------------------------------------------------

// /modules/findstring/findstring.inc.php 
$net2ftp_messages["Search directories and files"] = "搜索資料夾及檔案";
$net2ftp_messages["Search again"] = "重新搜索";
$net2ftp_messages["Search results"] = "搜索結果";
$net2ftp_messages["Please enter a valid search word or phrase."] = "請輸入正確的關鍵字或詞.";
$net2ftp_messages["Please enter a valid filename."] = "請輸入正確的檔案名稱.";
$net2ftp_messages["Please enter a valid file size in the \"from\" textbox, for example 0."] = "請在 \"from\" 文字框輸入正確的檔案大小, 例如 0.";
$net2ftp_messages["Please enter a valid file size in the \"to\" textbox, for example 500000."] = "請在 \"to\" 文字框輸入正確的檔案大小, 例如 500000.";
$net2ftp_messages["Please enter a valid date in Y-m-d format in the \"from\" textbox."] = "請在 \"from\" 文字框輸入正確的日期格式 Y-m-d.";
$net2ftp_messages["Please enter a valid date in Y-m-d format in the \"to\" textbox."] = "請在 \"to\" 文字框輸入正確的日期格式 Y-m-d.";
$net2ftp_messages["The word <b>%1\$s</b> was not found in the selected directories and files."] = "在選取的資料夾及檔案裡, 關鍵字 <b>%1\$s</b> 沒有任何找到的檔案.";
$net2ftp_messages["The word <b>%1\$s</b> was found in the following files:"] = "關鍵字 <b>%1\$s</b> 被找到在:";

// /skins/[skin]/findstring1.template.php
$net2ftp_messages["Search for a word or phrase"] = "搜索字或詞";
$net2ftp_messages["Case sensitive search"] = "區分大小寫搜索";
$net2ftp_messages["Restrict the search to:"] = "限制搜索於:";
$net2ftp_messages["files with a filename like"] = "檔案名稱像";
$net2ftp_messages["(wildcard character is *)"] = "(wildcard 文字是 *)";
$net2ftp_messages["files with a size"] = "檔案大小";
$net2ftp_messages["files which were last modified"] = "最後修改的檔案";
$net2ftp_messages["from"] = "從";
$net2ftp_messages["to"] = "到";

$net2ftp_messages["Directory"] = "資料夾";
$net2ftp_messages["File"] = "檔案";
$net2ftp_messages["Line"] = "Line";
$net2ftp_messages["Action"] = "Action";
$net2ftp_messages["View"] = "查看";
$net2ftp_messages["Edit"] = "編輯";
$net2ftp_messages["View the highlighted source code of file %1\$s"] = "高亮顯示 %1\$s 檔案的原始碼";
$net2ftp_messages["Edit the source code of file %1\$s"] = "編輯 %1\$s 檔案的原始碼";

} // end findstring


// -------------------------------------------------------------------------
// Help module
// -------------------------------------------------------------------------
// No messages yet


// -------------------------------------------------------------------------
// Install size module
if ($net2ftp_globals["state"] == "install") {
// -------------------------------------------------------------------------

// /modules/install/install.inc.php
$net2ftp_messages["Install software packages"] = "Install software packages";
$net2ftp_messages["Unable to open the template file"] = "無法開啟模版檔案";
$net2ftp_messages["Unable to read the template file"] = "無法讀取模版檔案";
$net2ftp_messages["Unable to get the list of packages"] = "Unable to get the list of packages";

// /skins/blue/install1.template.php
$net2ftp_messages["The net2ftp installer script has been copied to the FTP server."] = "The net2ftp installer script has been copied to the FTP server.";
$net2ftp_messages["This script runs on your web server and requires PHP to be installed."] = "This script runs on your web server and requires PHP to be installed.";
$net2ftp_messages["In order to run it, click on the link below."] = "In order to run it, click on the link below.";
$net2ftp_messages["net2ftp has tried to determine the directory mapping between the FTP server and the web server."] = "net2ftp has tried to determine the directory mapping between the FTP server and the web server.";
$net2ftp_messages["Should this link not be correct, enter the URL manually in your web browser."] = "Should this link not be correct, enter the URL manually in your web browser.";

} // end install


// -------------------------------------------------------------------------
// Java upload module
if ($net2ftp_globals["state"] == "jupload") {
// -------------------------------------------------------------------------
$net2ftp_messages["Upload directories and files using a Java applet"] = "Upload directories and files using a Java applet";
$net2ftp_messages["Your browser does not support applets, or you have disabled applets in your browser settings."] = "Your browser does not support applets, or you have disabled applets in your browser settings.";
$net2ftp_messages["To use this applet, please install the newest version of Sun's java. You can get it from <a href=\"http://www.java.com/\">java.com</a>. Click on Get It Now."] = "To use this applet, please install the newest version of Sun's java. You can get it from <a href=\"http://www.java.com/\">java.com</a>. Click on Get It Now.";
$net2ftp_messages["The online installation is about 1-2 MB and the offline installation is about 13 MB. This 'end-user' java is called JRE (Java Runtime Environment)."] = "The online installation is about 1-2 MB and the offline installation is about 13 MB. This 'end-user' java is called JRE (Java Runtime Environment).";
$net2ftp_messages["Alternatively, use net2ftp's normal upload or upload-and-unzip functionality."] = "Alternatively, use net2ftp's normal upload or upload-and-unzip functionality.";

} // end jupload



// -------------------------------------------------------------------------
// Login module
if ($net2ftp_globals["state"] == "login") {
// -------------------------------------------------------------------------
$net2ftp_messages["Login!"] = "Login!";
$net2ftp_messages["Once you are logged in, you will be able to:"] = "Once you are logged in, you will be able to:";
$net2ftp_messages["Navigate the FTP server"] = "Navigate the FTP server";
$net2ftp_messages["Once you have logged in, you can browse from directory to directory and see all the subdirectories and files."] = "Once you have logged in, you can browse from directory to directory and see all the subdirectories and files.";
$net2ftp_messages["Upload files"] = "Upload files";
$net2ftp_messages["There are 3 different ways to upload files: the standard upload form, the upload-and-unzip functionality, and the Java Applet."] = "There are 3 different ways to upload files: the standard upload form, the upload-and-unzip functionality, and the Java Applet.";
$net2ftp_messages["Download files"] = "Download files";
$net2ftp_messages["Click on a filename to quickly download one file.<br />Select multiple files and click on Download; the selected files will be downloaded in a zip archive."] = "Click on a filename to quickly download one file.<br />Select multiple files and click on Download; the selected files will be downloaded in a zip archive.";
$net2ftp_messages["Zip files"] = "Zip files";
$net2ftp_messages["... and save the zip archive on the FTP server, or email it to someone."] = "... and save the zip archive on the FTP server, or email it to someone.";
$net2ftp_messages["Unzip files"] = "Unzip files";
$net2ftp_messages["Different formats are supported: .zip, .tar, .tgz and .gz."] = "Different formats are supported: .zip, .tar, .tgz and .gz.";
$net2ftp_messages["Install software"] = "Install software";
$net2ftp_messages["Choose from a list of popular applications (PHP required)."] = "Choose from a list of popular applications (PHP required).";
$net2ftp_messages["Copy, move and delete"] = "Copy, move and delete";
$net2ftp_messages["Directories are handled recursively, meaning that their content (subdirectories and files) will also be copied, moved or deleted."] = "Directories are handled recursively, meaning that their content (subdirectories and files) will also be copied, moved or deleted.";
$net2ftp_messages["Copy or move to a 2nd FTP server"] = "Copy or move to a 2nd FTP server";
$net2ftp_messages["Handy to import files to your FTP server, or to export files from your FTP server to another FTP server."] = "Handy to import files to your FTP server, or to export files from your FTP server to another FTP server.";
$net2ftp_messages["Rename and chmod"] = "Rename and chmod";
$net2ftp_messages["Chmod handles directories recursively."] = "Chmod handles directories recursively.";
$net2ftp_messages["View code with syntax highlighting"] = "View code with syntax highlighting";
$net2ftp_messages["PHP functions are linked to the documentation on php.net."] = "PHP functions are linked to the documentation on php.net.";
$net2ftp_messages["Plain text editor"] = "Plain text editor";
$net2ftp_messages["Edit text right from your browser; every time you save the changes the new file is transferred to the FTP server."] = "Edit text right from your browser; every time you save the changes the new file is transferred to the FTP server.";
$net2ftp_messages["HTML editors"] = "HTML editors";
$net2ftp_messages["Edit HTML a What-You-See-Is-What-You-Get (WYSIWYG) form; there are 2 different editors to choose from."] = "Edit HTML a What-You-See-Is-What-You-Get (WYSIWYG) form; there are 2 different editors to choose from.";
$net2ftp_messages["Code editor"] = "Code editor";
$net2ftp_messages["Edit HTML and PHP in an editor with syntax highlighting."] = "Edit HTML and PHP in an editor with syntax highlighting.";
$net2ftp_messages["Search for words or phrases"] = "Search for words or phrases";
$net2ftp_messages["Filter out files based on the filename, last modification time and filesize."] = "Filter out files based on the filename, last modification time and filesize.";
$net2ftp_messages["Calculate size"] = "Calculate size";
$net2ftp_messages["Calculate the size of directories and files."] = "Calculate the size of directories and files.";

$net2ftp_messages["FTP server"] = "FTP 伺服器";
$net2ftp_messages["Example"] = "範例";
$net2ftp_messages["Port"] = "Port";
$net2ftp_messages["Protocol"] = "Protocol";
$net2ftp_messages["Username"] = "用戶名稱";
$net2ftp_messages["Password"] = "用戶密碼";
$net2ftp_messages["Anonymous"] = "Anonymous";
$net2ftp_messages["Passive mode"] = "被動連線(Passive mode)";
$net2ftp_messages["Initial directory"] = "進入資料夾";
$net2ftp_messages["Language"] = "語言";
$net2ftp_messages["Skin"] = "模版";
$net2ftp_messages["FTP mode"] = "FTP mode";
$net2ftp_messages["Automatic"] = "Automatic";
$net2ftp_messages["Login"] = "登入";
$net2ftp_messages["Clear cookies"] = "清除 Cookies";
$net2ftp_messages["Admin"] = "Admin";
$net2ftp_messages["Please enter an FTP server."] = "Please enter an FTP server.";
$net2ftp_messages["Please enter a username."] = "Please enter a username.";
$net2ftp_messages["Please enter a password."] = "Please enter a password.";

} // end login


// -------------------------------------------------------------------------
// Login module
if ($net2ftp_globals["state"] == "login_small") {
// -------------------------------------------------------------------------

$net2ftp_messages["Please enter your Administrator username and password."] = "Please enter your Administrator username and password.";
$net2ftp_messages["Please enter your username and password for FTP server <b>%1\$s</b>."] = "Please enter your username and password for FTP server <b>%1\$s</b>.";
$net2ftp_messages["Username"] = "用戶名稱";
$net2ftp_messages["Your session has expired; please enter your password for FTP server <b>%1\$s</b> to continue."] = "Your session has expired; please enter your password for FTP server <b>%1\$s</b> to continue.";
$net2ftp_messages["Your IP address has changed; please enter your password for FTP server <b>%1\$s</b> to continue."] = "Your IP address has changed; please enter your password for FTP server <b>%1\$s</b> to continue.";
$net2ftp_messages["Password"] = "用戶密碼";
$net2ftp_messages["Login"] = "登入";
$net2ftp_messages["Continue"] = "Continue";

} // end login_small


// -------------------------------------------------------------------------
// Logout module
if ($net2ftp_globals["state"] == "logout") {
// -------------------------------------------------------------------------

// logout.inc.php
$net2ftp_messages["Login page"] = "Login page";

// logout.template.php
$net2ftp_messages["You have logged out from the FTP server. To log back in, <a href=\"%1\$s\" title=\"Login page (accesskey l)\" accesskey=\"l\">follow this link</a>."] = "You have logged out from the FTP server. To log back in, <a href=\"%1\$s\" title=\"Login page (accesskey l)\" accesskey=\"l\">follow this link</a>.";
$net2ftp_messages["Note: other users of this computer could click on the browser's Back button and access the FTP server."] = "Note: other users of this computer could click on the browser's Back button and access the FTP server.";
$net2ftp_messages["To prevent this, you must close all browser windows."] = "To prevent this, you must close all browser windows.";
$net2ftp_messages["Close"] = "Close";
$net2ftp_messages["Click here to close this window"] = "Click here to close this window";

} // end logout


// -------------------------------------------------------------------------
// New directory module
if ($net2ftp_globals["state"] == "newdir") {
// -------------------------------------------------------------------------
$net2ftp_messages["Create new directories"] = "建立新資料夾";
$net2ftp_messages["The new directories will be created in <b>%1\$s</b>."] = "新資料夾將會建立在 <b>%1\$s</b>.";
$net2ftp_messages["New directory name:"] = "新資料夾名稱:";
$net2ftp_messages["Directory <b>%1\$s</b> was successfully created."] = "資料夾 <b>%1\$s</b> 已經成功建立.";
$net2ftp_messages["Directory <b>%1\$s</b> could not be created."] = "Directory <b>%1\$s</b> could not be created.";

} // end newdir


// -------------------------------------------------------------------------
// Raw module
if ($net2ftp_globals["state"] == "raw") {
// -------------------------------------------------------------------------

// /modules/raw/raw.inc.php
$net2ftp_messages["Send arbitrary FTP commands"] = "Send arbitrary FTP commands";


// /skins/[skin]/raw1.template.php
$net2ftp_messages["List of commands:"] = "List of commands:";
$net2ftp_messages["FTP server response:"] = "FTP server response:";

} // end raw


// -------------------------------------------------------------------------
// Rename module
if ($net2ftp_globals["state"] == "rename") {
// -------------------------------------------------------------------------
$net2ftp_messages["Rename directories and files"] = "重新命名資料夾及檔案";
$net2ftp_messages["Old name: "] = "舊名稱: ";
$net2ftp_messages["New name: "] = "新名稱: ";
$net2ftp_messages["The new name may not contain any dots. This entry was not renamed to <b>%1\$s</b>"] = "新名稱不可包含任何 <b>\".\"</b>字符 此輸入無法重新命名為 <b>%1\$s</b>";
$net2ftp_messages["The new name may not contain any banned keywords. This entry was not renamed to <b>%1\$s</b>"] = "The new name may not contain any banned keywords. This entry was not renamed to <b>%1\$s</b>";
$net2ftp_messages["<b>%1\$s</b> was successfully renamed to <b>%2\$s</b>"] = "<b>%1\$s</b> 已經成功重新命名為 <b>%2\$s</b>";
$net2ftp_messages["<b>%1\$s</b> could not be renamed to <b>%2\$s</b>"] = "<b>%1\$s</b> could not be renamed to <b>%2\$s</b>";

} // end rename


// -------------------------------------------------------------------------
// Unzip module
if ($net2ftp_globals["state"] == "unzip") {
// -------------------------------------------------------------------------

// /modules/unzip/unzip.inc.php
$net2ftp_messages["Unzip archives"] = "Unzip archives";
$net2ftp_messages["Getting archive %1\$s of %2\$s from the FTP server"] = "Getting archive %1\$s of %2\$s from the FTP server";
$net2ftp_messages["Unable to get the archive <b>%1\$s</b> from the FTP server"] = "Unable to get the archive <b>%1\$s</b> from the FTP server";

// /skins/[skin]/unzip1.template.php
$net2ftp_messages["Set all targetdirectories"] = "設定共同目標資料夾";
$net2ftp_messages["To set a common target directory, enter that target directory in the textbox above and click on the button \"Set all targetdirectories\"."] = "設定共同的目標資料夾, 請在上面的文字框填寫目標資料夾名稱並按 \"設定共同目標資料夾\".";
$net2ftp_messages["Note: the target directory must already exist before anything can be copied into it."] = "注意: 複製檔案前, 請確定目標資料夾必須存在.";
$net2ftp_messages["Unzip archive <b>%1\$s</b> to:"] = "Unzip archive <b>%1\$s</b> to:";
$net2ftp_messages["Target directory:"] = "目標資料夾:";
$net2ftp_messages["Use folder names (creates subdirectories automatically)"] = "使用資料夾名稱 (自動建立子資料夾)";

} // end unzip


// -------------------------------------------------------------------------
// Upload module
if ($net2ftp_globals["state"] == "upload") {
// -------------------------------------------------------------------------
$net2ftp_messages["Upload to directory:"] = "上傳到資料夾:";
$net2ftp_messages["Files"] = "檔案";
$net2ftp_messages["Archives"] = "Archives";
$net2ftp_messages["Files entered here will be transferred to the FTP server."] = "在這裡輸入的檔案將會傳送到 FTP 伺服器.";
$net2ftp_messages["Archives entered here will be decompressed, and the files inside will be transferred to the FTP server."] = "在這裡輸入的壓縮檔案將會被解壓並且把內含的檔案傳送到 FTP 伺服器.";
$net2ftp_messages["Add another"] = "加入其他";
$net2ftp_messages["Use folder names (creates subdirectories automatically)"] = "使用資料夾名稱 (自動建立子資料夾)";

$net2ftp_messages["Choose a directory"] = "請選擇資料夾";
$net2ftp_messages["Please wait..."] = "請稍侯...";
$net2ftp_messages["Uploading... please wait..."] = "上傳中... 請稍侯...";
$net2ftp_messages["If the upload takes more than the allowed <b>%1\$s seconds<\/b>, you will have to try again with less/smaller files."] = "如果上傳時間超過 <b>%1\$s 秒<\/b>, 你需要減少上傳檔案數量及上傳體積較少的檔案.";
$net2ftp_messages["This window will close automatically in a few seconds."] = "此視窗將於數秒後自動關閉.";
$net2ftp_messages["Close window now"] = "立即關閉視窗";

$net2ftp_messages["Upload files and archives"] = "上傳檔案及壓縮檔案";
$net2ftp_messages["Upload results"] = "上傳結果";
$net2ftp_messages["Checking files:"] = "檢查檔案:";
$net2ftp_messages["Transferring files to the FTP server:"] = "傳送到 FTP 伺服器的檔案:";
$net2ftp_messages["Decompressing archives and transferring files to the FTP server:"] = "解壓並傳送到 FTP 伺服器的檔案:";
$net2ftp_messages["Upload more files and archives"] = "上傳更多檔案或壓縮檔案";

} // end upload


// -------------------------------------------------------------------------
// Messages which are shared by upload and jupload
if ($net2ftp_globals["state"] == "upload" || $net2ftp_globals["state"] == "jupload") {
// -------------------------------------------------------------------------
$net2ftp_messages["Restrictions:"] = "限制:";
$net2ftp_messages["The maximum size of one file is restricted by net2ftp to <b>%1\$s</b> and by PHP to <b>%2\$s</b>"] = "net2ftp 容許最大單檔案的體積為 <b>%1\$s</b>, PHP 容許最大單檔案的體積為 <b>%2\$s</b>";
$net2ftp_messages["The maximum execution time is <b>%1\$s seconds</b>"] = "最大容許操作時間為 <b>%1\$s 秒</b>";
$net2ftp_messages["The FTP transfer mode (ASCII or BINARY) will be automatically determined, based on the filename extension"] = "FTP傳送模式 (ASCII 或 BINARY) 將會根據副檔名自動分辨";
$net2ftp_messages["If the destination file already exists, it will be overwritten"] = "如果目標檔案存在, 將會被覆蓋\";

} // end upload or jupload


// -------------------------------------------------------------------------
// View module
if ($net2ftp_globals["state"] == "view") {
// -------------------------------------------------------------------------

// /modules/view/view.inc.php
$net2ftp_messages["View file %1\$s"] = "View file %1\$s";
$net2ftp_messages["View image %1\$s"] = "查看圖片 %1\$s";
$net2ftp_messages["View Macromedia ShockWave Flash movie %1\$s"] = "View Macromedia ShockWave Flash movie %1\$s";
$net2ftp_messages["Image"] = "Image";

// /skins/[skin]/view1.template.php
$net2ftp_messages["Syntax highlighting powered by <a href=\"http://luminous.asgaard.co.uk\">Luminous</a>"] = "Syntax highlighting powered by <a href=\"http://luminous.asgaard.co.uk\">Luminous</a>";
$net2ftp_messages["To save the image, right-click on it and choose 'Save picture as...'"] = "To save the image, right-click on it and choose 'Save picture as...'";

} // end view


// -------------------------------------------------------------------------
// Zip module
if ($net2ftp_globals["state"] == "zip") {
// -------------------------------------------------------------------------

// /modules/zip/zip.inc.php
$net2ftp_messages["Zip entries"] = "壓縮項目";

// /skins/[skin]/zip1.template.php
$net2ftp_messages["Save the zip file on the FTP server as:"] = "在 FTP 伺服器上儲存壓縮檔案為:";
$net2ftp_messages["Email the zip file in attachment to:"] = "電郵壓縮檔案為附檔到:";
$net2ftp_messages["Note that sending files is not anonymous: your IP address as well as the time of the sending will be added to the email."] = "注意: 傳送檔案會記錄你的 IP 地址和時間並把這些資料一併送出.";
$net2ftp_messages["Some additional comments to add in the email:"] = "傳送電郵附加訊息:";

$net2ftp_messages["You did not enter a filename for the zipfile. Go back and enter a filename."] = "你沒有輸入壓縮檔案的名稱. 請返回並輸入.";
$net2ftp_messages["The email address you have entered (%1\$s) does not seem to be valid.<br />Please enter an address in the format <b>username@domain.com</b>"] = "此電郵地址 (%1\$s) 格式不正確.<br />請使用此格式 <b>username@domain.com</b>";

} // end zip

?>