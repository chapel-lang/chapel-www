.. default-domain:: chpl

.. module:: UtilMisc_forDocs
   :synopsis: Additional utilities

Misc Functions
==============

Additional utilities


.. function:: proc compilerError(param msg: string ...?n)

   
   Generate a compile-time error.
   The error text is a concatenation of the arguments.
   

.. function:: proc compilerError(param msg: string ...?n, param errorDepth: int)

   
   Generate a compile-time error.
   The error text is a concatenation of the string arguments.
   
   :arg errorDepth: controls the depth of the error stack trace
   

.. function:: proc compilerWarning(param msg: string ...?n)

   
   Generate a compile-time warning.
   The warning text is a concatenation of the arguments.
   

.. function:: proc compilerWarning(param msg: string ...?n, param errorDepth: int)

   
   Generate a compile-time warning.
   The warning text is a concatenation of the string arguments.
   
   :arg errorDepth: controls the depth of the error stack trace
   

.. function:: proc compilerAssert(param test: bool)

   Generate a compile-time error if the `test` argument is false.
   

.. function:: proc compilerAssert(param test: bool, param errorDepth: int)

   Generate a compile-time error if the `test` argument is false.
   
   :arg errorDepth: controls the depth of the error stack trace
   

.. function:: proc compilerAssert(param test: bool, param msg: string ...?n)

   Generate a compile-time error if the `test` argument is false.
   The warning text is a concatenation of the string arguments.
   

.. function:: proc compilerAssert(param test: bool, param msg: string ...?n, param errorDepth: int)

   Generate a compile-time error if the `test` argument is false.
   The warning text is a concatenation of the string arguments.
   
   :arg errorDepth: controls the depth of the error stack trace
   

.. function:: proc min(x, y ...)

   Compute the minimum value of 2 or more arguments
   using the ``<`` operator for comparison. 

.. function:: proc max(x, y ...)

   Compute the maximum value of 2 or more arguments
   using the ``>`` operator for comparison. 

.. function:: proc exit(status: int)

   
   Exit the program
   
   :arg status: The exit code for the program
   

