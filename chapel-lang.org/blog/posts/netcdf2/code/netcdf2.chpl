require "netcdf.h", "-lnetcdf";
use CTypes, BlockDist;

config const filename = "myFile.nc",
             datName = "test1D";

extern proc nc_open(path: c_ptrConst(c_char), mode: c_int, ncidp: c_ptr(c_int)): c_int;
extern const NC_NOWRITE: c_int;

proc main() {

  var ncid, datid, ndims, dimid: c_int;

  // Open the file
  nc_open(filename.c_str(), NC_NOWRITE, c_ptrTo(ncid));

  // Get the dataset ID
  extern proc nc_inq_varid(ncid: c_int, datName: c_ptrConst(c_char), varid: c_ptr(c_int));

  nc_inq_varid(ncid, datName.c_str(), c_ptrTo(datid));

  // Get the number of dimensions for this dataset
  extern proc nc_inq_varndims(ncid: c_int, varid: c_int, ndimsp: c_ptr(c_int));
  nc_inq_varndims(ncid, datid, c_ptrTo(ndims));

  // Get the IDs of each dimension
  var dimids: [0..<ndims] c_int;
  extern proc nc_inq_vardimid(ncid: c_int, varid: c_int, dimidsp: c_ptr(c_int)): c_int;
  nc_inq_vardimid(ncid, datid, c_ptrTo(dimids));

  // Get the size of each dimension
  var dimlens: [0..<ndims] c_size_t;
  extern proc nc_inq_dimlen(ncid: c_int, dimid: c_int, lenp: c_ptr(c_size_t)): c_int;
  for i in 0..<ndims {
    nc_inq_dimlen(ncid, dimids[i], c_ptrTo(dimlens[i]));
  }

  // Close the NetCDF file
  extern proc nc_close(ncid: c_int);
  nc_close(ncid);

  // Create the domain and distributed array to hold the data

  if ndims == 1 {
    var dom_in = CreateDomain(1, dimlens);
    DistributedRead(filename, datid, dom_in);
  }
  else if ndims == 2 then {
    var dom_in = CreateDomain(2, dimlens);
    DistributedRead(filename, datid, dom_in);
  }
  else if ndims == 3 then {
    var dom_in = CreateDomain(3, dimlens);
    DistributedRead(filename, datid, dom_in);
  }
  else if ndims == 4 then {
    var dom_in = CreateDomain(4, dimlens);
    DistributedRead(filename, datid, dom_in);
  }
  // else if etc. etc.
  else {
    halt("Can't yet handle >4 dimensions");
  }
}

proc CreateDomain(param numDims, indicesArr) {

  if numDims == 1 {
    return {0..<indicesArr[0]};
  } else if numDims == 2 {
    return {0..<indicesArr[0], 0..<indicesArr[1]};
  } else if numDims == 3 {
    return {0..<indicesArr[0], 0..<indicesArr[1], 0..<indicesArr[2]};
  } else if numDims == 4 {
    return {0..<indicesArr[0], 0..<indicesArr[1], 0..<indicesArr[2], 0..<indicesArr[3]};
  }
  // else if etc. etc.

}

inline proc tuplify(x) {
  if isTuple(x) then return x; else return (x,);
}

proc DistributedRead(const filename, datid, dom_in) {

  const D = blockDist.createDomain(dom_in);
  var dist_array: [D] real(64);

  coforall loc in Locales do on loc {

    //      int nc_get_vara_double(int ncid, int varid, const size_t* startp, const size_t* countp, float* ip)	
    extern proc nc_get_vara_double(ncid: c_int, varid: c_int, startp: c_ptr(c_size_t), countp: c_ptr(c_size_t), ip: c_ptr(real(64))): c_int;

    // Determine where to start reading file, and how many elements to read
    // Start specifies a hyperslab.  It expects an array of dimension sizes
    var start = tuplify(D.localSubdomain().first);

    // Count specifies a hyperslab.  It expects an array of dimension sizes
    var count = D.localSubdomain().shape;

    // Create arrays of c_size_t for compatibility with NetCDF-C functions.
    var start_c, count_c: [0..<dom_in.rank] c_size_t;
    start_c = start;
    count_c = count;

    var ncid: c_int;
    nc_open(filename.c_str(), NC_NOWRITE, c_ptrTo(ncid));

    nc_get_vara_double(ncid, datid, c_ptrTo(start_c), c_ptrTo(count_c), c_ptrTo(dist_array[start]));

    nc_close(ncid);
  }

  return dist_array;

}
