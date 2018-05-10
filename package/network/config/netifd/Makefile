include $(TOPDIR)/rules.mk

PKG_NAME:=netifd
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=$(PROJECT_GIT)/project/netifd.git
PKG_SOURCE_DATE:=2018-07-11
PKG_SOURCE_VERSION:=5cf79759a24e9bb2a6a3aef7c83d73efb9bf2df3
PKG_MIRROR_HASH:=16a69a87c3e9ddd9314f71006f6a2d9e27b4620a3dcafb11ae5598fcb19ff202
PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/netifd
  SECTION:=base
  CATEGORY:=Base system
  DEPENDS:=+libuci +libnl-tiny +libubus +ubus +ubusd +jshn +libubox
  TITLE:=OpenWrt Network Interface Configuration Daemon
endef

define Package/netifd/config
  config PACKAGE_netifd_capsh
    bool
    default 0
	select CONFIG_PACKAGE_libcap-bin
	prompt "Use capsh to drop capabilities"
endef

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include/libnl-tiny \
	-I$(STAGING_DIR)/usr/include \
	-flto

TARGET_LDFLAGS += -flto -fuse-linker-plugin

CMAKE_OPTIONS += \
	-DLIBNL_LIBS=-lnl-tiny \
	-DDEBUG=1

define Package/netifd/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/netifd $(1)/sbin/
	$(CP) ./files/* $(1)/
ifneq ($(CONFIG_PACKAGE_netifd_capsh),)
	sed -i 's|^\s*proto_run_command "$$$$config" udhcpc.*$$$$|\tlocal DROP_CAPS="cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_admin,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read+epi"\n\tproto_run_command "$$$$config" \\\n\t\t/usr/sbin/capsh --drop="$$$${DROP_CAPS}" -- -c \\\n\t\t"exec udhcpc -p /var/run/udhcpc-$$$$iface.pid -s /lib/netifd/dhcp.script -f -t 0 -i \\"$$$$iface\\" $$$${ipaddr:+-r $$$$ipaddr} $$$${hostname:+-x \\"hostname:$$$$hostname\\"} $$$${vendorid:+-V $$$$vendorid} $$$$clientid $$$$defaultreqopts $$$$broadcast $$$$release $$$$dhcpopts"|' $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*-p /var/run/udhcpc-$$$$iface.pid \\||'           $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*-s /lib/netifd/dhcp.script \\||'                 $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*-f -t 0 -i "$$$$iface" \\||'                     $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*$$$${ipaddr:+-r $$$$ipaddr} \\||'                $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*$$$${hostname:+-x "hostname:$$$$hostname"} \\||' $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*$$$${vendorid:+-V "$$$$vendorid"} \\||'          $(1)/lib/netifd/proto/dhcp.sh
	sed -i 's|^\s*$$$$clientid $$$$defaultreqopts $$$$broadcast $$$$release $$$$dhcpopts||' $(1)/lib/netifd/proto/dhcp.sh
endif
	$(CP) $(PKG_BUILD_DIR)/scripts/* $(1)/lib/netifd/
endef

$(eval $(call BuildPackage,netifd))
