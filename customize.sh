#默认不动
SKIPMOUNT=false
#如果想启用system.prop的参数，则改为true
PROPFILE=false
#开机前执行的命令，想启用则改为true
POSTFSDATA=false
#开机后执行的命令，想启用则改为true
LATESTARTSERVICE=false

#安装模块时打印的信息，不需要的部分可以自己删除，也可以自己添加。
print_modname() {
ui_print "
 ****************************
 - 模块: $MODNAME
 - 作者: $MODAUTHOR
 ****************************
 - 设备代号: $device
 - 安卓版本: Android $Android
 - MIUI版本: $Version
 ****************************
 "
 sleep 0.05
 ui_print " * 仅适用于运行MIUI的设备"
 sleep 0.05
 ui_print " * 其他设备安装可能造成未知影响！"
 sleep 0.05
 ui_print " * Telegram Group: @darkp_miui "
}

#开始安装（shell命令）
on_install() {
    ui_print " "
    ui_print " - Extracting module files"
    unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
#install_module
#abort 
#用于停止/清除安装时需要的命令，正常情况下用不到，请删除后写入你的shell命令。
}

#设置权限
set_permissions() {
set_perm_recursive  $MODPATH  0  0  0755  0644
}