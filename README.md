# 3dprinting
Various 3D printing projects

The `fix_files.sh` script fixes incorrect ownership issues under Cygwin on
Windows (where files belong to Administrator instead of the user), deletes
trailing spaces from the end of lines (because the OpenSCAD editor doesn't do
this), and normalizes line endings to `\n` for when using a real editor (like
vim, not emacs, heh heh heh)
