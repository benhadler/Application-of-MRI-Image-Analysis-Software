library(fslr)
tempdir <- '/home/fsluser/Desktop/MOOC-2015/Template'
template <- readNIfTI(file.path(tempdir, '/MNI152_T1_1mm_brain.nii.gz'),reorient=FALSE)

setwd('/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113')
nim=readNIfTI("113-01-MPRAGE.nii.gz",reorient=FALSE)
fast_img=fsl_biascorrect(nim,retimg=TRUE)
bet_fast=fslbet(infile=fast_img,retimg=TRUE)
cog=cog(bet_fast,ceil=TRUE)
cog = paste('-c',paste(cog,collapse=' '))
bet_fast2=
  fslbet(infile=fast_img,retimg=TRUE,opts=cog)
registered_fast = flirt(infile=bet_fast2,reffile = 
                          template, dof=6,retimg=TRUE)

orthographic(template)
orthographic(bet_fast2)
orthographic(registered_fast)

registered_fast_affine = flirt(infile=bet_fast2, reffile = 
                  template, dof =12,retimg = TRUE)

orthographic(registered_fast_affine)
fnirt_fast = fnirt_with_affine(infile=bet_fast2,
                               reffile=template,outfile='FNIRT_to_Template',
                               retimg = TRUE)
orthographic(fnirt_fast)