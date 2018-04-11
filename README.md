# name_collisions
Finds name collisions of files in Matlab path.


The example usage:

    >> [~, collisions] = name_collisions;
    Found the following duplicate names:

     25 x    Contents.m
      2 x    complex2interleaved.m
      2 x    demosinit.m
      2 x    exported_values.mat
      2 x    gcGuiReport.mat
      2 x    header.m
      2 x    interleaved2complex.m
      2 x    ltfatdiditfail.m
      2 x    mexinit.m
      2 x    octinit.m
      2 x    ref_spreadadj_1.m
      2 x    signalsinit.m
      2 x    startup.m
      2 x    testinginit.m

It also returns a structure with paths to the colliding files.

    >> disp(collisions)
      51×1 struct array with fields:
    
        name
        folder
        date
        bytes
        isdir
        datenum
