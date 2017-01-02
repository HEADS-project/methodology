# Prepare, build and flash any buildroot compatible device to run Kevoree

Buildroot is a simple, efficient and easy-to-use tool to generate embedded Linux systems through cross-compilation.

- Buildroot can handle lots of things: Cross-compilation toolchain, root filesystem generation, kernel image compilation and bootloader compilation.
- Buildroot is easy to use. Thanks to its kernel-like menuconfig, gconfig and xconfig configuration interfaces, building a basic system with Buildroot is easy and typically takes 15-30 minutes.
- Buildroot supports hundreds of packages:  X.org stack, Gtk3, Qt 5, GStreamer, Webkit, OpenJDK, nodeJS a large number of network-related and system-related utilities are supported.
- Buildroot is for Everyone. It has a simple structure that makes it easy to understand and extend. It relies only on the well-known Makefile language.

## Install buildroot

[Download](https://buildroot.org/downloads/buildroot-2016.11.1.tar.gz) build root and unzip it on a linux. You can also use docker. 

## Prepare your buildroot configuration


```bash
# in the unzipped folder (**buildroot root**)
make raspberrypi3_defconfig #if you want to create an image for a raspberry pi 3. 

## Customize your buildroot configuration

					
Add the KevoreeJS Feature

```bash
mkdir package/kevoreejs
cd package/kevoreejs
touch kevoreejs.mk
touch Config.in
nano -w Config.in
```

```txt
config BR2_PACKAGE_KEVOREEJS
    bool "kevoreejs"
    help
      KevoreeJS package: a runtime for Kevoree Javascript component
      see http://kevoree.org for more on this software
```

```bash
nano -w ../Config.in 
```

```txt
menu "Custom packages"
	source "package/kevoreejs/Config.in"
endmenu
```

```bash
nano -w kevoreejs.mk
```

```bash
#
# kevoreejs
# basic building rules
#
KEVOREEJS_VERSION = 1.1

KEVOREEJS_INSTALL_STAGING = YES

define KEVOREEJS_BUILD_CMDS
#    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) all
endef

define KEVOREEJS_INSTALL_STAGING_CMDS
#    $(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define KEVOREEJS_INSTALL_TARGET_CMDS
##    $(INSTALL) -D -m 0755 $(@D)/helloworld \
##                          $(TARGET_DIR)/bin/helloworld
npm update -g npm && npm i -g grunt-cli bower generator-kevoree kevoree-cli@latest && npm cache clean
endef

$(eval $(call package,kevoreejs))	

```

in board/yourboard/ (for example board/raspberrypi3/)

create a file nammed S99Kevoreejs.sh 

```bash
nano -w S99Kevoreejs.sh
```

Put the following content

```bash
#!/bin/sh
#
# Start the kevoreejs...
#

case "$1" in
  start)
    echo "Starting KevoreeJS..."
    /usr/bin/kevoree
    ;;
  stop)
    echo -n "Stopping kevoreeJS..."
    killall -9 node
    ;;
  restart|reload)
    "$0" stop
    "$0" start
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart}"
    exit 1
esac

exit $?
```

```bash
nano -w config.json
```

Put the following content

```js
{
  "registry": {
    "host": "registry.kevoree.org",
    "port": 443,
    "ssl": true,
    "oauth": {
      "client_secret": "kevoree_registryapp_secret",
      "client_id": "kevoree_registryapp"
    }
  }
}
```

You have to select some feature, in particular nodejs

Next, you have to ensure that kevoreejs will boot

edit the board/yourboard/postbuild.sh

```bash
#change yourboard with raspberrypi3 for example 
nano -w board/yourboard/postbuild.sh
```

```bash
# copy custom-files
cp board/raspberrypi3/S99Kevoreejs.sh  "$TARGET"/etc/init.d/
chmod a+x "$TARGET"/etc/init.d/S99Kevoreejs.sh
mkdir -p "$TARGET"/root/.kevoree/
cp board/raspberrypi3/config.json "$TARGET"/root/.kevoree/config.json
```

Next do make menuconfig and add **node**, **WCHAR**

```txt
-> toolchain 
 -> WCHAR 
...
-> Target packages
	-> Interpreter languages and scripting  
		-> node, npm express and add kevoree-cli in the additional modules
```

## Build your image

Next, build all. 

```bash
make -j4 all
# take a coffee
```

in the output/images folder, you will get your image for your device and kevoreejs runtime will start during the boot process, you can now deploy your own Heads application. 




