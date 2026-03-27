+++
title = "Chapel Community Calendar"
description = "Events taking place in the Chapel community"

+++

<!--
From: https://stackoverflow.com/questions/31821974/support-user-time-zone-in-embedded-google-calendar
 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.7/jstz.js" integrity="sha512-gPgCxBK1xjsllNvxhv6tdK4IU2lH7c5a/O9kg9y73K1+hDC4TUlkHz0pLfL6jyS7RrghnscJutlzvAiAojHh+w==" crossorigin="anonymous"></script>

<div id="calendar-container">
     <iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=America%2FLos_Angeles&showPrint=0&src=MWNlNTYyNzEzZjFkODdjOGRiNjRiZTBhYmQ1OWNlOTkxNDhmMzgzZmFjMmJjNGQ5ZTVhYTc2MmMxMjYyNGQzZUBncm91cC5jYWxlbmRhci5nb29nbGUuY29t&color=%23039be5" style="border:solid 1px #777" width="800" height="600" frameborder="0" scrolling="no"></iframe>
</div>

**Non-Google Calendar users:** If your app supports subscribing to online calendars, click to copy this
{{< copy-link url="https://calendar.google.com/calendar/ical/1ce562713f1d87c8db64be0abd59ce99148f383fac2bc4d9e5aa762c12624d3e%40group.calendar.google.com/public/basic.ics" text="iCal URL" >}} into it.
{.content-paragraph}

<script type="text/javascript">
  var timezone = jstz.determine();
  var pref = '<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=';
  var suff = '&showPrint=0&src=MWNlNTYyNzEzZjFkODdjOGRiNjRiZTBhYmQ1OWNlOTkxNDhmMzgzZmFjMmJjNGQ5ZTVhYTc2MmMxMjYyNGQzZUBncm91cC5jYWxlbmRhci5nb29nbGUuY29t&color=%23039be5" style="border:solid 1px #777" width="800" height="600" frameborder="0" scrolling="no"></iframe>';
  var iframe_html = pref + timezone.name() + suff;
  document.getElementById('calendar-container').innerHTML = iframe_html;
</script>
