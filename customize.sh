SKIPUNZIP=0

# 获取基础环境信息
MODversion=`grep_prop version $TMPDIR/module.prop`
MODdescription=`grep_prop description $TMPDIR/module.prop`
device=`getprop ro.product.device`
Version=`getprop ro.build.version.incremental`
Android=`getprop ro.build.version.release`
Sdk=`getprop ro.build.version.sdk`

# 获取音量键状态
get_choose()
{
	local choose
	local branch
	while :; do
		choose="$(getevent -qlc 1 | awk '{ print $3 }')"
		case "$choose" in
		KEY_VOLUMEUP)  branch="0" ;;
		KEY_VOLUMEDOWN)  branch="1" ;;
		*)  continue ;;
		esac
		echo "$branch"
		break
	done
}

#安装模块时打印的信息
UiPrint() 
{
	echo "$@"
	sleep 0.03
}
UiPrint "****************************"
UiPrint "- 模块: $MODNAME"
UiPrint "- 作者: $MODAUTH"
UiPrint "****************************"
UiPrint "- 设备代号: $device"
UiPrint "- 安卓版本: Android $Android"
UiPrint "- MIUI版本: $Version"
UiPrint "****************************"
UiPrint "* 仅适用于运行官方 MIUI 14 的设备 "
UiPrint "* 其他设备/系统安装可能造成未知影响！"
UiPrint "? 确定安装此模块吗？(请选择)" 
UiPrint "- 按音量键+ : 安装"
UiPrint "- 按音量键- : 取消"
 
if [[ $(get_choose) == 0 ]]; then
	UiPrint "- 已选择安装 $MODNAME"
	UiPrint " "
	if [[ -f "/system_ext/etc/forcedarkconfig/ForceDarkAppSettings.json" ]] ; then
		UiPrint "- 环境检测版本: $Version"
        UiPrint "- 检测到14配置，您是 MIUI14 系统"
        UiPrint "? 是否确定安装，版本不对应可能造成无法开机?"
		UiPrint "- 按音量键+ : 安装"
        UiPrint "- 按音量键- : 取消"
		if [[ $(get_choose) == 0 ]]; then
			UiPrint "- 开始 MIUI14 配置安装模式"
            unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
            mkdir -p $MODPATH/system/system_ext/etc/forcedarkconfig/
	        mv -f $MODPATH/system/etc/forcedarkconfig/* $MODPATH/system/system_ext/etc/forcedarkconfig/
            mv -f $MODPATH/system/etc/ForceDarkAppSettings.json $MODPATH/system/system_ext/etc/forcedarkconfig/ForceDarkAppSettings.json
	        rm -rf $MODPATH/system/etc
            UiPrint "* 模块安装完成"
        else
            abort "* 已经选择退出安装"
		fi
	else
		UiPrint "- 开始 MIUI13 配置安装模式"
        unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
		UiPrint "* 模块安装完成"
	fi
else
    abort "* 已经选择退出安装"
fi
