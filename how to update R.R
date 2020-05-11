
### How to save and reinstall all R packages after an update
getwd() ### just check to see where you are saving your list of files

ip <- installed.packages()
ip
saveRDS(ip, "CurrentRPackages.rds")

## *** UPDATE YOUR R and RStudio *** ##

        ## ** To update R on Windows, use the package installr (only for Windows):
        ## You should do steps 1 and 2 in the Rgui (not RStudio).
        ## Do not be afraid.

              ## 1. Install and load installr: install.packages("installr") and library(installr)
              ## 2. Call updateR() function. This will start the updating process of your R installation by: "finding the latest R version, downloading it, running the installer, deleting the installation file, copy and updating old packages to the new R installation."
              ## 3. From within RStudio, go to Help > Check for Updates to install newer version of RStudio (if available, optional).

        ## ** For Mac, go to and follow instructions: https://cloud.r-project.org/bin/macosx/

## Once your new R and RStudio are installed:
## use setwd() to direct to the place where you saved the packages

#setwd() 

ip <-readRDS("CurrentRPackages.rds")
install.packages(ip[,1]) ## follow the prompts, for me this only took about 10 mins for 283 packages: nrow(ip)


