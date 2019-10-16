!> \file set_soilveg.f

!> This module contains set_soilveg subroutine.
      module set_soilveg_mod

      implicit none

      private

      public set_soilveg

      contains

!> \ingroup Noah_LSM
!! This subroutine initializes soil and vegetation.
      subroutine set_soilveg(me,isot,ivet,nlunit)
      use namelist_soilveg
      implicit none

      integer, intent(in) :: me,isot,ivet,nlunit
!my begin locals
!for 20 igbp veg type and 19 stasgo soil type
      integer i
      REAL WLTSMC1,REFSMC1
! ----------------------------------------------------------------------
! SET TWO SOIL MOISTURE WILT, SOIL MOISTURE REFERENCE PARAMETERS
! ----------------------------------------------------------------------
      REAL SMLOW
      REAL SMLOW_DATA
      DATA SMLOW_DATA /0.5/

      REAL SMHIGH
      REAL SMHIGH_DATA
!     changed in 2.6 from 3 to 6 on June 2nd 2003
!      DATA SMHIGH_DATA /3.0/
      DATA SMHIGH_DATA /6.0/
      NAMELIST /SOIL_VEG/ SLOPE_DATA, RSMTBL, RGLTBL, HSTBL, SNUPX,
     &  BB, DRYSMC, F11, MAXSMC, REFSMC, SATPSI, SATDK, SATDW,
     &  WLTSMC, QTZ, LPARAM, ZBOT_DATA, SALP_DATA, CFACTR_DATA,
     &  CMCMAX_DATA, SBETA_DATA, RSMAX_DATA, TOPT_DATA,
     &  REFDK_DATA, FRZK_DATA, BARE, DEFINED_VEG, DEFINED_SOIL,
     &  DEFINED_SLOPE, FXEXP_DATA, NROOT_DATA, REFKDT_DATA, Z0_DATA,
     &  CZIL_DATA, LAI_DATA, CSOIL_DATA

cmy end locals
      if(ivet.eq.2) then

!using umd veg table
      slope_data =(/0.1,  0.6, 1.0, 0.35, 0.55, 0.8,
     &  	       0.63, 0.0, 0.0, 0.0,  0.0,  0.0,
     &  	       0.0 , 0.0, 0.0, 0.0,  0.0,  0.0,
     &  	       0.0 , 0.0, 0.0, 0.0,  0.0,  0.0,
     &  	       0.0 , 0.0, 0.0, 0.0,  0.0,  0.0/)
      rsmtbl =(/300.0, 175.0, 175.0, 300.0, 300.0, 70.0,
     &              20.0, 225.0, 225.0, 225.0, 400.0, 20.0,
     &  	   150.0,   0.0,   0.0,   0.0,   0.0,  0.0,
     &  	     0.0,   0.0,   0.0,   0.0,   0.0,  0.0,
     &  	     0.0,   0.0,   0.0,   0.0,   0.0,  0.0/)
c-----------------------------
      rgltbl =(/30.0,  30.0,  30.0,  30.0,  30.0,  65.0,
     &  	  100.0, 100.0, 100.0, 100.0, 100.0, 100.0,
     &  	  100.0,   0.0,   0.0,   0.0,	0.0,   0.0,
     &  	    0.0,   0.0,   0.0,   0.0,	0.0,   0.0,
     &  	    0.0,   0.0,   0.0,   0.0,	0.0,   0.0/)
      hstbl =(/41.69, 54.53, 51.93, 47.35,  47.35, 54.53,
     &  	  36.35, 42.00, 42.00, 42.00,  42.00, 36.35,
     &  	  42.00,  0.00,  0.00,  0.00,	0.00,  0.00,
     &  	   0.00,  0.00,  0.00,  0.00,	0.00,  0.00,
     &  	   0.00,  0.00,  0.00,  0.00,	0.00,  0.00/)
!     changed for version 2.6 on june 2nd 2003
!      data snupx  /0.080, 0.080, 0.080, 0.080, 0.080, 0.080,
!     &  	   0.040, 0.040, 0.040, 0.040, 0.025, 0.040,
!     &  	   0.025, 0.000, 0.000, 0.000, 0.000, 0.000,
      snupx  =(/0.040, 0.040, 0.040, 0.040, 0.040, 0.040,
     *             0.020, 0.020, 0.020, 0.020, 0.013, 0.020,
     *             0.013, 0.000, 0.000, 0.000, 0.000, 0.000,
     &  	   0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &  	   0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
 
      bare =11

c---------------------------------------------------------------------
! number of defined veg used.
! ----------------------------------------------------------------------
      defined_veg=13
      nroot_data =(/4,4,4,4,4,4,3,3,3,2,3,3,2,0,0,
     &                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/)
! ----------------------------------------------------------------------
! vegetation class-related arrays
! ----------------------------------------------------------------------
      z0_data =(/2.653, 0.826, 0.563, 1.089, 0.854, 0.856,
     &              0.035, 0.238, 0.065, 0.076, 0.011, 0.125,
     &              0.011, 0.000, 0.000, 0.000, 0.000, 0.000,
     &              0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &              0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
clu: change to 3 or 2   oct 15, 2004
      lai_data =(/3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
     &               3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
     &               3.0, 0.0, 0.0, 0.0, 0.0, 0.0,
     &               0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
     &               0.0, 0.0, 0.0, 0.0, 0.0, 0.0/)
! use igbp table
      elseif(ivet.eq.1)then

      SLOPE_DATA =(/1.0,  1.0, 1.0, 1.0, 1.0, 1.0,
     &                 1.0, 1.0, 1.0, 1.0,  1.0,  1.0,
     &                 1.0 , 1.0, 1.0, 1.0,  1.0,  1.0,
     &                 1.0 , 1.0, 0.0, 0.0,  0.0,  0.0,
     &                 0.0 , 0.0, 0.0, 0.0,  0.0,  0.0/)
      RSMTBL =(/300.0, 300.0, 70.0, 175.0, 175.0, 70.0,
     &              70.0, 70.0, 70.0, 20.0, 40.0, 20.0,
     &             400.0, 35.0, 200.0, 70.0, 100.0, 70.0,
     &             150.0, 200.0, 0.0, 0.0,0.0, 0.0,
     &              0.0, 0.0, 0.0,   0.0,   0.0,  0.0/)
c-----------------------------
      RGLTBL =(/30.0,  30.0,  30.0,  30.0,  30.0,  100.0,
     &            100.0, 65.0, 65.0, 100.0, 100.0, 100.0,
     &            100.0, 100.0, 100.0,100.0,30.0, 100.0,
     &            100.0, 100.0, 0.0,0.0,0.0,0.0,
     &            0.0, 0.0, 0.0,  0.0,  0.0,  0.0/)
      HSTBL =(/47.35, 41.69, 47.35, 54.53, 51.93, 42.00,
     &           42.00, 42.00, 42.00, 36.35, 60.00, 36.25,
     &           42.00, 36.25, 42.00, 42.00, 51.75, 42.00,
     &           42.00, 42.00, 0.00, 0.00, 0.00, 0.00,
     &           0.00, 0.00, 0.00,  0.00,  0.00,  0.00/)
      SNUPX  =(/0.080, 0.080, 0.080, 0.080, 0.080, 0.020,
     *             0.020, 0.060, 0.040, 0.020, 0.010, 0.020,
     *             0.020, 0.020, 0.013, 0.013, 0.010, 0.020,
     &             0.020, 0.020, 0.000, 0.000, 0.000, 0.000,
     &             0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)

      bare =16

!---------------------------------------------------------------------
! number of defined veg used.
! ----------------------------------------------------------------------
      defined_veg=20

      NROOT_DATA =(/4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 1, 3, 2,
     &              3, 1, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/)
!    &              3, 0, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/)   ! Moorthi
! ----------------------------------------------------------------------
! VEGETATION CLASS-RELATED ARRAYS
! ----------------------------------------------------------------------
      Z0_DATA =(/1.089, 2.653, 0.854, 0.826, 0.80, 0.05,
     &              0.03, 0.856, 0.856, 0.15, 0.04, 0.13,
     &              1.00, 0.25, 0.011, 0.011, 0.001, 0.076,
     &              0.05, 0.03, 0.000, 0.000, 0.000, 0.000,
     &              0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)

      lai_data =(/3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
     &               3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
     &               3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
     &               3.0, 3.0, 0.0, 0.0, 0.0, 0.0,
     &               0.0, 0.0, 0.0, 0.0, 0.0, 0.0/)

!  end if veg table
      endif

      if(isot.eq.0) then

      bb         =(/4.26,  8.72, 11.55, 4.74, 10.73,  8.17,
     &            6.77,  5.25,  4.26, 0.00,  0.00,  0.00,
     &            0.00,  0.00,  0.00, 0.00,  0.00,  0.00,
     &            0.00,  0.00,  0.00, 0.00,  0.00,  0.00,
     &            0.00,  0.00,  0.00, 0.00,  0.00,  0.00/)
! !!!!!!!!!!!!!! the following values in the table are not used
! !!!!!!!!!!!!!! and are just given for reference
      drysmc=(/0.029, 0.119, 0.139, 0.047, 0.100, 0.103,
     &            0.069, 0.066, 0.029, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! !!!!!!!!!!!!!! the following values in the table are not used
! !!!!!!!!!!!!!! and are just given for reference
      f11  =(/-0.999, -1.116, -2.137, -0.572, -3.201, -1.302,
     &           -1.519, -0.329, -0.999,  0.000,  0.000,  0.000,
     &            0.000,  0.000,  0.000,  0.000,  0.000,  0.000,
     &            0.000,  0.000,  0.000,  0.000,  0.000,  0.000,
     &            0.000,  0.000,  0.000,  0.000,  0.000,  0.000/)
      maxsmc=(/0.421, 0.464, 0.468, 0.434, 0.406, 0.465,
     &            0.404, 0.439, 0.421, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
!
! ----------------------------------------------------------------------
! the following 5 parameters are derived later in redprm.f from the soil
! data, and are just given here for reference and to force static
! storage allocation. -dag lohmann, feb. 2001
! ----------------------------------------------------------------------
!      data refsmc/0.283, 0.387, 0.412, 0.312, 0.338, 0.382,
!     &           0.315, 0.329, 0.283, 0.000, 0.000, 0.000,
! !!!!!!!!!!!!!! the following values in the table are not used
! !!!!!!!!!!!!!! and are just given for reference
      refsmc=(/0.248, 0.368, 0.398, 0.281, 0.321, 0.361,
     &            0.293, 0.301, 0.248, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! ----------------------------------------------------------------------
! soil texture-related arrays.
! ----------------------------------------------------------------------
      satpsi=(/0.04, 0.62, 0.47, 0.14, 0.10, 0.26,
     &            0.14, 0.36, 0.04, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00/)
      satdk =(/1.41e-5, 0.20e-5, 0.10e-5, 0.52e-5, 0.72e-5,
     &            0.25e-5, 0.45e-5, 0.34e-5, 1.41e-5, 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00/)
      qtz   =(/0.82, 0.10, 0.25, 0.60, 0.52, 0.35,
     &            0.60, 0.40, 0.82, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00/)

! !!!!!!!!!!!!!! the following values in the table are not used
! !!!!!!!!!!!!!! and are just given for reference
      wltsmc=(/0.029, 0.119, 0.139, 0.047, 0.100, 0.103,
     &            0.069, 0.066, 0.029, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! !!!!!!!!!!!!!! the following values in the table are not used
! !!!!!!!!!!!!!! and are just given for reference
      satdw =(/5.71e-6, 2.33e-5, 1.16e-5, 7.95e-6, 1.90e-5,
     &            1.14e-5, 1.06e-5, 1.46e-5, 5.71e-6, 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00/)

! ----------------------------------------------------------------------
! number of defined soiltyps used.
! ----------------------------------------------------------------------

      defined_soil=9

      else

! using stasgo table
      BB         =(/4.05,  4.26, 4.74, 5.33, 5.33,  5.25,
     &            6.77,  8.72,  8.17, 10.73, 10.39,  11.55,
     &            5.25,  4.26,  4.05, 4.26,  11.55,  4.05,
     &            4.05,  0.00,  0.00, 0.00,  0.00,  0.00,
     &            0.00,  0.00,  0.00, 0.00,  0.00,  0.00/)
! !!!!!!!!!!!!!! The following values in the table are NOT used
! !!!!!!!!!!!!!! and are just given for reference
!     DRYSMC=(/0.023, 0.028, 0.047, 0.084, 0.084, 0.066,
!    &            0.069, 0.120, 0.103, 0.100, 0.126, 0.135,
!    &            0.069, 0.028, 0.012, 0.028, 0.135, 0.012,
!    &            0.023, 0.000, 0.000, 0.000, 0.000, 0.000,
!    &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
      DRYSMC=(/0.010, 0.025, 0.010, 0.010, 0.010, 0.010,
     &            0.010, 0.010, 0.010, 0.010, 0.010, 0.010,
     &            0.010, 0.010, 0.010, 0.010, 0.010, 0.010,
     &            0.010, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! !!!!!!!!!!!!!! The following values in the table are NOT used
! !!!!!!!!!!!!!! and are just given for reference
      F11  =(/-1.090, -1.041, -0.568, 0.162, 0.162, -0.327,
     &           -1.535, -1.118, -1.297, -3.211,  -1.916, -2.258,
     &           -0.201, -1.041, -2.287, -1.041,  -2.258, -2.287,
     &           -1.090,  0.000,  0.000,  0.000,  0.000,  0.000,
     &            0.000,  0.000,  0.000,  0.000,  0.000,  0.000/)
      MAXSMC=(/0.395, 0.421, 0.434, 0.476, 0.476, 0.439,
     &            0.404, 0.464, 0.465, 0.406, 0.468, 0.457,
     &            0.464, 0.421, 0.200, 0.421, 0.457, 0.200,
     &            0.395, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
!
! ----------------------------------------------------------------------
! THE FOLLOWING 5 PARAMETERS ARE DERIVED LATER IN REDPRM.F FROM THE SOIL
! DATA, AND ARE JUST GIVEN HERE FOR REFERENCE AND TO FORCE STATIC
! STORAGE ALLOCATION. -DAG LOHMANN, FEB. 2001
! ----------------------------------------------------------------------
!      DATA REFSMC/0.283, 0.387, 0.412, 0.312, 0.338, 0.382,
!     &           0.315, 0.329, 0.283, 0.000, 0.000, 0.000,
! !!!!!!!!!!!!!! The following values in the table are NOT used
! !!!!!!!!!!!!!! and are just given for reference
      REFSMC=(/0.236, 0.283, 0.312, 0.360, 0.360, 0.329,
     &            0.315, 0.387, 0.382, 0.338, 0.404, 0.403,
     &            0.348, 0.283, 0.133, 0.283, 0.403, 0.133,
     &            0.236, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! ----------------------------------------------------------------------
! SOIL TEXTURE-RELATED ARRAYS.
! ----------------------------------------------------------------------
      SATPSI=(/0.035, 0.0363, 0.1413, 0.7586, 0.7586, 0.3548,
     &            0.1349, 0.6166, 0.2630, 0.0977, 0.3236, 0.4677,
     &            0.3548, 0.0363, 0.0350, 0.0363, 0.4677, 0.0350,
     &            0.0350, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00/)
      SATDK =(/1.76e-4, 1.4078e-5, 5.2304e-6, 2.8089e-6, 2.8089e-6,
     &            3.377e-6, 4.4518e-6, 2.0348e-6, 2.4464e-6, 7.2199e-6,
     &           1.3444e-6, 9.7394e-7, 3.377e-6, 1.4078e-5, 1.4087e-05,
     &           1.4078e-5, 9.7394e-7, 1.4078e-5, 1.760e-4, 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00/)
!     QTZ   =(/0.92, 0.82, 0.60, 0.25, 0.10, 0.40,
      QTZ   =(/0.92, 0.82, 0.25, 0.15, 0.10, 0.20,
     &            0.60, 0.10, 0.35, 0.52, 0.10, 0.25,
     &            0.05, 0.25, 0.07, 0.25, 0.60, 0.52,
     &            0.92, 0.00, 0.00, 0.00, 0.00, 0.00,
     &            0.00, 0.00, 0.00, 0.00, 0.00, 0.00/)

! !!!!!!!!!!!!!! The following values in the table are NOT used
! !!!!!!!!!!!!!! and are just given for reference
      WLTSMC=(/0.023, 0.028, 0.047, 0.084, 0.084, 0.066,
     &            0.069, 0.120, 0.103, 0.100, 0.126, 0.135,
     &            0.069, 0.028, 0.012, 0.028, 0.135, 0.012,
     &            0.023, 0.000, 0.000, 0.000, 0.000, 0.000,
     &            0.000, 0.000, 0.000, 0.000, 0.000, 0.000/)
! !!!!!!!!!!!!!! The following values in the table are NOT used
! !!!!!!!!!!!!!! and are just given for reference
      SATDW =(/0.6316e-4, 0.5171e-5, 0.8072e-5, 0.2386e-4, 0.2386e-4,
     &            0.1433e-4, 0.1006e-4, 0.2358e-4, 0.1130e-4,0.1864e-04,
     &           0.9658e-05,0.1151e-04,0.1356e-04,0.5171e-05,0.9978e-05,
     &           0.5171e-05, 0.1151e-04, 0.9978e-05, 0.6316e-04, 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00,
     &            0.00   , 0.00   , 0.00   , 0.00   , 0.00/)
! ----------------------------------------------------------------------
! number of defined soiltyps used.
! ----------------------------------------------------------------------

      defined_soil=19
!   end if soil table
      endif


! the values shared by different veg/soil type data

! PT 5/18/2015 - changed to FALSE to match atm_namelist setting
! PT LPARAM is not used anywhere
!      LPARAM =.TRUE.
      LPARAM =.FALSE.

!     changed for version 2.5.2
!      data zbot_data /-3.0/
      zbot_data =-8.0
!     changed for version 2.6 june 2nd 2003
!      data salp_data /2.6/
      salp_data =4.0
      cfactr_data =0.5
      cmcmax_data =0.5e-3
      sbeta_data =-2.0
      rsmax_data =5000.0
      topt_data =298.0
      refdk_data =2.0e-6
      frzk_data =0.15

      defined_slope=9
      fxexp_data =2.0
      refkdt_data =3.0
!   changed in version 2.6 june 2nd 2003
!      data czil_data /0.2/
      czil_data =0.075

!      DATA CSOIL_DATA /1.26E+6/
      CSOIL_DATA = 2.00E+6
! ----------------------------------------------------------------------
! READ NAMELIST FILE TO OVERRIDE DEFAULT PARAMETERS ONLY ONCE.
! NAMELIST_NAME must be 50 characters or less.
! ----------------------------------------------------------------------
!lu: namelist is set up in run script
!PT         if (me == 0) write(0,*) 'read namelist cwsoilvegSOIL_VEG'
!$$$         READ(5, SOIL_VEG)
!PT         rewind(nlunit)
!PT         READ(nlunit, SOIL_VEG)

!*       WRITE(6, SOIL_VEG)
! 	 OPEN(58, FILE = 'namelist_filename.txt')
!         READ(58,'(A)') NAMELIST_NAME
!         CLOSE(58)
!         WRITE(0,*) 'Namelist Filename is ', NAMELIST_NAME
!         OPEN(59, FILE = NAMELIST_NAME)
! 50      CONTINUE
!         READ(59, SOIL_VEG, END=100)
!         IF (LPARAM) GOTO 50
! 100     CONTINUE
!         CLOSE(59)

         IF (DEFINED_SOIL .GT. MAX_SOILTYP) THEN
            WRITE(0,*) 'Warning: DEFINED_SOIL too large in namelist'
            STOP 222
         ENDIF
         IF (DEFINED_VEG .GT. MAX_VEGTYP) THEN
            WRITE(0,*) 'Warning: DEFINED_VEG too large in namelist'
            STOP 222
         ENDIF
         IF (DEFINED_SLOPE .GT. MAX_SLOPETYP) THEN
            WRITE(0,*) 'Warning: DEFINED_SLOPE too large in namelist'
            STOP 222
         ENDIF
         
         SMLOW  = SMLOW_DATA
         SMHIGH = SMHIGH_DATA
         
         DO I = 1,DEFINED_SOIL
           if (satdk(i) /= 0.0 .and. bb(i) > 0.0) then
           SATDW(I)  = BB(I)*SATDK(I)*(SATPSI(I)/MAXSMC(I))
             F11(I)    = LOG10(SATPSI(I)) + BB(I)*LOG10(MAXSMC(I)) + 2.0
           REFSMC1   = MAXSMC(I)*(5.79E-9/SATDK(I))
     &                  **(1.0/(2.0*BB(I)+3.0))
           REFSMC(I) = REFSMC1 + (MAXSMC(I)-REFSMC1) / SMHIGH
           WLTSMC1   = MAXSMC(I) * (200.0/SATPSI(I))**(-1.0/BB(I))
           WLTSMC(I) = WLTSMC1 - SMLOW * WLTSMC1
            
!     ----------------------------------------------------------------------
!     CURRENT VERSION DRYSMC VALUES THAT EQUATE TO WLTSMC.
!     FUTURE VERSION COULD LET DRYSMC BE INDEPENDENTLY SET VIA NAMELIST.
!     ----------------------------------------------------------------------
!          DRYSMC(I) = WLTSMC(I)
           endif
         END DO
         
!       if (me == 0) write(6,soil_veg)
       return
       end subroutine set_soilveg

       end module set_soilveg_mod
