library(fslr)
setwd('/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113')
nim=readNIfTI("113-01-MPRAGE.nii.gz",reorient=FALSE)
orthographic(nim)
fast_img=fsl_biascorrect(nim,retimg=TRUE)
bet_fast=fslbet(infile=fast_img,retimg=TRUE)
bet_fast_mask <- niftiarr(bet_fast,1)
is_in_mask = bet_fast > 0
bet_fast_mask[!is_in_mask] <-NA
orthographic(bet_fast)
orthographic(fast_img,bet_fast_mask)
cog=cog(bet_fast,ceil=TRUE)
cog = paste('-c',paste(cog,collapse=' '))
bet_fast2=
  fslbet(infile=fast_img,retimg=TRUE,opts=cog)
orthographic(bet_fast2)
