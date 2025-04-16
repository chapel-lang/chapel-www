.. default-domain:: chpl

.. module:: Curl
   :synopsis: Simple support for many network protocols with libcurl

Curl
====
**Usage**

.. code-block:: chapel

   use Curl;



Simple support for many network protocols with libcurl

This module provides support for libcurl, enabling Chapel programs
to work with many network protocols.

The `curl homepage <https://curl.haxx.se/libcurl/>`_ describes libcurl thus::

 libcurl is a free and easy-to-use client-side URL transfer library, supporting
 DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3,
 POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, Telnet and TFTP.  libcurl supports
 SSL certificates, HTTP POST, HTTP PUT, FTP uploading, HTTP form based upload,
 proxies, cookies, user+password authentication (Basic, Digest, NTLM,
 Negotiate, Kerberos), file transfer resume, http proxy tunneling and more!

Dependencies
------------

The Curl module in Chapel is dependent on libcurl. For more information
 on how to setup libcurl, see the :ref:`readme-auxIO` page.

Using Curl Support in Chapel
----------------------------

Chapel support for libcurl exposes two interfaces:
 1. A standard file I/O interface
 2. Bindings to libcurl's curl_easy_setopt and curl_easy_perform

Interface 1:
  Since we do not support multiple readers on the same Curl handle, it is
  recommended that Chapel programs use :proc:`~IO.openreader` and
  :proc:`~IO.openwriter` in order to open up channels on a URL. Examples of how
  :proc:`~IO.openreader` and :proc:`~IO.openwriter` work can be found below.
  You may also open up a curl handle on a URL via :proc:`~IO.open`
  `(url=..., mode=...)`, and then open up channels, or use the second interface
  described below to set options on that handle before opening up a channel on
  the handle. Note that in this last case, Chapel programs must not open
  multiple channels for the same file backed by a curl handle.

  .. note::

    The URL is the last parameter to :proc:`~IO.open`. Therefore when you are
    opening a URL if you are not using all of the parameters for
    :proc:`~IO.open()` or :proc:`~IO.openreader`/:proc:`~IO.openwriter`, you
    MUST specify all arguments by name, e.g.:

    .. code-block:: chapel

      open(url="https://example.com", iomode.r);

    will result in a compile time error. You would, instead, need to use:

    .. code-block:: chapel

      open(url="https://example.com", mode=iomode.r).


Interface 2:
  Many times when we are connecting to a URL (FTP, IMAP, SMTP, HTTP) we have to
  give extra information to the Curl handle. This is done via the setopt()
  interface.  Documentation on the various options, as well as the functions
  that are referenced below can be found `here
  <https://curl.haxx.se/libcurl/c/libcurl-easy.html>`_

  Types:
    * :record:`slist`
  Methods:
    * :proc:`slist.append`
    * :proc:`slist.free`
    * :proc:`file.setopt`
    * :proc:`file.perform`

   Calling :proc:`~IO.file.close` on the file will disconnect the underlying
   Curl handle.


Here are some simple code snippets demonstrating these two interfaces:

Example 1
---------

.. code-block:: chapel

  // This example uses the first interface

  var writer = openwriter("out.txt");
  // Open a URL and get a reader on a section of the site
  var reader = openreader(url="https://example.com");

  var str:string;

  // While we can read a line from example.com, write it to 'out.txt'
  while(reader.readline(str)) do
    writer.write(str);

Example 2
---------

.. code-block:: chapel

  // This example uses the first interface
  var str:string;
  var reader = openreader(url="https://example.com");
  reader.readstring(str);
  reader.close();

  // Write out to a URL via Curl
  var writer = openwriter("https://127.0.0.1:1080");
  writer.write(str);
  writer.close();

Example 3
---------

.. code-block:: chapel

  // Open a file on our local file system
  var f = openwriter("out.txt");
  // Now get a curl handle
  var c = openreader(url="https://example.com");
  var str:string;

  // Read from example.com and write it out to out.txt
  c.readstring(str);
  f.write(str);

  // Disconnect and free the curl handle and channel, and close the local file and
  // channel
  c.close();
  f.close();


Example 4
---------

.. code-block:: chapel

  // This example uses the second interface

  // Open a file with a curl handle as the internal file
  var c = open(url="https://example.com", mode=iomode.r);
  // do a standard perform operation on the underlying curl handle
  c.perform(); // This will print to stdout
  // disconnect and free the curl handle
  c.close();


Example 5
---------

.. code-block:: chapel

  // This example uses the second interface + the first interface

  var c = open(url="https://example.com", mode=iomode.r);
  var str:string;
  // Set verbose output from curl
  c.setopt(curlopt_verbose, true);

  // now read into the string
  var reader = c.reader();
  reader.readstring(str);
  writeln(str);
  reader.close();
  c.close();


Example 6
---------

.. code-block:: chapel

  // Connect to an IMAP site, and fetch mail from the inbox
  config const username = "user";
  config const password = "xxxx";
  config const imapSite = "your_imap_site_here";

  var handle = open(url=imapSite+"/INBOX/;UID=1", mode=iomode.r);
  var reader = handle.reader();
  var str:string;

  handle.setopt((curlopt_username, username),
                (curlopt_password, password));

  //Calling this would give the same output
  // handle.perform();

  reader.readstring(str);
  write(str);

  reader.close();
  handle.close();

.. _curl-example-7:

Example 7
---------

.. code-block:: chapel

  // This example shows a more complex example of how the two interfaces can work
  // together: We use the second (setopt) interface to set the various options we
  // need on a given curl handle, and then open a writer on that handle to write
  // out via curl.

  config const url      = "smtp goes here";

  config const from     = "<some-email>";
  config const to       = "<some-email>";
  config const cc       = "<some-email>";

  config const username = "username";
  config const password = "password";

  config const subject  = "Testing Curl in Chapel (SMTP)";
  config const message  = "Hello! This is a message sent via Chapel!";


  var handle = open(url=url, mode=iomode.cw);

  var recipients:slist;
  recipients.append(to);
  recipients.append(cc);

  var arr = "To: " + to + "\r\n" +
            "From: " + from + "\r\n" +
            "Cc: " + cc + "\r\n" +
            "Subject: " + subject + "\r\n" + "\r\n" + message;


  handle.setopt((curlopt_username       , username),
                (curlopt_password       , password),
                (curlopt_mail_from      , from),
                (curlopt_use_ssl        , 3),
                (curlopt_ssl_verifypeer , false),
                (curlopt_ssl_verifyhost , false),
                (curlopt_mail_rcpt      , recipients.list),
                (curlopt_verbose        , true));

  // Create a writer on the curl handle.
  var writer = handle.writer();

  // Now write out to Curl to send the email
  writer.write(arr);

  // recipients.free(); // BAD: This will free the data while it is in use!
  writer.close();
  // Note here how we free the slist AFTER we close the writer. This way we can
  // ensure that we do not free data that is currently in use by curl.
  recipients.free();
  handle.close();


Curl Support Types and Functions
--------------------------------

 

.. method:: proc file.setopt(opt: c_int, arg): bool throws

   This function is the equivalent to the
   `curl_easy_setopt <https://curl.haxx.se/libcurl/c/curl_easy_setopt.html>`_
   function in libcurl. It sets information on the curl file handle
   that can change libcurl's behavior.
   
   :arg opt: the curl option to set. This file makes available lower
             case versions of these curl options (e.g. use curlopt_url
             instead of CURLOPT_URL in your Chapel program)
   :arg arg: the value to set the curl option specified by opt.
   :type arg: `int`, `string`, `bool`, or `slist`

.. method:: proc file.setopt(args ...?k)

   Set curl options on a curl file. It is equivalent to the
   curl_setopt_array you might find in PHP.
   
   For example, you might do:
   
   .. code-block:: chapel
   
     curlfile.setopt((curlopt_username, username),
                     (curlopt_password, password));
   
   :arg args: any number of tuples of the form (curl_option, value). For each
              curl_option, this function will setopt it to its value.
   

.. method:: proc file.perform(): bool throws

   Perform any blocking file transfer operations on the curl file.
   This function calls
   `curl_easy_perform <https://curl.haxx.se/libcurl/c/curl_easy_perform.html>`_.
   
   Corresponds to
   `curl_easy_perform <https://curl.haxx.se/libcurl/c/curl_easy_perform.html>`_
   where the file has been opened up by specifying that `url=<some url>`.
   
   :returns: true on success. This version halts if an error is encountered,
             but future versions will support returning an error code instead
             of halting.
   

.. record:: slist

   
      A linked list of strings used in many curl setopt calls. This type
      corresponds to the libcurl type curl_slist.
   
   .. note::
   
      The slist type is not reference counted. Therefore the user is responsible
      for freeing the slist when they are done with it with :proc:`slist.free`.
   


.. method:: proc slist.append(str: string) throws

   Append the string argument to an slist. This function is the same
   as calling
   `curl_slist_append <https://curl.haxx.se/libcurl/c/curl_slist_append.html>`_
   
   This function halts if an error is encountered. Future versions will
   support returning an error code instead of halting.
   
   :arg str: a string argument to append
   

.. method:: proc slist.free()

   Free an slist. Chapel programs must call this function after using an slist.
   Programs must ensure that there are no ongoing connections using
   this slist when it is freed. For an example, see :ref:`curl-example-7`.
   

.. data:: const curlopt_file: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_WRITEDATA.html 

.. data:: const curlopt_url: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_URL.html 

.. data:: const curlopt_port: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PORT.html 

.. data:: const curlopt_proxy: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXY.html 

.. data:: const curlopt_userpwd: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_USERPWD.html 

.. data:: const curlopt_proxyuserpwd: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYUSERPWD.html 

.. data:: const curlopt_range: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_RANGE.html 

.. data:: const curlopt_infile: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_READDATA.html 

.. data:: const curlopt_errorbuffer: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_ERRORBUFFER.html 

.. data:: const curlopt_writefunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_WRITEFUNCTION.html 

.. data:: const curlopt_readfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_READFUNCTION.html 

.. data:: const curlopt_timeout: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TIMEOUT.html 

.. data:: const curlopt_infilesize: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_INFILESIZE.html 

.. data:: const curlopt_postfields: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POSTFIELDS.html 

.. data:: const curlopt_referer: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_REFERER.html 

.. data:: const curlopt_ftpport: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTPPORT.html 

.. data:: const curlopt_useragent: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_USERAGENT.html 

.. data:: const curlopt_low_speed_limit: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_LOW_SPEED_LIMIT.html 

.. data:: const curlopt_low_speed_time: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_LOW_SPEED_TIME.html 

.. data:: const curlopt_resume_from: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_RESUME_FROM.html 

.. data:: const curlopt_cookie: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COOKIE.html 

.. data:: const curlopt_httpheader: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTPHEADER.html 

.. data:: const curlopt_httppost: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTPPOST.html 

.. data:: const curlopt_sslcert: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLCERT.html 

.. data:: const curlopt_keypasswd: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_KEYPASSWD.html 

.. data:: const curlopt_crlf: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CRLF.html 

.. data:: const curlopt_quote: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_QUOTE.html 

.. data:: const curlopt_writeheader: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HEADERDATA.html 

.. data:: const curlopt_cookiefile: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COOKIEFILE.html 

.. data:: const curlopt_sslversion: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLVERSION.html 

.. data:: const curlopt_timecondition: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TIMECONDITION.html 

.. data:: const curlopt_timevalue: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TIMEVALUE.html 

.. data:: const curlopt_customrequest: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CUSTOMREQUEST.html 

.. data:: const curlopt_stderr: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_STDERR.html 

.. data:: const curlopt_postquote: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POSTQUOTE.html 

.. data:: const curlopt_writeinfo: c_int

   This curlopt setting is deprecated 

.. data:: const curlopt_verbose: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_VERBOSE.html 

.. data:: const curlopt_header: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HEADER.html 

.. data:: const curlopt_noprogress: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NOPROGRESS.html 

.. data:: const curlopt_nobody: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NOBODY.html 

.. data:: const curlopt_failonerror: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FAILONERROR.html 

.. data:: const curlopt_upload: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_UPLOAD.html 

.. data:: const curlopt_post: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POST.html 

.. data:: const curlopt_dirlistonly: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_DIRLISTONLY.html 

.. data:: const curlopt_append: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_APPEND.html 

.. data:: const curlopt_netrc: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NETRC.html 

.. data:: const curlopt_followlocation: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FOLLOWLOCATION.html 

.. data:: const curlopt_transfertext: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TRANSFERTEXT.html 

.. data:: const curlopt_put: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PUT.html 

.. data:: const curlopt_progressfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROGRESSFUNCTION.html 

.. data:: const curlopt_progressdata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROGRESSDATA.html 

.. data:: const curlopt_autoreferer: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_AUTOREFERER.html 

.. data:: const curlopt_proxyport: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYPORT.html 

.. data:: const curlopt_postfieldsize: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POSTFIELDSIZE.html 

.. data:: const curlopt_httpproxytunnel: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTPPROXYTUNNEL.html 

.. data:: const curlopt_interface: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_INTERFACE.html 

.. data:: const curlopt_krblevel: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_KRBLEVEL.html 

.. data:: const curlopt_ssl_verifypeer: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_VERIFYPEER.html 

.. data:: const curlopt_cainfo: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CAINFO.html 

.. data:: const curlopt_maxredirs: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAXREDIRS.html 

.. data:: const curlopt_filetime: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FILETIME.html 

.. data:: const curlopt_telnetoptions: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TELNETOPTIONS.html 

.. data:: const curlopt_maxconnects: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAXCONNECTS.html 

.. data:: const curlopt_closepolicy: c_int

   This option is deprecated 

.. data:: const curlopt_fresh_connect: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FRESH_CONNECT.html 

.. data:: const curlopt_forbid_reuse: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FORBID_REUSE.html 

.. data:: const curlopt_random_file: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_RANDOM_FILE.html 

.. data:: const curlopt_egdsocket: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_EGDSOCKET.html 

.. data:: const curlopt_connecttimeout: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONNECTTIMEOUT.html 

.. data:: const curlopt_headerfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HEADERFUNCTION.html 

.. data:: const curlopt_httpget: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTPGET.html 

.. data:: const curlopt_ssl_verifyhost: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_VERIFYHOST.html 

.. data:: const curlopt_cookiejar: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COOKIEJAR.html 

.. data:: const curlopt_ssl_cipher_list: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_CIPHER_LIST.html 

.. data:: const curlopt_http_version: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTP_VERSION.html 

.. data:: const curlopt_ftp_use_epsv: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_USE_EPSV.html 

.. data:: const curlopt_sslcerttype: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLCERTTYPE.html 

.. data:: const curlopt_sslkey: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLKEY.html 

.. data:: const curlopt_sslkeytype: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLKEYTYPE.html 

.. data:: const curlopt_sslengine: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLENGINE.html 

.. data:: const curlopt_sslengine_default: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSLENGINE_DEFAULT.html 

.. data:: const curlopt_dns_use_global_cache: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_DNS_USE_GLOBAL_CACHE.html 

.. data:: const curlopt_dns_cache_timeout: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_DNS_CACHE_TIMEOUT.html 

.. data:: const curlopt_prequote: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PREQUOTE.html 

.. data:: const curlopt_debugfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html 

.. data:: const curlopt_debugdata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_DEBUGDATA.html 

.. data:: const curlopt_cookiesession: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COOKIESESSION.html 

.. data:: const curlopt_capath: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CAPATH.html 

.. data:: const curlopt_buffersize: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_BUFFERSIZE.html 

.. data:: const curlopt_nosignal: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NOSIGNAL.html 

.. data:: const curlopt_share: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SHARE.html 

.. data:: const curlopt_proxytype: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYTYPE.html 

.. data:: const curlopt_encoding: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_ACCEPT_ENCODING.html 

.. data:: const curlopt_private: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PRIVATE.html 

.. data:: const curlopt_http200aliases: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTP200ALIASES.html 

.. data:: const curlopt_unrestricted_auth: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_UNRESTRICTED_AUTH.html 

.. data:: const curlopt_ftp_use_eprt: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_USE_EPRT.html 

.. data:: const curlopt_httpauth: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTPAUTH.html 

.. data:: const curlopt_ssl_ctx_function: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_CTX_FUNCTION.html 

.. data:: const curlopt_ssl_ctx_data: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_CTX_DATA.html 

.. data:: const curlopt_ftp_create_missing_dirs: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_CREATE_MISSING_DIRS.html 

.. data:: const curlopt_proxyauth: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYAUTH.html 

.. data:: const curlopt_ftp_response_timeout: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_RESPONSE_TIMEOUT.html 

.. data:: const curlopt_ipresolve: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_IPRESOLVE.html 

.. data:: const curlopt_maxfilesize: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAXFILESIZE.html 

.. data:: const curlopt_infilesize_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_INFILESIZE_LARGE.html 

.. data:: const curlopt_resume_from_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_RESUME_FROM_LARGE.html 

.. data:: const curlopt_maxfilesize_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAXFILESIZE_LARGE.html 

.. data:: const curlopt_netrc_file: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NETRC_FILE.html 

.. data:: const curlopt_use_ssl: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_USE_SSL.html 

.. data:: const curlopt_postfieldsize_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POSTFIELDSIZE_LARGE.html 

.. data:: const curlopt_tcp_nodelay: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TCP_NODELAY.html 

.. data:: const curlopt_ftpsslauth: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTPSSLAUTH.html 

.. data:: const curlopt_ioctlfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_IOCTLFUNCTION.html 

.. data:: const curlopt_ioctldata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_IOCTLDATA.html 

.. data:: const curlopt_ftp_account: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_ACCOUNT.html 

.. data:: const curlopt_cookielist: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COOKIELIST.html 

.. data:: const curlopt_ignore_content_length: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_IGNORE_CONTENT_LENGTH.html 

.. data:: const curlopt_ftp_skip_pasv_ip: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_SKIP_PASV_IP.html 

.. data:: const curlopt_ftp_filemethod: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_FILEMETHOD.html 

.. data:: const curlopt_localport: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_LOCALPORT.html 

.. data:: const curlopt_localportrange: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_LOCALPORTRANGE.html 

.. data:: const curlopt_connect_only: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONNECT_ONLY.html 

.. data:: const curlopt_conv_from_network_function: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONV_FROM_NETWORK_FUNCTION.html 

.. data:: const curlopt_conv_to_network_function: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONV_TO_NETWORK_FUNCTION.html 

.. data:: const curlopt_conv_from_utf8_function: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONV_FROM_UTF8_FUNCTION.html 

.. data:: const curlopt_max_send_speed_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAX_SEND_SPEED_LARGE.html 

.. data:: const curlopt_max_recv_speed_large: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAX_RECV_SPEED_LARGE.html 

.. data:: const curlopt_ftp_alternative_to_user: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_ALTERNATIVE_TO_USER.html 

.. data:: const curlopt_sockoptfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SOCKOPTFUNCTION.html 

.. data:: const curlopt_sockoptdata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SOCKOPTDATA.html 

.. data:: const curlopt_ssl_sessionid_cache: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSL_SESSIONID_CACHE.html 

.. data:: const curlopt_ssh_auth_types: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSH_AUTH_TYPES.html 

.. data:: const curlopt_ssh_public_keyfile: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSH_PUBLIC_KEYFILE.html 

.. data:: const curlopt_ssh_private_keyfile: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSH_PRIVATE_KEYFILE.html 

.. data:: const curlopt_ftp_ssl_ccc: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_FTP_SSL_CCC.html 

.. data:: const curlopt_timeout_ms: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TIMEOUT_MS.html 

.. data:: const curlopt_connecttimeout_ms: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CONNECTTIMEOUT_MS.html 

.. data:: const curlopt_http_transfer_decoding: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTP_TRANSFER_DECODING.html 

.. data:: const curlopt_http_content_decoding: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_HTTP_CONTENT_DECODING.html 

.. data:: const curlopt_new_file_perms: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NEW_FILE_PERMS.html 

.. data:: const curlopt_new_directory_perms: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NEW_DIRECTORY_PERMS.html 

.. data:: const curlopt_postredir: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_POSTREDIR.html 

.. data:: const curlopt_ssh_host_public_key_md5: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SSH_HOST_PUBLIC_KEY_MD5.html 

.. data:: const curlopt_opensocketfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_OPENSOCKETFUNCTION.html 

.. data:: const curlopt_opensocketdata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_OPENSOCKETDATA.html 

.. data:: const curlopt_copypostfields: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_COPYPOSTFIELDS.html 

.. data:: const curlopt_proxy_transfer_mode: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXY_TRANSFER_MODE.html 

.. data:: const curlopt_seekfunction: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SEEKFUNCTION.html 

.. data:: const curlopt_seekdata: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SEEKDATA.html 

.. data:: const curlopt_crlfile: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CRLFILE.html 

.. data:: const curlopt_issuercert: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_ISSUERCERT.html 

.. data:: const curlopt_address_scope: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_ADDRESS_SCOPE.html 

.. data:: const curlopt_certinfo: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_CERTINFO.html 

.. data:: const curlopt_username: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_USERNAME.html 

.. data:: const curlopt_password: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PASSWORD.html 

.. data:: const curlopt_proxyusername: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYUSERNAME.html 

.. data:: const curlopt_proxypassword: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROXYPASSWORD.html 

.. data:: const curlopt_noproxy: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_NOPROXY.html 

.. data:: const curlopt_tftp_blksize: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_TFTP_BLKSIZE.html 

.. data:: const curlopt_socks5_gssapi_service: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SOCKS5_GSSAPI_SERVICE.html 

.. data:: const curlopt_socks5_gssapi_nec: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_SOCKS5_GSSAPI_NEC.html 

.. data:: const curlopt_protocols: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_PROTOCOLS.html 

.. data:: const curlopt_redir_protocols: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_REDIR_PROTOCOLS.html 

.. data:: const curlopt_lastentry: c_int

   All other curlopt values will be less than this one 

.. data:: const curlopt_mail_from: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAIL_FROM.html 

.. data:: const curlopt_mail_rcpt: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAIL_RCPT.html 

.. data:: const curlopt_mail_auth: c_int

   See https://curl.haxx.se/libcurl/c/CURLOPT_MAIL_AUTH.html 

