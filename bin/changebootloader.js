a = new ActiveXObject("scripting.filesystemobject")
b = a.opentextfile(WScript.Arguments(0))
c = b.read(0x40)
b.skip(0x200)
d = b.read(a.getfile(WScript.Arguments(0)).size-0x240)
b.close()
b=a.createtextfile(WScript.Arguments(0), 1).write(c+a.opentextfile(WScript.Arguments(1)).read(512)+d)
