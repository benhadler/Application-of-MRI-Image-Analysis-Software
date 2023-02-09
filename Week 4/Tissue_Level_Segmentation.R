mridir = file.path(
 "/home/fsluser/Desktop/MOOC-2015/kirby21/visit_1/113")
t1_path=file.path(mridir,"113-01-MPRAGE.nii.gz")
#Read the file
nim=readNIfTI(t1_path,reorient=FALSE)
#Conduct bias field correction
fast_img=fsl_biascorrect(nim,retimg=TRUE)
#Perform brain extraction
bet=fslbet(infile=fast_img,retimg=TRUE)
#Perform segmentation
fast=fast(file=bet,outfile=file.path(paste0(mridir
      ,"/113-01-MPRAGE_biascorrected_Bet_fast.nii.gz")))
#Displays CSF segmentation
ortho2(bet,fast==1,col.y=alpha('red',
                        0.5),text='SUBJ113_CSF_1')
#Displays GM segmentation
ortho2(bet,fast==2,col.y=alpha("red",0.5),text=
         "SUBJ113_GM_1")
#Displays WM Segmentation
ortho2(bet,fast==3,col.y=alpha('red',0.5),
       text="SUBJ113_WM_1")

#Reads in the pve file for CSF, GM, and WM
pve_CSF=readNIfTI(paste0(mridir,
  "/113-01-MPRAGE_biascorrected_Bet_fast_pve_0.nii.gz"))
pve_GM=readNIfTI(paste0(mridir,
                        "/113-01-MPRAGE_biascorrected_Bet_fast_pve_1.nii.gz"))
pve_WM=readNIfTI(paste0(mridir,
                        "/113-01-MPRAGE_biascorrected_Bet_fast_pve_2.nii.gz"))
#Reads in the pve file for CSF
threshold=0.33
#Calculate the product of voxel dimensions(volume)
vdim_CSF=prod(voxdim(pve_CSF))
#Reads in the pve file for WM
nvoxels_CSF=sum(pve_CSF>threshold)
#Calculate the volume of CSF in mL
vol_pveCSF=vdim_CSF*nvoxels_CSF/1000
#CSF volume in mL
vol_pveCSF
#GM volume in mL
vdim_GM=prod(voxdim(pve_GM))
nvoxels_GM=sum(pve_GM>threshold)
vol_pveGM=vdim_GM*nvoxels_GM/1000
vol_pveGM
#WM volume in mL
vdim_WM=prod(voxdim(pve_WM))
nvoxels_WM=sum(pve_WM>threshold)
vol_pveWM=vdim_WM*nvoxels_WM/1000
vol_pveWM
