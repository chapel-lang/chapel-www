use IO, JSON;

var A = [1, 2, 3, 4];

writeln(A);             // prints '1 2 3 4'  

var jsonWriter = stdout.withSerializer(jsonSerializer);  
jsonWriter.writeln(A);  // prints '[1, 2, 3, 4]'  
