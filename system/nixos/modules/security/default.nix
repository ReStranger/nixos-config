{
  lib,
  config,
  ...
}:

let
  cfg = config.module.security;
  inherit (lib)
    mkEnableOption
    mkIf
    optionalAttrs
    optionals
    ;
in
{
  options = {
    module.security = {
      enable = mkEnableOption "Enables security";
      enableBootOptions = mkEnableOption "Enables boot options";
      disableIPV6 = mkEnableOption "Disable ipv6";
    };
  };

  config = mkIf cfg.enable {
    security = {
      sudo.enable = false;

      pam.services = {
        gtklock = { };
        swaylock = { };
        hyprlock = { };
      };

      sudo-rs = {
        enable = true;
        execWheelOnly = true;
        wheelNeedsPassword = true;
      };
    };

    boot = optionalAttrs cfg.enableBootOptions {
      kernelParams = [
        # Security settings
        "debugfs=off"
        "init_on_alloc=1"
        "iommu=force"
        "iommu.passthrough=0"
        "iommu.strict=1"
        "page_alloc.shuffle=1"
        "page_poison=1"
        "randomize_kstack_offset=1"
        "slab_nomerge"
        "tsx=off"
        "tsx_async_abort=off"
        "vsyscall=none"

      ]
      ++ optionals cfg.disableIPV6 [
        # Disable ipv6
        "ipv6.disable=1"
      ];

      blacklistedKernelModules = [
        # Obscure network protocols
        "ax25"
        "netrom"
        "rose"

        # Old or rare or insufficiently audited filesystems
        "affs"
        "befs"
        "bfs"
        "cramfs"
        "efs"
        "exofs"
        "freevxfs"
        "hfs"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"

      ];

      kernel.sysctl = {
                # Enable protection against accidental writing to a FIFO object
        "fs.protected_fifos" = 2;

        # Restrict unsafe options for working with hard links
        "fs.protected_hardlinks" = 1;

        # Enable protection against accidental writing to the file
        "fs.protected_regular" = 2;

        # Restrict unsafe options for following symbolic links
        "fs.protected_symlinks" = 1;

        # Prevent core dumps from being created for certain executable files
        "fs.suid_dumpable" = 0;

        # Disable ftrace debugging
        "kernel.ftrace_enabled" = false;

        # Disable kexc_load system call
        "kernel.kexec_load_disabled" = 1;

        # Hide kptrs even for processes with CAP_SYSLOG`
        "kernel.kptr_restrict" = 2;

        # Restrict access to performance events
        "kernel.perf_event_paranoid" = 3;

        # Implement randomization of address space
        "kernel.randomize_va_space" = 2;

        # Prohibit connecting to other processes using ptrace
        "kernel.yama.ptrace_scope" = 3;

        # Enable protection for the eBPF JIT subsystem
        "net.core.bpf_jit_harden" = 2;

        # Ignore incoming ICMP redirects (note: default is needed to ensure that the
        # setting is applied to interfaces added after the sysctls are set)
        "net.ipv4.conf.all.accept_redirects" = false;
        "net.ipv4.conf.all.secure_redirects" = false;
        "net.ipv4.conf.default.accept_redirects" = false;
        "net.ipv4.conf.default.secure_redirects" = false;
        "net.ipv6.conf.all.accept_redirects" = false;
        "net.ipv6.conf.default.accept_redirects" = false;

        # Enable strict reverse path filtering (that is, do not attempt to route
        # packets that "obviously" do not belong to the iface's network; dropped
        # packets are logged as martians).
        "net.ipv4.conf.all.log_martians" = true;
        "net.ipv4.conf.all.rp_filter" = "1";
        "net.ipv4.conf.default.log_martians" = true;
        "net.ipv4.conf.default.rp_filter" = "1";

        # Ignore outgoing ICMP redirects (this is ipv4 only)
        "net.ipv4.conf.all.send_redirects" = false;
        "net.ipv4.conf.default.send_redirects" = false;

        # Ignore broadcast ICMP (mitigate SMURF)
        "net.ipv4.icmp_echo_ignore_broadcasts" = true;

        # Disable the userfaultfd system call for unprivileged users
        "vm.unprivileged_userfaultfd" = 0;

      }
      // optionalAttrs cfg.disableIPV6 {
        # Disable ipv6
        "net.ipv6.conf.all.disable_ipv6" = true;
        "net.ipv6.conf.default.disable_ipv6" = true;
        "net.ipv6.conf.lo.disable_ipv6" = true;
        "net.ipv6.conf.tun0.disable_ipv6" = true;
      };
    };
  };
}
