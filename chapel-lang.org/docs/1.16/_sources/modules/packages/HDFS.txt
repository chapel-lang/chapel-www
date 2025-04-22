.. default-domain:: chpl

.. module:: HDFS
   :synopsis: Support for Hadoop Distributed Filesystem

HDFS
====
**Usage**

.. code-block:: chapel

   use HDFS;



Support for Hadoop Distributed Filesystem

This module implements support for the
`Hadoop <http://hadoop.apache.org/>`_
`Distributed Filesystem <http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html>`_ (HDFS).

Dependencies
------------

See the :ref:`auxIO-HDFS-deps` documentation for details on setting up and
enabling HDFS support in Chapel.

Using HDFS Support in Chapel
----------------------------

There are three ways provided to open HDFS files within Chapel.

Using an HDFS filesystem with open(url="hdfs://...")
****************************************************

.. code-block:: chapel

  // Open a file on HDFS connecting to the default HDFS instance
  var f = open(mode=iomode.r, url="hdfs://host:port/path");

  // Open up a reader and read from the file
  var reader = f.reader();

  // ...

  reader.close();

  f.close();


Explicitly Using Replicated HDFS Connections and Files
******************************************************

.. code-block:: chapel

  use HDFS;

  // Connect to HDFS via the default username (or whichever you want)
  //
  var hdfs = hdfsChapelConnect("default", 0);

  //
  // Create a file per locale
  //
  var gfl  = hdfs.hdfsOpen("/user/johnDoe/isThisAfile.txt", iomode.r);

  ...
  //
  // On any given locale, you can get the local file for the locale that
  // the task is currently running on via:
  //
  var fl = gfl.getLocal();

  // This file can be used as with a traditional file in Chapel, by
  // creating reader channels on it.

  // When you are done and want to close the files and disconnect from
  // HDFS, use:

  gfl.hdfsClose();
  hdfs.hdfsChapelDisconnect();

Explicitly Using Local HDFS Connections and Files
*************************************************

The HDFS module file also supports non-replicated values across
locales. So if you only wanted to connect to HDFS and open a file on
locale 1 you could do:

.. code-block:: chapel

  on Locales[1] {
    var hdfs = hdfs_chapel_connect("default", 0);
    var fl = hdfs.hdfs_chapel_open("/user/johnDoe/myFile.txt", iomode.cw);
    ...
    var read = fl.reader();
    ...
    fl.close();
    hdfs.hdfs_chapel_disconnect();
  }

The only stipulations are that you cannot open a file in both read and
write mode at the same time. (i.e iomode.r and iomode.cw are the only
modes that are supported, due to HDFS limitations).


HDFS Support Types and Functions
--------------------------------


 

.. record:: hdfsChapelFile

   Holds a file per locale 


.. record:: hdfsChapelFileSystem

   Holds a connection to HDFS per locale 


.. function:: proc hdfsChapelConnect(out error: syserr, path: c_string, port: int): c_void_ptr

   Make a connection to HDFS for a single locale 

.. function:: proc hdfsChapelConnect(path: string, port: int): hdfsChapelFileSystem throws

   Connect to HDFS and create a filesystem ptr per locale 

.. method:: proc hdfsChapelFileSystem.hdfsChapelDisconnect() throws

   Disconnect from the configured HDFS filesystem on each locale 

.. method:: proc hdfsChapelFileSystem.hdfsOpen(path: string, mode: iomode, hints: iohints = IOHINT_NONE, style: iostyle = defaultIOStyle()): hdfsChapelFile throws

   Open a file on each locale 

.. method:: proc hdfsChapelFile.hdfsClose() throws

   Close a file opened with :proc:`hdfsChapelFileSystem.hdfsOpen` 

.. method:: proc hdfsChapelFileSystem_local.hdfs_chapel_open(path: string, mode: iomode, hints: iohints = IOHINT_NONE, style: iostyle = defaultIOStyle()): file throws

   Open a file on an HDFS filesystem for a single locale 

.. function:: proc hdfs_chapel_connect(path: string, port: int): hdfsChapelFileSystem_local throws

   Connect to an HDFS filesystem on a single locale 

