.. default-domain:: chpl

.. module:: LayoutCS

LayoutCS
========
**Usage**

.. code-block:: chapel

   use LayoutCS;

.. class:: CS

   
   This CS layout provides a Compressed Sparse Row (CSR) and Compressed Sparse
   Column (CSC) implementation for Chapel's sparse domains and arrays.
   
   To declare a CS domain, invoke the ``CS`` constructor in a `dmapped` clause,
   specifying CSR vs. CSC format with the ``param compressRows`` argument, which
   defaults to ``true`` if omitted. For example:
   
     .. code-block:: chapel
   
       use LayoutCS;
       var D = {1..n, 1..m};  // a default-distributed domain
       var CSR_Domain: sparse subdomain(D) dmapped CS(compressRows=true); // Default argument
       var CSC_Domain : sparse subdomain(D) dmapped CS(compressRows=false);
   
   To declare a CSR or CSC array, use a CSR or CSC domain, respectively.
   For example:
   
     .. code-block:: chapel
   
       // assumes the above declarations
       var CSR_Array: [CSR_Domain] real;
       var CSC_Array: [CSC_Domain] real;
   
   This domain map is a layout, i.e. it maps all indices to the current locale.
   All elements of a CS-distributed array are stored
   on the locale where the array variable is declared.


