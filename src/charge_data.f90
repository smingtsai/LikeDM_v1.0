
!############################################################################
!#
!# Note: A module generated by python script "Data2fortran.py" to deal with 
!#       multi-data-sets 
!#
!# Author: Yue-Lin Sming Tsai
!# Email: smingtsai@gmail.com
!# Date: 2015-6-12
!############################################################################


module charge_data
   use MathLib 

   implicit none

   !first col 2 for 2 types particles (e+ and pbar), 2nd col 2 for (En, flux), 100 rows of energy bins
   real*8 :: PreMod__DMpred(2,2,100)   


contains

  subroutine AMS02_posifrac(en,pflux,apflux,chisq)
    implicit none
    real*8, intent(in) :: en(100),pflux(100),apflux(100)
    real*8, intent(out) :: chisq 
    real*8 y(100)
    integer i
    real*8 sigma,theo
    real*8 xdata(66)
    real*8 ydata(66)
    real*8 yup(66)
    real*8 ylo(66)
    xdata=(/0.575,0.730,0.905,1.105, & 
       1.330,1.575,1.835,2.125, & 
       2.440,2.770,3.120,3.500, & 
       3.905,4.325,4.770,5.250, & 
       5.750,6.280,6.860,7.480, & 
       8.150,8.855,9.580,10.34, & 
       11.14,11.97,12.83,13.73, & 
       14.67,15.65,16.67,17.72, & 
       18.81,19.96,21.15,22.42, & 
       23.76,25.16,26.61,28.11, & 
       29.66,31.28,32.95,34.69, & 
       36.49,38.70,41.70,45.20, & 
       48.94,52.93,57.17,61.70, & 
       66.52,71.65,77.15,83.00, & 
       89.25,96.25,107.6,123.6, & 
       141.8,162.5,189.8,233.0, & 
       305.0,425.0/)
    ydata=(/0.0943,0.0917,0.0862,0.0820, & 
       0.0775,0.0724,0.0686,0.0650, & 
       0.0622,0.0597,0.0576,0.0559, & 
       0.0553,0.0539,0.0528,0.0524, & 
       0.0515,0.0514,0.0511,0.0506, & 
       0.0509,0.0514,0.0513,0.0523, & 
       0.0532,0.0546,0.0553,0.0552, & 
       0.0558,0.0570,0.0585,0.0601, & 
       0.0596,0.0625,0.0617,0.0640, & 
       0.0655,0.0652,0.0662,0.0704, & 
       0.0717,0.0719,0.0721,0.0766, & 
       0.0732,0.0781,0.0806,0.0872, & 
       0.0840,0.0887,0.0921,0.0933, & 
       0.0974,0.1069,0.0963,0.1034, & 
       0.1207,0.1169,0.1205,0.1110, & 
       0.1327,0.1374,0.1521,0.1550, & 
       0.1590,0.1471/)
    yup=(/0.0993774,0.0953249,0.0888249,0.084119, & 
       0.0793682,0.0740763,0.070056,0.0662369, & 
       0.063277,0.0606487,0.0584544,0.0566616, & 
       0.0559708,0.0544831,0.0533,0.0529, & 
       0.0519243,0.0518243,0.0516,0.0511, & 
       0.0514,0.0519,0.0518831,0.0528831, & 
       0.0538708,0.0552708,0.0559708,0.0560062, & 
       0.0566062,0.0578944,0.0594849,0.061177, & 
       0.060677,0.063577,0.0629083,0.0653, & 
       0.0668928,0.0665928,0.0676866,0.0720156, & 
       0.0734088,0.0737974,0.0740925,0.0788136, & 
       0.0754136,0.080219,0.0828472,0.0897298, & 
       0.0868461,0.0916732,0.0954526,0.0971601, & 
       0.10148,0.111488,0.101204,0.109197, & 
       0.1272,0.123452,0.126294,0.117723, & 
       0.141596,0.147892,0.16422,0.169977, & 
       0.180365,0.181/)
    ylo=(/0.0892226,0.0880751,0.0835751,0.079881, & 
       0.0756318,0.0707237,0.067144,0.0637631, & 
       0.061123,0.0587513,0.0567456,0.0551384, & 
       0.0546292,0.0533169,0.0523,0.0519, & 
       0.0510757,0.0509757,0.0506,0.0501, & 
       0.0504,0.0509,0.0507169,0.0517169, & 
       0.0525292,0.0539292,0.0546292,0.0543938, & 
       0.0549938,0.0561056,0.0575151,0.059023, & 
       0.058523,0.061423,0.0604917,0.0627, & 
       0.0641072,0.0638072,0.0647134,0.0687844, & 
       0.0699912,0.0700026,0.0701075,0.0743864, & 
       0.0709864,0.075981,0.0783528,0.0846702, & 
       0.0811539,0.0857268,0.0887474,0.0894399, & 
       0.0933196,0.102312,0.0913959,0.0976026, & 
       0.1142,0.110348,0.114706,0.104277, & 
       0.123805,0.126908,0.13998,0.140023, & 
       0.137635,0.1132/)

    do i=1,100,1 
       y(i)=apflux(i)/(pflux(i)+apflux(i)) 
    enddo

    chisq=0d0
    do i=4,66,1
      call linInt2p(en,y,100,.true.,xdata(i),theo,.false.)
      sigma=(yup(i)-ylo(i))/2d0
      chisq=chisq+(theo-ydata(i))**2/sigma**2
    enddo
    return 
  end subroutine AMS02_posifrac


  subroutine AMS02_electron(en,pflux,apflux,chisq)
    implicit none
    real*8, intent(in) :: en(100),pflux(100),apflux(100)
    real*8, intent(out) :: chisq 
    real*8 y(100)
    integer i
    real*8 sigma,theo
    real*8 xdata(73)
    real*8 ydata(73)
    real*8 yup(73)
    real*8 ylo(73)
    xdata=(/0.57,0.73,0.91,1.11, & 
       1.33,1.58,1.85,2.15, & 
       2.47,2.82,3.17,3.54, & 
       3.92,4.32,4.76,5.24, & 
       5.74,6.26,6.81,7.39, & 
       7.99,8.62,9.28,9.96, & 
       10.7,11.4,12.2,13.0, & 
       13.8,14.7,15.6,16.5, & 
       17.5,18.5,19.5,20.6, & 
       21.7,22.8,24.0,25.2, & 
       26.6,28.0,29.4,31.0, & 
       32.7,34.4,36.3,38.3, & 
       40.5,42.8,45.3,47.9, & 
       50.8,53.9,57.3,61.0, & 
       65.1,69.6,74.6,80.3, & 
       86.7,94.0,103.0,113.0, & 
       125.0,140.0,159.0,183.0, & 
       216.0,262.0,327.0,429.0, & 
       589.0/)
    ydata=(/2.72234,9.45311,15.6743,25.0276, & 
       38.5832,54.0371,70.281,88.8491, & 
       106.991,123.117,146.852,160.59, & 
       172.878,183.011,194.13,204.307, & 
       209.922,215.877,219.496,222.374, & 
       222.396,224.176,222.172,221.323, & 
       219.283,217.787,216.086,213.768, & 
       209.457,208.38,204.627,201.247, & 
       198.833,196.28,192.045,189.697, & 
       185.973,184.897,181.094,177.633, & 
       177.295,174.299,171.278,167.425, & 
       165.388,159.574,161.194,158.995, & 
       155.446,157.59,151.524,151.665, & 
       149.45,146.412,143.169,143.452, & 
       139.327,132.164,135.342,131.517, & 
       132.298,129.571,134.405,130.149, & 
       128.711,118.541,121.394,118.28, & 
       111.862,119.419,110.142,95.5338, & 
       92.5644/)
    yup=(/3.02381,10.0804,16.732,26.6745, & 
       40.7006,56.7981,73.4468,92.8257, & 
       111.514,128.056,152.277,166.374, & 
       178.902,189.461,200.601,210.062, & 
       215.596,222.015,225.82,228.441, & 
       228.538,230.613,228.615,227.333, & 
       224.183,222.232,221.534,218.864, & 
       214.512,213.187,209.62,206.269, & 
       203.774,200.757,196.555,194.154, & 
       190.186,189.784,185.466,182.694, & 
       181.769,178.825,175.781,171.763, & 
       169.811,163.824,165.732,163.274, & 
       159.647,161.812,155.681,156.58, & 
       153.596,150.896,147.545,148.02, & 
       143.776,136.56,140.184,136.402, & 
       136.998,134.414,139.869,135.552, & 
       134.183,124.029,127.107,124.347, & 
       118.315,127.304,119.537,106.156, & 
       111.945/)
    ylo=(/2.42087,8.82584,14.6166,23.3807, & 
       36.4658,51.2761,67.1152,84.8725, & 
       102.468,118.178,141.427,154.806, & 
       166.854,176.561,187.659,198.552, & 
       204.248,209.739,213.172,216.307, & 
       216.254,217.739,215.729,215.313, & 
       214.383,213.342,210.638,208.672, & 
       204.402,203.573,199.634,196.225, & 
       193.892,191.803,187.535,185.24, & 
       181.76,180.01,176.722,172.572, & 
       172.821,169.773,166.775,163.087, & 
       160.965,155.324,156.656,154.716, & 
       151.245,153.368,147.367,146.75, & 
       145.304,141.928,138.793,138.884, & 
       134.878,127.768,130.5,126.632, & 
       127.598,124.728,128.941,124.746, & 
       123.239,113.053,115.681,112.213, & 
       105.409,111.534,100.747,84.9117, & 
       73.1837/)

    do i=1,100,1 
       y(i)=en(i)**3*pflux(i) 
    enddo

    chisq=0d0
    do i=4,73,1
      call linInt2p(en,y,100,.true.,xdata(i),theo,.false.)
      sigma=(yup(i)-ylo(i))/2d0
      chisq=chisq+(theo-ydata(i))**2/sigma**2
    enddo
    return 
  end subroutine AMS02_electron


  subroutine AMS02_positron(en,pflux,apflux,chisq)
    implicit none
    real*8, intent(in) :: en(100),pflux(100),apflux(100)
    real*8, intent(out) :: chisq 
    real*8 y(100)
    integer i
    real*8 sigma,theo
    real*8 xdata(72)
    real*8 ydata(72)
    real*8 yup(72)
    real*8 ylo(72)
    xdata=(/0.57,0.73,0.91,1.11, & 
       1.33,1.58,1.85,2.15, & 
       2.47,2.82,3.17,3.54, & 
       3.92,4.32,4.76,5.24, & 
       5.74,6.26,6.81,7.39, & 
       7.99,8.62,9.28,9.96, & 
       10.7,11.4,12.2,13.0, & 
       13.8,14.7,15.6,16.5, & 
       17.5,18.5,19.5,20.6, & 
       21.7,22.8,24.0,25.2, & 
       26.6,28.0,29.4,31.0, & 
       32.7,34.4,36.3,38.3, & 
       40.5,42.8,45.3,47.9, & 
       50.8,53.9,57.3,61.0, & 
       65.1,69.6,74.6,80.3, & 
       86.7,94.0,103.0,113.0, & 
       125.0,140.0,159.0,183.0, & 
       216.0,262.0,327.0,429.0/)
    ydata=(/0.242603,0.902519,1.43932,2.11983, & 
       3.15253,4.18097,5.07163,6.15185, & 
       6.91677,7.69204,8.85569,9.40472, & 
       9.87875,10.3196,10.634,11.1649, & 
       11.2337,11.5052,11.8117,11.8654, & 
       11.9359,12.2336,11.9877,12.3506, & 
       12.3729,12.2968,12.3659,12.6547, & 
       12.0891,12.1978,12.6421,12.6229, & 
       12.7017,12.7266,12.9019,12.5882, & 
       12.4663,12.445,12.8978,12.6104, & 
       12.4784,13.0395,13.2143,12.8995, & 
       13.1471,13.0264,12.8668,13.6522, & 
       14.0168,13.3285,14.5017,13.4081, & 
       14.1584,14.6726,14.204,14.8219, & 
       14.9259,16.1159,16.1498,14.9121, & 
       17.9873,17.2761,16.7187,16.5933, & 
       16.7188,17.0402,21.0229,19.5499, & 
       20.9616,21.7615,21.5739,19.5015/)
    yup=(/0.299049,1.01207,1.55631,2.2593, & 
       3.34221,4.38209,5.31431,6.43295, & 
       7.20663,8.00919,9.21184,9.76238, & 
       10.2452,10.652,10.9873,11.5176, & 
       11.5824,11.8624,12.1718,12.2375, & 
       12.3072,12.5785,12.3451,12.758, & 
       12.7603,12.6414,12.7152,13.009, & 
       12.4318,12.5414,13.0003,13.0093, & 
       13.0882,13.132,13.2726,13.0253, & 
       12.8998,12.8723,13.3378,13.0519, & 
       12.9309,13.5209,13.6998,13.3845, & 
       13.6669,13.5477,13.4122,14.2494, & 
       14.6293,13.9408,15.172,14.0489, & 
       14.9228,15.4545,14.9977,15.6666, & 
       15.8156,17.0819,17.1539,15.9081, & 
       19.1837,18.5024,17.993,17.8839, & 
       18.16,18.6482,23.0363,21.6905, & 
       23.4891,25.068,25.9751,25.5212/)
    ylo=(/0.186157,0.792971,1.32233,1.98036, & 
       2.96285,3.97985,4.82895,5.87075, & 
       6.62691,7.37489,8.49954,9.04706, & 
       9.51235,9.98719,10.2807,10.8122, & 
       10.885,11.148,11.4516,11.4933, & 
       11.5646,11.8887,11.6303,11.9432, & 
       11.9855,11.9522,12.0166,12.3004, & 
       11.7464,11.8542,12.2839,12.2365, & 
       12.3152,12.3212,12.5312,12.1511, & 
       12.0328,12.0177,12.4578,12.1689, & 
       12.0259,12.5581,12.7288,12.4145, & 
       12.6273,12.5051,12.3214,13.055, & 
       13.4043,12.7162,13.8314,12.7673, & 
       13.394,13.8907,13.4103,13.9772, & 
       14.0362,15.1499,15.1457,13.9161, & 
       16.7909,16.0498,15.4444,15.3027, & 
       15.2776,15.4322,19.0095,17.4093, & 
       18.4341,18.455,17.1726,13.4818/)

    do i=1,100,1 
       y(i)=en(i)**3*apflux(i) 
    enddo

    chisq=0d0
    do i=4,72,1
      call linInt2p(en,y,100,.true.,xdata(i),theo,.false.)
      sigma=(yup(i)-ylo(i))/2d0
      chisq=chisq+(theo-ydata(i))**2/sigma**2
    enddo
    return 
  end subroutine AMS02_positron


  subroutine AMS02_total_elec(en,pflux,apflux,chisq)
    implicit none
    real*8, intent(in) :: en(100),pflux(100),apflux(100)
    real*8, intent(out) :: chisq 
    real*8 y(100)
    integer i
    real*8 sigma,theo
    real*8 xdata(74)
    real*8 ydata(74)
    real*8 yup(74)
    real*8 ylo(74)
    xdata=(/0.57,0.73,0.91,1.11, & 
       1.33,1.58,1.85,2.15, & 
       2.47,2.82,3.17,3.54, & 
       3.92,4.32,4.76,5.24, & 
       5.74,6.26,6.81,7.39, & 
       7.99,8.62,9.28,9.96, & 
       10.7,11.4,12.2,13.0, & 
       13.8,14.7,15.6,16.5, & 
       17.5,18.5,19.5,20.6, & 
       21.7,22.8,24.0,25.2, & 
       26.6,28.0,29.4,31.0, & 
       32.7,34.4,36.3,38.3, & 
       40.5,42.8,45.3,47.9, & 
       50.8,53.9,57.3,61.0, & 
       65.1,69.6,74.6,80.3, & 
       86.7,94.0,103.0,113.0, & 
       125.0,140.0,159.0,183.0, & 
       216.0,262.0,327.0,429.0, & 
       589.0,832.0/)
    ydata=(/5.01873,9.2586,16.3525,27.4894, & 
       41.8769,57.587,75.3463,94.1164, & 
       112.718,129.397,153.223,167.244, & 
       180.107,191.073,201.68,211.5, & 
       219.378,223.972,228.655,232.464, & 
       233.108,233.784,233.36,232.191, & 
       231.533,228.158,228.797,226.291, & 
       221.284,219.498,217.535,212.927, & 
       210.623,208.31,203.909,201.936, & 
       198.235,195.564,192.154,190.436, & 
       187.835,187.031,183.476,179.64, & 
       180.074,174.636,174.109,174.726, & 
       172.054,170.918,168.257,163.754, & 
       162.56,162.854,162.17,160.249, & 
       155.053,153.742,151.949,150.674, & 
       151.198,147.844,149.704,145.733, & 
       141.797,138.298,142.699,132.988, & 
       127.987,123.915,120.632,114.483, & 
       110.546,109.427/)
    yup=(/6.03578,10.0792,17.5606,29.1363, & 
       44.0073,59.9536,77.879,96.9009, & 
       115.585,132.321,156.424,170.821, & 
       183.721,195.104,205.994,215.816, & 
       223.16,228.639,233.403,237.324, & 
       237.727,238.313,238.221,237.229, & 
       236.433,232.603,234.245,230.685, & 
       225.821,223.99,222.154,217.508, & 
       215.042,212.787,208.419,206.393, & 
       202.448,199.312,196.526,194.014, & 
       191.765,190.921,187.421,183.408, & 
       184.061,178.498,177.752,178.279, & 
       175.631,174.424,172.414,167.229, & 
       166.706,166.355,166.044,164.22, & 
       158.886,157.389,155.866,154.408, & 
       155.371,151.997,154.34,149.814, & 
       145.94,142.765,147.539,137.774, & 
       133.026,129.559,127.358,122.987, & 
       122.916,136.001/)
    ylo=(/4.00168,8.43797,15.1444,25.8425, & 
       39.7465,55.2204,72.8136,91.3319, & 
       109.851,126.473,150.022,163.667, & 
       176.493,187.042,197.366,207.184, & 
       215.596,219.305,223.907,227.604, & 
       228.489,229.255,228.499,227.153, & 
       226.633,223.713,223.349,221.897, & 
       216.747,215.006,212.916,208.346, & 
       206.204,203.833,199.399,197.479, & 
       194.022,191.816,187.782,186.858, & 
       183.905,183.141,179.531,175.872, & 
       176.087,170.774,170.466,171.173, & 
       168.477,167.412,164.1,160.279, & 
       158.414,159.353,158.296,156.278, & 
       151.22,150.095,148.032,146.94, & 
       147.025,143.691,145.068,141.652, & 
       137.654,133.831,137.859,128.202, & 
       122.948,118.271,113.906,105.979, & 
       98.1756,82.8529/)

    do i=1,100,1 
       y(i)=en(i)**3*(pflux(i)+apflux(i)) 
    enddo

    chisq=0d0
    do i=4,74,1
      call linInt2p(en,y,100,.true.,xdata(i),theo,.false.)
      sigma=(yup(i)-ylo(i))/2d0
      chisq=chisq+(theo-ydata(i))**2/sigma**2
    enddo
    return 
  end subroutine AMS02_total_elec


  subroutine PAMELA_antip(en,pflux,apflux,chisq)
    implicit none
    real*8, intent(in) :: en(100),pflux(100),apflux(100)
    real*8, intent(out) :: chisq 
    real*8 y(100)
    integer i
    real*8 sigma,theo
    real*8 xdata(23)
    real*8 ydata(23)
    real*8 yup(23)
    real*8 ylo(23)
    xdata=(/0.28,0.56,0.81,1.07, & 
       1.34,1.61,2.03,2.42, & 
       2.90,3.47,4.14,4.93, & 
       5.9,7.0,8.4,10.1, & 
       12.3,15.3,19.6,26.2, & 
       38.0,67.4,128.9/)
    ydata=(/0.0067,0.0153,0.0172,0.0214, & 
       0.0245,0.0205,0.0271,0.0219, & 
       0.0227,0.0178,0.0157,0.0111, & 
       0.00831,0.00556,0.00516,0.0037, & 
       0.00212,0.00139,0.00067,0.000251, & 
       0.000127,2.28e-05,3.6e-06/)
    yup=(/0.0094074,0.0228538,0.0246813,0.0283231, & 
       0.0318546,0.0239176,0.0307674,0.0248069, & 
       0.0255178,0.0199471,0.0175358,0.0124038, & 
       0.0092998,0.00628007,0.00580413,0.00413909, & 
       0.00240636,0.00159616,0.000777703,0.000294658, & 
       0.000151042,3.00443e-05,9.30351e-06/)
    ylo=(/0.0039926,0.0114921,0.0131478,0.017289, & 
       0.0199459,0.0170824,0.0234326,0.0189931, & 
       0.0198822,0.0156529,0.0138642,0.00979616, & 
       0.0073202,0.00483993,0.00451587,0.00326091, & 
       0.00183364,0.00118384,0.000562297,0.000207342, & 
       0.000102958,1.55557e-05,1.59002e-06/)

    do i=1,100,1 
       y(i)=apflux(i) 
    enddo

    chisq=0d0
    do i=1,23,1
      call linInt2p(en,y,100,.true.,xdata(i),theo,.false.)
      sigma=(yup(i)-ylo(i))/2d0
      chisq=chisq+(theo-ydata(i))**2/sigma**2
    enddo
    return 
  end subroutine PAMELA_antip




end module charge_data

