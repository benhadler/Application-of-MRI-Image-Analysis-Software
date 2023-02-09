library(fslr)
setwd('/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113')
nim=readNIfTI("113-01-MPRAGE.nii.gz",reorient=FALSE)
orthographic(nim)
fast_img=fsl_biascorrect(nim,retimg=TRUE)
difference = nim - fast_img
orthographic(difference)

sub.bias <- niftiarr(nim,nim-fast_img)
q=quantile(sub.bias[sub.bias !=0],probs=seq(0,1,by=0.1))
install.packages('scales')
library(scales)
fcol=div_gradient_pal(low='blue',mid='yellow',high='red')
ortho2(nim,sub.bias,col.y=alpha(fcol(seq(0,1,length=10)),0.5),
ybreaks=q,ycolorbar=TRUE,text=paste0('Original Image minus N4',
'\n Bias-Corrected Image'))

slices =c(2,6,10,14,18)
vals=lapply(slices,function(x){
  cbind(img=c(nim[,,x]),fast=c(fast_img[,,x]),
        slice=x)
})
library(reshape2)
vals=do.call('rbind',vals)
vals=data.frame(vals)
vals=vals[vals$img>0&vals$fast>0,]
colnames(vals)[1:2]=c("Original Value",'Bias-Corrected Value')
v=melt(vals,id.vars='slice')
g=ggplot(aes(x=value,
             colour=factor(slice)),
         data=v) + geom_line(stat='density') +
  facet_wrap(~variable)
g=g+scale_colour_discrete(name='Slice#')
