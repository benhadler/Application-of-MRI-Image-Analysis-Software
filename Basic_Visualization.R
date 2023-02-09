getwd()
library(oro.nifti)
fname='Output_3D_File'
list.files()
print({nii_T1=readNIfTI(fname=fname)})
image(1:d[1],1:d[2],nii_T1[,,11],xlab='',ylab='',col=grey(0:64/64))
image(nii_T1,plot.type='single', plane = "sagittal")
orthographic(nii_T1,xyz=c(200,200,11))
par(mfrow=c(1,2));
o<-par(mar=c(4,4,0,0))
hist(nii_T1, breaks=75, prob=T, xlab='T1 intensities', col=rgb(0,0,1,1/2),main='')
hist(nii_T1[nii_T1 > 20], breaks=75, prob=T, xlab='T1 intensities', col=rgb(0,0,1,1/2),main='')
is_btw_300_400<- ((nii_T1>300) & (nii_T1<400))
nii_T1_mask<-nii_T1
nii_T1_mask[!is_btw_300_400] = NA
overlay(nii_T1,nii_T1_mask)
image(nii_T1_mask)
d
orthographic(nii_T1,nii_T1_mask,xyz=c(200,200,11),text='Image overlaid with mask',text.cex = 1.5)
