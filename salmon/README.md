# How to create the patch file
1. get the archive for salmon for version {VERSION}
2. extract
3. copy to salmon-{VERSION}_new
4. mod the files in salmon-{VERSION} according to the latest version patch
5. create the patch file
6. diff -Naur salmon-{VERSION}_new salmon-{VERSION} > salmon-{VERSION}-alpine-3.12.patch
