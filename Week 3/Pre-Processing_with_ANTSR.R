library(extrantsr)
library(fslr)
setwd('/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113')
nim=readNIfTI("113-01-MPRAGE.nii.gz",reorient=FALSE)

n3img = bias_correct(nim, correction = 'N3', retimg=TRUE)
n4img = bias_correct(nim, correction = 'N4', retimg=TRUE)

orthographic(n3img)
orthographic(n4img)

tempdir <- '/home/fsluser/Desktop/MOOC-2015/Template'
template <- readNIfTI(file.path(tempdir, '/MNI152_T1_1mm_brain.nii.gz'),reorient=FALSE)

registered_n4 = ants_regwrite(filename=n4img,
                              template.file = template,
                              remove.warp = TRUE,
                              typeofTransform = 'Rigid')
orthographic(registered_n4)
orthographic(template)
