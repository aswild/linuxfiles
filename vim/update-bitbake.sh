#!/bin/bash

set -xeo pipefail

curl -sSLf 'https://github.com/openembedded/bitbake/archive/master.tar.gz' | \
    tar -xzvf- --strip-components=3 --exclude=LICENSE.txt --exclude=plugin \
    bitbake-master/contrib/vim

patch -p2 <<'_EOF'
diff --git a/vim/ftdetect/bitbake.vim b/vim/ftdetect/bitbake.vim
index 09fc4dc..0631b05 100644
--- a/vim/ftdetect/bitbake.vim
+++ b/vim/ftdetect/bitbake.vim
@@ -14,11 +14,14 @@ endif
 au BufNewFile,BufRead *.{bb,bbappend,bbclass}  set filetype=bitbake
 
 " .inc
-au BufNewFile,BufRead *.inc		set filetype=bitbake
+au BufNewFile,BufRead *.inc
+    \ if (match(expand("%:p:h"), "/meta-[^/]\\+\\|/meta") > 0) |
+    \       set filetype=bitbake |
+    \ endif
 
 " .conf
 au BufNewFile,BufRead *.conf
-    \ if (match(expand("%:p:h"), "conf") > 0) |
+    \ if (match(expand("%:p:h"), "/\\(meta\\|build\\)\\(-[^/]\\+\\|\\)/conf") > 0) |
     \     set filetype=bitbake |
     \ endif
 
_EOF
