.. default-domain:: chpl

.. module:: Path
   :synopsis: A file utilities library, specifically related to path operations

Path
====
**Usage**

.. code-block:: chapel

   use Path;

A file utilities library, specifically related to path operations

The Path module focuses on manipulation of the path to a file or directory.
Also provided are constant values representing common idioms that may vary
across operating systems (though rarely in the modern era), such as general
references to a parent directory or the current directory.

.. note::

   This module is currently under development and will expand significantly
   in upcoming releases.  Stay tuned!

Operations which occur on the files or directories referred to by these paths
may be found in :mod:`FileSystem` (for operations *on* the file) or :mod:`IO`
(for operations *within* the file).

Path Computations
-----------------
:proc:`commonPath`
:proc:`realPath`
:proc:`file.realPath`

Path Manipulations
------------------
:proc:`joinPath`
:proc:`splitPath`

Path Properties
---------------
:proc:`basename`
:proc:`dirname`
:proc:`file.getParentName`
:proc:`isAbsPath`

Constant and Function Definitions
---------------------------------

.. data:: const curDir = "."

   Represents generally the current directory 

.. data:: const parentDir = ".."

   Represents generally the parent directory 

.. data:: const pathSep = "/"

   Denotes the separator between a directory and its child. 

.. function:: proc basename(name: string): string

   Returns the basename of the file name provided.  For instance, in the
   name `/foo/bar/baz`, this function would return `baz`, while `/foo/bar/`
   would yield the empty string.  Note that this is different from the Unix
   basename function.
   
   :arg name: a string file name.  Note that this string does not have to be
              a valid file name, as the file itself will not be affected.
   :type name: `string`

.. function:: proc commonPath(paths: string ...?n): string

   Determines and returns the longest common path prefix of
   all the string pathnames provided.
   
   :arg paths: Any number of paths
   :type paths: `string`
   
   :return: The longest common path prefix
   :rtype: `string`
   

.. function:: proc commonPath(paths: []): string

   Determines and returns the longest common path prefix of
   all the string pathnames provided.
   
   :arg paths: Any number of paths as an array
   :type paths: `array`
   
   :return: The longest common path prefix
   :rtype: `string`
   

.. function:: proc dirname(name: string): string

   Returns the parent directory of the file name provided.  For instance,
   in the name `/foo/bar/baz`, this function would return `/foo/bar`, as
   would a call with `/foo/bar/` as the argument.
   
   :arg name: a string file name.  Note that this string does not have to be
              a valid file name, as the file itself will not be affected.
   :type name: `string`

.. method:: proc file.getParentName(): string throws

   
   Returns the parent directory of the :type:`~IO.file` record.  For instance,
   a file with path `/foo/bar/baz` would return `/foo/bar`
   
   Will throw an error if one occurs.
   
   :return: The parent directory of the file
   :rtype: `string`
   

.. function:: proc isAbsPath(name: string): bool

   Determines whether the path specified is an absolute path.
   
   .. note::
   
      This is currently only implemented in a Unix environment.  It will not
      behave correctly in a non-Unix environment.
   
   :arg name: the path to be checked.
   :type name: `string`
   
   :return: `true` if `name` is an absolute path, `false` otherwise
   :rtype: `bool`

.. function:: proc joinPath(paths: string ...?n): string

   Join and return one or more paths, putting precedent on the last absolute
   path seen.  Return value is the concatenation of the paths with one
   directory separator following each non-empty argument except the last.
   Examples:
   
   `joinPath("/foo/bar", "/baz")` will yield `"/baz"`
   
   `joinPath("/foo", "./baz")` will yield `"/foo/./baz"`
   
   `joinPath("/foo/", "", "./baz")` will also yield `"/foo/./baz"`
   
   :arg paths: Any number of paths
   :type paths: `string`
   
   :return: The concatenation of the last absolute path with everything following
            it, or all the paths provided if no absolute path is present
   :rtype: `string`

.. function:: proc realPath(name: string): string throws

   Given a path `name`, attempts to determine the canonical path referenced.
   This resolves and removes any :data:`curDir` and :data:`parentDir` uses
   present, as well as any symbolic links.  Returns the result
   
   Will throw an error if one occurs.
   
   :arg name: A path to resolve.  If the path does not refer to a valid file
              or directory, an error will occur.
   :type name: `string`
   
   :return: A canonical version of the argument.
   :rtype: `string`

.. method:: proc file.realPath(): string throws

   Determines the canonical path referenced by the :type:`~IO.file` record
   performing this operation.  This resolves and removes any :data:`curDir` and
   :data:`parentDir` uses present, as well as any symbolic links.  Returns the
   result
   
   Will throw an error if one occurs.
   
   :return: A canonical path to the file referenced by this :type:`~IO.file`
            record.  If the :type:`~IO.file` record is not valid, an error will
            occur
   :rtype: `string`

.. function:: proc splitPath(name: string): (string, string)

   Split name into a tuple that is equivalent to (:proc:`dirname`,
   :proc:`basename`).  The second part of the tuple will never contain a slash.
   Examples:
   
   `splitPath("foo/bar")` will yield `("foo", "bar")`
   
   `splitPath("bar")` will yield `("", "bar")`
   
   `splitPath("foo/")` will yield `("foo", "")`
   
   `splitPath("")` will yield `("", "")`
   
   `splitPath("/")` will yield `("/", "")`
   
   With the exception of a path of the empty string or just "/", the original
   path can be recreated from this function's returned parts by joining them
   with the path separator character, either explicitly:
   
   `dirname` + "/" + `basename`
   
   or by calling :proc:`joinPath`:
   
   `joinPath(dirname, basename)`
   
   :arg name: path to be split
   :type name: `string`

