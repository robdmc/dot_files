EDITOR = 'vim';
HOST = db.serverStatus().host;
prompt = function(){
  return db + "@" + HOST + " -->";
}

//f = function(){};
//g = function(){};
//h = function(){};
//print('\nf(), g(), h() are three blank functions ready for editing');
//print('\nExample: Type "edit f" to open f() definition in vim\n');
print('\n\nAvailable databases\n-----------------');
_INITFUNC = function(){
  conn = new Mongo();
  var dbList = conn.getDBNames();
  for(var nr=0; nr<dbList.length; ++nr){
    print(dbList[nr]);
  }
  print("\n");
  print("\nWhile youre at it, try vim zz\n\n")
}
_INITFUNC();

//show dbs
