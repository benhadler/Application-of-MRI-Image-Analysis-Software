library(oro.nifti)
library(extrantsr)
library(fslr)
kirbydir <- "/home/fsluser/Desktop/MOOC-2015/kirby21"
mridir=file.path(kirbydir, 'visit_1','113')
files = c('113-01-MPRAGE.nii.gz',
          '113-01-T2w.nii.gz',
          '113-01-FLAIR.nii.gz')
files=file.path(mridir,files)
outfiles = c('113-01-MPRAGE_processed.nii.gz',
             '113-01-T2w_processed.nii.gz',
             '113-01-FLAIR_processed.nii.gz')
outfiles=file.path(mridir,outfiles)
preprocess_mri_within(files=files,retimg = FALSE,
                      outfiles = outfiles,
                      correction = 'N4',skull_strip = FALSE)
brain=fslbet_robust(img=outfiles[1],
                    correct=FALSE,verbose=FALSE)
mask=brain >0
masked_imgs=lapply(outfiles,fslmask,mask=mask,
                   verbose=FALSE)
orthographic(masked_imgs[[2]])

mridir2=file.path(kirbydir, 'visit_2','113')
files = c('113-02-MPRAGE.nii.gz',
          '113-02-T2w.nii.gz',
          '113-02-FLAIR.nii.gz')
files2=file.path(mridir2,files)
outfiles2 = c('113-02-MPRAGE_processed.nii.gz',
             '113-02-T2w_processed.nii.gz',
             '113-02-FLAIR_processed.nii.gz')
outfiles2=file.path(mridir2,outfiles2)
preprocess_mri_within(files=files2,retimg = FALSE,
                      outfiles = outfiles2,
                      correction = 'N4',skull_strip = FALSE)
brain2=fslbet_robust(img=outfiles2[1],
                    correct=FALSE,verbose=FALSE)
mask2=brain2 >0
masked_imgs=lapply(outfiles2,fslmask,mask=mask2,
                   verbose=FALSE)
