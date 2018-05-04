#
# Copyright (C) 2012-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=odhcp6c
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=$(PROJECT_GIT)/project/odhcp6c.git
PKG_SOURCE_DATE:=2025-02-06
PKG_SOURCE_VERSION:=8aa8b706727a6a6a841be42ef35a629ed635db3e
PKG_MIRROR_HASH:=ea631af735b04d54e553a525b263b8b072917ff2f323eff3e68f1f6e1df53e08
PKG_MAINTAINER:=Hans Dedecker <dedeckeh@gmail.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS += \
	-DUSE_LIBUBOX=on

ifneq ($(CONFIG_PACKAGE_odhcp6c_ext_cer_id),0)
  CMAKE_OPTIONS += -DEXT_CER_ID=$(CONFIG_PACKAGE_odhcp6c_ext_cer_id)
endif

define Package/odhcp6c
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Embedded DHCPv6-client for OpenWrt
  DEPENDS:=@IPV6 +libubox
endef

define Package/odhcp6c/config
  config PACKAGE_odhcp6c_ext_cer_id
    int "CER-ID Extension ID (0 = disabled)"
    depends on PACKAGE_odhcp6c
    default 0

  config PACKAGE_odhcp6c_capsh
    bool
    default 0
    select CONFIG_PACKAGE_libcap-bin
    prompt "Use capsh to drop capabilities"
endef

define Package/odhcp6c/conffiles
/etc/odhcp6c.user
/etc/odhcp6c.user.d/
endef

define Package/odhcp6c/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/odhcp6c $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/dhcpv6.sh $(1)/lib/netifd/proto/dhcpv6.sh
ifneq ($(CONFIG_PACKAGE_odhcp6c_capsh),)
	sed -i 's|^\s*proto_run_command "$$$$config" odhcp6c.*$$$$|\tlocal DROP_CAPS="cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_admin,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read+epi"\n\tproto_run_command "$$$$config" \\\n\t\t/usr/sbin/capsh --drop="$$$${DROP_CAPS}" -- -c \\\n\t\t"exec odhcp6c -s /lib/netifd/dhcpv6.script $$$$opts $$$$iface"|' $(1)/lib/netifd/proto/dhcpv6.sh
	sed -i 's|^\s*-s /lib/netifd/dhcpv6.script \\$$$$||' $(1)/lib/netifd/proto/dhcpv6.sh
	sed -i 's|^\s*$$$$opts $$$$iface$$$$||' $(1)/lib/netifd/proto/dhcpv6.sh
endif
	$(INSTALL_BIN) ./files/dhcpv6.script $(1)/lib/netifd/
	$(INSTALL_DIR) $(1)/etc/odhcp6c.user.d/
	$(INSTALL_CONF) ./files/odhcp6c.user $(1)/etc/
endef

$(eval $(call BuildPackage,odhcp6c))
