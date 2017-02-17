##########################################
# Teksun Makefile Configuration
#
#  Author:      caicai
#  Version:     1.0.0
#  Date:        2016.12.09
##########################################



TEKSUN_TARGET_PROJECT=$(MTK_TARGET_PROJECT)
$(warning caicai_debug TEKSUN_TARGET_PROJECT=$(TEKSUN_TARGET_PROJECT))
#$(shell rm -rf out/buildinfo.txt)
#$(shell echo TARGET_PRODUCT=$(TEKSUN_TARGET_PROJECT) > out/buildinfo.txt)
#$(shell echo TARGET_BUILD_VARIANT=$(TARGET_BUILD_VARIANT) >> out/buildinfo.txt)
$(shell test -d out || mkdir out)
$(shell printenv | grep -E "ANDROID_BUILD_TOP|TARGET_PRODUCT|TARGET_BUILD_VARIANT|ANDROID_PRODUCT_OUT" > out/buildinfo.txt)


# kernel config file configuration
ifeq ($(TARGET_BUILD_VARIANT),eng)
$(shell cp device/teksun/$(TEKSUN_TARGET_PROJECT)/kernel-autoconfig/debug_defconfig  kernel-3.18/arch/arm/configs/kernel_defconfig)
else
$(shell cp device/teksun/$(TEKSUN_TARGET_PROJECT)/kernel-autoconfig/user_defconfig  kernel-3.18/arch/arm/configs/kernel_defconfig)
endif
KERNEL_DEFCONFIG := kernel_defconfig
# end kernel config file configuration


# MemoryDevice configuration
MEMORY_TYPE := $(strip $(XUNHU_PROJECT_MEMORY_TYPE))
#$(warning MEMORY_TYPE = $(MEMORY_TYPE))
ifneq ($(wildcard vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/custom_MemoryDevice.h.$(MEMORY_TYPE)),)
  $(shell cp -rf vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/custom_MemoryDevice.h.$(MEMORY_TYPE)  vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/$(TEKSUN_TARGET_PROJECT)/inc/custom_MemoryDevice.h )
  PRODUCT_PROPERTY_OVERRIDES += ro.xunhu.memory_type=$(MEMORY_TYPE)
else
  $(error check your Projectconfig.mk :  XUNHU_PROJECT_MEMORY_TYPE or custom_MemoryDevice.h.$(MEMORY_TYPE) if exsit  )
endif

# end MemoryDevice configuration



# begin: Add by caicai for During the first boot, the date display the default build time 
$(shell echo "#define RTC_DEFAULT_MTH $(shell date +%-m)" > vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/$(TEKSUN_TARGET_PROJECT)/inc/make_month.h)
$(shell echo "#define RTC_DEFAULT_YEA $(shell date +%Y)" >> vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/$(TEKSUN_TARGET_PROJECT)/inc/make_month.h)

$(shell echo "#define RTC_DEFAULT_MTH $(shell date +%-m)" > kernel-3.18/drivers/misc/mediatek/rtc/make_month.h)
$(shell echo "#define RTC_DEFAULT_YEA $(shell date +%Y)" >> kernel-3.18/drivers/misc/mediatek/rtc/make_month.h)
# end Xunhu: Add by caicai for During the first boot, the date display the default build time



# TEKSUN PREBUILT APP configuration BEGIN
$(warning ======================腾瑞丰预装应用方案V1.0======================)
$(shell bash teksun/prebuilt/build/prebuilt_mk.sh $(TEKSUN_TARGET_PROJECT))
include teksun/prebuilt/build/prebuilt_app.mk

ifneq ($(wildcard device/teksun/$(TEKSUN_TARGET_PROJECT)/custom/prebuilt_app.mk),)
  include device/teksun/$(TEKSUN_TARGET_PROJECT)/custom/prebuilt_app.mk
endif

$(warning TEKSUN_OPERATOR_APP=$(TEKSUN_OPERATOR_APP))
$(warning TEKSUN_PRIV_APP=$(TEKSUN_PRIV_APP))
$(warning TEKSUN_APP=$(TEKSUN_APP))

PRODUCT_PACKAGES += $(subst ",,$(strip $(TEKSUN_OPERATOR_APP)))
PRODUCT_PACKAGES += $(subst ",,$(strip $(TEKSUN_PRIV_APP)))
PRODUCT_PACKAGES += $(subst ",,$(strip $(TEKSUN_APP)))


#$(warning $(PRODUCT_PACKAGES))
$(warning ======================腾瑞丰预装应用方案END======================)
# TEKSUN PREBUILT APP configuration END 

#eng需加入测试版本水印，user版本也要用开关可以加入测试版本水印，防止未测试的软件客户用于量产
ifeq ($(strip $(TARGET_BUILD_VARIANT)),eng)
    PRODUCT_PACKAGES += MineVersion
else 
	ifeq ($(strip $(XUNHU_LH_OPEN_TEST_VERSION)), yes)
	    PRODUCT_PACKAGES += MineVersion
	endif
endif

#add GMS core app
ifeq ($(strip $(XUNHU_BUILD_GMS)),yes) 
PRODUCT_SHIPPING_API_LEVEL := 24
$(call inherit-product-if-exists, teksun/packages/apps/Google/products/gms.mk)
endif


# add FactoryTest
PRODUCT_PACKAGES += FactoryTest

# add SecretCode
PRODUCT_PACKAGES += SecretCode

#add 外单销量统计
ifeq ($(strip $(XUNHU_LIUT_SALE_TRACKER)), yes)
PRODUCT_PACKAGES += MengSalestracker
endif

#Xunhu: add SmartWakeUp function at 2017-02-06 11:45:11 by QinTuanye{{&&
#Description: 	开启智能唤醒后编译SmartWakeUp应用
ifeq ($(strip $(XUNHU_QTY_SMART_WAKE_UP)), yes)
	PRODUCT_PACKAGES += SmartWakeUp
endif
#&&}}

#Xunhu: 未写IMEI或MEID需有未写IMEI号的水印，防止客户未写IMEI出货 at 2017-02-15 by TRF251{{&&
	PRODUCT_PACKAGES += WriteImei
#&&}}

# Xunhu: ImeiSettings at 2017-02-16 10:50:02 by QinTuanye{{&&
# Description: IMEI写号工具
ifeq ($(strip $(XUNHU_QTY_IMEI_SETTINGS)), yes) 
	PRODUCT_PACKAGES += ImeiSettings
endif
# &&}}
