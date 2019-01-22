# Fedora-Post-Installation

```sh
Usage: ./post_install.sh [--(no-)nvidia] [--(no-)dnfyes] [-h|--help]
	--nvidia: <Installs Nvidia drivers and CUDA from Negativo17.org. Be sure to check out https://github.com/Superdanby/Grub-Nvidia-Entry.> (off by default)
	--dnfyes: <Replies yes to all dnf prompts.> (off by default)
	-h,--help: Prints help
```

## Featured Changes

-	Configures `dnf.conf` to avoid slow mirrors.
-	Sets up `git`.
-	Sets up [`tuned`](https://github.com/redhat-performance/tuned/issues) for better battery life.
