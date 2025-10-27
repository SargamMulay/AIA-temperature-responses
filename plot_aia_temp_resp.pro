PRO plot_aia_temp_resp, dir_save = dir_save, $
obs_date = obs_date, edensity = edensity, $
plot_ssw_aia_wave_resp = plot_ssw_aia_wave_resp, $
ssw_aia_temp_resp_calc = ssw_aia_temp_resp_calc, $
plot_ssw_aia_temp_resp = plot_ssw_aia_temp_resp, $
chianti_aia_temp_resp_calc = chianti_aia_temp_resp_calc, $
plot_chianti_aia_temp_resp = plot_chianti_aia_temp_resp, $
plot_compare_temp_resp_ssw_chianti = plot_compare_temp_resp_ssw_chianti, $
plot_ratio_94_131 = plot_ratio_94_131

;**********************************************************************
;+
; NAME:
;     PLOT_AIA_TEMP_RESP
;
; PURPOSE:
;     Plot AIA wavelength responses and temperature responses using CHIANTI atomic
;     database. The isothermal.pro procedure is used to calculate the isothermal spectrum
;     which is then folded with effective areas and plate scale of 
;     instrument to calculate AIA temperature responses
;
;     More info give at 
;     : http://helio.cfa.harvard.edu/trace/SSXG/ynsu/Ji/sdo_primer_V1.1.pdf
;
;     AIA Data analysis guide : 
;     https://www.lmsal.com/sdodocs/doc/dcur/SDOD0060.zip/zip/entry/
;     
; CATEGORY:
;     SDO; image analysis.
;
; INPUTS:
;     Date of the observation and electron number density
;
; OUTPUTS:
;     Returns AIA wavelength responses and temperature responses in save files
;
; EXAMPLE: how to run the program
;         
;     IDL> out_dir = '/path/'
;     IDL> dir_save = '/path/'
;     IDL> obs_date = '2015-Dec-26'
;     IDL> edensity = 1e+10
;
;     IDL> .r plot_aia_temp_resp
;     IDL> .r plot_aia_temp_resp
;          plot_aia_temp_resp, out_dir = out_dir, dir_save = dir_save, $
;          obs_date = obs_date, edensity = edensity, $
;	   /plot_ssw_aia_wave_resp, $
;          /ssw_aia_temp_resp_calc, $
;          /plot_ssw_aia_temp_resp, $
;	   /chianti_aia_temp_resp_calc, $
;	   /plot_chianti_aia_temp_resp, $
;	   /plot_compare_temp_resp_ssw_chianti, $
;          /plot_ratio_94_131
;
; MODIFICATION HISTORY:
;     Ver.1, 03-Sep-2018, Dr. Sargam Madhav Mulay
;     Ver.2, 18-Aug-2025, Dr. Sargam Madhav Mulay 
;         added plot for comparison - temperature responses calculated using the SSW routine
;         and one that using CHIANTI routine - ISOTHERMAL.pro
;     
; CONTACT:
;     Dr. Sargam Madhav Mulay
;     Email - sargam.mulay@glasgow.ac.uk, sargamastro@gmail.com
;     ORCID - https://orcid.org/0000-0002-9242-2643
;     GitHub page - https://github.com/SargamMulay/AIA-temperature-responses.git
;     ADS - https://ui.adsabs.harvard.edu/search/p_=0&q=Mulay%2C%20Sargam%20M.&sort=date%20desc%2C%20bibcode%20desc
;
;*************************************************************************

print,'***************************************************************************************'
print, 'Calculating the instrument responses as a function of wavelength - using ssw routine
print,'https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/idl/response/aia_get_response.pro'
print,'***************************************************************************************'

; The AIA telescopes select the different wavelength bands using broad band filters. Each filter has a specific response function which is typically centred on the wavelength of the observed spectral line. 

; To obtain the wavelength response functions:
; https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/idl/response/aia_get_response.pro

ssw_aia_wave_resp = aia_get_response(/dn, timedepend_date = obs_date)
; '/DN' will give you temperature responses and effective areas
; It calculates the responses in 'cm^2 DN phot^-1'

print, 'dn - (AREA and TEMP ONLY) if set, the response function includes the photon-to-DN units conversion '

help, ssw_aia_wave_resp, /str

;   NAME            STRING    'AIA'
;   VERSION         INT             10
;   DATE            STRING    '20151016_000000'
;   CHANNELS        STRING    Array[7]
;   WAVE            FLOAT     Array[8751]
;   ALL             DOUBLE    Array[7, 8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'
;   A94             STRUCT    -> <Anonymous> Array[1]
;   A131            STRUCT    -> <Anonymous> Array[1]
;   A171            STRUCT    -> <Anonymous> Array[1]
;   A193            STRUCT    -> <Anonymous> Array[1]
;   A211            STRUCT    -> <Anonymous> Array[1]
;   A304            STRUCT    -> <Anonymous> Array[1]
;   A335            STRUCT    -> <Anonymous> Array[1]
;   CORRECTIONS     STRUCT    -> <Anonymous> Array[1]

;IDL> help, ssw_aia_wave_resp.A94
;** Structure <33d60f8>, 5 tags, length=105056, data length=105048, refs=2:
;   NAME            STRING    'A94'
;   WAVE            FLOAT     Array[8751]
;   EA              DOUBLE    Array[8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'

;IDL> help, ssw_aia_wave_resp.CORRECTIONS
;** Structure <1bd4c98>, 5 tags, length=1352, data length=1352, refs=2:
;   TIME            STRUCT    -> <Anonymous> Array[1]
;   TIME_APPLIED    STRING    'YES'
;   EVENORM         STRUCT    -> <Anonymous> Array[1]
;   EVENORM_APPLIED STRING    'NO'
;   INFO            STRING    Array[6]


;IDL> print, aia_wave_resp.CORRECTIONS.INFO
; TIME: Sub-structure describing how the time-dependent response correction for each channel is calculated
; TIME_APPLIED: Does the response function use the time-dependent correction?
; EVENORM: Sub-structure giving the normalization constant used to ensure agreement with EVE observations
; EVENORM_APPLIED: Does the response function use the EVE-derived normalization constant?  

;******************************************************************************
; For more details on NOT using the evenorm and chiantifix keywords
; check section 3 of the following paper - Del Zanna et al. 2013, A&A 558, A73
; link: https://ui.adsabs.harvard.edu/abs/2013A%26A...558A..73D/abstract
;******************************************************************************

help, ssw_aia_wave_resp.a171, /str

; ** Structure <ee5df8>, 5 tags, length=70048, data length=70044, refs=2:
;   NAME            STRING    'A171'
;   WAVE            FLOAT     Array[8751]
;   EA              FLOAT     Array[8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'

print, ssw_aia_wave_resp.date

date = ssw_aia_wave_resp.date

; saving wavelength responses
save, filename = dir_save + 'ssw_aia_wavelength_resp.save', ssw_aia_wave_resp, date

;*******************************************************************

if keyword_set(plot_ssw_aia_wave_resp) then begin

print,'************************************************************************************'
print, 'Plotting AIA wavelength responses by considering degradation over time'
print,'************************************************************************************'

restore, dir_save + 'ssw_aia_wavelength_resp.save',/v

;*****************************************************************

xs = 16   ; page size in X-direction - it changes the dimension of each of the image
ys = 12.5 ; page size in Y-direction - it changes the dimension of each of the image

!p.multi = [0,3,3]
n_plot_x = 3 ; no. of columns to plot 
n_plot_y = 3 ; no. of rows to plot

gap_x = 0.08 ; gaps between two images in X-direction
gap_y = 0.1  ; gaps between two images in Y-direction

margin = 0.06 ; enough space in y-direction to display the labels

space_plot_x = (1-2*margin-gap_x*n_plot_x)/n_plot_x
space_plot_y = (1-2*margin-gap_y*n_plot_y)/n_plot_y

right  = [margin+space_plot_x+ (space_plot_x+gap_x)*findgen(n_plot_x)]
left   = [margin+(space_plot_x+gap_x)*findgen(n_plot_x)]
bottom = 1-[margin+space_plot_y+ (space_plot_y+gap_y)*findgen(n_plot_y)]
top    = 1-[margin +(space_plot_y+gap_y)*findgen(n_plot_y)]

;*****************************************************************
; this is in linear scale

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'ssw_aia_wavelength_resp.eps', bits = 24, XSIZE = xs, YSIZE = ys


!p.font = 1
loadct,0

plot, ssw_aia_wave_resp.a94.wave,  ssw_aia_wave_resp.a94.ea,  charsize = 1.1, xr = [91,97],   title = obs_date + ' AIA 94 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[0], right[0], top[0]]

plot, ssw_aia_wave_resp.a131.wave, ssw_aia_wave_resp.a131.ea, charsize = 1.1, xr = [120,138],   title = 'AIA 131 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[1], bottom[0], right[1], top[0]]

plot, ssw_aia_wave_resp.a171.wave, ssw_aia_wave_resp.a171.ea, charsize = 1.1, xr = [165,185],   title = 'AIA 171 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[2], bottom[0], right[2], top[0]]

plot, ssw_aia_wave_resp.a193.wave, ssw_aia_wave_resp.a193.ea, charsize = 1.1, xr = [175,215],   title = 'AIA 193 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[1], right[0], top[1]]

plot, ssw_aia_wave_resp.a211.wave, ssw_aia_wave_resp.a211.ea, charsize = 1.1, xr = [190,230],   title = 'AIA 211 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[1], bottom[1], right[1], top[1]]

plot, ssw_aia_wave_resp.a335.wave, ssw_aia_wave_resp.a335.ea, charsize = 1.1, xr = [300,370], title = 'AIA 335 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[2], bottom[1], right[2], top[1]]

plot,ssw_aia_wave_resp.a304.wave, ssw_aia_wave_resp.a304.ea, charsize = 1.1, xr = [270,350],  title = 'AIA 304 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[2], right[0], top[2]]

device, /close
set_plot, 'x'

;*******************************************************************
; this is in log scale

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'aia_wavelength_resp_log.eps', bits = 24, XSIZE = xs, YSIZE = ys

!p.multi = [0,3,3]
!p.font = 1
loadct,0

plot, ssw_aia_wave_resp.a94.wave,  ssw_aia_wave_resp.a94.ea,  charsize = 1.1, xr = [91,97], /ylog,  title = obs_date + ' AIA 94 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[0], right[0], top[0]]

plot, ssw_aia_wave_resp.a131.wave, ssw_aia_wave_resp.a131.ea, charsize = 1.1, xr = [120,138], /ylog, title = 'AIA 131 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[1], bottom[0], right[1], top[0]]

plot, ssw_aia_wave_resp.a171.wave, ssw_aia_wave_resp.a171.ea, charsize = 1.1, xr = [165,185], /ylog, title = 'AIA 171 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[2], bottom[0], right[2], top[0]]

plot, ssw_aia_wave_resp.a193.wave, ssw_aia_wave_resp.a193.ea, charsize = 1.1, xr = [175,215], /ylog,  title = 'AIA 193 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[1], right[0], top[1]]

plot, ssw_aia_wave_resp.a211.wave, ssw_aia_wave_resp.a211.ea, charsize = 1.1, xr = [190,230], /ylog,  title = 'AIA 211 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[1], bottom[1], right[1], top[1]]

plot, ssw_aia_wave_resp.a335.wave, ssw_aia_wave_resp.a335.ea, charsize = 1.1, xr = [300,370],/ylog, title = 'AIA 335 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[2], bottom[1], right[2], top[1]]

plot, ssw_aia_wave_resp.a304.wave, ssw_aia_wave_resp.a304.ea, charsize = 1.1, xr = [270,350],/ylog,  title = 'AIA 304 !3' + STRING(197B) + '!X', xstyle = 1, ystyle = 1, xtitle = 'Wavelength (!3' + STRING(197B) + '!X)', ytitle = 'Effective area (cm!E2!N DN phot!E-1!N)', position = [left[0], bottom[2], right[0], top[2]]

device, /close
set_plot, 'x'

;*******************************************************************

endif

; It is noticeable that the filter is broader for larger wavelengths.  It is clear that the 171 A filter has a secondary peak at 175 A. Currently there is no response functions for the visible spectral lines.


;***************************************************************
;  AIA TEMPERATURE RESPONSES using SSW routine
;
; Information of AIA temperature repsonses - version 10 published on 2020-Oct-28 
; https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/response/V10_release_notes.txt

; For other versions check - https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/response/
; 
; Disadvantage of using the IDL routine aia_get_response.pro for 
; calculating the temperature responses
; It is quicker and as the chianti.ioneq and 
; emissivity of the lines are calculated using the older verion of CHIANTI
; the model parameters - it is calculated at constant pressure, 
; Zero electron number density and coronal abundances
; check - aia_temp_resp_ssw.EMISSINFO - for more details
; The user can not make any changes to these parameters *******
;
; Advantage of using ISOTHERMAL procedure for calculating the temperature responses 
; You can use the latest version of CHIANTI database (depending on your local solarsoft 
; CHIANTI database if updated) to calculate the emissivities of the lines in 
; the wavelength array you have chosen, 
; flexibility of choosing the electron number density/pressure and elemental abundances
; depending on the observations
;  
; The procedure is explained in the following section
;***************************************************************

if keyword_set(ssw_aia_temp_resp_calc) then begin

print,'***********************************************************************'
print, 'Calculating AIA Temperature responses using '
print, 'SSW routine - aia_get_response(/temp,/dn, timedepend_date = obs_date)'
print,'***********************************************************************'

ssw_aia_temp_resp = aia_get_response(/temp,/dn, timedepend_date = obs_date)

; --------------------------------------------------------------------
;| AIA_GET_RESPONSE...                                                |
;| You asked for time dependent correction but not EVE normalization; |
;| Are you sure you do not want to include EVE normalization?         |
; --------------------------------------------------------------------
;Include EVE normalization as well? (Default is no) [y/n] 
; ---------------------------------------------------
;| AIA_GET_RESPONSE: Not including EVE normalization |
; ---------------------------------------------------
; ----------------------------------------------------------
;| Generating temperature response function from            |
;| /data/p022/ssw/sdo/aia/response/aia_V9_all_fullinst.genx |
;| /data/p022/ssw/sdo/aia/response/aia_V9_fullemiss.genx    |
; ----------------------------------------------------------

help, ssw_aia_temp_resp

;** Structure <a563678>, 17 tags, length=23104, data length=23044, refs=1:
;   NAME            STRING    'AIA'
;   DATE            STRING    '20151016_000000'
;   EFFAREA_VERSION INT             10
;   EMISS_VERSION   INT             10
;   EMISSINFO       STRUCT    -> <Anonymous> Array[1]
;   CHANNELS        STRING    Array[7]
;   UNITS           STRING    'DN cm^5 s^-1 pix^-1'
;   LOGTE           FLOAT     Array[101]
;   ALL             DOUBLE    Array[101, 7]
;   A94             STRUCT    -> <Anonymous> Array[1]
;   A131            STRUCT    -> <Anonymous> Array[1]
;   A171            STRUCT    -> <Anonymous> Array[1]
;   A193            STRUCT    -> <Anonymous> Array[1]
;   A211            STRUCT    -> <Anonymous> Array[1]
;   A304            STRUCT    -> <Anonymous> Array[1]
;   A335            STRUCT    -> <Anonymous> Array[1]
;   CORRECTIONS     STRUCT    -> <Anonymous> Array[1]


ssw_aia_Eff_area_version = ssw_aia_temp_resp.EFFAREA_VERSION


; help,aia_temp_resp_ssw.EMISSINFO    
  
;** Structure <a564e38>, 14 tags, length=592, data length=572, refs=2:
;   ABUNDFILE       STRING    '/ssw/packages/chianti/dbase/abundance/sun_coronal_1992_feldman_ext.abun'...
;   SOURCE          STRING    'CH_SYNTHETIC run on Wed Jun 24 08:53:31 2020'
;   IONEQ_LOGT      FLOAT     Array[101]
;   IONEQ_NAME      STRING    '/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
;   IONEQ_REF       STRING    Array[3]
;   WVL_LIMITS      FLOAT     Array[2]
;   MODEL_NAME      STRING    'Constant pressure'
;   MODEL_NE        FLOAT           0.00000
;   MODEL_PE        FLOAT       1.00000e+15
;   MODEL_TE        FLOAT           0.00000
;   WVL_UNITS       STRING    'Angstroms'
;   ADD_PROTONS     INT              1
;   VERSION         STRING    '9.0.1'
;   PHOTOEXCITATION INT              0

Element_abundances = ssw_aia_temp_resp.EMISSINFO.ABUNDFILE
CHIANTI_version = ssw_aia_temp_resp.EMISSINFO.VERSION 
model_name = ssw_aia_temp_resp.EMISSINFO.MODEL_NAME
pressure = ssw_aia_temp_resp.EMISSINFO.MODEL_PE
electron_number_density = ssw_aia_temp_resp.EMISSINFO.MODEL_NE

print,'************************************************************************************'
print, 'Effective area version = ', ssw_aia_Eff_area_version
print, 'Element abundances = ', Element_abundances
print, 'CHIANTI version used for calculating the emissivities of the lines = ', CHIANTI_version 
print, 'constant pressure/electron number density = ', model_name
print, 'constant pressure =  ', pressure
print, 'constant electron number density =  ', electron_number_density
print,'************************************************************************************'

; saving wavelength and temperature responses

print,'********************************************************************************'
print, 'saving wavelength and temperature responses calculated using the SSW routines '
print,'********************************************************************************'

date = ssw_aia_temp_resp.date
save, filename = dir_save + 'ssw_aia_temp_wavelength_resp.save', ssw_aia_wave_resp, date, ssw_aia_temp_resp_ssw, ssw_aia_Eff_area_version, Element_abundances, CHIANTI_version, model_name, pressure, electron_number_density

endif

;*******************************************************************************
; Plotting AIA temperature responses calculated using SSW routines
;*******************************************************************************

print,'************************************************************************************'
print,'Plotting AIA temperature responses calculated using SSW routines'
print,'************************************************************************************'

if keyword_set(plot_ssw_aia_temp_resp) then begin

restore, dir_save + 'ssw_aia_temp_wavelength_resp.save', /v

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'plot_ssw_aia_temp_resp.eps', bits = 24

!p.font=1
!p.multi=0


; AIA 94
plot,ssw_aia_temp_resp.A94.LOGTE,ssw_aia_temp_resp.A94.TRESP,/yl,xr=[4.5,8.0],title='SSW - AIA temperature responses ' + obs_date,yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color=0, thick=4, xstyle=1

cgoplot, ssw_aia_temp_resp.A94.LOGTE, ssw_aia_temp_resp.A94.TRESP, charsize=1.4, background=255, color='black', thick=4

; AIA 131
cgoplot, ssw_aia_temp_resp.A131.LOGTE, ssw_aia_temp_resp.A131.TRESP, charsize=1.4, background=255, color='orange', thick=4

; AIA 171
cgoplot, ssw_aia_temp_resp.A171.LOGTE, ssw_aia_temp_resp.A171.TRESP, charsize=1.4, background=255, color='green', thick=4

; AIA 193
cgoplot, ssw_aia_temp_resp.A193.LOGTE, ssw_aia_temp_resp.A193.TRESP, charsize=1.4, background=255, color='blue', thick=4

; AIA 211
cgoplot, ssw_aia_temp_resp.A211.LOGTE, ssw_aia_temp_resp.A211.TRESP, charsize=1.4, background=255, color='magenta', thick=4

; AIA 304
cgoplot, ssw_aia_temp_resp.A304.LOGTE, ssw_aia_temp_resp.A304.TRESP, charsize=1.4, background=255, color='purple', thick=4

; AIA 335
cgoplot, ssw_aia_temp_resp.A335.LOGTE, ssw_aia_temp_resp.A335.TRESP, charsize=1.4, background=255, color='red', thick=4

al_legend, ['94 !3' + STRING(197B) + '!X','131 !3' + STRING(197B) + '!X','171 !3' + STRING(197B) + '!X','193 !3' + STRING(197B) + '!X', '211 !3' + STRING(197B) + '!X','304 !3' + STRING(197B) + '!X','335 !3' + STRING(197B) + '!X'], color = ['black', 'orange', 'green', 'blue', 'magenta','purple', 'red'], textcolors = ['black', 'orange', 'green', 'blue', 'magenta','purple', 'red'], linestyle = 0, thick = 4, /top, /right, charsize=1.2

device, /close
set_plot, 'x'

endif



;***************************************************************
;***************************************************************
;***************************************************************
; AIA TEMPERATURE RESPONSES WITH CHIANTI ISOTHERMAL PROCEDURE 

; The procedure for calculating the AIA temperature responses 
; using the latest version of CHIANTI atomic database is adopted from
; the following paper - for IDL code check appendix
; SDO AIA and Hinode EIS observations of "warm" loops
; Del Zanna et al. 2011 - https://ui.adsabs.harvard.edu/abs/2011A%26A...535A..46D/abstract

;***************************************************************

if keyword_set(chianti_aia_temp_resp_calc) then begin

print,'************************************************************************************'
print, 'Calculating AIA Temperature responses using CHIANTI routine - ISOTHERMAL.pro
print,'************************************************************************************'

; First, we need to define an array of temperatures:

temp = 10.d^(indgen(81)*0.05+4.0)

; IDL> print,alog10(temp)
;       4.0000000       4.0500002       4.0999999       4.1500001       4.1999998
;       4.2500000       4.3000002       4.3499999       4.4000001       4.4499998
;       4.5000000       4.5500002       4.5999999       4.6500001       4.6999998
;       4.7500000       4.8000002       4.8499999       4.9000001       4.9499998
;       5.0000000       5.0500002       5.0999999       5.1500001       5.1999998
;       5.2500000       5.3000002       5.3499999       5.4000001       5.4499998
;       5.5000000       5.5500002       5.5999999       5.6500001       5.6999998
;       5.7500000       5.8000002       5.8499999       5.9000001       5.9499998
;       6.0000000       6.0500002       6.1000004       6.1500001       6.1999998
;       6.2500000       6.3000002       6.3500004       6.4000001       6.4499998
;       6.5000000       6.5500002       6.6000004       6.6500001       6.6999998
;       6.7500000       6.8000002       6.8500004       6.9000001       6.9499998
;       7.0000000       7.0500002       7.1000004       7.1500001       7.1999998
;       7.2500000       7.3000002       7.3500004       7.4000001       7.4499998
;       7.5000000       7.5500002       7.6000004       7.6500001       7.6999998
;       7.7500000       7.8000002       7.8500004       7.9000001       7.9499998
;       8.0000000
;************************************************************************************

; We calculate a spectrum using the CHIANTI routine 'isothermal.pro'.
; https://hesperia.gsfc.nasa.gov/ssw/packages/chianti/idl/synt_spec/isothermal.pro

; The example below is with constant density
; (edensity = use density of your choice should be in the format like 1.e11),
; including all the lines (/all),

; the continuum (/cont), over a wavelength range of 1--1000 Angstrom, with a 0.1 Angstrom bin

; your choice of elemental abundance
; (abund_name=) and ion (ioneq_name=) .

; GUI will pop-up during this procedure, 
; you need to choose your 'abundance file' - e.g. the coronal abundance of 2021
; this procedure takes a couple of minutes/hours to run depending on the wavelgth range
; please check the CHIANTI version before running - it should be the latest version 
; If you are using CHIANTI version 11 then you need IDL version 8.4 
; as some of the latest CHIANTI routines only runs in this IDL version.


density = edensity

chianti_version = ch_get_version()
print, 'CHIANTI version used for ISOTHERMAL procedure = ', chianti_version

ch_version = strmid(chianti_version,0,2) + strmid(chianti_version,3,1) + strmid(chianti_version,5,1)

isothermal, 1, 1000, 0.1, temp, lambda, spectrum, list_wvl, list_ident, edensity = edensity, /photons, /cont

; Abundance = ABUND_NAME

save, filename = dir_save + 'isothermal_spectrum_' + 'ch_' + ch_version +'.save', temp, lambda, spectrum, density, date, chianti_version ; Abundance, 

;*********************************************
; RESTORE THE ISOTHERMAL SPECTRUM
;;********************************************

;restore, dir_save + 'isothermal_spectrum_' + 'ch_' + ch_version +'.save',/v

restore,dir_save + 'isothermal_spectrum_ch_1102.save',/v

;**********************************************************************************
; AIA EFFECTIVE AREA AND TEMPERATURE RESPONSES ARE CALCULATED 'PER AIA PIXEL'
;**********************************************************************************

print,'************************************************************************************'
print,'AIA EFFECTIVE AREA AND TEMPERATURE RESPONSES ARE CALCULATED PER AIA PIXEL'
print,'************************************************************************************'

; To obtain the wavelength response functions:
; https://hesperia.gsfc.nasa.gov/ssw/sdo/aia/idl/response/aia_get_response.pro

ssw_aia_wave_resp = aia_get_response(/dn, timedepend_date = obs_date)
; '/DN' will give you temperature responses and effective areas
; It calculates the responses in 'cm^2 DN phot^-1'

print, 'dn - (AREA and TEMP ONLY) if set, the response function includes the photon-to-DN units conversion '

help, ssw_aia_wave_resp, /str

;   NAME            STRING    'AIA'
;   VERSION         INT             10
;   DATE            STRING    '20151016_000000'
;   CHANNELS        STRING    Array[7]
;   WAVE            FLOAT     Array[8751]
;   ALL             DOUBLE    Array[7, 8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'
;   A94             STRUCT    -> <Anonymous> Array[1]
;   A131            STRUCT    -> <Anonymous> Array[1]
;   A171            STRUCT    -> <Anonymous> Array[1]
;   A193            STRUCT    -> <Anonymous> Array[1]
;   A211            STRUCT    -> <Anonymous> Array[1]
;   A304            STRUCT    -> <Anonymous> Array[1]
;   A335            STRUCT    -> <Anonymous> Array[1]
;   CORRECTIONS     STRUCT    -> <Anonymous> Array[1]

;IDL> help, ssw_aia_wave_resp.A94
;** Structure <33d60f8>, 5 tags, length=105056, data length=105048, refs=2:
;   NAME            STRING    'A94'
;   WAVE            FLOAT     Array[8751]
;   EA              DOUBLE    Array[8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'

;IDL> help, ssw_aia_wave_resp.CORRECTIONS
;** Structure <1bd4c98>, 5 tags, length=1352, data length=1352, refs=2:
;   TIME            STRUCT    -> <Anonymous> Array[1]
;   TIME_APPLIED    STRING    'YES'
;   EVENORM         STRUCT    -> <Anonymous> Array[1]
;   EVENORM_APPLIED STRING    'NO'
;   INFO            STRING    Array[6]


;IDL> print, aia_wave_resp.CORRECTIONS.INFO
; TIME: Sub-structure describing how the time-dependent response correction for each channel is calculated
; TIME_APPLIED: Does the response function use the time-dependent correction?
; EVENORM: Sub-structure giving the normalization constant used to ensure agreement with EVE observations
; EVENORM_APPLIED: Does the response function use the EVE-derived normalization constant?  

;******************************************************************************
; For more details on not using the evenorm and chiantifix keywords
; check section 3 of the following paper - Del Zanna et al. 2013, A&A 558, A73
; link: https://ui.adsabs.harvard.edu/abs/2013A%26A...558A..73D/abstract
;******************************************************************************

help, ssw_aia_wave_resp.a171, /str

; ** Structure <ee5df8>, 5 tags, length=70048, data length=70044, refs=2:
;   NAME            STRING    'A171'
;   WAVE            FLOAT     Array[8751]
;   EA              FLOAT     Array[8751]
;   PLATESCALE      FLOAT       8.46158e-12
;   UNITS           STRING    'cm^2 DN phot^-1'

print, ssw_aia_wave_resp.date

date = ssw_aia_wave_resp.date

; saving wavelength responses
save, filename = dir_save + 'ssw_aia_wavelength_resp.save', ssw_aia_wave_resp, date

;*********************************************

; This is the conversion factor for an AIA pixel

print, ssw_aia_wave_resp.a171.PLATESCALE
;   8.46158e-12

; (number of steradians per AIA pixel size):
; caluculate the pixel in steradian 
; The AIA resolution is = 1.2 arcsec and plate scale is = 0.6 arcsec
; arcsec per degree = 3600
; sterad_xrt_pix = (pi / (180.0 * 3600.0)) ^2.0 * the resolution of instrument 
; sterad_xrt_pix = (!PI/ 648000.)^2.0 = 2.35044e-11

; 1 AIA pixel is = 0.6
; sterad_xrt_pix = 2.35044e-11 * (0.6 * 0.6)

; print,sterad_xrt_pix = 8.46158e-12 - 
; this is same as the one obtianed from ssw_aia_wave_resp.a171.PLATESCALE

sterad_aia_pix = 8.46158e-12 ;  UNITS           STRING    'cm^2 DN phot^-1'

;*********************************************
; regrid the AIA effective areas onto the
; wavelength grid with e.g. interpol:
;*********************************************

print, 'regrid the AIA effective areas onto the wavelength grid with e.g. interpol:'

;****************
; AIA 94 channel
;****************

chianti_aia_94_ea = interpol(ssw_aia_wave_resp.a94.ea, ssw_aia_wave_resp.a94.wave, lambda)

; fold the isothermal spectra with the
; effective areas:

sp_conv = spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_94_ea

; total over the wavelengths:
chianti_aia_94_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_94_temp_resp) ; dividing by factor of 0.36 - making it to responses to per EIS pixels 
c = [a,b]

openw,1,'chianti_aia_94_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_94_ea) 
f = [d,e]

openw,1,'aia_eff_94.area'
printf,1, f
close,1

;*****************
; AIA 131 channel
;*****************

chianti_aia_131_ea = interpol(ssw_aia_wave_resp.a131.ea, ssw_aia_wave_resp.a131.wave, lambda)

; fold the isothermal spectra with the
; effective areas:

sp_conV= spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_131_ea

; total over the wavelengths:
chianti_aia_131_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_131_temp_resp)
c = [a,b]

openw,1,'chianti_aia_131_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_131_ea) 
f = [d,e]

openw,1,'aia_eff_131.area'
printf,1, f
close,1

;*****************
; AIA 171 channel
;*****************

chianti_aia_171_ea = interpol(ssw_aia_wave_resp.a171.ea, ssw_aia_wave_resp.a171.wave, lambda)

; fold the isothermal spectra with the
; effective areas:

sp_conv= spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_171_ea

; total over the wavelengths:
chianti_aia_171_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_171_temp_resp)
c = [a,b]

openw,1,'chianti_aia_171_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_171_ea) 
f = [d,e]

openw,1,'aia_eff_171.area'
printf,1, f
close,1

;*****************
; AIA 193 channel
;*****************

chianti_aia_193_ea = interpol(ssw_aia_wave_resp.a193.ea, ssw_aia_wave_resp.a193.wave, lambda)

; fold the isothermal spectra with the
; effective areas:
sp_conv = spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_193_ea

; total over the wavelengths:
chianti_aia_193_temp_resp = total(sp_conv,1)


a = transpose(alog10(temp))
b = transpose(chianti_aia_193_temp_resp)
c = [a,b]

openw,1,'chianti_aia_193_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_193_ea) 
f = [d,e]

openw,1,'aia_eff_193.area'
printf,1, f
close,1

;*****************
; AIA 211 channel
;*****************

chianti_aia_211_ea = interpol(ssw_aia_wave_resp.a211.ea, ssw_aia_wave_resp.a211.wave,lambda)

; fold the isothermal spectra with the
; effective areas:
sp_conv= spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_211_ea

; total over the wavelengths:
chianti_aia_211_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_211_temp_resp)
c = [a,b]

openw,1,'chianti_aia_211_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_211_ea) 
f = [d,e]

openw,1,'aia_eff_211.area'
printf,1, f
close,1

;*****************
; AIA 304 channel
;*****************

chianti_aia_304_ea = interpol(ssw_aia_wave_resp.a304.ea, ssw_aia_wave_resp.a304.wave, lambda)

; fold the isothermal spectra with the
; effective areas:

sp_conv = spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_304_ea

; total over the wavelengths:
chianti_aia_304_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_304_temp_resp)
c = [a,b]

openw,1,'chianti_aia_304_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_304_ea) 
f = [d,e]

openw,1,'aia_eff_304.area'
printf,1, f
close,1

;*****************
; AIA 335 channel
;*****************

chianti_aia_335_ea = interpol(ssw_aia_wave_resp.a335.ea, ssw_aia_wave_resp.a335.wave,lambda)

; fold the isothermal spectra with the
; effective areas:

sp_conv = spectrum & sp_conv[*,*] = 0.
for i = 0, n_elements(temp)-1 do $
sp_conv[*, i] = sterad_aia_pix*spectrum[*,i]*chianti_aia_335_ea

; total over the wavelengths:
chianti_aia_335_temp_resp = total(sp_conv,1)

a = transpose(alog10(temp))
b = transpose(chianti_aia_335_temp_resp)
c = [a,b]

openw,1,'chianti_aia_335_temp_resp.resp'
printf,1, c
close,1

d = transpose(lambda)
e = transpose(chianti_aia_335_ea) 
f = [d,e]

openw,1,'aia_eff_335.area'
printf,1, f
close,1

;**********************************************
; saving the new effective area temperature responses

save, filename = dir_save + 'chianti_aia_eff_area_temp_resp.save', obs_date, lambda, chianti_aia_94_ea, chianti_aia_131_ea, chianti_aia_171_ea, chianti_aia_193_ea, chianti_aia_211_ea, chianti_aia_304_ea, chianti_aia_335_ea, temp, chianti_aia_94_temp_resp, chianti_aia_131_temp_resp, chianti_aia_171_temp_resp, chianti_aia_193_temp_resp, chianti_aia_211_temp_resp, chianti_aia_304_temp_resp, chianti_aia_335_temp_resp, obs_date


endif 

;-----------------------------------------------------------------

;***********************************************************************************
; Plotting AIA temperature responses calculated using CHIANTI - ISOTHERMAL PROCEDURE
;***********************************************************************************

print,'************************************************************************************'
print,'Plotting AIA temperature responses calculated using CHIANTI - ISOTHERMAL PROCEDURE'
print,'************************************************************************************'

if keyword_set(plot_chianti_aia_temp_resp) then begin

restore, dir_save + 'chianti_aia_eff_area_temp_resp.save', /v

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'plot_chianti_aia_temp_resp.eps', bits = 24

!p.font=1
!p.multi=0

; AIA 94
plot,alog10(temp),chianti_aia_94_temp_resp,/yl,xr=[4.5,8.0],title='CHIANTI - AIA temperature responses ' + obs_date,yr=[1d-29,7d-25], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color=0, thick=4, xstyle=1

cgoplot, alog10(temp), chianti_aia_94_temp_resp, charsize=1.4, background=255, color='black', thick=4

; AIA 131
cgoplot, alog10(temp), chianti_aia_131_temp_resp, charsize=1.4, background=255, color='orange', thick=4

; AIA 171
cgoplot, alog10(temp), chianti_aia_171_temp_resp, charsize=1.4, background=255, color='green', thick=4

; AIA 193
cgoplot, alog10(temp), chianti_aia_193_temp_resp, charsize=1.4, background=255, color='blue', thick=4

; AIA 211
cgoplot, alog10(temp), chianti_aia_211_temp_resp, charsize=1.4, background=255, color='magenta', thick=4

; AIA 304
cgoplot, alog10(temp), chianti_aia_304_temp_resp, charsize=1.4, background=255, color='purple', thick=4

; AIA 335
cgoplot, alog10(temp), chianti_aia_335_temp_resp, charsize=1.4, background=255, color='red', thick=4

al_legend, ['94 !3' + STRING(197B) + '!X','131 !3' + STRING(197B) + '!X','171 !3' + STRING(197B) + '!X','193 !3' + STRING(197B) + '!X', '211 !3' + STRING(197B) + '!X','304 !3' + STRING(197B) + '!X','335 !3' + STRING(197B) + '!X'], color = ['black', 'orange', 'green', 'blue', 'magenta','purple', 'red'], textcolors = ['black', 'orange', 'green', 'blue', 'magenta','purple', 'red'], linestyle = 0, thick = 4, /top, /right, charsize=1.2

device, /close
set_plot, 'x'

endif

;*****************************************************


print,'************************************************************************************'
print,'Plotting AIA temperature responses calculated using CHIANTI - ISOTHERMAL PROCEDURE'
print,'************************************************************************************'

if keyword_set(plot_compare_temp_resp_ssw_chianti) then begin

restore, dir_save + 'chianti_aia_eff_area_temp_resp.save', /v
restore, dir_save + 'ssw_aia_temp_wavelength_resp.save', /v

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'plot_compare_temp_resp_ssw_chianti.eps', bits = 24

!p.font=1
!p.multi=0

; AIA 94
plot,alog10(temp),chianti_aia_94_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color=0, thick=4, xstyle=1, linestyle = 0

cgoplot, alog10(temp), chianti_aia_94_temp_resp, charsize=1.4, background=255, color='black', thick=4
cgoplot, ssw_aia_temp_resp.A94.LOGTE, ssw_aia_temp_resp.A94.TRESP, linestyle = 2, color='black', thick=4

al_legend, ['CHIANTI - AIA 94 !3' + STRING(197B) + '!X','SSW - AIA 94 !3' + STRING(197B) + '!X'], color = ['black', 'black'], textcolors = ['black', 'black'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 131
plot, alog10(temp), chianti_aia_131_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4, linestyle = 0
cgoplot, alog10(temp), chianti_aia_131_temp_resp, charsize=1.4, background=255, color='orange', thick=4
cgoplot, ssw_aia_temp_resp.A131.LOGTE, ssw_aia_temp_resp.A131.TRESP, linestyle = 2, color='orange', thick=4

al_legend, ['CHIANTI - AIA 131 !3' + STRING(197B) + '!X','SSW - AIA 131 !3' + STRING(197B) + '!X'], color = ['orange', 'orange'], textcolors = ['orange', 'orange'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 171
plot, alog10(temp), chianti_aia_171_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4, linestyle = 0
cgoplot, alog10(temp), chianti_aia_171_temp_resp, charsize=1.4, background=255, color='green', thick=4
cgoplot, ssw_aia_temp_resp.A171.LOGTE, ssw_aia_temp_resp.A171.TRESP, linestyle = 2, color='green', thick=4

al_legend, ['CHIANTI - AIA 171 !3' + STRING(197B) + '!X','SSW - AIA 171 !3' + STRING(197B) + '!X'], color = ['green', 'green'], textcolors = ['green', 'green'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 193
plot, alog10(temp), chianti_aia_193_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4, linestyle = 0
cgoplot, alog10(temp), chianti_aia_193_temp_resp, charsize=1.4, background=255, color='blue', thick=4
cgoplot, ssw_aia_temp_resp.A193.LOGTE, ssw_aia_temp_resp.A193.TRESP, linestyle = 2, color='blue', thick=4

al_legend, ['CHIANTI - AIA 193 !3' + STRING(197B) + '!X','SSW - AIA 193 !3' + STRING(197B) + '!X'], color = ['blue', 'blue'], textcolors = ['blue', 'blue'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 211
plot, alog10(temp), chianti_aia_211_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4
cgoplot, alog10(temp), chianti_aia_211_temp_resp, charsize=1.4, background=255, color='magenta', thick=4
cgoplot, ssw_aia_temp_resp.A211.LOGTE, ssw_aia_temp_resp.A211.TRESP, linestyle = 2, color='magenta', thick=4

al_legend, ['CHIANTI - AIA 211 !3' + STRING(197B) + '!X','SSW - AIA 211 !3' + STRING(197B) + '!X'], color = ['magenta', 'magenta'], textcolors = ['magenta', 'magenta'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 304
plot, alog10(temp), chianti_aia_304_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4, linestyle = 0
cgoplot, alog10(temp), chianti_aia_304_temp_resp, charsize=1.4, background=255, color='purple', thick=4
cgoplot, ssw_aia_temp_resp.A304.LOGTE, ssw_aia_temp_resp.A304.TRESP, linestyle = 2, color='purple', thick=4

al_legend, ['CHIANTI - AIA 304 !3' + STRING(197B) + '!X','SSW - AIA 304 !3' + STRING(197B) + '!X'], color = ['purple', 'purple'], textcolors = ['purple', 'purple'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

; AIA 335
plot, alog10(temp), chianti_aia_335_temp_resp,/yl,xr=[4.5,8.0],title =  obs_date + ' AIA temperature response',yr=[1d-29,7d-24], ystyle=1, xtitle='log T [K]', ytitle='log DN s!E-1!N pixel!E-1!N cm!E+5', charsize=1.4, background=255, color='black', thick=4, linestyle = 0
cgoplot, alog10(temp), chianti_aia_335_temp_resp, charsize=1.4, background=255, color='red', thick=4
cgoplot, ssw_aia_temp_resp.A335.LOGTE, ssw_aia_temp_resp.A335.TRESP, linestyle = 2, color='red', thick=4

al_legend, ['CHIANTI - AIA 335 !3' + STRING(197B) + '!X','SSW - AIA 335 !3' + STRING(197B) + '!X'], color = ['red', 'red'], textcolors = ['red', 'red'], linestyle = [0,2], thick = 4, /top, /right, charsize=1.2

device, /close
set_plot, 'x'

endif

;*****************************************************


;*******************************************************************************
; PLOTTING RATIO - 94 and 131
;*******************************************************************************

if keyword_set(plot_ratio_94_131) then begin

restore, dir_save + 'chianti_aia_eff_area_temp_resp.save', /v

set_plot,'ps'
device, /encaps, /color, filename = dir_save + 'paper_aia_temp_resp_ratio_94_131.eps', bits = 24

!p.font = 1
!p.multi = 0

;---------------------
; AIA 94
;---------------------

plot, alog10(temp), chianti_aia_94_temp_resp, /yl, xr = [5.0,7.5], title = obs_date + ' AIA 94, 131 !3' + STRING(197B) + '!X temperature responses', yr = [2d-31,7d-26], ystyle = 1, xtitle = 'log T [K]', ytitle = 'log DN s!E-1!N pixel!E-1!N cm!E+5', thick = 4, charsize = 1.2

cgoplot, alog10(temp), chianti_aia_94_temp_resp, color = 'blue', thick = 4

cgoplot, alog10(temp), chianti_aia_131_temp_resp, color = 'magenta', thick = 4

al_legend, ['131 !3' + STRING(197B) + '!X','94 !3' + STRING(197B) + '!X'], colors = ['magenta','blue'], textcolors = 0, lineSTYLE = [0,0], thick = 4, charsize = 1.2, /right, /top

;---------------------
; AIA 131
;---------------------

plot, alog10(temp), chianti_aia_94_temp_resp/chianti_aia_131_temp_resp, /yl,xr = [5.0,7.5], title = obs_date + ' AIA 94 and 131 temperature response ratio ', ystyle = 1, xtitle = 'log T (K)', ytitle = ' ', thick = 4, charsize = 1.2

cgoplot, alog10(temp), chianti_aia_94_temp_resp/chianti_aia_131_temp_resp, color = 'red', thick = 4

device, /close
set_plot, 'x'

endif

;*****************************************************

end
