// Batch IHC quantification - extract hematoxylin (H) counterstain

// An ImageJ/FIJI macro script for batch extracting DAB staining using Immunohistochemistry (IHC) Image Analysis Toolbox 
// (https://imagej.nih.gov/ij/plugins/ihc-toolbox/index.html) plugin.

// (C) Copyright 2018, All rights reserved. 
// Waitt Advanced Biophotonics Core, Salk Institute for Biological Studies
// 10010 N Torrey Pines Rd., San Diego, CA 92037, The United States
// Linjing Fang, Uri Manor 06-05-2018


// Hide images in GUI for faster processing
setBatchMode(true);

// Get input files
path = getDirectory("Select folder of input tiff files"); 
filelist = getFileList(path);

//Set measurements
run("Set Measurements...", "area area_fraction display redirect=None decimal=2");
open(filelist[0]);      
run("IHC Toolbox", "");
waitForUser("User selects custom color detection model", "Select \"Read User Model\" for H (purple/blue), then click OK.")
close()
for (i=0; i< filelist.length; i++) {
	print("analyzing: "+ filelist[i]);
	
	// process tiff files only
	if (endsWith(filelist[i], ".tif") || endsWith(filelist[i], ".tiff"))  {
    	open(filelist[i]);
		setBatchMode(false);
		// User clicks "Training" on IHC Toolbox. Ideally, would like to automate this part
		waitForUser("User input is needed", "Press \"Color\", then click OK when \"Stain Color Detection\" window appears.");
		setBatchMode(true);

		selectWindow("Stain Color Detection");
		analyzedName = replace(replace(filelist[i],".tiff","_H.tiff"),".tif","_H.tif");
		print("Saving:  " + analyzedName);
		save(path + analyzedName);
		
		// find % of interested color over entire sample
		run("Make Binary");
		run("Measure");
		setResult("Label", i*2, analyzedName);
        selectWindow(filelist[i]);
        run("Make Binary");
		run("Measure");
		setResult("Label", (i*2)+1, filelist[i]);
		run("Close All");
	}
}

resultName = "results-H.xls";
print("Saving:  " + resultName);
saveAs("Results", path + resultName);

setBatchMode(false);
