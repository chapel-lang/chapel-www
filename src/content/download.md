+++
title = "Downloading Chapel"
description = "Instructions for downloading Chapel"
keywords = ["TODO"]

[[configurations]]
title="Downloading from Source"
id="source"
description="""
To download and install Chapel from source, download **[chapel-2.4.0.tar.gz](https://github.com/chapel-lang/chapel/releases/download/2.4.0/chapel-2.4.0.tar.gz)** from [GitHub](https://github.com/chapel-lang/chapel/releases/tag/2.4.0), then unpack and build it as described in the [Quickstart instructions](https://chapel-lang.org/docs/usingchapel/QUICKSTART.html).
"""

[[configurations]]
title="Downloading with Spack"
id="spack"
description="""
To get started with the Chapel Spack package:

1. [Install the Spack package manager](https://spack.readthedocs.io/en/latest/getting_started.html#installation) on your system, if it isn't already there.
2. To customize the Chapel installation, use the variants of the [Chapel Spack package](https://packages.spack.io/package.html?name=chapel) as opposed to the normal `CHPL_*` environment variables. Most settings described in [Chapel's documentation](https://chapel-lang.org/docs/usingchapel/chplenv.html#setting-up-your-environment-for-chapel) can be set using variants of the Chapel Spack package.
3. Install the Chapel package, specifying any variant desired. For example, to also install the chpldoc tool, use `spack install chapel+chpldoc`.
"""

[[configurations]]
title="Downloading with Docker"
id="docker"
description="""
To get started with the Chapel Docker image:

1. [Install Docker Engine](https://docs.docker.com/engine/install) on your system if it isn't already.
2. Get the Chapel image: `docker pull chapel/chapel`
3. Follow the instructions on the [Chapel Docker Hub](https://hub.docker.com/r/chapel/chapel/) page to compile and run some simple programs.
"""

[[configurations]]
title="Downloading with Homebrew"
id="homebrew"
description="""
[Homebrew](http://brew.sh/) users can install a single-locale build of Chapel on Mac/Linux as follows:

1. Make sure your brew is up-to-date: `brew update`
2. Install the Chapel formula: `brew install chapel`
3. Note that for a homebrew install, `$CHPL_HOME` can be determined by running `chpl --print-chpl-home`.
4. If you're not already familiar with Chapel, jump to the "Compile an exmaple program step in the [Quickstart Instructions](https://chapel-lang.org/docs/usingchapel/QUICKSTART.html).
"""

[[configurations]]
title="Downloading on HPE Systems"
id="hpe"
description="""
#### Using and Installing Chapel on HPE Cray EX and XC systems

Users of HPE Cray EX and XC systems can use Chapel as follows:
1. Load the Chapel module: `module load chapel`
2. Read [$CHPL_HOME/doc/rst/platforms/cray.rst](https://chapel-lang.org/docs/platforms/cray.html) for quick-start instructions and more detailed notes.
If these steps don't work, be sure that the latest version of Chapel (2.4) is installed on your system and ask your system administrator to install it if not. If the latest version doesn't work for you, send us a [bug report](https://chapel-lang.org/docs/usingchapel/bugs.html).

#### Installing Chapel on HPE Apollo and Cray CS systems
Users of HPE Apollo or Cray CS systems should download Chapel and build from source, referring to [$CHPL_HOME/doc/rst/platforms/cray.rst](https://chapel-lang.org/docs/platforms/cray.html) for further details.
"""





[[configurations]]
title="Installing with Linux Package Managers"
id="linux"
description="""
We provide Chapel packages for several different Linux distributions, though they come with some performance caveats. They can be installed as follows:
1. Download the package for your system using one of the following links:
{{<pkg-list "2.4.0">}}

2. Check its SHA256 checksum using the values and instructions on the corresponding [GitHub release page](https://github.com/chapel-lang/chapel/releases/tag/2.4.0/).

3. Install using the system package manager. 
  - For RPM based distributions (Fedora, RHEL, etc), use: `dnf install ./<chapel package name>`
  - For Debian based distributions (Debian, Ubuntu, etc), use: `apt install ./<chapel package name>`


Caveats:
- Using these packages means that parts of the Chapel runtime may not be compiled optimally for your architecture (e.g. the BigInteger and Regex modules may result in degrade performance). Users looking for maximum performance that makes use of their specific hardware should consider building Chapel from source.
- The GASNet multi-locale configuration is a portable implementation based on GASNet-EX/UDP, so won't take advantage of high-performance networks.
- The SLURM/libfabric multi-locale configuration is experimental and may not work with all providers. It is known to work with the tcp and efa providers.
"""
+++

{{<toggle "configurations">}}


