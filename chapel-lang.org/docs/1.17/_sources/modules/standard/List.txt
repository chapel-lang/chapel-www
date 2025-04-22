.. default-domain:: chpl

.. module:: List
   :synopsis: This module provides a simple singly linked list.

List
====
**Usage**

.. code-block:: chapel

   use List;


This module provides a simple singly linked list.

.. note::

    This module is expected to change in the future.


.. record:: list

   
   A singly linked list.
   
   .. note::
   
       :proc:`~list.destroy` must be called to reclaim any memory used by the list.
   
   


   .. attribute:: type eltType

      
      The type of the data stored in every node.
      

   .. attribute:: var length: int

      
      The number of nodes in the list.
      

   .. method:: proc size

      
      Synonym for length.
      

   .. itermethod:: iter these()

      
      Iterate over the list, yielding each element.
      
      :ytype: eltType
      

   .. method:: proc ref append(e: eltType)

      
      Append `e` to the list.
      

   .. method:: proc push_back(e: eltType)

      
      Synonym for append.
      

   .. method:: proc append(e: eltType, es: eltType ...?k)

      
      Append all of the supplied arguments to the list.
      

   .. method:: proc prepend(e: eltType)

      
      Prepend `e` to the list.
      

   .. method:: proc push_front(e: eltType)

      
      Synonym for prepend.
      

   .. method:: proc concat(l: list(eltType))

      
      Append all the elements in `l` to the end of the list.
      

   .. method:: proc ref remove(x: eltType)

      
      Remove the first encountered instance of `x` from the list.
      Does nothing if `x` is not present in the list.
      

   .. method:: proc pop_front(): eltType

      
      Remove the first element from the list and return it.
      It is an error to call this function on an empty list.
      

   .. method:: proc destroy()

      
      Delete every node in the list.
      

   .. method:: proc deinit()

      
      Destructor
      

.. function:: proc makeList(x ...?k)

   
   Construct a new :record:`list` containing all of the supplied arguments.
   
   :arg x: Every argument must be of type `T`.
   :type x: `T`
   :rtype: list(T)
   

