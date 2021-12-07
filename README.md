# 个人修改DBMS_CLOUD包以在非自治数据库支持EXPORT_DATA功能

## 项目地址：
https://github.com/Dark-Athena/dbms_cloud_fix

## 声明：
本补丁制作目的为学习，非商业行为，制作过程未对ORACLE公司旗下产品产生任何反编译及破解行为，如有使用本代码引起的被ORACLE投诉侵权，本人概不负责。

## 补丁介绍
本补丁代码大部分是从oraclecloud上的自治数据库（19.13.0.1.0）手工提取，提取时间为2021-12-06 22:00:00

已通过以下基本测试，其余功能应该也没问题，如有问题请反馈
- 创建认证 CREATE_CREDENTIAL
- 云存储外部表 CREATE_EXTERNAL_TABLE
- 上传对象 PUT_OBJECT
- 下载对象 GET_OBJECT
- list对象 LIST_OBJECT
- 删除对象 DELETE_OBJECT
- 导出数据到云存储 EXPORT_DATA

EXPORT_DATA的format参数支持（兼容原版）
- format_type : json/csv/xml/txt, 文本格式
- recorddelimiter : 换行符
- delimiter : 字段分隔符(CSV格式使用)
 
其中DBMS_CLOUD_FIX.sql为本人手动修正的代码，不保证和自治数据库一致（自治数据库无sys权限，部分代码和数据无法看到）  
经核实官方代码，由于非自治数据库的19.13版本内置C语言函数未更新，
>LANGUAGE C  
LIBRARY sys.dbms_pdb_lib  
NAME "kpdbocExportRows"  

所以打了自治数据库的DBMS_CLOUD包仍然无法执行export_data。
但由于目前自治数据库的plsql代码已经很完善了(之前代码有大量缺失)，所以我修改了dbms_cloud的代码，借用put_object(content)实现export_data。

dbms_cloud.pck_bak为自治数据库中的原版备份，   
dbms_cloud.pck中的export_rows_tabfunc函数为我重新开发，以兼容原版功能，  
export_data_xform_query函数中的xml类型sql转换进行了微调，   
这两处均有注释"BY DarkAthena"。此包中的其余部分没有进行任何修改  

## 与自治数据库版的差异

暂不支持的format参数
- maxfilesize 最大文件大小
- compression : AUTO/GZIP, 是否压缩
 
私有变量ROWS_PER_FETCH未启用，原功能是在C语言函数中使用此变量，对json进行分批处理(之前我也遇到过大批量数据转json的效率问题)。  
本修改版为一次性查到内存再上传，如果分包上传的话，对原功能的修改量会比较大，不方便维护。   

自治数据库会自行截断超过每行限制长度的字符，造成数据缺失，本补丁代码不支持截断数据。

自治数据库export_data时，会在文件名上加上时间戳，而且会识别文件后缀是否和format_type一致，不一致时会再加上一个后缀。  
我认为此功能不方便根据对象名称获取云存储对象，因此未模拟此代码，而是让文件名和用户指定的uri保持一致，如果压缩则加上".gz"  

另外，官方代码中目前仍有大量未启用的变量，例如更多的压缩类型、是否跳过字段名等，均未进行支持，所以本补丁暂时也不会越俎代庖来提前支持官方不支持的功能。
 
自治数据库随时都可能有代码维护，变动很频繁，没准哪天oracle神不知鬼不觉的就把这些未启用的变量给用上了，所以本补丁也不会时刻保持跟进

## 安装方法
请先按官方文档安装完dbms_cloud_install.sql后再打本补丁  
[How To Setup And Use DBMS_CLOUD Package (Doc ID 2748362.1)](https://support.oracle.com/epmos/faces/DocContentDisplay?id=2748362.1)  
如果无查看mos文档的权限，也可参考Tim Hall的文章来安装官方的dbms_cloud_install.sql  
[DBMS_CLOUD : Installation on 19c and 21c On-Prem Databases](https://oracle-base.com/articles/21c/dbms_cloud-installation)  

以下为打本补丁的命令参考  
```
cd /u03/dbms_cloud_from_adb

$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl \
  -u sys/SysPassword1 \
  --force_pdb_mode 'READ WRITE' \
  -b dbms_cloud_from_adb_install \
  -d /u03/dbms_cloud_from_adb \
  -l /u03/dbms_cloud_from_adb \
  dbms_cloud_from_adb_install.sql
```

注意CDB打完补丁后可能需要重启数据库(PDB)才能生效新的plsql包  

## 相关文章
[【ORACLE】使用DBMS_CLOUD包对京东云对象存储服务OSS进行操作及创建外部表](https://a.darkathena.top/archives/dbmscloudjdcloudoss)
