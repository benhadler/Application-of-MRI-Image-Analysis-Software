setwd("/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113")
library(fslr)
img=readnii('113-01-MPRAGE.nii.gz')
ortho2(img)
fslview(img)
devtools::install_github('muschellij2/papayar')
library(papayar)
mask = img > 5e5
ortho2(img,img > 5e5)
papaya(list(img,mask))

devtools::install_github('muschellij2/itksnapr',force=TRUE)
itksnap(grayscale=img)
