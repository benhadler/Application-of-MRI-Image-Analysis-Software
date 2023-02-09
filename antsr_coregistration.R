library(oro.nifti)
library(extrantsr)
library(fslr)
kirbydir <- "/home/fsluser/Desktop/MOOC-2015/kirby21"
mridir=file.path(kirbydir, 'visit_1','113')
T1_file=file.path(mridir,'113-01-MPRAGE.nii.gz')
T1=readNIfTI(T1_file,reorient=FALSE)
T2_file=file.path(mridir,'113-01-T2w.nii.gz')
reg_t2_img = ants_regwrite(filename=T2_file,template.file
                           =T1, typeofTransform = 'Rigid',
                           verbose=FALSE)
double_ortho(T1,reg_t2_img)
flair_file=file.path(mridir, '113-01-FLAIR.nii.gz')
reg_flair_img= ants_regwrite(filename=flair_file,
                             template.file=T1,
                             typeofTransform = 'Rigid',
                             verbose=FALSE)
library(scales)
ortho2(T1,reg_t2_img,col.y=alpha(hotmetal(),0.25))
ortho2(T1,reg_flair_img,col.y=alpha(hotmetal(),0.25))
