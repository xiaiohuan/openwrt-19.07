## 拉取
1. 下载源代码，更新 feeds 并选择配置

   ```bash
   git clone --depth=1 https://github.com/yuos-bit/openwrt-19.07
   # 拉取最新分支
   git clone -b xiaomi --single-branch https://github.com/yuos-bit/openwrt-19.07
   # 拉取小米适配分支
  
   cd openwrt-19.07
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   ```  
   
 ## 适配说明
 

```shell
grep -lri miwifi-nano target/
# 查找需要修改的文件
```

得到结果：
```shell
yuos@yuos-virtual-machine:~/openwrt-19.07$ grep -lri miwifi-nano target/
target/linux/ramips/image/mt76x8.mk
target/linux/ramips/base-files/lib/ramips.sh
target/linux/ramips/base-files/etc/board.d/02_network
target/linux/ramips/dts/MIWIFI-NANO.dts
```

`mt76x8.mk` 修改：

```shell
define Device/miwifi-3a
  DTS := MIWIFI-3A
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DEVICE_TITLE := Xiaomi MiWiFi 3a
  DEVICE_PACKAGES := kmod-mt76x2
endef
TARGET_DEVICES += miwifi-3a
```

`ramips.sh`修改：

```shell
	*"MiWiFi 3a")
		name="miwifi-3a"
		;;
```



`02_network`修改:

```shell
	miwifi-3a)
		ucidef_add_switch "switch0" \
			"0:wan" "2:lan:2" "4:lan:1" "6@eth0"
		;;
```
`MIWIFI-3A.dts`修改：

```shell

/dts-v1/;

#include "mt7628an.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	compatible = "xiaomi,miwifi-3a", "mediatek,mt7628an-soc";
	model = "MiWiFi 3a";

	aliases {
		led-boot = &led_blue;
		led-failsafe = &led_blue;
		led-running = &led_blue;
		led-upgrade = &led_blue;
	};

	chosen {
		bootargs = "console=ttyS0,115200";
	};

	memory@0 {
		device_type = "memory";
		reg = <0x0 0x4000000>;
	};

	leds {
		compatible = "gpio-leds";

		led_blue: status_blue {
			label = "miwifi-3a:blue:status";
			gpios = <&gpio0 11 GPIO_ACTIVE_LOW>;
		};
		status_red {
			label = "miwifi-3a:red:status";
			gpios = <&gpio1 5 GPIO_ACTIVE_LOW>;
		};
		status_amber {
			label = "miwifi-3a:amber:status";
			gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
		};
	};

	keys {
		compatible = "gpio-keys-polled";
		poll-interval = <20>;

		reset {
			label = "reset";
			gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
			linux,code = <KEY_RESTART>;
		};
	};
};

&pinctrl {
	state_default: pinctrl0 {
		gpio {
			ralink,group = "refclk", "wled_an", "gpio";
			ralink,function = "gpio";
		};
	};
};

&wmac {
	status = "okay";
};

&ethernet {
	mtd-mac-address = <&factory 0x28>;
};

&spi0 {
	status = "okay";

	m25p80@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;
		spi-max-frequency = <10000000>;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "u-boot";
				reg = <0x0 0x30000>;
				read-only;
			};

			partition@30000 {
				label = "u-boot-env";
				reg = <0x30000 0x10000>;
				read-only;
			};

			factory: partition@40000 {
				label = "factory";
				reg = <0x40000 0x10000>;
				read-only;
			};

			partition@50000 {
				compatible = "denx,uimage";
				label = "firmware";
				reg = <0x50000 0xfb0000>;
			};
		};
	};
};

```

 
 
 ## 官方声明
 
 
 ```
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
```
This is the buildsystem for the OpenWrt Linux distribution.

To build your own firmware you need a Linux, BSD or MacOSX system (case
sensitive filesystem required). Cygwin is unsupported because of the lack
of a case sensitive file system.

You need gcc, binutils, bzip2, flex, python, perl, make, find, grep, diff,
unzip, gawk, getopt, subversion, libz-dev and libc headers installed.

1. Run "./scripts/feeds update -a" to obtain all the latest package definitions
defined in feeds.conf / feeds.conf.default

2. Run "./scripts/feeds install -a" to install symlinks for all obtained
packages into package/feeds/

3. Run "make menuconfig" to select your preferred configuration for the
toolchain, target system & firmware packages.

4. Run "make" to build your firmware. This will download all sources, build
the cross-compile toolchain and then cross-compile the Linux kernel & all
chosen applications for your target system.

Sunshine!
	Your OpenWrt Community
	http://www.openwrt.org



