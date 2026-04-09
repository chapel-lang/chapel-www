use DynamicLoading, CTypes;

const lib = binary.load('./libMyAdd.so'),
      add = lib.retrieve('myAdd', proc(x: c_int, y: c_int): c_int);

const n = add(2, 2);
writeln(n);

on Locales.last {
  const n = add(here.id: c_int, here.id: c_int);
  writeln(n);
}
