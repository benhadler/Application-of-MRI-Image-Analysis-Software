library(oro.nifti)
library(translations)
library(pacman)
p_install(AnalyzeFMRI)
getwd()
T1 <- readNIfTI(file.path(mridir, "113-01-MPRAGE.nii.gz"),reorient=FALSE)
im_hist <- hist(T1,plot=FALSE)
par(mar=c(5,4,4,4) + 0.3)
coll=rgb(0,0,1,1/2)
par(mfrow=c(1,2))
plot(im_hist$mids,im_hist$count,log='y',type='h',lwd=10,lend=2,col=coll,xlab="Intensity Values",ylab="Count(Log Scale)")
plot(im_hist$mids,im_hist$count,log='y',type='h',lwd=10,lend=2,col=coll,xlab="Intensity Values",ylab="Count(Log Scale)")
par(new=TRUE)
curve(x*1,axes =FALSE, xlab="",ylab='',col=2,lwd=3)
axis(side=4,at=pretty(range(im_hist$mids))/max(T1), labels=pretty(range(im_hist$mids)))
mtext("original Intensity", side=4, line=2)
lin.sp<-function(x,knots,slope)
  {knots<-c(min(x),knots,max(x))
  slopeS<-slope[1]
  for(j in 2:length(slope)){slopeS<-c(slopeS,slope[j]-sum(slopeS))}
  
  rvals<-numeric(length(x))
  for(i in 2:length(knots))
  {rvals<-ifelse(x>=knots[i-1],slopeS[i-1]*(x-knots[i-1])+rvals,rvals)}
  return(rvals)}
#Define a spline iwth tow knots aqnd three slopes
knot.vals<-c(.3,.6)
slp.vals<-c(1,.5,.25)
par(new=TRUE)
curve(lin.sp(x,knot.vals,slp.vals),axes=FALSE,xlab='',ylab='',col=2,lwd=3)
axis(side=4,at=pretty(range(im_hist$mids))/
       max(T1),labels=pretty(range(im_hist$mids)))
mtext("Transformed Intensity",side=4,line=2)
trans_T1<-lin.sp(T1,knot.vals*max(T1),slp.vals)
par(mfrow=c(1,2))
image(T1,z=150,plot.type='single',main='Original Image')
image(trans_T1,z=150,plot.type='single',main='Transformed Image')
smooth.T1 <- GaussSmoothArray(T1,voxdim=c(1,1,1),ksize=11,sigma=diag(3,3),mask=NULL,var.norm=FALSE)
orthographic(smooth.T1)
