.. default-domain:: chpl

.. module:: OwnedObject
   :synopsis: :record:`Owned` (along with :record:`~SharedObject.Shared`) manage the

OwnedObject
===========
**Usage**

.. code-block:: chapel

   use OwnedObject;



:record:`Owned` (along with :record:`~SharedObject.Shared`) manage the
deallocation of a class instance. :record:`Owned` is meant to be used when
only one reference to an object needs to manage that object's storage.

To use :record:`Owned`, store a new class instance in a new Owned
record as is shown in this example:

.. code-block:: chapel

  use OwnedObject;
  class MyClass { }

  var myOwnedObject = new Owned(new MyClass());

When myOwnedObject goes out of scope, the class instance
it refers to will be deleted.

Copy initializing from ``myOwnedObject`` or assigning it to another
:record:`Owned` will leave ``myOwnedObject`` storing a nil value
and transfer the owned class instance to the other value.

.. code-block:: chapel

  var otherOwnedObject = myOwnedObject;
  // now myOwnedObject stores nil
  // the value it stored earlier has moved to otherOwnedObject

  myOwnedObject = otherOwnedObject;
  // this assignment moves the value from the right-hand-side
  // to the left-hand-side, leaving the right-hand-side empty.
  // after the assignment, otherOwnedObject stores nil
  // and myOwnedObject stores a value that will be deleted
  // when myOwnedObject goes out of scope.

The compiler includes support for introducing automatic coercions
from :record:`Owned` to the contained class type. For example:

.. code-block:: chapel


  proc f(arg:MyClass) {
    writeln(arg);
  }

  var myOwned = new Owned(new MyClass());
  f(myOwned); // compiler coerces to MyClass via borrow()

Additionally, the compiler includes support for coercing a value
of type ``Owned(T)`` to ``Owned(U)`` when ``T`` is a subclass of ``U``.
For example:

.. code-block:: chapel

  class Person { }
  class Student : Person { }

  var myStudent = new Owned(new Student());
  var myPerson:Owned(Person) = myStudent;
  // relies on coercion from Owned(Student) to Owned(Person)
  // moves the instance from myStudent to myPerson, leaving
  // myStudent containing nil.

.. note::

  The ways in which :record:`Owned` may be used are currently limited.
  Copy-initialization, assignment, and `in` intent are expected to work.
  However, it is currently an error to use a :record:`Owned` in a way that
  causes the compiler to add an implicitly copy, such as by returning a
  :record:`Owned` that was passed by reference.



.. record:: Owned

   
   :record:`Owned` manages the deletion of a class instance assuming
   that this :record:`Owned` is the only thing responsible for managing
   the lifetime of the class instance.
   


   .. method:: proc forwarding_expr1_p()

   .. method:: proc Owned(type t)

      
      Default-initialize a :record:`Owned`.
      

   .. method:: proc Owned(p, type t = p.type )

      
      Initialize a :record:`Owned` with a class instance.
      When this :record:`Owned` goes out of scope, it will
      delete whatever class instance it is storing.
      
      It is an error to directly delete the class instance
      while it is managed by a :record:`Owned`.
      
      :arg p: the class instance to manage. Must be of class type.
      

   .. method:: proc Owned(ref src: Owned, type t = src.t)

      
      Copy-initializer. Creates a new :record:`Owned`
      that takes over ownership from `src`. `src` will
      refer to `nil` after this call.
      

   .. method:: proc deinit()

      
      The deinitializer for :record:`Owned` will destroy the class
      instance it manages when the :record:`Owned` goes out of scope.
      

   .. method:: proc ref clear()

      
      Empty this :record:`Owned` so that it stores `nil`.
      Deletes the previously managed object, if any.
      

   .. method:: proc ref retain(newPtr: p.type )

      
      Change the instance managed by this class to `newPtr`.
      If this record was already managing a non-nil instance,
      that instance will be deleted.
      

   .. method:: proc ref release(): p.type 

      
      Empty this :record:`Owned` so that it manages `nil`.
      Returns the instance previously managed by this :record:`Owned`.
      

   .. method:: proc borrow()

      
      Return the object managed by this :record:`Owned` without
      impacting its lifetime at all. It is an error to use the
      value returned by this function after the :record:`Owned`
      goes out of scope.
      

