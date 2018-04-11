
# MyHybrid

This application is a demo of RStudio's reticulate and Shiny packages. The demo incorporates the Google Maps Python API client and an advanced vehicle simulation tool written in Python by the National Renewable Energy Lab.

# Steps to Reproduce

1. Restore the R environment using packrat
2. Restore the Python environment using conda or virtualenv
3. Download NREL's [FASTSim tool](https://www.nrel.gov/transportation/fastsim.html) version `py-fastsim-2018a` and place the unzipped folder into the repo. The following modifications are required:
a. Modify line 56 of `/src/FASTSim.py` to read `csv_path = './/py-fastsim-2018a//cycles//'+cycle_name+'.csv'`
b. Modify line 77 to read `    with open('.//py-fastsim-2018a//docs//FASTSim_py_veh_db.csv','r') as csvfile:`
c. Insert a line before 1041 with `    output['mpsAch'] = np.asarray(mpsAch)`




# Disclaimer

This application was developed independently by RStudio as a DEMO using the freely available FASTSim model. The app was not written in conjunction with the National Renewable Energy Lab (NREL) nor is the application endorsed by NREL. The results presented in the application are
not to be used for accurate vehicle comparisons. RStudio is NOT RESPONSIBLE for the accuracy or reliability of any results presented in this application.