.. default-domain:: chpl

.. module:: HDFSiterator
   :synopsis: Iterators for distributed iteration over Hadoop Distributed Filesystem

HDFSiterator
============
**Usage**

.. code-block:: chapel

   use HDFSiterator;


Iterators for distributed iteration over Hadoop Distributed Filesystem

Iterators that can iterate over distributed data in an HDFS filesystem
in a distributed manner. See :mod:`HDFS`.


.. iterfunction:: iter HDFSiter(path: string, type rec, regex: string)

   Iterate through an HDFS file (available in the default configured
   HDFS server) and yield records matching a regular expression.
   
   Serial and leader-follower versions of this iterator are available.
   
   :arg path: the path to the file within the HDFS server
   :arg rec: the type of the records to return
   :arg regexp: a regular expression with the same number of captures as
                the number of fields in the record type ``rec``
   
   

