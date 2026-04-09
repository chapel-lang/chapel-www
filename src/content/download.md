+++
title = "Download and Install Chapel"
description = "Instructions for downloading and installing Chapel"
keywords = ["TODO"]

[[configurations]]
title="From Source"
id="source"
description="""
To download and install Chapel from source, download **[chapel-2.8.0.tar.gz](https://github.com/chapel-lang/chapel/releases/download/2.8.0/chapel-2.8.0.tar.gz)** from [GitHub](https://github.com/chapel-lang/chapel/releases/tag/2.8.0), then unpack and build it as described in the [Quickstart instructions](https://chapel-lang.org/docs/usingchapel/QUICKSTART.html).
"""

[[configurations]]
title="With Spack"
id="spack"
description="""
To get started with the Chapel Spack package:

1. [Install the Spack package manager](https://spack.readthedocs.io/en/latest/getting_started.html#installation) on your system, if it isn't already there.
2. To customize the Chapel installation, use the variants of the [Chapel Spack package](https://packages.spack.io/package.html?name=chapel) as opposed to the normal `CHPL_*` environment variables. Most settings described in [Chapel's documentation](https://chapel-lang.org/docs/usingchapel/chplenv.html#setting-up-your-environment-for-chapel) can be set using variants of the Chapel Spack package.
3. Install the Chapel package, specifying any variant desired. For example, to also install the chpldoc tool, use `spack install chapel+chpldoc`.
"""

[[configurations]]
title="With Docker"
id="docker"
description="""
To get started with the Chapel Docker image:

1. [Install Docker Engine](https://docs.docker.com/engine/install) on your system if it isn't already.
2. Get the Chapel image: `docker pull chapel/chapel`
3. Follow the instructions on the [Chapel Docker Hub](https://hub.docker.com/r/chapel/chapel/) page to compile and run some simple programs.
"""

[[configurations]]
title="With Homebrew"
id="homebrew"
description="""
[Homebrew](https://brew.sh/) users can install Chapel on Mac/Linux as follows:

1. Make sure your brew is up-to-date: `brew update`
2. Install the Chapel formula: `brew install chapel`
3. Note that for a homebrew install, `$CHPL_HOME` can be determined by running `chpl --print-chpl-home`.
4. If you're not already familiar with Chapel, jump to the "Compile an example program step in the [Quickstart Instructions](https://chapel-lang.org/docs/usingchapel/QUICKSTART.html).
"""

[[configurations]]
title="On HPE Systems"
id="hpe"
description="""
#### Using and Installing Chapel on HPE Cray EX systems

Users of HPE Cray EX systems can use Chapel as follows:
1. Load the Chapel module: `module load chapel`
2. Read [$CHPL_HOME/doc/rst/platforms/cray.rst](https://chapel-lang.org/docs/platforms/cray.html) for quick-start instructions and more detailed notes.

If these steps don't work, be sure that the latest version of Chapel (2.8) is installed on your system and ask your system administrator to [install it](https://myenterpriselicense.hpe.com/cwp-ui/software/Search?productCategory=Open%20Source&productInfo=Chapel_EX-OSP) if not.  Alternatively, you can build from source using the instructions just below. If the latest version doesn't work for you, send us a [bug report](https://chapel-lang.org/docs/usingchapel/bugs.html).

#### Installing Chapel on HPE Apollo, HPE Cray XD, Cray XC, and Cray CS systems
Users of other HPE or Cray systems should download Chapel and build from source, referring to [$CHPL_HOME/doc/rst/platforms/cray.rst](https://chapel-lang.org/docs/platforms/cray.html#building-chapel-for-an-hpe-cray-system-from-source) for details.
"""





[[configurations]]
title="With Linux Package Managers"
id="linux"
description="""
We provide Chapel packages for several different Linux distributions, though they come with some performance caveats, as noted at the bottom of this section.

Each package comes bundled with
a number of different supported Chapel configurations and Chapel development tools. The installed package will default to the preferred single-locale configuration. To select a different configuration, you can pass compiler flags, set environment variables, or create `chplconfig` files. See the
[Chapel documentation](https://chapel-lang.org/docs/usingchapel/chplenv.html#setting-up-your-environment-for-chapel)
for more information on these options.

The packages can be installed as follows:
1. Download the package for your system using one of the following links:
{{<pkg-list "2.8.0">}}

2. Check its SHA256 checksum using the values and instructions on the corresponding [GitHub release page](https://github.com/chapel-lang/chapel/releases/tag/2.8.0/).

3. Install using the system package manager.
   - For RPM based distributions (Fedora, RHEL, etc), use: `dnf install ./<chapel package name>`
      - For RHEL/RockyLinux/AlmaLinux, you will need to install EPEL first: `dnf install epel-release`
   - For Debian based distributions (Debian, Ubuntu, etc), use: `apt install ./<chapel package name>`

Caveats:
- For the optimal performance when using Chapel's BigInteger support, users
  should build Chapel from source, [manually](#source) or using [Spack](#spack).
- The bundled GASNet multi-locale configurations will not take advantage of
  high-performance networks. Users wanting that configuration should build
  Chapel from source, [manually](#source) or using [Spack](#spack).
- The bundled libfabric multi-locale configuration is experimental and may
  not work with all providers. It is known to work with the tcp and efa providers.
"""
+++

{{<toggle "configurations">}}


