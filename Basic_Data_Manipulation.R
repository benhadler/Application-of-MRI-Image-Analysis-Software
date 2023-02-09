library(oro.nifti)
setwd("C:/Programming/Neurohacking_data-0.0")
list.files()
setwd("C:/Programming/Neurohacking_data-0.0/kirby21/visit_1/113")
mridir <- "C:/Programming/Neurohacking_data-0.0/kirby21/visit_1/113"
list.files()
T1 <- readNIfTI(file.path(mridir, "113-01-MPRAGE.nii.gz"),reorient=FALSE)
orthographic(T1)
mask<-readNIfTI(file.path(mridir, '/SUBJ0001_mask.nii.gz'), reorient = FALSE)
orthographic(mask)
orthographic(mask * T1)
masked.T1 <- T1*mask
orthographic(T1.masked)
T1.follow = readNIfTI(file.path("C:/Programming/Neurohacking_data-0.0/kirby21/visit_2/113", '/113-02-MPRAGE.nii'), reorient = FALSE)
subtract.T1 <- T1.follow -T1
min(subtract.T1)
max(subtract.T1)
orthographic(subtract.T1)