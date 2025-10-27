# AIA-temperature-responses

The Atmospheric Imaging Assembly (AIA) is an EUV/UV imaging instrument on board NASA's Solar Dynamics Observatory (SDO).

The AIA comprises four telescopes that provide narrow-band imaging of seven extreme ultraviolet (EUV) band passes centered on specific spectral lines: Fe XVIII (94 Å), Fe XVIII, Fe XXI (131 Å), Fe IX (171 Å), Fe XII, XXIV (193 Å), Fe XIV (211 Å), He II (304 Å), and Fe XVI (335 Å). 

This repository contains Interactive Data Language (IDL) code (plot_aia_temp_resp.pro) to plot AIA wavelength responses and temperature responses using the CHIANTI atomic database (https://www.chiantidatabase.org/). The IDL isothermal.pro procedure is used to calculate the isothermal spectrum, which is then folded with the instrument's effective areas and plate scale to determine AIA temperature responses.

AIA wavelength and temperature responses using SolarSoft IDL routine - aia_get_response.pro  
Information of AIA temperature repsonses - version 10 published on 2020-Oct-28   
link: https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/response/V10_release_notes.txt  

For other versions check - https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/response/  

Limitations of using the IDL routine aia_get_response.pro for calculating the AIA temperature responses  
It is quicker as the chianti.ioneq and emissivity of the lines are calculated using the older verion of CHIANTI the model parameters - it is calculated at constant pressure, Zero electron number density and coronal abundances  
check - aia_temp_resp_ssw.EMISSINFO - for more details  
The user can not make any changes to these parameters   

Advantage of using ISOTHERMAL procedure for calculating the temperature responses - IDL code adopted from Del Zanna et al. 2011, A&A, 535, A46 - see Appendix  
You can use the latest version of the CHIANTI database (depending on your local version of the SolarSoft CHIANTI database) to calculate the emissivities of the lines in the wavelength array you have chosen, with the flexibility of choosing the electron number density/pressure and elemental abundances, depending on the observations.  

Importance - Using the correct temperature responses for AIA in Differential Emission Measure (DEM) analysis is crucial for studying solar plasma temperature.  

References:  
1) Del Zanna et al. 2013, A&A 558, A73  
   link: https://ui.adsabs.harvard.edu/abs/2013A%26A...558A..73D/abstract   
3) Del Zanna et al. 2011, A&A, 535, A46  
   link: https://ui.adsabs.harvard.edu/abs/2011A%26A...535A..46D/abstract  
4) Guennou, C., Auchère, F., Soubrié, E., et al. 2012, ApJS, 203, 25 - Figure 8  
   link: https://ui.adsabs.harvard.edu/abs/2012ApJS..203...25G/abstract  
5) Mulay, S. M., Del Zanna, G., & Mason, H. 2017, A&A, 598, A11 - The above procedure is used to calculate AIA temperature responses and used as an input for the DEM code.  
   link: https://ui.adsabs.harvard.edu/abs/2017A%26A...598A..11M/abstract  

CONTACT:  
Dr. Sargam Madhav Mulay  
Email - sargam.mulay@glasgow.ac.uk, sargamastro@gmail.com  
ORCID - https://orcid.org/0000-0002-9242-2643  
GitHub page - https://github.com/SargamMulay/AIA-temperature-responses.git  
ADS - https://ui.adsabs.harvard.edu/search/p_=0&q=Mulay%2C%20Sargam%20M.&sort=date%20desc%2C%20bibcode%20desc  
