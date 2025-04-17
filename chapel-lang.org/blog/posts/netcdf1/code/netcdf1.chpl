require "netcdf.h", "-lnetcdf";
use CTypes, BlockDist;

config const filename = "myFile.nc",
             datName = "test1D";

proc main() {

  var ncid, datid, ndims, dimid: c_int;

  // Open the file
  //      int nc_open(const char* path, int mode, int* ncidp)	
  extern proc nc_open(path: c_ptrConst(c_char), mode: c_int, ncidp: c_ptr(c_int)): c_int;

  extern const NC_NOWRITE: c_int;

  nc_open(filename.c_str(), NC_NOWRITE, c_ptrTo(ncid));

  // Get the dataset ID
  //
  //      int nc_inq_varid(int ncid, const char* datName, int* varid)
  extern proc nc_inq_varid(ncid: c_int, datName: c_ptrConst(c_char), varid: c_ptr(c_int));

  nc_inq_varid(ncid, datName.c_str(), c_ptrTo(datid));

  // Get the number of dimensions for this dataset
  //
  //      int nc_inq_varndims(int ncid, int varid, int* ndimsp)
  extern proc nc_inq_varndims(ncid: c_int, varid: c_int, ndimsp: c_ptr(c_int));

  nc_inq_varndims(ncid, datid, c_ptrTo(ndims));

  var dimids: [0..<ndims] c_int;

  // Get the IDs of each dimension
  //
  //      int nc_inq_vardimid(int ncid, int varid, int* dimidsp)
  extern proc nc_inq_vardimid(ncid: c_int, varid: c_int, dimidsp: c_ptr(c_int)): c_int;

  nc_inq_vardimid(ncid, datid, c_ptrTo(dimids));

  var dimlens: [0..<ndims] c_size_t;

  // Get the size of each dimension
  //
  //      int nc_inq_dimlen(int ncid, int dimid, size_t* lenp)
  extern proc nc_inq_dimlen(ncid: c_int, dimid: c_int, lenp: c_ptr(c_size_t)): c_int;

  for i in 0..<ndims {
    nc_inq_dimlen(ncid, dimids[i], c_ptrTo(dimlens[i]));
  }

  // Close the NetCDF file
  //
  //      int nc_close(int ncid)
  extern proc nc_close(ncid: c_int);
  nc_close(ncid);

}
