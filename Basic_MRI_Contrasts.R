list.files()
getwd()
mridir <- "C:/Programming/Neurohacking_data-0.0/kirby21/visit_1/113"
sequence <- "113-01-FLAIR"
volume.f <- readNIfTI(file.path(mridir, paste0(sequence,'.nii.gz')),reorient=FALSE)
volume.f <- cal_img(volume.f)
image(volume.f,z=11)
