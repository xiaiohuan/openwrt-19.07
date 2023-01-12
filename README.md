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
//SPDX-License-Identifier: GPL-2.0-or-later OR MIT
/dts-v1/;

#include "mt7628an.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	compatible = "xiaomi,miwifi-3a", "mediatek,mt7628an-soc";
	model = "MiWiFi 3a";

	chosen {
		bootargs = "console=ttyS0,115200";
	};

	memory@0 {
		device_type = "memory";
		reg = <0x0 0x4000000>;
	};

	aliases {
		led-boot = &led_status_amber;
		led-failsafe = &led_status_red;
		led-running = &led_status_blue;
		led-upgrade = &led_status_amber;
		label-mac-device = &ethernet;
	};

	leds {
		compatible = "gpio-leds";

		led_status_blue: status_blue {
			label = "blue:status";
			gpios = <&gpio0 11 GPIO_ACTIVE_LOW>;
		};

		led_status_red: status_red {
			label = "red:status";
			gpios = <&gpio1 5 GPIO_ACTIVE_LOW>;
		};

		led_status_amber: status_amber {
			label = "amber:status";
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

&spi0 {
	status = "okay";

	flash@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;
		spi-max-frequency = <10000000>;

		partitions: partitions {
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
                 label = "firmware";
                 reg = <0x50000 0xf80000>;            
                 compatible = "denx,uimage";
             };            
            
             /* additional partitions in DTS */
             /* https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=5459952&extra=page%3D1&page=1 */
         };
	};
};

&pcie {
	status = "okay";
};

&pcie0 {
	wifi@0,0 {
		compatible = "mediatek,mt76";
		reg = <0x0000 0 0 0 0>;
		mediatek,mtd-eeprom = <&factory 0x8000>;
		ieee80211-freq-limit = <5000000 6000000>;
	};
};

&pinctrl {
	state_default: pinctrl0 {
		gpio {
			ralink,group = "gpio", "wdt", "wled_an";
			ralink,function = "gpio";
		};
	};
};

&ethernet {
	mtd-mac-address = <&factory 0x4>;
	mtd-mac-address-increment = <(-1)>;
};

&esw {
	mediatek,portmap = <0x2f>;
	mediatek,portdisable = <0x2a>;
};

&wmac {
	status = "okay";
};

```

 
 
 ### 捐贈

***
<center><b>如果你觉得此项目对你有帮助，可以捐助我，用爱发电也挺难的，哈哈。</b></center>

|  微信   | 支付宝  |
|  ----  | ----  |
| ![](https://pic.imgdb.cn/item/62502707239250f7c5b8ac3d.png) | ![](https://pic.imgdb.cn/item/62502707239250f7c5b8ac36.png) |

## 赞助名单

![](https://pic.imgdb.cn/item/625028c0239250f7c5bd102b.jpg)
感谢以上大佬的充电！
