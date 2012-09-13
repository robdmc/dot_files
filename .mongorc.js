EDITOR = 'vim';
HOST = db.serverStatus().host;
prompt = function(){
  return db + "@" + HOST + " -->";
}

f = function(){};
g = function(){};
h = function(){};
print('\nf(), g(), h() are three blank functions ready for editing');
print('\nExample: Type "edit f" to open f() definition in vim\n');
