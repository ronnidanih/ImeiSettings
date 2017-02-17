#------------------------- 以下为只有 .c .cpp makefile等文件控制需要加的 部分, 只是java就不用加这里----------------------------------------------#
XUNHU_AUTO_ADD_GLOBAL_DEFINE_BY_NAME =XUNHU_LPS_TEKHW_SUPPORT XUNHU_BUILD_GMS XUNHU_QTY_SMART_WAKE_UP XUNHU_BUILD_FINGERPRINT_SHORT XUNHU_LLQ_POWER_OFF_CHARGING_SHOW_LOGO  XUNHU_HARDWARE_WITH_TEMP_CHECK XUNHU_LLQ_SHOW_CHARGING_CURRENT
XUNHU_AUTO_ADD_GLOBAL_DEFINE_BY_NAME_VALUE =
XUNHU_AUTO_ADD_GLOBAL_DEFINE_BY_VALUE =
XUNHU_AUTO_ADD_GLOBAL_DEFINE_BY_INT_VALUE =

XUNHU_CSY_TEST_FEATURE=yes

#324 324_ddr3  644  648 648_ddr3  12816_ddr3
XUNHU_PROJECT_MEMORY_TYPE=no
#默认关闭MTK的configcheck
DISABLE_MTK_CONFIG_CHECK=yes

XUNHU_LPS_TEKHW_SUPPORT=yes
#add by liuteng begin
XUNHU_ZDP_LAUNCHER_APP_TITLE_DISPLAY_IN_TWO_LINES=yes
#add by liuteng end
#作者:TRF251
#功能:user版本用开关可以加入测试版本水印
#使用方法:yes/no,默认no
XUNHU_LH_OPEN_TEST_VERSION=no


#作者:TRF228
#功能:GMS core app 核心app的开关
#使用方法:yes/no,默认yes
XUNHU_BUILD_GMS=yes

#作者:TRF251
#功能:*#5374# 外单平台验证销量统计指令,相关宏,其中宏XUNHU_LIUT_SALE_TRACKER开启后会将apk打包进系统
#使用方法:yes/no,默认no
XUNHU_LIUT_SALE_TRACKER=no
XUNHU_INTEX_S5023_INDIA=no
XUNHU_INTEX_S5023_SRILANKA=no
XUNHU_INTEX_S5023_NEPAL=no
XUNHU_INTEX_S5023_BANGLADESH=no
XUNHU_YS_YFND_STYLUS_SALETRACKER=no
XUNHU_YS_H910_ALF_SALETRACKER=no
XUNHU_ZJD_H921W_YDW_X5AW_SALETRACKER=no
XUNHU_HFJ_WLSD_STAR_SALETRACKER=no
XUNHU_SBYH_SALESTRACKER=no

#########################Add by QinTuanye########################
XUNHU_QTY_SMART_WAKE_UP=no
XUNHU_QTY_CPU_USAGE_CURVE=no
#######################End add by QinTuanye#######################

#add by luoliqiang  for project name can not exceed 91 bytes build error
XUNHU_BUILD_FINGERPRINT_SHORT=yes
#add by luoliqiang for power off charging show logo
XUNHU_LLQ_POWER_OFF_CHARGING_SHOW_LOGO=yes
#add by luoliqiang for battery temp check
XUNHU_HARDWARE_WITH_TEMP_CHECK=yes
#add by luoliqiang for show charging current
XUNHU_LLQ_SHOW_CHARGING_CURRENT=yes
