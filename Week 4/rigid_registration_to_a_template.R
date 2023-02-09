library(oro.nifti)
library(extrantsr)
library(fslr)
library(scales)
neurodir <- "/home/fsluser/Desktop/MOOC-2015"
mridir = file.path(neurodir, 'BRAINIX','NIfTI')
t1 = file.path(mridir, 'T1.nii.gz')
t1=(readNIfTI(t1,reorient=FALSE))
flair=file.path(mridir,"FLAIR.nii.gz")
roi=file.path(mridir,"ROI.nii.gz")
flair_file=readNIfTI(flair,reorient=FALSE)
roi_file=readNIfTI(roi,reorient=FALSE)
is_tumor <- (roi_file>0)
roi_file[!is_tumor]=NA
orthographic(flair_file,roi_file,xyz=c(200,115,12),
             col.y=alpha('red',0.2),
             text="Image overlaid with mask",
             text.cex=1.5)
reg_flair = file.path(mridir, 'FLAIR_regToT1.nii.gz')
reg_roi = file.path(mridir,"ROI_regToT1.nii.gz")
reg_flair_img = ants_regwrite(filename=flair,
                              template.file=t1,
                              outfile=reg_flair,
                              typeofTransform = 'Rigid',
                              other.files=roi,
                              other.outfiles=reg_roi,
                              verbose=FALSE)
reg_roi_img=readNIfTI(reg_roi,reorient=FALSE)
double_ortho(t1,reg_flair_img)
ortho2(reg_flair_img,reg_roi_img,col.y=alpha('red',0.2))

n4_t1=bias_correct(t1,correction='N4')
brain=fslbet_robust(img=n4_t1,
                    correct=FALSE, verbose=FALSE)
template.file = file.path(neurodir,
                          "Template",'JHU_MNI_SS_T1_brain.nii.gz')
aff_t1_outfile = file.path(mridir,"T1_AffinetoEve.nii.gz")
aff_roi_outfile = file.path(mridir,
                            "ROI_regToT1_AffinetoEve.nii.gz")
aff_brain = ants_regwrite(filename=brain,
                          outfile=aff_t1_outfile,
                          other.files=reg_roi,
                          other.outfiles=aff_roi_outfile,
                          template.file=template.file,
                          typeofTransform='Affine',
                          verbose=FALSE)
aff_roi=readNIfTI(aff_roi_outfile,reorient=FALSE)
template=readNIfTI(template.file,reorient=FALSE)
double_ortho(aff_brain,template)
ortho2(aff_brain,template,col.y=alpha(hotmetal(),0.35))
#ortho2(aff_brain,template,z=ceiling(dim(template)[3]/2),
 #      plot.type='single', col.y=alpha(hotmetal(),0.35))
ortho2(aff_brain,aff_roi,col.y=alpha(hotmetal(),0.35),
       xyz=xyz(aff_roi))

template.file = file.path(neurodir, "Template",
                          "JHU_MNI_SS_T1_brain.nii.gz")
syn_t1_outfile = file.path(mridir, "T1_SyntoEve.nii.gz")
syn_roi_outfile=file.path(mridir,
                          "ROI_regToT1_SyntoEve.nii.gz")
syn_brain = ants_regwrite(filename=brain,
                          outfile = syn_t1_outfile,
                          other.files = reg_roi,
                          other.outfiles = syn_roi_outfile,
                          template.file = template.file,
                          typeofTransform = "SyN",
                          verbose=FALSE)
syn_roi = readNIfTI(aff_roi_outfile,reorient=FALSE)
double_ortho(syn_brain,template)
ortho2(syn_brain,template, col.y=alpha(hotmetal(),0.35))
ortho2(syn_brain,template,z=ceiling(dim(template)[3]/2),
       plot.type='single',col.y=alpha(hotmetal(),0.35))

########################################################
# Getting ROI Anatomic Information from 
# Non-Linear Registration

# extracting JHU Eve atlas Type I and labels

atlas = "JHU_MNI_SS_WMPM_Type-I"
txtfile=file.path(neurodir,'Template',paste0(atlas
                               , "_SlicerLUT.txt"))

# Read look up table (LUT)
jhut1.df = read.table(txtfile, stringsAsFactors=FALSE)
jhut1.df=jhut1.df[, 1:2]
colnames(jhut1.df) = c('index','Label')
jhut1.df$index=as.numeric(jhut1.df$index)
jhut1.df[1:4,]

#read in the templatei mage
jhut1.img=readNIfTI(file.path(neurodir, 'Template', 
                              paste0(atlas, '.nii.gz')))
#Obtain the nnumeric labels from the atlas
uimg = sort(unique(c(jhut1.img)))
#Obtain the numeric labels from the LUT
all.ind=jhut1.df$index
#Check that all numeric labels from the atlas are in LUT
stopifnot(all(uimg%in%all.ind))
hist(c(syn_roi[syn_roi > 0]))

library(plyr)
#Make a data frame with the index of hte atlas
#and the value of the ROI at that voxel
roi.df=data.frame(index=jhut1.img[syn_roi>0],
                  roi=syn_roi[syn_roi>0])
#obtain the number (sum) of voxels that have an roi
# value >0.5 in the roi by the index of labels
label_sums=ddply(roi.df, .(index),summarize,
             sum_roi=sum(roi),sum_roi_thresh=sum(roi>0.5))
label_sums = merge(label_sums,jhut1.df, by='index')
sums=label_sums #will use later
#Assign the labels to the row names
rownames(label_sums) = label_sums$Label
label_sums$Label=label_sums$index =NULL
#Reorder labels from the most to the least engaged
label_sums=label_sums[order(label_sums$sum_roi,
                            decreasing=TRUE),]
#Calculate the percent of the tumor engaging the region
label_pct=t(t(label_sums)/colSums(label_sums)) * 100
head(round(label_pct,1),10)


#Calculating the percent of labeled brain
#regions covered by roi

#Create a table that contains the number of voxels
#Engaged in each labeled region
jhut1.tab=as.data.frame(table(c(jhut1.img)))
colnames(jhut1.tab)=c('index','size')
#Merge the table of number of voxels per region with the
#table fo nuymber of voxels by ROI
region_pct = merge(sums,jhut1.tab,by='index')
rownames(region_pct) = sums$Label
#Calculate the percent of region engaged by the tumor
region_pct$Label = region_pct$index = NULL
region_pct = region_pct/region_pct$size * 100
region_pct$size = NULL
#Reorder regions from the most to the least engaged
region_pct = region_pct[order(region_pct$sum_roi,
                              decreasing=TRUE),]
#Calculate the percent of the tumor engaging the region
head(round(region_pct,1),10)
